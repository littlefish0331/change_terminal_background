# Change Windows Terminal Background in cmd

tags: @oh-my-posh @LazoCoder-PokemonTerminal @microsoft-terminal @cmd @R

## 效果

![change cmd background image](./effect.gif?raw=true "effect.gif")

## 未來希望有的功能

- .bat檔中藥可以判斷是否有輸入參數。或是R裡面要能做判斷，但應該是bat檔中要做調整
- pass specify parameter to bat file
- 多個tags的篩選。

> Rscript ver02_ver01_clean.R -t cute  
> callR.bat cute

---

## 中文簡介

### 靈感來源

windows 推出新的命令提示字元視窗之後，  
整體的風格變動很多，其中增加了許多可變動的地方，  
基本上就是linux的oh-my-zsh為模板(畢竟執行長是linux技術出身)。

偶然間看到 [LazoCoder/Pokemon-Terminal: Pokemon terminal themes.](https://github.com/LazoCoder/Pokemon-Terminal) 這個專案，  
覺得十分有趣，  

再加上新版的terminal背景，可以如同桌面一樣，放置gif檔。  
所以決定建立一個自己的圖庫，利用資料夾分類的方式，也可以做到切換桌布的做法。

### 流程構想

底層是用 R 寫的指令，  
基本上構想很簡單，就是更改 terminal 設定檔的圖片路徑，  
取代後再存檔。

而寫好的Rscrip再用bash指令做呼叫，寫成.bat檔。

### 技術

- bash 指令的參數傳遞。
- bash包覆Rscript
- R存檔時使用 LF 作為 eol。(原始的 windows terminal settings.json是用LF做eol的，為避免後續的出錯，所以盡可能和原始檔案構造相同。)

### 函數與資料表設計

選擇想要的背景，主要依照資料表完成。

- 圖片列表 [cate = dir_name, image_tags, file_format, aid]
  - PK = cate + file_format + aid，所以可能有image_tags完全相同的情形

- Rfunction參數: -cate, -format, -aid, -tag
  - 把下面想成filter資料表，再sample
  - 完整要有參數: -cate, -format, -aid
    - 只給參數 -cate，則隨機吐一張在dir_name下的背景
    - 只給參數 -tag，則隨機吐一張符合image_tags的背景
    - 只給參數 -format，則隨機吐一張符合file_format的背景

---

## English Introduction

### idea

After windows publish new version of terminal, it become more attractive.  
And if you are familiar with linux bash, it's look like it a lot.

So, there are lots of tutorials which teach how to change windows-terminal more beautiful.  
Just like oh-my-zsh in unix, you can install oh-my-posh in windows terminal.

One day, I find a interesing project [LazoCoder/Pokemon-Terminal: Pokemon terminal themes.](https://github.com/LazoCoder/Pokemon-Terminal), besides, I know new version terminal can have gif image.  
So, I decided to do this project which can change your terminal background by command.

### how to do

use R to read settings.json of windows terminal.  
(Python is also good, but I'm R-user. XD~)  
(Mybe one day I will write a python script.)

Rewrite the background image path and save it.

### technical skill

- use bash to call Rscript
- pass param in bash command
- save file with "LF" eol by R

### function and datatable

- background image data [cate = dir_name, image_fullname, image_abbr, file_format, aid]
  - PK = cate + file_format + aid，(it's possible to have same image_fullname/image_abbr)

- Rfunction param: -cate, -format, -aid, -tag
  - just filter from above data, and then sample
  - complete param: -cate, -format, -aid
    - if only -cate，則隨機吐一張在dir_name下的jpg/png/gif
    - if only -tag，則隨機吐一張符合image_fullname/image_abbr的背景
    - if only -format，則隨機吐一張符合format的背景

