# CREDITS
# Some of this file is mine <slarti@gentoo.org>, some is take from
# spider's <spider@gentoo.org> zshrc, and some from the zshwiki.org.
# Some bash functions are nicked from ciaranm's <ciaranm@gentoo.org>
# bashrc

# README
# * Remember to change the stuff specific to me! It's all at the top of
#   this file.
# * You can obviously only get the most out of this file if you take the
#   time to read through the comments. Of course, you can still see
#   zsh's superiority by simply plugging this file in and using it.

# BEGIN LOCAL
export MAILDIR="$HOME/.maildir/"

export BROWSER="firefox"
export TERMCMD="urxvtc"
export EDITOR="vim"

# Things from dev.gentoo.org/~ciaranm/configs/bashrc -- thanks Ciaran!
if [[ "${TERM}" == "rxvt-unicode" ]] ; then
    export TERMTYPE="256"
elif [[ "${TERM}" != "dumb" ]] ; then
    export TERMTYPE="16"
else
    export TERMTYPE=""
    export NOCOLOR="true"
fi

if [[ "${TERM}" == "rxvt-unicode" ]] && \
    [[ ! -f /usr/share/terminfo/r/rxvt-unicode ]] && \
    [[ ! -f ~/.terminfo/r/rxvt-unicode ]] ; then
    export TERM=rxvt
fi

if [[ -n "${PATH/*$HOME\/bin:*}" ]] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [[ -n "${PATH/*\/usr\/local\/bin:*}" ]] ; then
    export PATH="/usr/local/bin:$PATH"
fi

if [[ -n "${PATH/*$HOME\/.cabal\/bin:*}" ]] ; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

if [[ -f /usr/bin/less ]] ; then
    export PAGER=less
    export LESS="--ignore-case --long-prompt -RSNg"
fi
if [[ -f /usr/bin/vimpager ]] ; then
    export PAGER=vimpager
    export MANPAGER=vimmanpager
fi
alias page=$PAGER

#if [ -z $VG_VIEWGLOB_ACTIVE ] && [ $DISPLAY ] ; then
#    exec viewglob
#fi

# END LOCAL

# Change word boundary characters. Nabbed from
# http://zshwiki.org/KeyBindings.

# by default: export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# we take out the slash, period, angle brackets, dash here.
export WORDCHARS='*?_-[]~=&;!#$%^(){}'

# Follow GNU LS_COLORS for completion menus
zmodload -i zsh/complist
eval $(dircolors -b /home/th/.dir_colors)
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

# Load the completion system
autoload -U compinit; compinit

# Very powerful version of mv implemented in zsh. The main feature I
# know of it that seperates it from the standard mv is that it saves you
# time by being able to use patterns which are expanded into positional
# parameters. So:
#
# slarti@pohl % zmv (*)foo ${1}bar
#
# On a series of files like onefoo, twofoo, threefoo, fivefoo would be
# renamed to onebar twobar threebar fourbar.
#
# Although that's nifty enough, I suspect there are other features I
# don't know about yet...
#
# Read $fpath/zmv for some more basic examples of usage, and also use
# run-help on it :)
autoload -U zmv

# Command line calculator written in zsh, with a complete history
# mechanism and other shell features.
autoload -U zcalc

# Like xargs, but instead of reading lines of arguments from standard input,
# it takes them from the command line. This is possible/useful because,
# especially with recursive glob operators, zsh often can construct a command
# line for a shell function that is longer than can be accepted by an external
# command. This is what's often referred to as the "shitty Linux exec limit" ;)
# The limitation is on the number of characters or arguments.
# 
# slarti@pohl % echo {1..30000}
# zsh: argument list too long: /bin/echo
# zsh: exit 127   /bin/echo {1..30000}
autoload -U zargs

# Yes, we are as bloated as emacs
autoload -U tetris
zle -N tetris
bindkey "^Xt" tetris

# Makes it easy to type URLs as command line arguments. As you type, the
# input character is analyzed and, if it mayn eed quoting, the current
# word is checked for a URI scheme. If one is found and the current word
# is not already quoted, a blackslash is inserted before the input
# caracter.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# zed is a tiny command-line editor in pure ZSH; no other shell could do
# this.  zed itself is simple as anything, but it's killer feature for
# me is that it can edit functions on the go with zed -f <funcname> (or
# fned <funcname>. This is useful for me when I'm using and defining
# functions interactively, for example, when I'm working through the
# Portage tree in CVS. It allows me to edit a function on the fly,
# without having to call the last definition back up from the history
# and re-edit that in ZLE. It also indents the function, even if it was
# defined on all one line in the line editor, making it easy as anything
# to edit.
#
# ^X^W to save, ^C to abort.
autoload -U zed

# Incremental completion of a word. After starting this, a list of
# completion choices can be shown after every character you type, which
# can deleted with ^H or delete. Return will accept the current
# completion. Hit tab for normal completion, ^G to get back where you
# came from and ^D to list matches.
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word

# This function allows you type a file pattern, and see the results of
# the expansion at each step.  When you hit return, they will be
# inserted into the command line.
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

# This set of functions implements a sort of magic history searching.
# After predict-on, typing characters causes the editor to look backward
# in the history for the first line beginning with what you have typed so
# far.  After predict-off, editing returns to normal for the line found.
# In fact, you often don't even need to use predict-off, because if the
# line doesn't match something in the history, adding a key performs
# standard completion - though editing in the middle is liable to delete
# the rest of the line.
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on
bindkey "^Z" predict-off

# run-help is a help finder, bound in ZLE to M-h.  It doesn't need to be
# autoloaded to work - the non-autoloaded version just looks up a man
# page for the command under the cursor, then when that process is
# finished it pulls your old command line back up from the buffer stack.
# However, with the autoloaded function and:
#
# mkdir ~/zsh-help; cd ~/zsh-help MANPAGER="less" man zshbuiltins | \
# colcrt | perl /usr/share/zsh/4.2.1/Util/helpfiles
#
# It'll work for zsh builtins too. By the way, I've assumed some things
# in that command. ~/zsh-help can be wherever you like, MANPAGER needs
# to be any standard pager (less, pg, more, just not the MANPAGER I have
# defined in this file), colcrt can be col -bx, and the path to
# helpfiles may be different for you (Util may not even be installed
# with your distribution; fair enough, make install doesn't install it.
# Dig up a source tarball and everything's in there).

# Define our helpdir unalias run-help
HELPDIR=~/zsh-help
# We need to get rid of the old run-help (NOTE: if you source ~/.zshrc
# this will through up a warning about the alias not existing for
# unaliasing. The solution is to form an if construct, with the
# condition that run-help is aliased. I do not know how to do this.
#unalias run-help
# Load the new one
autoload -U run-help

# Colours
autoload -U colors; colors

# For those who want the default Gentoo prompt back.
# I used to have this earlier in the file, but it didn't work with
# *just* the gentoo prompt theme. I would investigate, but I'm
# lazy.
autoload -U promptinit; promptinit
prompt adam2

# _gnu_generic is a completion widget that parses the --help output of
# commands for options. df and feh work fine with it, however options
# are not described.
compdef _gnu_generic feh df

compdef _pkglist ecd emetadataviewer
compdef _useflaglist explainuseflag
compdef _category list_cat

compdef _nothing etc-update dispatch-conf fixpackages

# History things
HISTFILE=$HOME/.zshist
SAVEHIST=10000
HISTSIZE=10000
TMPPREFIX=$HOME/tmp

# Key bindings

# You can use:
# % autoload -U zkbd
# % zkbd
# to discover your keys.

# Vi keybindings
# bindkey -v

# Actually, stick with emacs for the moment. The vi keymap just doesn't
# seem to be as complete (even if it's nicer for editing, there's no
# execute-named-cmd bound, for example). I'm way too lazy to make my own
# new one.
bindkey -e

# Up, down left, right.
# echotc is part of the zsh/termcap module. It outputs the termcap value
# corresponding to the capability it was given as an argument. man zshmodules.
zmodload -i zsh/termcap
bindkey "$(echotc kl)" backward-char
bindkey "$(echotc kr)" forward-char
bindkey "$(echotc ku)" up-line-or-history
bindkey "$(echotc kd)" down-line-or-history

bindkey '\e[3~' delete-char # Delete

if [[ "$TERM" == "rxvt-unicode" ]]; then
    bindkey '\e[7~' beginning-of-line # Home
    bindkey '\e[8~' end-of-line # End
elif [[ "$TERM" == "linux" ]]; then
    bindkey '\e[1~' beginning-of-line # Home
    bindkey '\e[4~' end-of-line # End    
else # At least xterm; probably other terms too
    bindkey '^[[H' beginning-of-line # Home
    bindkey '^[[F' end-of-line # End
fi

bindkey '\e[5~' history-incremental-search-backward  # PageUp
bindkey '\e[6~' history-incremental-search-forward # PageDown

# Aliases
alias ls="ls -F --color=always"
alias mutt="mutt -y"
alias muttng="muttng -y"
alias cvs="colorcvs"

# This function sets the window tile to user@host:/workingdir before each
# prompt. If you're using screen, it sets the window title (works
# wonderfully for hardstatus lines :)
precmd() {
#    [[ -t 1 ]] || return
    case $TERM in
	*xterm*|rxvt*) print -Pn "]2;%n@%m:%~\a"
	;;
	screen*) print -Pn "\"%n@%m:%~\134"
	;;
    esac
}

# This sets the window title to the last run command.
preexec() {
#    [[ -t 1 ]] || return
    case $TERM in
	*xterm*|rxvt*)
	print -Pn "]2;$1\a"
	;;
	screen*)
	print -Pn "\"$1\134"
	;;
    esac
}

# Some home cooked functions - pinched from Ciaran McCreesh
# <ciaranm@gentoo.org> because I've got no imagination.

# change to an ebuild's directory.
ecd() {
    local pc d

    pc=$(efind $*)
    d=$(eportdir)

    if [[ $pc == "" ]] ; then
	echo "nothing found for $*"
	return 1
    fi

    cd ${d}/${pc}
}

# find either a cvs co of gentoo's portage module or the portage directory, and
# echo the result.
eportdir() {
    # does fast cache magic. portageq in particular is really slow...
    # this makes subsequent calls to eportdir() pretty much
    # instantaneous, as opposed to taking several seconds.
    if [[ -n "${PORTDIR_CACHE}" ]] ; then
	echo "${PORTDIR_CACHE}"
    elif [[ -d ${HOME}/cvs/portage ]] ; then
	PORTDIR_CACHE="${HOME}/cvs/portage" eportdir 
    elif [[ -d /usr/portage ]] ; then
	PORTDIR_CACHE="/usr/portage" eportdir
    else
	PORTDIR_CACHE="$(portageq portdir )" eportdir
    fi
}

efind() {
    local efinddir cat pkg
    efinddir=$(eportdir)

    case $1 in
	*-*/*)
	pkg=${1##*/}
	cat=${1%/*}
	;;

	?*)
	pkg=${1}
	cat=$(echo1 ${efinddir}/*-*/${pkg}/*.ebuild)
	[[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/${pkg}*/*.ebuild)
	[[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}/*.ebuild)
	[[ -f $cat ]] || cat=$(echo1 ${efinddir}/*-*/*${pkg}*/*.ebuild)
	if [[ ! -f $cat ]]; then
	    return 1
	fi
	pkg=${cat%/*}
	pkg=${pkg##*/}
	cat=${cat#${efinddir}/}
	cat=${cat%%/*}
	;;
    esac

    echo ${cat}/${pkg}
}

echo1() {
    echo "$1"
}

ewho() {
    local pc d metadata f

    pc=$(efind $*)
    d=$(eportdir)
    f=0

    if [[ $pc == "" ]] ; then
	echo "nothing found for $*"
	return 1
    fi

    metadata="${d}/${pc}/metadata.xml"
    if [[ -f "${metadata}" ]] ; then
	echo "metadata.xml says:"
	sed -ne 's,^.*<herd>\([^<]*\)</herd>.*,  herd:  \1,p' \
	"${metadata}"
	sed -ne 's,^.*<email>\([^<]*\)@[^<]*</email>.*,  dev:   \1,p' \
	"${metadata}"
	f=1
    fi

    if [[ -d ${d}/${pc}/CVS ]] ; then
	echo "CVS log says:"
	pushd ${d}/${pc} > /dev/null
	for e in *.ebuild ; do
	    echo -n "${e}: "
	    cvs log ${e} | sed -e '1,/^revision 1\.1$/d' | sed -e '2,$d' \
	    -e "s-^.*author: --" -e 's-;.*--'
	done
	popd > /dev/null
	f=1
    fi

    if [[ f == 0 ]] ; then
	echo "Nothing found, so blame seemant"
	return 1
    fi
    return 0
}

# FIXME: Add more later... I'm boring. These functions are all mine.

# convert my FLACs to Vorbis and mv them to the right place
# must be in a ~/audio/flac/artist/album/ for it to work. I doubt anyone
# else on the planet would find any use for this but me.
flacvorbmv() {
    oggenc -q7 *.flac
    mkdir -p "${PWD%flac*}${PWD#*flac}"
    mv *.ogg "${PWD%flac*}${PWD#*flac}"
}

bug() {
    w3m "http://bugs.gentoo.org/show_bug.cgi?id=$1"
}

google() {
    w3m "http://www.google.com/search?q=$@"
}

foldoc() {
    w3m "http://wombat.doc.ic.ac.uk/foldoc/foldoc.cgi?query=$1&action=Search"
}

fm() {
    w3m "http://www.freshmeat.net/search/?q=$@"
}

fw() {
    w3m "http://www.filewatcher.org/?q=$@"
}

# Pretty menu!
zstyle ':completion:*' menu select=1

# Completion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
zstyle ':completion::complete:*' '\'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

#  tag-order 'globbed-files directories' all-files 
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# With commands like rm, it's annoying if you keep getting offered the same
# file multiple times. This fixes it. Also good for cp, et cetera..
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'

# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Simulate spider's old abbrev-expand 3.0.5 patch 
#zstyle ':completion:*:history-words' stop verbose
#zstyle ':completion:*:history-words' remove-all-dups yes
#zstyle ':completion:*:history-words' list false

# From the zshwiki. Hide CVS files/directores from being completed.
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Also from the wiki. Hide uninteresting users from completion.
zstyle ':completion:*:*:*:users' ignored-patterns \
adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys \
www-data alias amavis at clamav cmd5checkpw cron cyrus dhcp dnscache \
dnslog foldingathome guest haldaemon jabber ldap mailman mpd mysql \
nut p2p portage postmaster qmaild qmaill qmailp qmailq qmailr qmails \
smmsp tinydns vpopmail wasabi zope

# Pull hosts from $HOME/.ssh/known_hosts, also from the wiki
# local _myhosts
_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*' hosts $_myhosts

# Approximate completion. From the wiki.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Options
setopt			\
NO_all_export		\
   always_last_prompt	\
   always_to_end	\
   append_history	\
   auto_cd		\
   auto_list		\
   auto_menu		\
   auto_name_dirs	\
   auto_param_keys	\
   auto_param_slash	\
   auto_pushd		\
   auto_remove_slash	\
NO_auto_resume		\
   bad_pattern		\
   bang_hist		\
NO_beep			\
   brace_ccl		\
   correct_all		\
NO_bsd_echo		\
NO_cdable_vars		\
NO_chase_links		\
   clobber		\
   complete_aliases	\
   complete_in_word	\
   correct		\
NO_correct_all		\
   csh_junkie_history	\
NO_csh_junkie_loops	\
NO_csh_junkie_quotes	\
NO_csh_null_glob	\
   equals		\
   extended_glob	\
   extended_history	\
   function_argzero	\
   glob			\
NO_glob_assign		\
   glob_complete	\
NO_glob_dots		\
NO_glob_subst		\
NO_hash_cmds		\
NO_hash_dirs		\
   hash_list_all	\
   hist_allow_clobber	\
   hist_beep		\
   hist_ignore_dups	\
   hist_ignore_space	\
NO_hist_no_store	\
   hist_verify		\
NO_hup			\
NO_ignore_braces	\
NO_ignore_eof		\
   interactive_comments	\
   inc_append_history	\
NO_list_ambiguous	\
NO_list_beep		\
   list_types		\
   long_list_jobs	\
   magic_equal_subst	\
NO_mail_warning		\
NO_mark_dirs		\
   menu_complete	\
   multios		\
   nomatch		\
   notify		\
NO_null_glob		\
   numeric_glob_sort	\
NO_overstrike		\
   path_dirs		\
   posix_builtins	\
NO_print_exit_value 	\
NO_prompt_cr		\
   prompt_subst		\
   pushd_ignore_dups	\
NO_pushd_minus		\
   pushd_silent		\
   pushd_to_home	\
   rc_expand_param	\
NO_rc_quotes		\
NO_rm_star_silent	\
NO_sh_file_expansion	\
   sh_option_letters	\
   short_loops		\
NO_sh_word_split	\
NO_single_line_zle	\
NO_sun_keyboard_hack	\
NO_verbose		\
   zle


# This line was appended by KDE
# Make sure our customised gtkrc file is loaded.
export GTK2_RC_FILES=$HOME/.gtkrc-2.0

alias ll="ls -lh --color=auto"
alias la="ls -lha --color=auto"

export HOSTNAME=heptachlor

alias mvnd='MAVEN_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=n" mvn'

export mvnc='MAVEN_OPTS="-Xmx384M -XX:MaxPermSize=128m" mvn'

alias diff=colordiff

alias grep="grep --color=auto"

alias remind="remind -b1 -m"

# color diffs for SVN
function svndiff () {
  if [ "$1" != "" ]; then
    svn diff $@ | colordiff | less -R;
  else
    svn diff | colordiff | less -R;
  fi
}

export OOO_FORCE_DESKTOP=gnome

