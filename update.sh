#!/bin/bash

variant=Sans
license=LICENSE.txt
srcpath='source-han-sans'
subdirs='ExtraLight Light Normal Regular Medium Bold Heavy'
removed='latin_special jpcntwhk_special kr_special kr2jp kr2cn kr2tw kr2hk locl'

remove_unused_blocks() {
  sed -i ":begin; /$1/,/$2/ { /$2/! { \$! { N; b begin }; }; /$1.*$2/d; };" $3
}

search_unused_glyphs() {
  st=`grep -A 1 -n "$1" "$3" | sed -n '2,2p' | sed -r 's|([0-9]+).*|\1|'`
  sp=`grep -B 1 -n "$2" "$3" | sed -n '1,1p' | sed -r 's|([0-9]+).*|\1|'`

  sed -n "${st},${sp}p" $3 >> unused_blocks.txt
}

for dir in $subdirs; do
  mkdir -p "$dir/OTC"

  sed "s|${variant}K|${variant}C|
       s|Korean|Classic|" "$srcpath/$dir/OTC/features.OTC.K" > "$dir/OTC/features.OTC.CL"
  sed "s|${variant}K|${variant}C|
       s|Korean|Classic|" "$srcpath/$dir/OTC/cidfont.ps.OTC.K" > "$dir/OTC/cidfont.ps.OTC.CL"
  sed "s|${variant}K|${variant}C|
       s|Korean|Classic|" "$srcpath/$dir/OTC/cidfontinfo.OTC.K" > "$dir/OTC/cidfontinfo.OTC.CL"

  for block in $removed; do
    remove_unused_blocks "[a-z] $block " "} $block;\n" "$dir/OTC/features.OTC.CL"
  done
done

:> unused_blocks.txt
:> unused_glyphs.txt

for block in $removed; do
  search_unused_glyphs "[a-z] $block " "} $block;" "$srcpath/Regular/OTC/features.OTC.K"
done

sort unused_blocks.txt | uniq > unused_blocks_sorted.txt
for line in $(echo -e $(cat unused_blocks_sorted.txt)); do
  str=$(echo "$line" | grep -E '[\][0-9]+;' | sed -r 's|[\]([0-9]+);|\1|')

  if [ -n "$str" ]; then
    ret0=$(cat "Regular/OTC/features.OTC.CL" | grep "[\]$str[; ]")
    ret1=$(cat "UniSourceHan${variant}CL-UTF32-H" "SourceHan${variant}_CL_sequences.txt" | grep "$str$")

    if [ -z "$ret0" -a -z "$ret1" ]; then
      echo "$str" >> unused_glyphs.txt
    fi
  fi
done

sort unused_glyphs.txt | uniq > unused_glyphs_sorted.txt
for line in $(echo -e $(cat unused_glyphs_sorted.txt)); do
  arg="$arg,/$line"
done

for dir in $subdirs; do
  mergefonts -gx $arg "$dir/output.ps" "$dir/OTC/cidfont.ps.OTC.CL"
  mv "$dir/output.ps" "$dir/OTC/cidfont.ps.OTC.CL"
done

sed "s|${variant}KR|${variant}CL|" "$srcpath/UniSourceHan${variant}KR-UTF32-H" > "UniSourceHan${variant}CL-UTF32-H"

cp "$srcpath/SourceHan${variant}_KR_sequences.txt" "SourceHan${variant}_CL_sequences.txt"
cp "$srcpath/$license" LICENSE.txt
