#!/bin/bash

# timebox用の週ファイルを作成する

# usage e.g. ctrlp-launcher

# # [タイトル(空白含んでOK)] [タブ文字(複数可能] [実行するコマンド]
# NewTimebox	let b:file=system('bash ~/.ctrlp/timebox/create.sh '.expand('%:p:h')) | execute "e" b:file
# # vim:set ts=4

DIR=$1

WEEKDAY=`date +%w`
if [ $WEEKDAY -eq 0 ]; then
  YEAR=`date +%Y`
  MONTH=`date +%m`
  DAY=`date +%d`
else
  DIFF=$(( 7-$WEEKDAY ))

  # date@busybox では不可
  SUNDAY=`date -d "$DIFF days"`
  YEAR=`date -d "$SUNDAY" +%Y`
  MONTH=`date -d "$SUNDAY" +%m`
  DAY=`date -d "$SUNDAY" +%d`

  # # for busybox date command
  # DAY_ARG="1970.01.01-00:00:$(( $( date +%s ) + $(( $DIFF * 24 * 60 * 60 )) ))"
  # YEAR=`date -d $DAY_ARG +%Y`
  # MONTH=`date -d $DAY_ARG +%m`
  # DAY=`date -d $DAY_ARG +%d`
fi

FILE_PREFIX=$DIR/${YEAR}${MONTH}${DAY}

if ls $FILE_PREFIX* > /dev/null 2>&1; then
  # 存在するため何もしない
  FILE=`ls $FILE_PREFIX*`
else
  # FILE="${FILE_PREFIX}_pX_dY.md"
  FILE="${FILE_PREFIX}.md"
  touch $FILE
fi

echo $FILE
