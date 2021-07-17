#!/bin/bash

# timebox用の週ファイル名を更新する
# - 計画ポイント pX
# - 実績ポイント dY
# を自動入力してリネーム

# usage e.g. ctrlp-launcher

# # [タイトル(空白含んでOK)] [タブ文字(複数可能] [実行するコマンド]
# UpdateTimebox	let b:file=system('bash ./timebox/update.sh '.expand('%')) | execute "e" b:file
# # vim:set ts=4

FILE=$1

PLAN=0
DONE=0

#REGEX="[(.)] *(.+?) "
PLAN_REGEX="- \[.\] \*(\d+) "
DONE_REGEX="- \[x\] \**(\d+) "

while read LINE
do
  if [[ $LINE =~ $PLAN_REGEX ]]; then
    PLAN=$(( $PLAN+${BASH_REMATCH[1]} ))
  fi
  if [[ $LINE =~ $DONE_REGEX ]]; then
    DONE=$(( $DONE+${BASH_REMATCH[1]} ))
  fi
done < $FILE

NEW_FILE=`echo $FILE | sed -re "s/_p(X|\d)+_/_p${PLAN}_/" -re "s/_d(Y|\d)+\.md/_d${DONE}\.md/"`

if [ $FILE != $NEW_FILE ]; then
  mv $FILE $NEW_FILE
fi

echo $NEW_FILE
