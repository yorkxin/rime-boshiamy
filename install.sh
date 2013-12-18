#!/bin/sh
#
# install.sh
#
# 一鍵安裝嘸蝦米 for RIME 的程式
#

# Detects Platform
case `uname -s` in
  "Darwin" )
    PLATFORM="mac"
    RIME_HOME="$HOME/Library/Rime"
    ;;
  "Linux" )
    PLATFORM="linux"
    RIME_HOME="$HOME/.config/ibus/rime/"
    ;;
  *)
    PLATFORM="unknown"
    RIME_HOME=`pwd` # use current dir for install path
    ;;
esac

# Converts ibus boshiamy table to rime table.
#
# @param name [String] boshiamy_t or boshiamy_j
#
# @return 0 if installed successfully
# @return 1 if the table file does not exist
function install_boshiamy() {
  name=$1
  table_file="$name.db"
  dict_file="$name.dict.yaml"
  schema_file="$name.schema.yaml"

  if [[ -f $table_file ]]; then
    ./ibus2rime.sh $table_file

    cp $dict_file $schema_file $RIME_HOME

    echo "$name -- \033[1;32m完成\033[m"
    echo ""

    return 0
  else
    echo "找不到 $table_file 檔案，跳過。"
    return 1
  fi
}

install_boshiamy boshiamy_t
install_boshiamy boshiamy_j

if [[ $PLATFORM == "unknown" ]]; then
  echo "\033[31m偵測到不支援的作業系統\033[m"
  echo "轉換完成的 *.yaml 會放在此資料夾，請自行複製到 RIME 的用戶資料夾。"
  echo ""
else
  echo "表格轉換完成之後，請編輯 \033[1;33m$RIME_HOME/default.custom.yaml\033[m 並把嘸蝦米輸入法加進去，例如："
  echo ""
  echo "    patch:"
  echo "      schema_list:  # 對於列表類型，現在無有辦法指定如何添加、消除或單一修改某項，於是要在定製檔中將整個列表替換！"
  echo "        - schema: luna_pinyin"
  echo "        - schema: cangjie5"
  echo "        - schema: luna_pinyin_fluency"
  echo "        - schema: luna_pinyin_simp"
  echo "        - schema: luna_pinyin_tw"
  echo "\033[32m        - schema: boshiamy_t  # 嘸蝦米中文模式\033[m"
  echo "\033[32m        - schema: boshiamy_j  # 嘸蝦米日文模式\033[m"
  echo    ""
fi
