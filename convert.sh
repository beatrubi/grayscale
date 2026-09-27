#!/bin/bash

set -o pipefail -eu

for in in JPEG/*.jpg; do
  out="$(basename $in .jpg).jpeg"
  if [ ! -f Pictures/$out ]; then
    datetime=$(exiftool -T -DateTimeOriginal $in)
    city=$(exiftool -T -City $in)
    profile=$(exiftool -s -T -ProfileDescription $in)

    if [ "$city" == "-" ]; then
      echo "$in has no City" >&2
      exit 1
    fi

    if [ "$profile" != "Display P3" ]; then
      echo "$in is not in Display P3" >&2
      exit 1
    fi

    mmdd=$(echo $datetime \
      | awk '{ print $1 }' | cut -f2-3 -d: | tr -d :)
    label="$datetime, $city"

    convert $in \
      -resize 1400x1400 \
      -background black -gravity center -extent 1600x1600 \
      -gravity north -extent 1600x1554 \
      -background black -fill grey -font Monaco -pointsize 36 \
        label:"$label" -gravity West -append \
      -gravity west -extent 2560x1600 \
      -gravity southeast watermarkretina.png -composite \
      Pictures/$out

    echo "  \"$mmdd\" => \"$out\","
  fi
done | tee -a convert.log
