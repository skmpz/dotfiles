#!/bin/bash

# ------------------------- settings ---------------------------
s_log_cols=50           # log length
s_line_cols=80          # hr line length
s_sudo_perm="NO"        # sudo perm needed
s_line_color="BLUE"     # hr line color
s_main_color="WHITE"   # main action color
s_plus_color="YELLOW"    # sign color
s_sec_color="GREEN"     # section color
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

function _note {
    echo -e "${GREY}${1}${NC}"
}

function _section {
_line
echo -e "${!s_main_color}[${!s_plus_color}+${!s_main_color}] ${!s_sec_color}$@"
_line
}

# ----------------------- helper funcs -------------------------

# ------------------------- arguments --------------------------
# print usage and exit
function show_usage {
    echo -e "[${RED}usage${NC}] ${!s_main_color}./$(basename $0) [opts]${NC}"
    _line
    echo -en "[${WHITE}opts${NC}] "
    echo -e "${BLUE}-r|--report <report_file>  html report   [optional]${NC}"
    _line
    exit 1
}

# parse arguments
for i in "$@"
do
    case $i in
        -r|--report) REPORT_ON="YES"; REPORT_FILE=$(realpath "$2"); shift 2 ;;
        *) ;;
    esac
done

# check arguments
if [ "$REPORT_ON" == "YES" ] && [ -z "$REPORT_FILE" ]; then show_usage; fi

# ------------------------- arguments --------------------------

# ------------------------ initialize --------------------------
SCRIPT=$(basename $0)        # get script name
LOGFILE="$PWD/.$SCRIPT.log"  # set logfile
echo "" > $LOGFILE           # empty logfile
start_time=`date +%s`        # start timer
if [ "$s_sudo_perm" == "YES" ]; then _sudo; fi
_line
echo -e "${!s_info_color}Script: $SCRIPT${NC}"
echo -e "${!s_info_color}Logfile: $LOGFILE${NC}"

if [ "$REPORT_ON" == "YES" ]; then 
    echo -e "${!s_info_color}Report file: $REPORT_FILE${NC}"

    cat <<EOT > $REPORT_FILE
<!DOCTYPE html>
<html>
    <head>
        <style>
table { font-family: arial, sans-serif; font-size: 13px; border-collapse: collapse; width: 1200px; }
td, th { border: 1px solid #34495E; text-align: center; padding: 8px; }
a { color: #34495E; text-decoration: none }
        </style>
    </head>
    <body>
    <h2>Packages report $(date "+%Y-%m-%d %H:%M:%S")</h2>
    <hr>
EOT
fi

echo -e "${!s_info_color}Started: $(date -d@$((start_time)) -u +%H:%M:%S)${NC}"
# ------------------------ initialize --------------------------

# ------------------------ main script -------------------------

# grab git user/mail
git_user=$(git config -l | grep name | cut -f2 -d=)
git_mail=$(git config -l | grep email | cut -f2 -d=)

function _report {
    new_version=$(echo "$ret" | tail -1 | rev | cut -d'-' -f1 | rev)
    old_version=$(cat $HOME/void-packages/srcpkgs/$1/template | grep 'version=' | cut -f2 -d'=')
    maintainer=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer= | cut -f2 -d'"')
    homepage=$(cat $HOME/void-packages/srcpkgs/$1/template | grep 'homepage=' | cut -f2 -d'"')

    if [ -z "$new_version" ]; then 
        new_version="$old_version"
        _done
    else
        echo -e "[${WHITE}${old_version} -> ${new_version}${NC}]"
    fi

    if [ "$REPORT_ON" == "YES" ]; then

        repology="https://repology.org/project/$1/versions"
        pr_url="https://github.com/void-linux/void-packages/pulls?q=$1"
        arch_url="null"
        arch_git_url="null"
        arch_info="null"
        arch_version="null"
        arch_revision="null"
        alpine_url="null"
        alpine_git_url="null"
        alpine_info="null"
        alpine_version="null"
        alpine_revision="null"
        fedora_url="null"
        fedora_git_url="null"
        fedora_info="null"
        fedora_version="null"
        fedora_revision="null"

        # arch
        if [[ $(curl -s -o .tmp.out -w "%{http_code}" \
            https://github.com/archlinux/svntogit-packages/commits/packages/$1/trunk) == "200" ]]; then
            arch_url="https://github.com/archlinux/svntogit-packages/commits/packages/$1/trunk"
            arch_info=$(date -d "$(cat .tmp.out | grep -i "Commits on" | head -1 | awk -F " on " '{print $2}' | cut -f1 -d'<' | tr -d ",")" +%Y-%m-%d)
            arch_git_url="https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/$1/trunk/PKGBUILD"
            arch_git_data=$(curl -s "$arch_git_url")
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" \
            https://github.com/archlinux/svntogit-community/commits/packages/$1/trunk) == "200" ]]; then
            arch_url="https://github.com/archlinux/svntogit-community/commits/packages/$1/trunk"
            arch_info=$(date -d "$(cat .tmp.out | grep -i "Commits on" | head -1 | awk -F " on " '{print $2}' | cut -f1 -d'<' | tr -d ",")" +%Y-%m-%d)
            arch_git_url="https://raw.githubusercontent.com/archlinux/svntogit-community/packages/$1/trunk/PKGBUILD"
            arch_git_data=$(curl -s "$arch_git_url")
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" https://aur.archlinux.org/cgit/aur.git/log/?h=$1) == "200" ]]; then
            arch_url="https://aur.archlinux.org/cgit/aur.git/log/?h=$1"
            arch_info=$(cat .tmp.out | grep -A1 "Commit message" | tail -1 | awk -F "title='" '{print $2}' | cut -f1 -d' ')
            arch_git_url="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$1"
            arch_git_data=$(curl -s $arch_git_url)
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        fi

        # alpine
        if [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/main/x86_64/$1) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/main/x86_64/$1"
            alpine_info=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/main/$1/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/community/x86_64/$1) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/community/x86_64/$1"
            alpine_info=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/community/$1/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/testing/x86_64/$1) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/testing/x86_64/$1"
            alpine_info=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/testing/$1/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        fi

        # fedora
        if [[ $(curl -s -o .tmp.out -w "%{http_code}" https://src.fedoraproject.org/rpms/$1/commits/master) == "200" ]]; then
            fedora_url="https://src.fedoraproject.org/rpms/$1/commits/master"
            fedora_info=$(cat .tmp.out | grep -A 20 "my-2" |  grep title | head -1 | awk -F 'title="' '{print $2}' | cut -f1 -d' ');
            fedora_git_url="https://src.fedoraproject.org/rpms/$1/raw/master/f/$1.spec"
            fedora_git_data=$(curl -s $fedora_git_url)
            fedora_version=$(echo "$fedora_git_data" | grep "Version:" | tr -s ' ' | cut -f2 -d' ')
            fedora_revision=$(echo "$fedora_git_data" | grep "Release:" | tr -s ' ' | cut -f2 -d' ' | cut -f1 -d'%')

            if [[ $fedora_version == *"%{branch}"* ]]; then
                fedora_branch=$(echo "$fedora_git_data" | grep "global branch" | tr -s ' ' | cut -f3 -d' ')
                fedora_version=$(echo "$fedora_version" | sed "s/%{branch}/$fedora_branch/")
            fi
        fi

        if [ "$new_version" == "$old_version" ]; then
            echo "<tr style=\"background-color: #F2F8FF\">" >> $REPORT_FILE
        else
            echo "<tr style=\"background-color: #FFF3F2\">" >> $REPORT_FILE
        fi

        echo "<td style=\"text-align: left\"><a href=\"https://github.com/void-linux/void-packages/blob/master/srcpkgs/$1/template\" target=\"_blank\">"$1"</td>" >> $REPORT_FILE
        echo "<td>"$old_version"</td>" >> $REPORT_FILE
        echo "<td>"$new_version"</td>" >> $REPORT_FILE

        if [ "$arch_version" == "null" ]; then
            echo "<td width="7%">---</td>" >> $REPORT_FILE
            echo "<td width="9%">---</td>" >> $REPORT_FILE
        elif [ "$arch_version" == "$new_version" ]; then
            echo "<td width="7%"><a href="$arch_git_url" target=\"_blank\" style=\"color: #0E6655\">$arch_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$arch_url" target=\"_blank\" style=\"color: #0E6655\">$arch_info</td>" >> $REPORT_FILE
        else
            echo "<td width="7%"><a href="$arch_git_url" target=\"_blank\" style=\"color: #7B241C\">$arch_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$arch_url" target=\"_blank\" style=\"color: #7B241C\">$arch_info</td>" >> $REPORT_FILE
        fi

        if [ "$alpine_version" == "null" ]; then
            echo "<td width="7%">---</td>" >> $REPORT_FILE
            echo "<td width="9%">---</td>" >> $REPORT_FILE
        elif [ "$alpine_version" == "$new_version" ]; then
            echo "<td width="7%"><a href="$alpine_git_url" target="_blank" style=\"color: #0E6655\">$alpine_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$alpine_url" target="_blank" style=\"color: #0E6655\">$alpine_info</td>" >> $REPORT_FILE
        else
            echo "<td width="7%"><a href="$alpine_git_url" target="_blank" style=\"color: #7B241C\">$alpine_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$alpine_url" target="_blank" style=\"color: #7B241C\">$alpine_info</td>" >> $REPORT_FILE
        fi

        if [ "$fedora_version" == "null" ]; then
            echo "<td width="7%">---</td>" >> $REPORT_FILE
            echo "<td width="9%">---</td>" >> $REPORT_FILE
        elif [ "$fedora_version" == "$new_version" ]; then
            echo "<td width="7%"><a href="$fedora_git_url" target="_blank" style=\"color: #0E6655\">$fedora_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$fedora_url" target="_blank" style=\"color: #0E6655\">$fedora_info</td>" >> $REPORT_FILE
        else
            echo "<td width="7%"><a href="$fedora_git_url" target="_blank" style=\"color: #7B241C\">$fedora_version</td>" >> $REPORT_FILE
            echo "<td width="9%"><a href="$fedora_url" target="_blank" style=\"color: #7B241C\">$fedora_info</td>" >> $REPORT_FILE
        fi

        echo "<td><a href="$pr_url" target="_blank">check</td>" >> $REPORT_FILE
        echo "<td><a href="$homepage" target="_blank">homepage</td>" >> $REPORT_FILE
        echo "<td><a href="$repology" target="_blank">repology</td>" >> $REPORT_FILE
        echo "</tr>" >> $REPORT_FILE
    fi
}

function _check_update {
    _cmd_out "./xbps-src update-check $1"
    if [ "$ret" != "" ] || [ "$2" == "own" ]; then
        _start "Checking $1"
        _report "$1"
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

if [ "$REPORT_ON" == "YES" ]; then
    echo "<h3>Maintained packages</h3>" >> $REPORT_FILE
    echo "<table>" >> $REPORT_FILE
    echo "<tr>" >> $REPORT_FILE
    echo "<th width=\"15%\" style=\"text-align: left\">Package</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Void</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">New</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Arch</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Alpine</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Fedora</th>" >> $REPORT_FILE
    echo "<th width=\"7%\">PR</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Homepage</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Repology</th>" >> $REPORT_FILE
    echo "</tr>" >> $REPORT_FILE
fi

for f in $(ls srcpkgs); do
    if [ ! -L "srcpkgs/$f" ]; then
        MAINTAINER=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer | cut -f2 -d'"')
        if [ "$MAINTAINER" == "$git_user <$git_mail>" ]; then
            _check_update "$f" "own"
        fi
    fi
done

if [ "$REPORT_ON" == "YES" ]; then
    echo "</table><br />" >> $REPORT_FILE
    echo "<h3>Outdated orphaned packages</h3>" >> $REPORT_FILE
    echo "<table>" >> $REPORT_FILE
    echo "<tr>" >> $REPORT_FILE
    echo "<th width=\"15%\" style=\"text-align: left\">Package</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Void</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">New</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Arch</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Alpine</th>" >> $REPORT_FILE
    echo "<th width=\"16%\" colspan=\"2\">Fedora</th>" >> $REPORT_FILE
    echo "<th width=\"7%\">PR</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Homepage</th>" >> $REPORT_FILE
    echo "<th width=\"8%\">Repology</th>" >> $REPORT_FILE
    echo "</tr>" >> $REPORT_FILE
fi

# show outdated used orphaned packages
_section "Outdated used orphaned packages"
for f in $(xbps-query -l | awk '{print $2}' | rev | cut -f2- -d- | rev); do
    if [ ! -L "srcpkgs/$f" ]; then
        MAINTAINER=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer | cut -f2 -d'"')
        if [ "$MAINTAINER" == "Orphaned <orphan@voidlinux.org>" ]; then
            _check_update "$f"
        fi
    fi
done

if [ "$REPORT_ON" == "YES" ]; then
    echo "</table>" >> $REPORT_FILE
    echo "</body>" >> $REPORT_FILE
    echo "</html>" >> $REPORT_FILE
fi
# ------------------------ main script -------------------------

# print run info
_line
end_time=`date +%s`
echo -e "${YELLOW}Runtime: $(date -d@$((end_time-start_time)) -u +%H:%M:%S)"
_line
