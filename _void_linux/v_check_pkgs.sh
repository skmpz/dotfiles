#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=50           # log length
s_line_cols=80          # hr line length
s_sudo_perm="NO"        # sudo perm needed
s_line_color="BLUE"     # hr line color
s_main_color="YELLOW"   # main action color
s_plus_color="WHITE"    # sign color
s_sec_color="WHITE"     # section color
s_ok_color="GREEN"      # ok color
s_info_color="PURPLE"   # info color
s_fail_color="RED"      # fail color
# ------------------------- settings ---------------------------

# ----------------------- helper funcs -------------------------
NC="\033[0m"        RED="\033[0;31m"   GREEN="\033[0;32m"
YELLOW="\033[0;33m" WHITE="\033[0;97m" BLUE="\033[0;34m"
PURPLE="\033[0;35m" CYAN="\033[0;36m"  GREY="\033[0;90m"

function _check_ok {
    if [ $1 == 0 ]; then
        echo -en "[${!s_ok_color}OK${NC}]"
        if [ ! -z "$2" ]; then echo -e "[${!s_info_color}${2}${NC}]"; else echo ""; fi
    else
        echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1
    fi
}

function _check_no_ok {
    if [ $1 == 0 ]; then return; else echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1; fi
}

function _start {
    str_len=${#1}
    str_len=$((s_log_cols-str_len))
    echo -en "${!s_main_color}[${!s_plus_color}-${!s_main_color}] $1 "
    v=$(printf "%-${str_len}s" ".")
    echo -en "${v// /.} ${NC}"
    echo "------- $1" >> $LOGFILE
}

function _done {
    echo -en "[${!s_ok_color}OK${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
}

function _fail {
    echo -en "[${!s_fail_color}FAIL${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
    exit 1
}

function _line {
    v=$(printf "%-${s_line_cols}s" "-")
    echo -e "${!s_line_color}${v// /-} ${NC}"
}

function _print {
    echo -e "${!s_main_color}${1}${NC}"
}

function _sudo {
    if [[ $EUID -ne 0 ]]; then
        _line
        echo -e "[${RED}Error${NC}] ${!s_main_color}Sudo permissions required to run this script${NC}"
        _line
        exit 1
    fi
}

function _cmd_ok {
    eval "$@" >> $LOGFILE 2>&1
    _check_ok $?
}

function _cmd_no_ok {
    eval "$@" >> $LOGFILE 2>&1
    _check_no_ok $?
}

function _cmd_out {
    ret=$(eval "$@" 2>> $LOGFILE)
    _check_no_ok $?
}

function _section {
_line
echo -e "${!s_main_color}[${!s_plus_color}+${!s_main_color}] ${!s_sec_color}$@"
_line
}

# ----------------------- helper funcs -------------------------

# ------------------------ initialize --------------------------
SCRIPT=$(basename $0)        # get script name
LOGFILE="$PWD/.$SCRIPT.log"  # set logfile
echo "" > $LOGFILE           # empty logfile
start_time=`date +%s`        # start timer
if [ "$s_sudo_perm" == "YES" ]; then _sudo; fi
_line
echo -e "${!s_info_color}Script: $SCRIPT${NC}"
echo -e "${!s_info_color}Logfile: $LOGFILE${NC}"
echo -e "${!s_info_color}Started: $(date -d@$((start_time)) -u +%H:%M:%S)${NC}"
# ------------------------ initialize --------------------------

# ------------------------ main script -------------------------

# grab git user/mail
git_user=$(git config -l | grep name | cut -f2 -d=)
git_mail=$(git config -l | grep email | cut -f2 -d=)

function _check_update {
    _cmd_out "./xbps-src update-check $@"
    if [ "$ret" != "" ]; then
        _start "Update found for $@"
        new_version=$(echo "$ret" | tail -1 | rev | cut -d'-' -f1 | rev)
        old_version=$(cat $HOME/void-packages/srcpkgs/$@/template | grep 'version=' | cut -f2 -d'=')
        echo -e "[${WHITE}${old_version} -> ${new_version}${NC}]"
    fi
}

# switch to directory
cd $HOME/void-packages/

# sync with latest
_section "Syncing"
_start "Switching to master"
branch=$(git branch | grep \* | awk '{print $2}');
if [ "$branch" != "$1" ]; then
    _cmd_ok "git checkout master"
fi
_start "Updating packages"
_cmd_ok "git pull --rebase upstream master"

# show outdated maintained packages
_section "Outdated maintained packages"
for f in $(ls srcpkgs); do
    if [ ! -L "srcpkgs/$f" ]; then
        MAINTAINER=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer | cut -f2 -d'"')
        if [ "$MAINTAINER" == "$git_user <$git_mail>" ]; then
            _check_update "$f"
        fi
    fi
done

# show outdated used orphaned packages
_section "Outdated used orphaned packages"
for f in $(xbps-query -l | awk '{print $2}' | rev | cut -f2- -d- | rev); do
    MAINTAINER=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer | cut -f2 -d'"')
    if [ "$MAINTAINER" == "Orphaned <orphan@voidlinux.org>" ]; then
        _check_update "$f"
    fi
done

# ------------------------ main script -------------------------

# print run info
_line
end_time=`date +%s`
echo -e "${YELLOW}Runtime: $(date -d@$((end_time-start_time)) -u +%H:%M:%S)"
_line
