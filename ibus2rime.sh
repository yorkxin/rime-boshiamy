#!/bin/sh
#
# ibus2rime.sh
#
# 把嘸蝦米的 ibus 表格檔轉換成 Rime 的字典檔。
#
# 您必須要有合法的嘸蝦米正版授權才能使用這個程式來轉換檔案。轉換後的檔案不可散佈，否則會侵犯
# 行易有限公司的著作權。
#
# Usage:
#
# ./ibus2rime.sh boshiamy_t.db
# #=> Generates boshiamy_t.dict.yaml
#
SQLITE3=`which sqlite3`
FILE_NAME=`basename $1 .db`
RIME_DICT="$FILE_NAME.dict.yaml"

echo "Converting $FILE_NAME to $RIME_DICT ..."

function create_rime_dict_file() {
  # clear the existing file
  echo "# $DESCRIPTION" > $RIME_DICT

  echo '#'                                          >> $RIME_DICT
  echo '# 本字典檔是從 ibus 的表格檔轉換而來。'         >> $RIME_DICT
  echo '# 字典表（"..." 那一行以下）之著作權屬行易有限公司所有。' >> $RIME_DICT

  echo '#'                                          >> $RIME_DICT
  echo '# 僅限擁有正版授權之個人使用。不許散佈。'        >> $RIME_DICT

  echo ''                              >> $RIME_DICT
  echo '---'                           >> $RIME_DICT
  echo "name: $FILE_NAME"              >> $RIME_DICT
  echo "version: \"$VERSION\""         >> $RIME_DICT
  echo 'sort: original'                >> $RIME_DICT
  echo 'use_preset_vocabulary: false'  >> $RIME_DICT
  echo ''                              >> $RIME_DICT
  echo '...'                           >> $RIME_DICT
}

DESCRIPTION=`SQLITE3 $1 'SELECT val FROM ime where attr = "description";' | sed -e 's/IBus/Rime/g'`
echo $DESCRIPTION

VERSION=`SQLITE3 $1 'SELECT val FROM ime where attr = "serial_number";'`

create_rime_dict_file

total_entries=`SQLITE3 $1 'SELECT COUNT(*) FROM phrases;'`
echo "Total entries: $total_entries"

SQLITE3 -list $1 <<EOSQL >> $RIME_DICT
.separator "\t"
SELECT
  phrase, tabkeys
FROM phrases
ORDER BY tabkeys, freq DESC;
EOSQL
