#!/bin/bash

set -o pipefail -eu

for in in JPEG/*.jpg; do
  out="$(basename $in .jpg).jpeg"
  if [ ! -f Pictures/$out ]; then
    mmdd=$(exiftool -T -DateTimeOriginal $in \
      | awk '{ print $1 }' | cut -f2-3 -d: | tr -d :)
    label=$(exiftool -T -DateTimeOriginal -City $in | sed 's/\t/, /')
    echo "$mmdd $label"
#    convert $in \
#      -resize 1400x1400 \
#      -background black -gravity center -extent 1600x1600 \
#      -gravity north -extent 1600x1554 \
#      -background black -fill grey -font Monaco -pointsize 36 \
#        label:"$label" -gravity West -append \
#      -gravity west -extent 2560x1600 \
#      -gravity southeast watermarkretina.png -composite \
#      Pictures/$out
#    echo "  \"$mmdd\" => \"$out\","
  fi
done #| tee -a convert.log
