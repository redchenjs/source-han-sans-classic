#!/bin/sh

for dir in ExtraLight Light Normal Regular Medium Bold Heavy; do
  sed "s|SansK|SansC|" "source-han-sans/$dir/OTC/features.OTC.K" > "$dir/OTC/features.OTC.CL"
  sed "s|SansK|SansC|" "source-han-sans/$dir/OTC/cidfont.ps.OTC.K" > "$dir/OTC/cidfont.ps.OTC.CL"
  sed "s|SansK|SansC|
       s|Korean|Classic|" "source-han-sans/$dir/OTC/cidfontinfo.OTC.K" > "$dir/OTC/cidfontinfo.OTC.CL"
done

sed "s|SansKR|SansCL|" "source-han-sans/UniSourceHanSansKR-UTF32-H" > UniSourceHanSansCL-UTF32-H
cp source-han-sans/SourceHanSans_KR_sequences.txt SourceHanSans_CL_sequences.txt
