#!/bin/sh
#
# liubox2rime.sh
#
# 讀取OSX官版嘸蝦米的加字加詞內容並轉換為RIME詞庫格式，再寫入至相對應詞庫之最尾端
#

if [ $(uname -s) == "Darwin" ]; then
    RIME_DICT="boshiamy_$1.dict.yaml"
    LIUBOX_PATH="$HOME/Library/Application Support/Boshiamy"
    LIUBOX_FILE="UserPhrasesTC.cin" # 預設使用正體中文版的詞庫

    case $1 in
        "t")
            LIUBOX_FILE="UserPhrasesTC.cin"
            ;;
        "j")
            LIUBOX_FILE="UserPhrasesJP.cin"
            ;;
        *)
            ;;
    esac

    awk 'BEGIN{ORS=""} NR>1 && $1!="%chardef" {for (i=2; i<=NF; i++) print $i; print "\t" $1 "\n"}' < "$LIUBOX_PATH/$LIUBOX_FILE" >> $RIME_DICT
fi
