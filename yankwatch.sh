#!/bin/bash

# WSLでdockerコンテナ内からのクリップボード共有用スクリプト
# $FILEに記載内容をclip.exeで共有する仕組み
# package: inotify-tools

FILE="/tmp/yanked"

inotifywait -e CLOSE_WRITE -m ${FILE} --format "%w %f %e" | \
while read LINE; do
  # --format指定した通りに変数に格納
  declare -a eventData=(${LINE})
  FILEPATH=${eventData[0]}
  
  cat $FILEPATH | clip.exe
done
