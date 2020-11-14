#!/bin/bash

# -------------------------- colors ----------------------------
nc="\033[0m"        red="\033[0;31m"   green="\033[0;32m"
yellow="\033[0;33m" white="\033[0;97m" blue="\033[0;34m"
purple="\033[0;35m" cyan="\033[0;36m"  grey="\033[0;90m"
# ------------------------- /colors ----------------------------

# ------------------------- settings ---------------------------
s_log_cols=50
s_line_cols=80
s_sudo_perm="NO"
# ------------------------ /settings ---------------------------

# ---------------------------- init ----------------------------
function _sudo_check { if [[ $EUID -ne 0 ]]; then _fail "sudo needed"; exit 1; fi; }
script=$(basename $0)
logfile="$PWD/.${script}.log"; echo "" > $logfile
start_time=`date +%s`
if [ "$s_sudo_perm" == "yes" ]; then _sudo_check; fi
# --------------------------- /init ----------------------------

# ------------------------ helper funcs ------------------------
function _note { echo -e "${green}${1}${nc}"; }
function _print { echo -en "${white}${1}${nc}"; }
function _print_nl { echo -e "${white}${1}${nc}"; }
function _ok { echo -e "${white}[${green}OK${white}]${nc} ${purple}${1}${nc}"; }
function _info { echo -e "${white}[${purple}${1}${white}]${nc}"; }
function _fail { echo -e "${white}[${red}FAIL${white}] ${purple}${1}${nc}"; }
function _check_ok { if [ ${1} == 0 ]; then _ok "${2}"; else _fail "${2}"; exit 1; fi }
function _check_no_ok { if [ ${1} != 0 ]; then _fail "${2}"; exit 1; fi; }
function _line { v=$(printf "%-${s_line_cols}s" "-"); echo -e "${blue}${v// /-} ${NC}"; }
function _cmd_ok { eval "$1" >> $logfile 2>&1; _check_ok "${?}" "${2}" ; }
function _cmd_no_ok { eval "$1" >> $logfile 2>&1; _check_no_ok "${?}" "${2}"; }
function _cmd_out { ret=$(eval "$1" 2>> $logfile); _check_no_ok "${?}" "${2}"; }
function _section { _line; echo -e "${white}[${yellow}+${white}] ${yellow}${1}"; _line; }
function _start {
    str_len=${#1}; str_len=$((s_log_cols-str_len)); echo -en "${white}[${yellow}-${white}] $1 "
    v=$(printf "%-${str_len}s" "."); echo -en "${v// /.} ${nc}"; echo "------- $1" >> $logfile;
}
# ----------------------- /helper funcs ------------------------

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

# --------------------------- info -----------------------------
_line;
_note "Script: ${script}";
_note "Logfile: ${logfile}";
if [ "${report_on}" == "yes" ]; then _note "Report: ${report_file}"; fi
_note "Started: $(date -d@$((start_time)) -u +%H:%M:%S)"
# -------------------------- /info -----------------------------

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

    _ok
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
    _ok

    _start "Initializing x86_64-musl"
    if [ ! -d "masterdir-x86_64-musl" ]; then
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl binary-bootstrap x86_64-musl"
    else
        _cmd_no_ok "./xbps-src -m masterdir-x86_64-musl bootstrap-update x86_64-musl"
    fi
    _ok

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
        _ok
    fi

    _start "Checking maintainer"
    if [ "$MAINTAINER" != "$git_user <$git_mail>" ]; then
        _ok "not adopted"
    else
        _ok
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
