#!/bin/bash

set -o pipefail -eu

rm -Rf Grayscale*
mkdir Grayscale

cp Credits.rtf Grayscale/

gcc  -O3 -prebind -mmacosx-version-min=11.0 \
  -o sleepwatcher sleepwatcher_2.2.1/sources/sleepwatcher.c \
  -framework IOKit -framework CoreFoundation

platypus \
  --name Grayscale \
  --interface-type 'None' \
  --app-icon Camera_31090.icns \
  --interpreter /usr/bin/perl \
  --app-version 1.1.0 \
  --author "Beat Rubischon" \
  --bundled-file Credits.rtf \
  --bundled-file Pictures \
  --bundled-file sleepwatcher \
  --quit-after-execution \
  --optimize-nib \
  --overwrite \
  grayscale.pl \
  Grayscale/Grayscale.app

hdiutil create -fs HFS+ -srcfolder Grayscale -volname Grayscale Grayscale-temp.dmg
hdiutil convert Grayscale-temp.dmg -format UDZO -o Grayscale.dmg
