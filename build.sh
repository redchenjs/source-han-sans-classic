#!/bin/bash

variant=Sans
subdirs='ExtraLight Light Normal Regular Medium Bold Heavy'

mkdir -p OTF

for dir in $subdirs; do
  cd "$dir/OTC"
  makeotf -f cidfont.ps.OTC.CL -omitMacNames -ff features.OTC.CL -fi cidfontinfo.OTC.CL -mf ../../FontMenuNameDB -r -nS -cs 3 -ch "../../UniSourceHan${variant}CL-UTF32-H" -ci "../../SourceHan${variant}_CL_sequences.txt" ; tx -cff +S cidfont.ps.OTC.CL CFF.OTC.CL ; sfntedit -a CFF=CFF.OTC.CL "SourceHan${variant}C-$dir.otf"
  mv "SourceHan${variant}C-$dir.otf" ../../OTF
  rm CFF.OTC.CL
  cd ../../
done

zip "SourceHan${variant}C-OTF.zip" LICENSE.txt OTF/*
sha512sum "SourceHan${variant}C-OTF.zip" | sed -r 's|([0-9a-z]+).*|\1|g' > "SourceHan${variant}C-OTF.zip.sha512sum"
