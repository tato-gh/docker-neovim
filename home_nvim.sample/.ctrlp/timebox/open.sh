#!/bin/bash

# timebox用の週ファイルを開く

# usage e.g. ctrlp-launcher

# # [タイトル(空白含んでOK)] [タブ文字(複数可能] [実行するコマンド]
# NewTimebox	let b:file=system('bash ~/.ctrlp/timebox/open.sh '.expand('%:p:h')) | execute "e" b:file
# # vim:set ts=4

DIR=$1

WEEKDAY=`date +%w`
DIFF=$(( $WEEKDAY ))
# for busybox date command
DAY_ARG="1970.01.01-00:00:$(( $( date +%s ) - $(( $DIFF * 24 * 60 * 60 )) ))"
YEAR=`date -d $DAY_ARG +%Y`
MONTH=`date -d $DAY_ARG +%m`
DAY=`date -d $DAY_ARG +%d`

FILE_PREFIX=$DIR/timebox/${YEAR}${MONTH}${DAY}
FILE=`ls $FILE_PREFIX*`
echo $FILE
