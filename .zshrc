# $FreeBSD: src/share/skel/dot.cshrc,v 1.13 2001/01/10 17:35:28 archie Exp $
#
# .cshrc - csh resource script, read at beginning of execution by each shell
#
# see also csh(1), environ(7).
#

PROMPT='%m[%T]%# '
RPROMPT=' %~'
export LANG=ja_JP.utf8
export LC_TIME=C

if [ -x "`where dircolors`" ] && [ -e "$HOME/.dircolors" ]; then
	eval `dircolors $HOME/.dircolors` # 色を設定する
fi
#alias ls='/usr/local/bin/jls -G'
alias ls='ls --color=tty'
alias history='history -d'

# A righteous umask
umask 022

path=(/sbin /bin /usr/sbin /usr/bin /opt/interbase/bin /usr/games /usr/local/sbin /usr/local/bin /usr/X11R6/bin $HOME/bin)

if [ -f /usr/local/bin/vim  ]; then
	export  EDITOR="vim"
else
	export	EDITOR="vi"
fi

if [ -f /usr/local/bin/lv ]; then
	export  PAGER="lv"
elif [ -f /usr/bin/lv ]; then
	export  PAGER="lv"
else
	export	PAGER="more"
fi
export	BLOCKSIZE="K"
export  XMODIFIERS="@im=SCIM"
export  GTK_IM_MODULE="scim"

if [ $?prompt ]; then
	# An interactive shell -- set some stuff up
	autoload -U compinit
	compinit

	# リダイレクトによる上書きを拒否する
	setopt no_clobber
	# ^Dでログインをしない
	setopt ignore_eof
	# ディレクトリ名だけで移動する
	setopt auto_cd
	# 1つ前のディレクトリを記憶する
	setopt auto_pushd
	#  同じディレクトリを記憶しない
	setopt pushd_ignore_dups
	# emacsキーバインド
	bindkey -e

	# for hisory
	HISTFILE=~/.zsh_history
	HISTSIZE=1000000
	SAVEHIST=1000000
	setopt	hist_ignore_all_dups    # 既にヒストリにあるコマンド行は古い方を削除
	setopt	hist_reduce_blanks		# コマンドラインの余計なスペースを排除
	setopt	share_history			# ヒストリの共有
	setopt  print_eight_bit         # 候補に日本語を表示
	setopt  extended_history        # ヒストリに実行時刻を表示

	MAILPATH="/var/mail/$USER"
fi
