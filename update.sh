#!/bin/sh

search_and_delete() {
  sed -i ":begin; /$1/,/$2/ { /$2/! { \$! { N; b begin }; }; /$1.*$2/d; };" $3
}

for dir in ExtraLight Light Normal Regular Medium Bold Heavy; do
  mkdir -p "$dir/OTC"
  sed "s|SansK|SansC|" "source-han-sans/$dir/OTC/features.OTC.K" > "$dir/OTC/features.OTC.CL"
  sed "s|SansK|SansC|" "source-han-sans/$dir/OTC/cidfont.ps.OTC.K" > "$dir/OTC/cidfont.ps.OTC.CL"
  sed "s|SansK|SansC|
       s|Korean|Classic|" "source-han-sans/$dir/OTC/cidfontinfo.OTC.K" > "$dir/OTC/cidfontinfo.OTC.CL"
  sed -i "/lookup kr2.*;$/d" "$dir/OTC/features.OTC.CL"
  search_and_delete 'lookup kr2jp' 'kr2jp;\n' "$dir/OTC/features.OTC.CL"
  search_and_delete 'lookup kr2cn' 'kr2cn;\n' "$dir/OTC/features.OTC.CL"
  search_and_delete 'lookup kr2tw' 'kr2tw;\n' "$dir/OTC/features.OTC.CL"
  search_and_delete 'lookup kr2hk' 'kr2hk;\n' "$dir/OTC/features.OTC.CL"
done

sed "s|SansKR|SansCL|" "source-han-sans/UniSourceHanSansKR-UTF32-H" > UniSourceHanSansCL-UTF32-H

cp source-han-sans/SourceHanSans_KR_sequences.txt SourceHanSans_CL_sequences.txt
cp source-han-sans/LICENSE.txt LICENSE.txt
