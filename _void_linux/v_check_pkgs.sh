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
function _cmd { eval "$1" >> $logfile 2>&1; _check_no_ok "${?}" "${2}"; }
function _cmd_out { ret=$(eval "$1" 2>> $logfile); _check_no_ok "${?}" "${2}"; }
function _cmd_no_chk { eval "$1" >> $logfile 2>&1; }
function _section { _line; echo -e "${white}[${yellow}+${white}] ${yellow}${1}"; _line; }
function _start {
    str_len=${#1}; str_len=$((s_log_cols-str_len)); echo -en "${white}[${yellow}-${white}] $1 "
    v=$(printf "%-${str_len}s" "."); echo -en "${v// /.} ${nc}"; echo "------- $1" >> $logfile;
}
# ----------------------- /helper funcs ------------------------

# ------------------------- arguments --------------------------
# print usage and exit
function show_usage {
    _line; echo -e "${white}[${red}usage${white}] ./$(basename $0) [opts]${nc}"; _line
    echo -en "${white}[${blue}opts${white}]${nc} "
    echo -e "${blue}-p|--package <package>     package       [required]${nc}"
    echo -e "       ${blue}-r|--report <report_file>  html report   [optional]${nc}"
    _line
    exit 1
}

# parse arguments
for i in "${@}"; do
    case ${i} in
        -p|--package) pkg="${2}"; shift 2;;
        -r|--report)  report_on="yes"; report_file="$2"; shift 2;;
        *) ;;
    esac
done

# check arguments
if [ "$pkg" == "" ] || [ -z "$pkg" ]; then show_usage; fi
if [ "$pkg" != "all" ] && [ ! -f "$HOME/void-packages/srcpkgs/$pkg/template" ]; then show_usage; fi
if [ "$report_on" == "yes" ] && [ -z "$report_file" ]; then show_usage; fi
report_file=$(realpath "$report_file");
# ------------------------ /arguments --------------------------

# --------------------------- info -----------------------------
_line;
_note "Script: ${script}";
_note "Logfile: ${logfile}";
if [ "${report_on}" == "yes" ]; then _note "Report: ${report_file}"; fi
_note "Started: $(date -d@$((start_time)) -u +%H:%M:%S)"
# -------------------------- /info -----------------------------

# --------------------------- html ----------------------------

function _html_start {
    cat <<EOT > $report_file
    <!DOCTYPE html><html><head><style>
            table { font-family: arial, sans-serif; font-size: 13px;
                    border-collapse: collapse; width: 1200px; }
            td, th { border: 1px solid #34495E; text-align: center; padding: 8px; }
            a { color: #34495E; text-decoration: none }
        </style> </head> <body>
EOT
}

function _html_end { echo "</body></html>" >> $report_file; }
function _html_hr { echo "<hr>" >> $report_file; }
function _html_h2 { echo "<h2>${1}</h2>" >> $report_file; }
function _html_h3 { echo "<h3>${1}</h3>" >> $report_file; }
function _html_th { echo "<th ${1}>" >> $report_file; }
function _html_th_c { echo "</th>" >> $report_file; }
function _html_tr { echo "<tr ${1}>" >> $report_file; }
function _html_tr_c { echo "</tr>" >> $report_file; }
function _html_td { echo "<td ${1}>" >> $report_file; }
function _html_td_c { echo "</td>" >> $report_file; }
function _html_a { echo "<a href=${2} target=\"_blank\" ${3}>${1}</a>" >> $report_file; }
function _html_text { echo "${1}" >> $report_file; }
function _html_table { echo "<table>" >> $report_file; }
function _html_table_c { echo "</table>" >> $report_file; }
function _html_br { echo "<br />" >> $report_file; }
# -------------------------- /html ----------------------------

# -------------------------- script ----------------------------
if [ "$report_on" == "yes" ]; then
    _html_start
    _html_h2 "Packages report $(date '+%Y-%m-%d %H:%M:%S')"
    _html_hr
fi

# grab git user/mail
git_user=$(git config -l | grep name | cut -f2 -d=)
git_mail=$(git config -l | grep email | cut -f2 -d=)

# dates
today=$(date +%Y-%m-%d)
yesterday=$(date +%Y-%m-%d -d yesterday)


function _report {
    new_version=$(echo "$ret" | tail -1 | rev | cut -d'-' -f1 | rev)
    old_version=$(cat $HOME/void-packages/srcpkgs/$1/template | grep 'version=' | cut -f2 -d'=')
    maintainer=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer= | cut -f2 -d'"')
    homepage=$(cat $HOME/void-packages/srcpkgs/$1/template | grep 'homepage=' | cut -f2 -d'"')
    pkg_name="$1"

    if [ -z "$new_version" ]; then new_version="$old_version"; _ok
    else _info "${old_version} -> ${new_version}"; fi

    if [ "$report_on" == "yes" ]; then

        # urls
        url_void_pkg="https://github.com/void-linux/void-packages/"
        url_arch_raw="https://raw.githubusercontent.com/archlinux"
        url_arch_gh="https://github.com/archlinux"
        url_arch_aur="https://aur.archlinux.org/cgit/aur.git"

        repology="https://repology.org/project/$pkg_name/versions"
        pr_url="https://github.com/void-linux/void-packages/pulls?q=$pkg_name"
        arch_url="null"
        arch_git_url="null"
        arch_updated="null"
        arch_revision="null"
        alpine_url="null"
        alpine_git_url="null"
        alpine_updated="null"
        alpine_version="null"
        alpine_revision="null"
        fedora_url="null"
        fedora_git_url="null"
        fedora_updated="null"
        fedora_version="null"
        fedora_revision="null"

        function _url_valid {
            ret=$(curl -s -o .tmp -w "%{http_code}" "${1}")
            if [ "$ret" == "200" ]; then return 0; else return 1; fi
        }

        if _url_valid "$url_arch_gh/svntogit-packages/commits/packages/$pkg_name/trunk"; then
            arch_url="$url_arch_gh/svntogit-packages/commits/packages/$pkg_name/trunk"
            arch_updated=$(date -d "$(cat .tmp | grep -i "Commits on" | head -1 \
                | awk -F " on " '{print $2}' | cut -f1 -d'<' | tr -d ",")" +%Y-%m-%d)
            arch_git_url="$url_arch_raw/svntogit-packages/packages/$pkg_name/trunk/PKGBUILD"
            arch_git_data=$(curl -s "$arch_git_url")
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')

        elif _url_valid "$url_arch_gh/svntogit-community/commits/packages/$pkg_name/trunk"; then

            arch_url="$url_arch_gh/svntogit-community/commits/packages/$pkg_name/trunk"
            arch_updated=$(date -d "$(cat .tmp | grep -i "Commits on" | head -1 \
                | awk -F " on " '{print $2}' | cut -f1 -d'<' | tr -d ",")" +%Y-%m-%d)
            arch_git_url="$url_arch_raw/svntogit-community/packages/$pkg_name/trunk/PKGBUILD"
            arch_git_data=$(curl -s "$arch_git_url")
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')

        elif _url_valid "$url_arch_aur/log/?h=$pkg_name"; then
            arch_url="https://aur.archlinux.org/cgit/aur.git/log/?h=$pkg_name"
            arch_updated=$(cat .tmp | grep -A1 "Commit message" | tail -1 \
                | awk -F "title='" '{print $2}' | cut -f1 -d' ')
            arch_git_url="$url_arch_aur/plain/PKGBUILD?h=$pkg_name"
            arch_git_data=$(curl -s $arch_git_url)
            arch_version=$(echo "$arch_git_data" | grep pkgver= | head -1 | tr -d '"' | cut -f2 -d'=')
            arch_revision=$(echo "$arch_git_data" | grep pkgrel= | head -1 | tr -d '"' | cut -f2 -d'=')
        fi

        # alpine
        if [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/main/x86_64/$pkg_name) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/main/x86_64/$pkg_name"
            alpine_updated=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/main/$pkg_name/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/community/x86_64/$pkg_name) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/community/x86_64/$pkg_name"
            alpine_updated=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/community/$pkg_name/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        elif [[ $(curl -s -o .tmp.out -w "%{http_code}" https://pkgs.alpinelinux.org/package/edge/testing/x86_64/$pkg_name) == "200" ]]; then
            alpine_url="https://pkgs.alpinelinux.org/package/edge/testing/x86_64/$pkg_name"
            alpine_updated=$(cat .tmp.out | grep -A 1 "Build time" | tail -1 | awk -F '<td>' '{print $2}' | cut -f1 -d' ')
            alpine_git_url="https://git.alpinelinux.org/aports/plain/testing/$pkg_name/APKBUILD"
            alpine_git_data=$(curl -s $alpine_git_url)
            alpine_version=$(echo "$alpine_git_data" | grep pkgver= | head -1 | cut -f2 -d'=')
            alpine_revision=$(echo "$alpine_git_data" | grep pkgrel= | head -1 | cut -f2 -d'=')
        fi

        # fedora
        if [[ $(curl -s -o .tmp.out -w "%{http_code}" https://src.fedoraproject.org/rpms/$pkg_name/commits/master) == "200" ]]; then
            fedora_url="https://src.fedoraproject.org/rpms/$pkg_name/commits/master"
            fedora_updated=$(cat .tmp.out | grep -A 20 "my-2" |  grep title | head -1 | awk -F 'title="' '{print $2}' | cut -f1 -d' ');
            fedora_git_url="https://src.fedoraproject.org/rpms/$pkg_name/raw/master/f/$pkg_name.spec"
            fedora_git_data=$(curl -s $fedora_git_url)
            fedora_version=$(echo "$fedora_git_data" | grep "Version:" | head -1 | sed 's/\t/ /g' | tr -s ' ' | cut -f2 -d' ')
            fedora_revision=$(echo "$fedora_git_data" | grep "Release:" | head -1 | sed 's/\t/ /g' | tr -s ' ' | cut -f2 -d' ' | cut -f1 -d'%')

            if [[ $fedora_version == *"%{branch}"* ]]; then
                fedora_branch=$(echo "$fedora_git_data" | grep "global branch" | head -1 | tr -s ' ' | sed 's/\t/ /g' | cut -f3 -d' ')
                fedora_version=$(echo "$fedora_version" | sed "s/%{branch}/$fedora_branch/")
            fi
        fi


        if [ "$new_version" == "$old_version" ]; then
            _html_tr "style=\"background-color: #F2F8FF\""
        else
            _html_tr "style=\"background-color: #F6C6C3\""
        fi

        # package column
        _html_td "style=\"text-align: left\"";
        _html_a "$pkg_name" "${url_void_pkg}/blob/master/srcpkgs/${pkg_name}/template"
        _html_td_c

        # version columns
        _html_td; _html_text "$old_version"; _html_td_c
        _html_td; _html_text "$new_version"; _html_td_c

        if [ -z "$arch_version" ]; then
            _html_td "width=\"7%\""; _html_text "---"; _html_td_c
            _html_td "width=\"9%\""; _html_text "---"; _html_td_c
        elif [ "$arch_version" == "$new_version" ]; then
            _html_td "width=\"7%\"";
            _html_a "${arch_version}" "${arch_git_url}" "style=\"color: #0E6655\""
            _html_td_c
            if [ "$arch_updated" == "$today" ] || [ "$arch_updated" == "$yesterday" ]; then
                _html_td "width=\"9%\" style=\"background-color: #0E6655\"";
                _html_a "$arch_updated" "$arch_url" "style=\"color: #FFFFFF\""
                _html_td_c
            else
                _html_td "width=\"9%\"";
                _html_a "$arch_updated" "$arch_url" "style=\"color: #0E6655\""
                _html_td_c
            fi
        else
            _html_td "width=\"7%\"";
            _html_a "${arch_version}" "${arch_git_url}" "style=\"color: #7B241C\""
            _html_td_c
            if [ "$arch_updated" == "$today" ] || [ "$arch_updated" == "$yesterday" ]; then
                _html_td "width=\"9%\" style=\"background-color: #7B241C\"";
                _html_a "$arch_updated" "$arch_url" "style=\"color: #FFFFFF\""
                _html_td_c
            else
                _html_td "width=\"9%\"";
                _html_a "$arch_updated" "$arch_url" "style=\"color: #7B241C\""
                _html_td_c
            fi
        fi

        if [ "$alpine_version" == "null" ]; then
            echo "<td width="7%">---</td>" >> $report_file
            echo "<td width="9%">---</td>" >> $report_file
        elif [ "$alpine_version" == "$new_version" ]; then
            echo "<td width="7%"><a href="$alpine_git_url" target="_blank" style=\"color: #0E6655\">$alpine_version</td>" >> $report_file
            if [ "$alpine_updated" == "$today" ] || [ "$alpine_updated" == "$yesterday" ]; then
                echo "<td width="9%" style=\"background-color: #0E6655;\"><a href="$alpine_url" target=\"_blank\" style=\"color: #FFFFFF\"><strong>$alpine_updated<strong></td>" >> $report_file
            else
                echo "<td width="9%"><a href="$alpine_url" target=\"_blank\" style=\"color: #0E6655\">$alpine_updated</td>" >> $report_file
            fi
        else
            echo "<td width="7%"><a href="$alpine_git_url" target="_blank" style=\"color: #7B241C\">$alpine_version</td>" >> $report_file
            if [ "$alpine_updated" == "$today" ] || [ "$alpine_updated" == "$yesterday" ]; then
                echo "<td width="9%" style=\"background-color: #7B241C;\"><a href="$alpine_url" target=\"_blank\" style=\"color: #FFFFFF\"><strong>$alpine_updated<strong></td>" >> $report_file
            else
                echo "<td width="9%"><a href="$alpine_url" target=\"_blank\" style=\"color: #7B241C\">$alpine_updated</td>" >> $report_file
            fi
        fi

        if [ "$fedora_version" == "null" ]; then
            echo "<td width="7%">---</td>" >> $report_file
            echo "<td width="9%">---</td>" >> $report_file
        elif [ "$fedora_version" == "$new_version" ]; then
            echo "<td width="7%"><a href="$fedora_git_url" target="_blank" style=\"color: #0E6655\">$fedora_version</td>" >> $report_file
            if [ "$fedora_updated" == "$today" ] || [ "$fedora_updated" == "$yesterday" ]; then
                echo "<td width="9%" style=\"background-color: #0E6655;\"><a href="$fedora_url" target=\"_blank\" style=\"color: #FFFFFF\"><strong>$fedora_updated<strong></td>" >> $report_file
            else
                echo "<td width="9%"><a href="$fedora_url" target=\"_blank\" style=\"color: #0E6655\">$fedora_updated</td>" >> $report_file
            fi
        else
            echo "<td width="7%"><a href="$fedora_git_url" target="_blank" style=\"color: #7B241C\">$fedora_version</td>" >> $report_file
            if [ "$fedora_updated" == "$today" ] || [ "$fedora_updated" == "$yesterday" ]; then
                echo "<td width="9%" style=\"background-color: #7B241C;\"><a href="$fedora_url" target=\"_blank\" style=\"color: #FFFFFF\"><strong>$fedora_updated<strong></td>" >> $report_file
            else
                echo "<td width="9%"><a href="$fedora_url" target=\"_blank\" style=\"color: #7B241C\">$fedora_updated</td>" >> $report_file
            fi
        fi

        echo "<td><a href="$pr_url" target="_blank">check</td>" >> $report_file
        echo "<td><a href="$homepage" target="_blank">homepage</td>" >> $report_file
        echo "<td><a href="$repology" target="_blank">repology</td>" >> $report_file
        echo "</tr>" >> $report_file
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
    _cmd "git checkout master"
fi
_ok

_start "Updating packages"
_cmd "git pull --rebase upstream master"
_ok

if [ "$pkg" != "all" ]; then

    _section "Targeted package check"

    if [ "$report_on" == "yes" ]; then
        _html_h3 "Report on ${pkg}"
        _html_table
        _html_tr
        _html_th "width=\"15%\" style=\"text-align: left\""; _html_text "Package"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Void"; _html_th_c
        _html_th "width=\"8%\""; _html_text "New"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Arch"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Alpine"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Fedora"; _html_th_c
        _html_th "width=\"7%\""; _html_text "PR"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Homepage"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Repology"; _html_th_c
        _html_tr_c
    fi

    _check_update "$pkg" "own"

else

    # show outdated maintained packages
    _section "Outdated maintained packages"

    if [ "$report_on" == "yes" ]; then
        _html_h3 "Maintained packages"
        _html_table
        _html_tr
        _html_th "width=\"15%\" style=\"text-align: left\""; _html_text "Package"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Void"; _html_th_c
        _html_th "width=\"8%\""; _html_text "New"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Arch"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Alpine"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Fedora"; _html_th_c
        _html_th "width=\"7%\""; _html_text "PR"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Homepage"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Repology"; _html_th_c
        _html_tr_c
    fi

    for f in $(ls srcpkgs); do
        if [ ! -L "srcpkgs/$f" ]; then
            maintainer=$(cat srcpkgs/$f/template 2> /dev/null | grep maintainer | cut -f2 -d'"')
            if [ "$maintainer" == "$git_user <$git_mail>" ]; then
                _check_update "$f" "own"
            fi
        fi
    done

    _section "Outdated orphaned packages"

    if [ "$report_on" == "yes" ]; then
        _html_h3 "Outdated orphan packages"; _html_br
        _html_table
        _html_tr
        _html_th "width=\"15%\" style=\"text-align: left\""; _html_text "Package"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Void"; _html_th_c
        _html_th "width=\"8%\""; _html_text "New"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Arch"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Alpine"; _html_th_c
        _html_th "width=\"16%\" colspan=\"2\""; _html_text "Fedora"; _html_th_c
        _html_th "width=\"7%\""; _html_text "PR"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Homepage"; _html_th_c
        _html_th "width=\"8%\""; _html_text "Repology"; _html_th_c
        _html_tr_c
    fi

    _start "Fetching latest file"
    url_void_checker="https://a-hel-fi.m.voidlinux.org/void-updates/void-updates.txt"
    _cmd "wget ${url_void_checker} -O .v"
    _cmd "cat .v | sed -n '/orphan@void/,/^$/p' | awk '{print \$1}' | sort -u | tail +6 > .v_"
    _ok

    for p in $(cat .v_); do
        if [ ! -L "srcpkgs/$p" ]; then
            _check_update "$p"
        fi
    done

    rm -rf .v .v_
fi

if [ "$report_on" == "yes" ]; then
    _html_table_c
    _html_end
fi
# ------------------------ main script -------------------------

# -------------------------- runtime ---------------------------
_line
end_time=`date +%s`
_note "Runtime $(date -d@$((end_time-start_time)) -u +%H:%M:%S)"
_line
# ------------------------- /runtime ---------------------------
