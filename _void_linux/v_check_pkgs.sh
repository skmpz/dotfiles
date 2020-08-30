#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=50           # log length
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

# section start
function _start {
    str_len=${#1}
    str_len=$((s_log_cols-str_len))
    echo -en "${!s_main_color}[${!s_plus_color}+${!s_main_color}] $1 "
    v=$(printf "%-${str_len}s" ".")
    echo -en "${v// /.} ${NC}"
    echo "------- $1" >> $LOGFILE
}

# hr line
function _line {
    v=$(printf "%-${s_line_cols}s" "-")
    echo -e "${!s_line_color}${v// /-} ${NC}"
}

# cmd with return wrapper
function _check_update {
    ret=$(eval "$@" 2> $LOGFILE)
    if [ "$ret" == "" ]; then
        echo -e "[${!s_ok_color}OK${NC}]"
    else
        echo -e "[${PURPLE}UPDATE${NC}]"
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

echo -e "${WHITE}Updating repo${NC}"
cd ~/void-packages/
./xbps-src bootstrap-update > /dev/null 2>&1
branch=$(git branch | grep \* | awk '{print $2}');
if [ "$branch" != "master" ]; then
    git checkout master  > /dev/null 2>&1
fi
git pull --rebase upstream master > /dev/null 2>&1
git push -f origin master > /dev/null 2>&1

_line
echo -e "${WHITE}Maintained packages${NC}"
_line
for f in $(ls srcpkgs); do
    MAINTAINER=$(cat srcpkgs/$f/template | grep maintainer)
    if [[ $MAINTAINER == *"procopio"* ]]; then
        _start "Checking $f"
        _check_update "./xbps-src update-check $f"
    fi
done
_line
echo -e "${WHITE}Used orphan packages${NC}"
_line
for f in $(xbps-query -l | awk '{print $2}' | rev | cut -f2- -d- | rev); do
    MAINTAINER=$(cat srcpkgs/$f/template | grep maintainer)
    if [[ $MAINTAINER == *"orphan"* ]]; then
        _start "Checking $f"
        _check_update "./xbps-src update-check $f"
    fi
done
_line
