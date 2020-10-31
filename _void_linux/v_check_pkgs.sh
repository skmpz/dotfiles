#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=60           # log length
s_line_cols=80          # hr line length
s_sudo_perm="NO"        # sudo perm needed
s_line_color="BLUE"     # hr line color
s_main_color="YELLOW"   # main action color
s_plus_color="WHITE"    # sign color
s_ok_color="GREEN"      # ok color
s_info_color="PURPLE"   # info color
s_fail_color="RED"      # fail color
# ------------------------- settings ---------------------------

# ----------------------- helper funcs -------------------------
# colors
NC="\033[0m"        RED="\033[0;31m"   GREEN="\033[0;32m"
YELLOW="\033[0;33m" WHITE="\033[0;97m" BLUE="\033[0;34m"
PURPLE="\033[0;35m" CYAN="\033[0;36m"  GREY="\033[0;90m"

# check function (with ok output)
function _check_ok {
    if [ $1 == 0 ]; then
        echo -en "[${!s_ok_color}OK${NC}]"
        if [ ! -z "$2" ]; then echo -e "[${!s_info_color}${2}${NC}]"; else echo ""; fi
    else
        echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1
    fi
}

# check function (without ok output)
function _check_no_ok {
    if [ $1 == 0 ]; then return; else echo -e "[${!s_fail_color}FAIL${NC}]"; exit 1; fi
}

# section start
function _start {
    str_len=${#1}
    str_len=$((s_log_cols-str_len))
    echo -en "${!s_main_color}[${!s_plus_color}+${!s_main_color}] $1 "
    v=$(printf "%-${str_len}s" ".")
    echo -en "${v// /.} ${NC}"
    echo "------- $1" >> $LOGFILE
}

# no check ok
function _done {
    echo -en "[${!s_ok_color}OK${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
}

# no check fail
function _fail {
    echo -en "[${!s_fail_color}FAIL${NC}]"
    if [ ! -z "$1" ]; then echo -e "[${PURPLE}${1}${NC}]"; else echo ""; fi
    exit 1
}

# hr line
function _line {
    v=$(printf "%-${s_line_cols}s" "-")
    echo -e "${!s_line_color}${v// /-} ${NC}"
}

# print
function _print {
    echo -e "${!s_main_color}${1}${NC}"
}

# sudo perm
function _sudo {
    if [[ $EUID -ne 0 ]]; then
        _line
        echo -e "[${RED}Error${NC}] ${!s_main_color}Sudo permissions required to run this script${NC}"
        _line
        exit 1
    fi
}

# cmd wrapper
function _cmd_no_ok {
    eval "$@" >> $LOGFILE 2>&1
    _check_no_ok $?
}
# ----------------------- helper funcs -------------------------

# cmd with return wrapper
function _check_update {
    ret=$(eval "./xbps-src update-check $@" 2> $LOGFILE)
    if [ "$ret" != "" ]; then
        new_version=$(echo "$ret" | tail -1 | rev | cut -d'-' -f1 | rev)
        old_version=$(cat $HOME/void-packages/srcpkgs/$@/template | grep 'version=' | cut -f2 -d'=')
        _start "Update found for ${WHITE}${f}${NC}"
        echo -e "[${WHITE}${old_version} -> ${new_version}${NC}]"
    fi
}

# ----------------------- helper funcs -------------------------

# ------------------------ initialize --------------------------
SCRIPT=$(basename $0)        # get script name
LOGFILE="$PWD/.$SCRIPT.log"  # set logfile
echo "" > $LOGFILE           # empty logfile
start_time=`date +%s`        # start timer
if [ "$s_sudo_perm" == "YES" ]; then _sudo; fi
_line
# ------------------------ initialize --------------------------

_start "Updating packages"
cd ~/void-packages/
_cmd_no_ok "./xbps-src bootstrap-update"
branch=$(git branch | grep \* | awk '{print $2}');
if [ "$branch" != "master" ]; then
    _cmd_no_ok "git checkout master"
fi
_cmd_no_ok "git pull --rebase upstream master"
_done
_line

echo -e "${WHITE}Maintained packages${NC}"
_line
for f in $(ls srcpkgs); do
    if [[ ! -L "srcpkgs/$f" ]]; then
        MAINTAINER=$(cat srcpkgs/$f/template | grep maintainer | cut -f2 -d'=' | tr -d '"')
        if [[ $MAINTAINER == "skmpz <dem.procopiou@gmail.com>" ]]; then
            echo -e "${YELLOW}${MAINTAINER}${NC} - ${WHITE}$f${NC}"
        fi
    fi
done
_line

echo -e "${WHITE}Outdated maintained packages${NC}"
_line
for f in $(ls srcpkgs); do
    if [[ ! -L "srcpkgs/$f" ]]; then
        MAINTAINER=$(cat srcpkgs/$f/template | grep maintainer)
        if [[ $MAINTAINER == *"procopio"* ]]; then
            _check_update "$f"
        fi
    fi
done
_line

echo -e "${WHITE}Outdated used orphan packages${NC}"
_line
for f in $(xbps-query -l | awk '{print $2}' | rev | cut -f2- -d- | rev); do
    MAINTAINER=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer)
    if [[ $MAINTAINER == *"orphan"* ]]; then
        _check_update "$f"
    fi
done
_line
