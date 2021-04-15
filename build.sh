#!/bin/sh

mkdir -p OTF

for dir in ExtraLight Light Normal Regular Medium Bold; do
  cd "$dir/OTC"
  makeotf -f cidfont.ps.OTC.CL -omitMacNames -ff features.OTC.CL -fi cidfontinfo.OTC.CL -mf ../../FontMenuNameDB -r -nS -cs 3 -ch ../../UniSourceHanSansCL-UTF32-H -ci ../../SourceHanSans_CL_sequences.txt ; tx -cff +S -no_futile cidfont.ps.OTC.CL CFF.OTC.CL ; sfntedit -a CFF=CFF.OTC.CL "SourceHanSansC-$dir.otf"
  mv "SourceHanSansC-$dir.otf" ../../OTF
  rm CFF.OTC.CL
  cd ../../
done

zip source-han-sans-classic-otf.zip OTF/*
