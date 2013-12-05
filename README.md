# rime-boshiamy

在 [Rime](https://code.google.com/p/rimeime/) 使用嘸蝦米。

本程式不提供嘸蝦米表格檔，您必須先購買正版的嘸蝦米，才能從官方網站取得 Linux 版的表格檔來轉換。

## 主要功能

* 打繁出簡（RIME 內建的繁轉簡）
* 日文漢字模式（做為另一個輸入法存在）
* 漢語拼音輸入／反查模式（RIME 內建，不會拆字時應急用）
* 找不到字碼 fallback 到英文輸入

## 不支援的官蝦功能

* `，，Ｔ` 、`，，ＣＴ` 、`，，Ｊ`
* 注音反查
* liu.box
* 強迫快打／快打反查
* 符號表

## 尚未實作的功能

以下是 RIME 有支援，但目前沒有實作出來的功能：

* Unicode Ext 擴展漢字（RIME 有內建的機制，但需配合 Ext-A/B 加字檔）
* 以詞為單位的自動選字（使你不再需要修正「斷護」→「所以」）
* etc. etc.

## 系統需求

* UNIX Shell 環境，不支援 Windows
* SQLite 3

## 安裝方式

1. 到[行易網站](http://boshiamy.com/member_download.php)登入會員，下載 Linux 用的 **ibus 表格檔**。
   如果您沒有會員帳號，請在網站上購買網路下載版，就可以成為會員。
   購買的版本可以是 Windows 或 Mac OS X 不拘。

2. 解壓縮 ibus 表格檔之後，把 `boshiamy_t.db` 和 `boshiamy_j.db` 放到這個資料夾裡面。
   注意「打繁出簡」 (`boshiamy_tc`) 字典檔**不需要**，因為 Rime 內建繁轉簡。

3. 執行安裝程式：

   ```sh
   ./install.sh
   ```

   它會把 ibus 表格檔轉換成 RIME 字典檔，並且連同 schema 檔複製到 RIME 的用戶資料夾裡面。

4. 要啟用嘸蝦米輸入法，必須在用戶資料夾的 `default.custom.yaml` 裡面打開：

    ```yml
    # default.custom.yaml

    patch:
      schema_list:  # 對於列表類型，現在無有辦法指定如何添加、消除或單一修改某項，於是要在定製檔中將整個列表替換！
        # 略
        - schema: boshiamy_t  # 嘸蝦米中文模式
        - schema: boshiamy_j  # 嘸蝦米日文模式
    ```

最後還要重新部署 (Deploy) RIME 輸入法。

## 著作權聲明

本轉換程式的作者是 Yu-Cheng Chuang，依 MIT License 授權發佈。完整的授權條款見 LICENSE 檔案。

請注意**表格檔的內容著作權仍屬於行易有限公司**，您使用本程式轉換出來的 Rime 表格檔，其著作
權並不在於您，也不歸屬於本程式的作者。您不可以散佈轉換出來的表格檔，否則會侵犯行易有限
公司的著作權。轉換之後的檔案可以使用在哪些電腦，請依照當初購買時的授權條款來使用。

本程式的作者主張使用本程式將 ibus 表格檔轉換成 Rime 字典檔供個人使用，屬合理使用範圍，
目的是使之可以在 Rime 相關的輸入法引擎（如 OS X 的鼠鬚管）運作，以增進使用體驗。本轉換程式
的作者無意侵犯行易有限公司的嘸蝦米表格檔的著作權。
