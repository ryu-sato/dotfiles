" バッファ動作に関する設定
set hidden           "複数のファイルを編集中にできる
set ambiwidth=double "2Byte文字記号を2文字幅とする
" カーソル位置を表示する
set ruler
" ステータスラインを表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" 行数を表示する
set number
" 文字コードを設定する(最初にマッチしたものが使用される)
set fileencodings=utf-8,euc-jp,sjis
set tabstop=4
" TABの設定の仕方
set ts=4 sw=4 sts=0
" 補完機能を制御する
set wildmode=list:full
" Tabの左端にカーソルを表示
" 改行文字を表示する
set listchars=tab:\ \ 
set list
" ソースに色をつけて表示（ハイライトさせる）
syntax on
" 挿入中に改行を削除できるようにする
set backspace=1
" Use pathogen
execute pathogen#infect()
