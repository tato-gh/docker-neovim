#!/bin/bash

# 下記ファイルが作成された際に内容をclip.exeでコピーする
# use: inotify-tools

FILE="/tmp/yanked"

inotifywait -e CLOSE_WRITE -m ${FILE} --format "%w %f %e" | \
while read LINE; do
  # --format指定した通りに変数に格納
  declare -a eventData=(${LINE})
  FILEPATH=${eventData[0]}
  
  cat $FILEPATH | clip.exe
done
