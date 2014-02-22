#!/bin/sh
#
# liubox2rime.sh
#
# 將OSX版嘸蝦米輸出的liu.box轉換為RIME辭典格式，並寫入於boshiamy_[t,j].dict.yaml最尾端
#

if [[ -f "liu.box" ]]; then
    awk 'BEGIN{ORS=""} NR>1 && $1!="%chardef" {for (i=2; i<=NF; i++) print $i; print "\t" $1 "\n"}' < liu.box >> $1
fi
