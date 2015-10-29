#!/bin/bash
cd `dirname $0`

#
# Functions
#
function preparation() {
  find . -name .AppleDouble -exec rm -rf {} \;
  find . -type f -name *.zip -print0 | xargs -0 rename 's/.zip/.cbz/'
  find . -type f -name *.rar -print0 | xargs -0 rename 's/.rar/.cbr/'
}

function seasonWithProducersInfo() {
#  title=$(echo ${food_staff} | sed -e 's/\....$//;s/^\.//;s/\[//;s/\]//;s/^ //;s/\///g')
  title=$(echo ${food_staff} | grep -o '\].*[^.]' | sed -e 's/\....$//;s/^\.//;s/\[//;s/\]//;s/^ //;s/\///g')
  authors=$(echo ${food_staff} | grep -o '\[.*\]' | sed -e 's/\[//;s/\]//;s/^ //;s/\///g')
  echo title=${title}, authors=${authors}
}

function slice() {
  find . -type f -maxdepth 1 \( -name \*.txt -o -name \*.pdf -o -name \*.cbz -o -name \*.cbr \)  | while read food_staff; do 
  seasonWithProducersInfo
  echo ${food_staff}
  ebook-convert "${food_staff}" "$(echo ${food_staff} | sed -e 's/\....$/.mobi/g')" --right2left --no-inline-toc --keep-aspect-ratio --output-profile=kindle_pw --dont-grayscale --title="${title}" --authors="${authors}"
  done
}

#
# Main
#
preparation

find $(pwd) -type d | while read food_staffs; do 
  cd "$food_staffs"
  echo "Cook Now: $(pwd)"
  slice
done

mv -f ./*.mobi ../Bookshelf
