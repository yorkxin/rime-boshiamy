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

function translate_keys() {
  # 暴力取代法來自 GCIN 同好會：
  # http://cle.linux.org.tw/trac/wiki/GcinInstallBoshiamy
  sed -e "s/00//g" \
      -e "s/01/a/g" \
      -e "s/02/b/g" \
      -e "s/03/c/g" \
      -e "s/04/d/g" \
      -e "s/05/e/g" \
      -e "s/06/f/g" \
      -e "s/07/g/g" \
      -e "s/08/h/g" \
      -e "s/09/i/g" \
      -e "s/10/j/g" \
      -e "s/11/k/g" \
      -e "s/12/l/g" \
      -e "s/13/m/g" \
      -e "s/14/n/g" \
      -e "s/15/o/g" \
      -e "s/16/p/g" \
      -e "s/17/q/g" \
      -e "s/18/r/g" \
      -e "s/19/s/g" \
      -e "s/20/t/g" \
      -e "s/21/u/g" \
      -e "s/22/v/g" \
      -e "s/23/w/g" \
      -e "s/24/x/g" \
      -e "s/25/y/g" \
      -e "s/26/z/g" \
      -e "s/27/\'/g" \
      -e "s/45/[/g" \
      -e "s/46/]/g" \
      -e "s/55/,/g" \
      -e "s/56/./g" \
      -e "s/;//g"
}

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
  # FIXME: 想辦法撈出表格檔版本，例如從 install.sh 裡面抓出 VERSION
  echo 'version: "0.1"'                >> $RIME_DICT
  echo 'sort: original'                >> $RIME_DICT
  echo 'use_preset_vocabulary: false'  >> $RIME_DICT
  echo ''                              >> $RIME_DICT
  echo '...'                           >> $RIME_DICT
}

DESCRIPTION=`SQLITE3 $1 'SELECT val FROM ime where attr = "description";' | sed -e 's/IBus/Rime/g'`
echo $DESCRIPTION

create_rime_dict_file

total_entries=`SQLITE3 $1 'SELECT COUNT(*) FROM phrases;'`
echo "Total entries: $total_entries"

SQLITE3 -list $1 <<EOSQL | translate_keys >> $RIME_DICT
.separator "\t"
SELECT
  phrase,
  (
    -- SQLite3 的 Left Padding （SUBSTR 大法）從這裡抄來的：
    -- http://www.askingbox.com/info/sqlite-rpad-and-lpad-in-sqlite-fill-string-with-characters-left-or-right
    SUBSTR('00' || IFNULL(m0, ''), -2, 2) || ';' ||
    SUBSTR('00' || IFNULL(m1, ''), -2, 2) || ';' ||
    SUBSTR('00' || IFNULL(m2, ''), -2, 2) || ';' ||
    SUBSTR('00' || IFNULL(m3, ''), -2, 2) || ';' ||
    SUBSTR('00' || IFNULL(m4, ''), -2, 2)
  ) AS input
FROM phrases
ORDER BY input, freq DESC;
EOSQL
