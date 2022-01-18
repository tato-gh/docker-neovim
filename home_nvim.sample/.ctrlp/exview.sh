#!/bin/bash
# Phoenix ビュー移動
# $1: 現ファイルパス (%)
# $2: カレントディレクトリ (cwd)

FILENAME=`echo $1 | sed 's/\.[^\/]*$//'`
EXT_LIST=(".html.heex" ".html.leex")

#   同一フォルダ内
for extname in ${EXT_LIST[@]}; do
  filepath="${FILENAME}${extname}"
  if [ -e ${filepath} ]; then
    echo ${filepath}
    exit
  fi
done

#   最終的にファイルが見つからない場合は慣習的に .html.slimleex
echo "${FILENAME}${EXT_LIST[0]}"
