# Yaprox uses code from https://github.com/andsens/homeshick

function yaprox_help() {
    printf "yaprox sets your http_proxy and https_proxy environment variables.

 Usage: yaprox [options] [user] server

 (if server is a number N, use line N from ~/.yaproxrc)

 Runtime options:
  -c, [--clear]     # Unset http_proxy and https_proxy
  -q, [--quiet]     # Quiet mode
  -h, [--help]      # Display this help and exit
  -l, [--list]      # Show relevant environment variables
  -s, [--stash]     # Unset proxy variables, but save for later use in a temporary environment variable
  -u, [--unstash]   # Set proxy variables using stashed value; clear temporary environment variable

 Note:
  If you wish to specify a domain USER, use the format <domain>\\\\\\<user>
  (note the double backslash).

 Warning:
  Use wisely, the environment will store your plaintext password for
  the duration of the session. Always inspect the source code when you download
  something from the internet, including this script.
"

}

function _yaprox_clear() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
}

function yaprox() {
    local proxy_user proxy_server proxy_pwd proxy_url
    local TALK=true

    # Option parsing from andsens/homeshick
    while [[ $# -gt 0 ]]; do
        if [[ $1 =~ ^- ]]; then
            # Convert combined short options into multiples short options (e.g. `-qb' to `-q -b')
            if [[ $1 =~ ^-[a-z]{2,} ]]; then
                param=$1
                shift
                set -- ${param:0:2} -${param:2} $@
                unset param
            fi
            case $1 in
                -h | --help)  yaprox_help ; return ;;
                -q | --quiet) TALK=false ; shift; continue ;;
                -l | --list)
                    env | grep -i prox
                    return
                    ;;
                -c | --clear)
                    _yaprox_clear
                    unset _yaprox_stash
                    if $TALK; then
                        echo "Proxy variables cleared."
                    fi
                    return
                    ;;
                -s | --stash)
                    export _yaprox_stash=$http_proxy
                    _yaprox_clear
                    if $TALK; then
                        echo "Proxy variables stashed."
                    fi
                    return
                    ;;
                -u | --unstash)
                    yaprox -q $_yaprox_stash
                    unset _yaprox_stash
                    if $TALK; then
                        echo "Proxy variables unstashed."
                    fi
                    return
                    ;;
                *)
                    echo "Unknown option '$1'"
                    return 1
                    ;;
            esac
        else
            break
        fi
    done

    if [[ "$#" -eq 2 ]]; then
        proxy_user=$1
        proxy_server=$2
        echo -n "Enter password for $proxy_user@$proxy_server: "
        read -s proxy_pwd
        proxy_url=$proxy_user:$proxy_pwd@$proxy_server
    elif [[ "$#" -eq 1 ]]; then
        if [[ "$1" =~ ^[1-9]$ ]]; then
          proxy_server=$(sed "$1q;d" ~/.yaproxrc)
        else
          proxy_server=$1
          proxy_url=$proxy_server
        fi
    else
        yaprox_help
        return
    fi

    # git seems to work best with lower case environment variable names
    export http_proxy=$proxy_url
    export HTTP_PROXY=$proxy_url
    export https_proxy=$proxy_url
    export HTTPS_PROXY=$proxy_url

    if $TALK; then
      echo
      echo "Now using proxy server $proxy_server. Run yaprox --clear when done to unset."
    fi
}

