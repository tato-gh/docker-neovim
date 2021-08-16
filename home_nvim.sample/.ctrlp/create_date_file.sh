#!/bin/bash

# 日付＋採番のファイルを該当フォルダに作成する

# usage e.g. ctrlp-launcher

# # [タイトル(空白含んでOK)] [タブ文字(複数可能] [実行するコマンド]
# NewDatefile	let b:file=system('bash ~/.ctrlp/create_date_file.sh '.expand('%:p:h')) | execute "e" b:file
# # vim:set ts=4

DIR=$1

YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`

DATEFILE=$DIR/${YEAR}${MONTH}${DAY}

if ls ${DATEFILE}* > /dev/null 2>&1; then
  NUMFILE=`ls -1 ${DATEFILE}* | wc -l`
  NO=`printf %02d $(( $NUMFILE+1 ))`
else
  NO="01"
fi

FILE="${DATEFILE}${NO}.md"
touch $FILE
echo $FILE
