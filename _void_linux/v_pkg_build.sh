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
    echo -en "${!s_main_color}${1}${NC}"
}

function _print_nl {
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

# ------------------------- arguments --------------------------
# print usage and exit
function show_usage {
    echo -e "[${RED}usage${NC}] ${!s_main_color}./$(basename $0) [opts]${NC}"
    _line
    echo -en "[${WHITE}opts${NC}] "
    echo -e "${BLUE}-p|--package   package   [required]${NC}"
    echo -e "       ${BLUE}-b|--build               [optional]${NC}"
    echo -e "       ${BLUE}-c|--check               [optional]${NC}"
    echo -e "       ${BLUE}-g|--git                 [optional]${NC}"
    _line
    exit 1
}

# arg count
if [ $# -lt 2 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        -p|--package) PKG="$2"; shift 2 ;;
        -b|--build) BUILD="YES"; shift 1 ;;
        -c|--check) CHECK="YES"; shift 1 ;;
        -g|--git) GIT_CHECK="YES"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$PKG" == "" ] || [ -z "$PKG" ]; then show_usage; fi
if [ "$BUILD" == "" ]; then BUILD="NO"; fi
if [ "$CHECK" == "" ]; then CHECK="NO"; fi
if [ "$BUILD" == "YES" ] && [ "$CHECK" == "YES" ]; then show_usage; fi
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
echo -e "${!s_info_color}Started: $(date -d@$((start_time)) -u +%H:%M:%S)${NC}"
# ------------------------ initialize --------------------------

# -------------------------- script ----------------------------

# grab git user/mail
git_user=$(git config -l | grep name | cut -f2 -d=)
git_mail=$(git config -l | grep email | cut -f2 -d=)

cd ~/void-packages/

_line

VERSION=$(cat srcpkgs/$PKG/template | grep ^version= | tail -1 | cut -f2 -d'=')
REVISION=$(cat srcpkgs/$PKG/template | grep ^revision= | tail -1 | cut -f2 -d'=')
MAINTAINER=$(cat srcpkgs/$PKG/template | grep ^maintainer= | cut -f2 -d'"')
ARCHS=$(cat srcpkgs/$PKG/template | grep ^archs= | cut -f2 -d'=' | cut -f2 -d'"')
NOCROSS=$(cat srcpkgs/$PKG/template | grep ^nocross= | cut -f2 -d'"')

_print_nl "Package: $PKG"
_print_nl "Version: $VERSION"
_print_nl "Revision: $REVISION"
_print_nl "Maintainer: $MAINTAINER"

if [ "$ARCHS" != "" ]; then _print_nl "Archs: $ARCHS"; fi
if [ "$NOCROSS" != "" ]; then _print_nl "No cross: $NOCROSS"; fi

ARCH_X86_64="YES"
ARCH_I686="YES"
ARCH_AARCH64="YES"
ARCH_ARMV7L="YES"
ARCH_X86_64_MUSL="YES"
ARCH_AARCH64_MUSL="YES"
ARCH_ARMV6L_MUSL="YES"

if [ "$ARCHS" != "" ]; then

    if [ "$ARCHS" == "noarch" ]; then
        :
    else
        ARCH_X86_64="NO"
        ARCH_I686="NO"
        ARCH_AARCH64="NO"
        ARCH_ARMV7L="NO"

        ARCH_X86_64_MUSL="NO"
        ARCH_ARMV6L_MUSL="NO"
        ARCH_AARCH64_MUSL="NO"

        for ARCH in $ARCHS; do

            if [ "$ARCH" == "x86_64" ]; then
                ARCH_X86_64="YES"
            elif [ "$ARCH" == "x86_64*" ]; then
                ARCH_X86_64="YES"
                ARCH_X86_64_MUSL="YES"
            elif [ "$ARCH" == "i686" ] || [ "$ARCH" == "i686*" ]; then
                ARCH_I686="YES"
            elif [ "$ARCH" == "armv7l" ] || [ "$ARCH" == "armv7l*" ]; then
                ARCH_ARMV7L="YES"
            elif [ "$ARCH" == "armv6l" ] || [ "$ARCH" == "armv6l*" ]; then
                ARCH_ARMV6L_MUSL="YES"
            elif [ "$ARCH" == "aarch64" ]; then
                ARCH_AARCH64="YES"
            elif [ "$ARCH" == "aarch64*" ]; then
                ARCH_AARCH64="YES"
                ARCH_AARCH64_MUSL="YES"
            elif [ "$ARCH" == "*-musl" ]; then
                ARCH_X86_64_MUSL="YES"
                ARCH_ARMV6L_MUSL="YES"
                ARCH_AARCH64_MUSL="YES"
            elif [ "$ARCH" == "~*-musl" ]; then
                ARCH_X86_64_MUSL="NO"
                ARCH_ARMV6L_MUSL="NO"
                ARCH_AARCH64_MUSL="NO"
            fi
        done
    fi
fi

if [ "$NOCROSS" != "" ]; then
    ARCH_AARCH64="NO"
    ARCH_ARMV7L="NO"
    ARCH_AARCH64_MUSL="NO"
    ARCH_ARMV6L_MUSL="NO"
fi
_line

_print "Archs: "
if [ "$ARCH_X86_64" == "YES" ]; then _print "x86_64 "; fi
if [ "$ARCH_I686" == "YES" ]; then _print "i686 "; fi
if [ "$ARCH_AARCH64" == "YES" ]; then _print "aarch64 "; fi
if [ "$ARCH_ARMV7L" == "YES" ]; then _print "armv7l "; fi
if [ "$ARCH_X86_64_MUSL" == "YES" ]; then _print "x86_64-musl "; fi
if [ "$ARCH_AARCH64_MUSL" == "YES" ]; then _print "aarch64-musl "; fi
if [ "$ARCH_ARMV6L_MUSL" == "YES" ]; then _print "armv6l-musl "; fi
_print_nl

if [ "$BUILD" == "YES" ] || [ "$CHECK" == "YES" ]; then

    _section "Initialization"

    _start "Initializing x86_64"
    _cmd_no_ok "./xbps-src clean"
    _cmd_no_ok "./xbps-src -m masterdir-x86 clean"
    _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"

    if [ ! -d "masterdir" ]; then
        _cmd_no_ok "./xbps-src binary-bootstrap"
    else
        _cmd_no_ok "./xbps-src bootstrap-update"
    fi

    _done
fi

if [ "$BUILD" == "YES" ]; then
    _section "Build for x86_64"
    ./xbps-src pkg -f $PKG
fi

if [ "$CHECK" == "YES" ]; then

    _start "Initializing i686"
    if [ ! -d "masterdir-x86" ]; then
        _cmd_no_ok "./xbps-src -m masterdir-x86 binary-bootstrap i686"
    else
        _cmd_no_ok "./xbps-src -m masterdir-x86 bootstrap-update i686"
    fi
    _done

    _start "Initializing x86_64-musl"
    if [ ! -d "masterdir-x86_64-musl" ]; then
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl binary-bootstrap x86_64-musl"
    else
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl bootstrap-update x86_64-musl"
    fi
    _done

    _section "Build test and lint"
    if [ "$ARCH_X86_64" == "YES" ]; then
        _start "Building for x86_64 (x86_64)"
        _cmd_no_ok "./xbps-src clean"
        _cmd_ok "./xbps-src pkg -f $PKG"
    fi

    if [ "$ARCH_I686" == "YES" ]; then
        _start "Building for i686 (i686)"
        _cmd_no_ok "./xbps-src -m masterdir-x86 clean"
        _cmd_ok "./xbps-src -j$(nproc) pkg -m masterdir-x86 -f $PKG"
    fi

    if [ "$ARCH_AARCH64" == "YES" ]; then
        _start "Building for aarch64 (x86_64)"
        _cmd_no_ok "./xbps-src clean"
        _cmd_ok "./xbps-src -j$(nproc) pkg -a aarch64 -f $PKG"
    fi

    if [ "$ARCH_ARMV7L" == "YES" ]; then
        _start "Building for armv7l (x86_64)"
        _cmd_no_ok "./xbps-src clean"
        _cmd_ok "./xbps-src -j$(nproc) pkg -a armv7l -f $PKG"
    fi

    if [ "$ARCH_X86_64_MUSL" == "YES" ]; then
        _start "Building for x86_64-musl (x86_64-musl)"
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
        _cmd_ok "./xbps-src -m masterdir-x86_64-musl -j$(nproc) pkg -f $PKG"
    fi

    if [ "$ARCH_AARCH64_MUSL" == "YES" ]; then
        _start "Building for aarch64-musl (x86_64-musl)"
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
        _cmd_ok "./xbps-src -m masterdir-x86_64-musl -a aarch64-musl -j$(nproc) pkg -f $PKG"
    fi

    if [ "$ARCH_ARMV6L_MUSL" == "YES" ]; then
        _start "Building for armv6l-musl (x86_64-musl)"
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
        _cmd_ok "./xbps-src -m masterdir-x86_64-musl -a armv6l-musl -j$(nproc) pkg -f $PKG"
    fi

    _start "Linting"
    _cmd_ok "xlint srcpkgs/$PKG/template"

fi

if [ "$GIT_CHECK" == "YES" ]; then
    _section "Final checks"
    _start "Checking version/revision"
    VERSION_DIFF=$(git diff srcpkgs/$PKG/template | grep version= | wc -l)
    if [ "$VERSION_DIFF" == "2" ] && [ "$REVISION" != "1" ]; then
        _fail "version/revision"
    else
        _done
    fi

    _start "Checking maintainer"
    if [ "$MAINTAINER" != "$git_user <$git_mail>" ]; then
        _done "not adopted"
    else
        _done
    fi

    _section "Committing"
    _print_nl "git checkout -b $PKG-$VERSION"
    _print_nl "git commit -am \"$PKG: update to $VERSION.\""
    _print_nl "git push -u origin $PKG-$VERSION"
    _print_nl "git checkout master"
    _print_nl "git pull --rebase upstream master"
    _print_nl "./xbps-src clean"
    _print_nl "xi $PKG"
    _line

    _print_nl "Built for: "
    if [ "$ARCH_X86_64" == "YES" ]; then _print_nl "- x86_64 [x86_64]"; fi
    if [ "$ARCH_I686" == "YES" ]; then _print_nl "- i686 [i686]"; fi
    if [ "$ARCH_AARCH64" == "YES" ]; then _print_nl "- aarch64 [x86_64]"; fi
    if [ "$ARCH_ARMV7L" == "YES" ]; then _print_nl "- armv7l [x86_64]"; fi
    if [ "$ARCH_X86_64_MUSL" == "YES" ]; then _print_nl "- x86_64-musl [x86_64-musl]"; fi
    if [ "$ARCH_AARCH64_MUSL" == "YES" ]; then _print_nl "- aarch64-musl [x86_64-musl]"; fi
    if [ "$ARCH_ARMV6L_MUSL" == "YES" ]; then _print_nl "- armv6l-musl [x86_64-musl]"; fi

fi
# -------------------------- script ----------------------------

# --------------------------- end ------------------------------
# print run time
_line
end_time=`date +%s`
echo -en "${YELLOW}Runtime: " #$((end_time-start_time)) sec${NC}"
date -d@$((end_time-start_time)) -u +%H:%M:%S
_line
# --------------------------- end ------------------------------
