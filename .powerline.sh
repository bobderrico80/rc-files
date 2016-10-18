#!/usr/bin/env bash

__ps_init() {
    # Color Palette
    readonly PS_BG_BLACK="\[$(tput setab 0)\]"
    readonly PS_BG_RED="\[$(tput setab 1)\]"
    readonly PS_BG_GREEN="\[$(tput setab 2)\]"
    readonly PS_BG_YELLOW="\[$(tput setab 3)\]"
    readonly PS_BG_BLUE="\[$(tput setab 4)\]"
    readonly PS_BG_PURPLE="\[$(tput setab 5)\]"
    readonly PS_BG_CYAN="\[$(tput setab 6)\]"
    readonly PS_BG_LIGHTGREY="\[$(tput setab 7)\]"
    readonly PS_BG_DARKGREY="\[$(tput setab 8)\]"
    readonly PS_BG_BRIGHTRED="\[$(tput setab 9)\]"
    readonly PS_BG_BRIGHTGREEN="\[$(tput setab 10)\]"
    readonly PS_BG_BRIGHTYELLOW="\[$(tput setab 11)\]"
    readonly PS_BG_BRIGHTBLUE="\[$(tput setab 12)\]"
    readonly PS_BG_BRIGHTPURPLE="\[$(tput setab 13)\]"
    readonly PS_BG_BRIGHTCYAN="\[$(tput setab 14)\]"
    readonly PS_BG_BRIGHTWHITE="\[$(tput setab 15)\]"

    readonly PS_FG_BLACK="\[$(tput setaf 0)\]"
    readonly PS_FG_RED="\[$(tput setaf 1)\]"
    readonly PS_FG_GREEN="\[$(tput setaf 2)\]"
    readonly PS_FG_YELLOW="\[$(tput setaf 3)\]"
    readonly PS_FG_BLUE="\[$(tput setaf 4)\]"
    readonly PS_FG_PURPLE="\[$(tput setaf 5)\]"
    readonly PS_FG_CYAN="\[$(tput setaf 6)\]"
    readonly PS_FG_LIGHTGREY="\[$(tput setaf 7)\]"
    readonly PS_FG_DARKGREY="\[$(tput setaf 8)\]"
    readonly PS_FG_BRIGHTRED="\[$(tput setaf 9)\]"
    readonly PS_FG_BRIGHTGREEN="\[$(tput setaf 10)\]"
    readonly PS_FG_BRIGHTYELLOW="\[$(tput setaf 11)\]"
    readonly PS_FG_BRIGHTBLUE="\[$(tput setaf 12)\]"
    readonly PS_FG_BRIGHTPURPLE="\[$(tput setaf 13)\]"
    readonly PS_FG_BRIGHTCYAN="\[$(tput setaf 14)\]"
    readonly PS_FG_WHITE="\[$(tput setaf 15)\]"

    # Text Options
    readonly PS_DIM="\[$(tput dim)\]"
    readonly PS_REVERSE="\[$(tput rev)\]"
    readonly PS_RESET="\[$(tput sgr0)\]"
    readonly PS_BOLD="\[$(tput bold)\]"

    # Colors that change based on state
    PS_BG_LAST=""
    PS_FG_LAST=""
    PS_LAST_STATUS=0
    PS_NO_COLOR=""
    PS_SEPARATOR=''
    PS_SHORT_SEPARATOR=''

    # Declare the color lists so we can look them up later.
    PS_BG_COLORS=($PS_BG_BLACK $PS_BG_RED $PS_BG_GREEN $PS_BG_YELLOW $PS_BG_BLUE $PS_BG_PURPLE $PS_BG_CYAN $PS_BG_LIGHTGREY $PS_BG_DARKGREY $PS_BG_BRIGHTRED $PS_BG_BRIGHTGREEN $PS_BG_BRIGHTYELLOW $PS_BG_BRIGHTBLUE $PS_BG_BRIGHTPURPLE $PS_BG_BRIGHTCYAN $PS_BG_BRIGHTWHITE)
    PS_FG_COLORS=($PS_FG_BLACK $PS_FG_RED $PS_FG_GREEN $PS_FG_YELLOW $PS_FG_BLUE $PS_FG_PURPLE $PS_FG_CYAN $PS_FG_LIGHTGREY $PS_FG_DARKGREY $PS_FG_BRIGHTRED $PS_FG_BRIGHTGREEN $PS_FG_BRIGHTYELLOW $PS_FG_BRIGHTBLUE $PS_FG_BRIGHTPURPLE $PS_FG_BRIGHTCYAN $PS_FG_BRIGHTWHITE)

    # == Utility functions ===========================
    ps_find_index() {
        local value=$1
        local i=0
        shift

        while [ -n "$1" ]; do
            if [ "$1" == "$value" ]; then
                printf $i;
                return
            fi

            shift
            i=$((i+1))
        done
    }

    ps_add() {
        local bgcolor=$1
        local fgcolor=$2
        local text="${*:3}"

        if [ -n "$text" ]; then
            if [ "$PS_NO_COLOR" == "true" ]; then
                if [ -n "$PS_BG_LAST" ]; then
                    PS1+=" $PS_SHORT_SEPARATOR "
                fi

                PS_BG_LAST=1
                PS1+="$text"
            else
                PS1+=$PS_RESET

                if [ -z "$PS_BG_LAST" ]; then
                    PS1+="$bgcolor$fgcolor"
                else
                    local sep_color=$(ps_find_index $PS_BG_LAST ${PS_BG_COLORS[*]})
                    local next_color=$(ps_find_index $bgcolor ${PS_BG_COLORS[*]})
                    if [ "$sep_color" == "$next_color" ]; then
                        PS1+="$bgcolor$PS_FG_LAST$PS_SHORT_SEPARATOR$fgcolor"
                    else
                        PS1+="$bgcolor${PS_FG_COLORS[$sep_color]}$PS_SEPARATOR$fgcolor"
                    fi
                fi

                PS_BG_LAST=$bgcolor
                PS_FG_LAST=$fgcolor
                PS1+=" $text $PS_RESET"
            fi
        fi
    }

    ps_finish() {
        if [ "$PS_NO_COLOR" == "true" ]; then
            PS1+=" $PS_SHORT_SEPARATOR"
        else
            PS1+="$PS_RESET"

            local sep_color=$(ps_find_index $PS_BG_LAST ${PS_BG_COLORS[*]})
            if [ -n "$sep_color" ]; then
                PS1+="${PS_FG_COLORS[$sep_color]}$PS_SEPARATOR$PS_RESET"
            fi
        fi

        PS_BG_LAST=""
        PS_FG_LAST=""
        PS1+=" "
    }

    # == Various displays ============================

    ps_display_date() {
        printf "$PS_BG_DARKGREY $PS_FG_WHITE $(date "+$PS_DATE_FORMAT")"
    }

    ps_display_datetime() {
        printf "$PS_BG_DARKGREY $PS_FG_WHITE $(date "+$PS_DATE_FORMAT $PS_TIME_FORMAT")"
    }

    ps_display_exitcode() {
        if [ $PS_LAST_STATUS -ne 0 ]; then
            printf "$PS_BG_RED $PS_FG_WHITE ✖ $PS_LAST_STATUS"
        fi
    }

    ps_display_git() {
        # Make sure git is installed
        [ -x "$(which git)" ] || return

        # get current branch name or short SHA1 hash for detached head
        local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return

        local bg
        local marks
        if [ -n "$(git status --porcelain)" ]; then
            bg=$PS_BG_RED
            if [ "$PS_NO_COLOR" == "true" ]; then
                marks+=" +"
            fi
        else
            bg=$PS_BG_GREEN
        fi

        local stat="$(git status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead \d\+' | grep -o '\d\+')"
        [ -n "$aheadN" ] && marks+=" ⇡$aheadN"

        [ -n "$behindN" ] && marks+=" ⇣$behindN"
        local behindN="$(echo $stat | grep -o 'behind \d\+' | grep -o '\d\+')"
        printf "$bg $PS_FG_BLACK ⑂ $branch$marks"
    }

    ps_display_mercurial() {
        [ -x "$(which hg)" ] || return

        local branch=$(hg id -b 2>/dev/null)
        [ -n "$branch" ] || return

        local bg
        local marks
        if [ -n "$(hg status)" ]; then
            bg=$PS_BG_BRIGHTRED
            if [ "$PS_NO_COLOR" == "true" ]; then
                marks+=" +"
            fi
        else
            bg=$PS_BG_GREEN
        fi

        # Incoming/Outgoing is really slow, revisit this.
        # local marks
        # local aheadN="$(hg outgoing -q --template "{node}\n" | wc -l)"
        # [ -n "$aheadN" ] && marks+=" ⇡$aheadN"

        # local behindN="$(hg incoming -q --template "{node}\n" | wc -l)"
        # [ -n "$behindN" ] && marks+=" ⇣$behindN"

        printf "$bg $PS_FG_WHITE ⑂ $branch$marks"

    }

    ps_display_os() {
        local symbol

        case "$(uname)" in
            Darwin)
                symbol=''
                ;;
            Linux)
                symbol='$'
                ;;
            *)
                symbol='%'
        esac

        local color=$PS_FG_GREEN
        if [ $PS_LAST_STATUS -ne 0 ]; then
            color=$PS_FG_RED

            if [ "$PS_NO_COLOR" == "true" ]; then
                symbol='✖'
            fi
        fi

        printf "$PS_BG_DARKGREY $color $symbol"
    }

    ps_display_path() {
        printf "$PS_BG_BLUE $PS_FG_WHITE \w"
    }

    ps_display_root() {
        if [ "$UID" == "0" ]; then
            printf "$PS_BG_RED $PS_FG_WHITE $USER"
        fi
    }

    ps_display_time() {
        printf "$PS_BG_DARKGREY $PS_FG_WHITE $(date "+$PS_TIME_FORMAT")"
    }

    ps_display_username() {
        if [ "$UID" == "0" ]; then
            printf "$PS_BG_RED $PS_FG_WHITE $USER"
        else
            printf "$PS_BG_CYAN $PS_FG_WHITE $USER"
        fi
    }

    ps_display_virtualenv() {
        local environment="${VIRTUAL_ENV#$WORKON_HOME/}"
        [ -n "$environment" ] || return

        printf "$PS_BG_LIGHTGREY $PS_FG_BLACK $environment"
    }

    # == Execution ================

    # Load User settings
    PS_DATE_FORMAT='%m/%d'
    PS_TIME_FORMAT='%-I:%M:%S%P'
    PS_FEATURES='time username virtualenv path mercurial git os'
    [ -r "$HOME/.powershell" ] && source "$HOME/.powershell"

    ps1() {
        PS_LAST_STATUS=$?
        PS1=""

        for i in $PS_FEATURES; do
            case "$i" in
                date) ps_add $(ps_display_date) ;;
                datetime) ps_add $(ps_display_datetime) ;;
                exitcode) ps_add $(ps_display_exitcode) ;;
                git) ps_add $(ps_display_git) ;;
                mercurial) ps_add $(ps_display_mercurial) ;;
                root) ps_add $(ps_display_root) ;;
                os) ps_add $(ps_display_os) ;;
                path) ps_add $(ps_display_path) ;;
                time) ps_add $(ps_display_time) ;;
                username) ps_add $(ps_display_username) ;;
                virtualenv) ps_add $(ps_display_virtualenv) ;;
            esac
        done

        ps_finish
    }

    PROMPT_COMMAND=ps1
}

__ps_init
unset __ps_init
