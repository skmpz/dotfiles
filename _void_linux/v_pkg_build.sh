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
function _cmd {
    eval "$@" >> $LOGFILE 2>&1
    _check_ok $?
}

function _cmd_no_ok {
    eval "$@" >> $LOGFILE 2>&1
    _check_no_ok $?
}

function _cmd_no_exit {
    eval "$@" >> $LOGFILE 2>&1
    if [ $? == 0 ]; then echo -e "[${!s_ok_color}OK${NC}]"; else echo -e "[${!s_fail_color}FAIL${NC}]"; fi
}

# cmd with return wrapper
function _cmd_r {
    ret=$(eval "$@" 2> $LOGFILE)
    _check_no_ok $?
}

function _cmd_i {
    eval "$@" >> $LOGFILE 2>&1
}

# return not
function _rn {
    if [ "$ret" == "$@" ]; then _fail; fi
}

# return equal
function _re {
    if [ "$ret" != "$@" ]; then _fail; fi
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

# ------------------------- arguments --------------------------
# print usage and exit
function show_usage {
    echo -e "[${RED}usage${NC}] ${!s_main_color}./$(basename $0) [opts]${NC}"
    _line
    echo -en "[${WHITE}opts${NC}] "
    echo -e "${BLUE}-p|--packages   packages  [required]${NC}"
    echo -e "       ${BLUE}-b|--build               [optional]${NC}"
    echo -e "       ${BLUE}-t|--test                [optional]${NC}"
    echo -e "       ${BLUE}-c|--commit              [optional]${NC}"
    _line
    exit 1
}

# arg count
if [ $# -lt 2 ]; then show_usage ;fi

# parse arguments
for i in "$@"
do
    case $i in
        -p|--packages) PKGS="$2"; shift 2 ;;
        -b|--build) BUILD="YES"; shift 1 ;;
        -t|--test) TEST="YES"; shift 1 ;;
        -c|--commit) COMMIT="YES"; shift 1 ;;
        *) ;;
    esac
done

# check arguments
if [ "$PKGS" == "" ] || [ -z "$PKGS" ]; then show_usage; fi
if [ "$BUILD" == "" ]; then BUILD="NO"; fi
if [ "$TEST" == "" ]; then TEST="NO"; fi
if [ "$BUILD" == "YES" ] && [ "$TEST" == "YES" ]; then show_usage; fi
# ------------------------- arguments --------------------------

# -------------------------- script ----------------------------

cd ~/void-packages/

_print "Build: $BUILD"

for PKG in $PKGS; do

    _line

    VERSION=$(cat srcpkgs/$PKG/template | grep ^version= | tail -1 | cut -f2 -d'=')
    REVISION=$(cat srcpkgs/$PKG/template | grep ^revision= | tail -1 | cut -f2 -d'=')
    MAINTAINER=$(cat srcpkgs/$PKG/template | grep ^maintainer= | cut -f2 -d'"')
    ARCHS=$(cat srcpkgs/$PKG/template | grep ^archs= | cut -f2 -d'=' | cut -f2 -d'"')
    NOCROSS=$(cat srcpkgs/$PKG/template | grep ^nocross= | cut -f2 -d'"')

    _print "Starting checks for $PKG"
    _print "Version: $VERSION (Revision: $REVISION)"
    _print "Maintainer: $MAINTAINER"
    _print "Archs: $ARCHS"
    _print "No cross: $NOCROSS"

    ARCH_X86_64="YES"
    ARCH_I686="YES"
    ARCH_AARCH64="YES"
    ARCH_ARMV7L="YES"

    ARCH_X86_64_MUSL="YES"
    ARCH_ARMV6L_MUSL="YES"
    ARCH_AARCH64_MUSL="YES"

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

    _print "ARCH_X86_64: $ARCH_X86_64"
    _print "ARCH_I686: $ARCH_I686"
    _print "ARCH_AARCH64: $ARCH_AARCH64"
    _print "ARCH_ARMV7L: $ARCH_ARMV7L"
    _print "ARCH_X86_64_MUSL: $ARCH_X86_64_MUSL"
    _print "ARCH_ARMV6L_MUSL: $ARCH_ARMV6L_MUSL"
    _print "ARCH_AARCH64_MUSL: $ARCH_AARCH64_MUSL"

    if [ "$BUILD" == "YES" ] || [ "$TEST" == "YES" ]; then

        _line
        _start "Initializing x86_64"
        _cmd_no_ok "./xbps-src clean"
        _cmd_no_ok "./xbps-src -m masterdir-x86 clean"
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"

        # first run, create bootstrap directories
        if [ ! -d "masterdir" ]; then
            _cmd_no_ok "./xbps-src binary-bootstrap"
        else
            _cmd_no_ok "./xbps-src bootstrap-update"
        fi

        _done
    fi

    if [ "$BUILD" == "YES" ]; then
        _line
        ./xbps-src pkg -f $PKG
    fi

    if [ "$TEST" == "YES" ]; then

        _start "Initializing other architectures"

        if [ ! -d "masterdir-x86" ]; then
            _cmd_no_ok "./xbps-src -m masterdir-x86 binary-bootstrap i686"
        else
            _cmd_no_ok "./xbps-src -m masterdir-x86 bootstrap-update i686"
        fi

        if [ ! -d "masterdir-x86_64-musl" ]; then
            _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl binary-bootstrap x86_64-musl"
        else
            _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl bootstrap-update x86_64-musl"
        fi

        _done

        if [ "$ARCH_X86_64" == "YES" ]; then
            _start "Compiling for x86_64 (native)"
            _cmd_no_ok "./xbps-src clean"
            _cmd "./xbps-src pkg -f $PKG"
        fi

        if [ "$ARCH_I686" == "YES" ]; then
            _start "Compiling for i686 (native)"
            _cmd_no_ok "./xbps-src -m masterdir-x86 clean"
            _cmd "./xbps-src pkg -m masterdir-x86 -f $PKG"
        fi

        if [ "$ARCH_AARCH64" == "YES" ]; then
            _start "Compiling for aarch64 (cross on x86_64)"
            _cmd_no_ok "./xbps-src clean"
            _cmd "./xbps-src pkg -a aarch64 -f $PKG"
        fi

        if [ "$ARCH_ARMV7L" == "YES" ]; then
            _start "Compiling for armv7l (cross on x86_64)"
            _cmd_no_ok "./xbps-src clean"
            _cmd "./xbps-src pkg -a armv7l -f $PKG"
        fi

        if [ "$ARCH_X86_64_MUSL" == "YES" ]; then
            _start "Compiling for x86_64-musl (native)"
            _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
            _cmd "./xbps-src -m masterdir-x86_64-musl pkg -f $PKG"
        fi

        if [ "$ARCH_AARCH64_MUSL" == "YES" ]; then
            _start "Compiling for aarch64-musl (cross on x86_64-musl)"
            _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
            _cmd "./xbps-src -m masterdir-x86_64-musl -a aarch64-musl pkg -f $PKG"
        fi

        if [ "$ARCH_ARMV6L_MUSL" == "YES" ]; then
            _start "Compiling for armv6l-musl (cross on x86_64-musl)"
            _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl clean"
            _cmd "./xbps-src -m masterdir-x86_64-musl -a armv6l-musl pkg -f $PKG"
        fi
    fi
done

if [ "$COMMIT" == "YES" ]; then
    _line
    _start "Info check"
    if [ "$REVISION" != "1" ]; then
        _fail "revision $REVISION"
    fi
    if [ "$MAINTAINER" != "skmpz <dem.procopiou@gmail.com>" ]; then
        echo -en "[${PURPLE}${MAINTAINER}${NC}]"
    fi
    _done

    _start "Linting"
    _cmd "xlint srcpkgs/$PKG/template"

    _line

    echo "git checkout -b $PKG-$VERSION"
    echo "git commit -am \"$PKG: update to $VERSION.\""

    echo "git push -u origin $PKG-$VERSION"
    _line
    echo "xi $PKG"
    _line
    echo "git checkout master"
    echo "git pull --rebase upstream master"
    echo "./xbps-src clean"
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
