#!/bin/bash
# Phoenix liveファイル移動
# $1: 現ファイルパス (%)
# $2: カレントディレクトリ (cwd)

FILENAME=`echo $1 | sed 's/\.[^\/]*$//'`
EXT_LIST=(".ex")

#   同一フォルダ内
for extname in ${EXT_LIST[@]}; do
  filepath="${FILENAME}${extname}"
  if [ -e ${filepath} ]; then
    echo ${filepath}
    exit
  fi
done

#   最終的にファイルが見つからない場合は慣習的に .ex
echo "${FILENAME}${EXT_LIST[0]}"
