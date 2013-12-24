function yaprox_help() {
    printf "yaprox sets your http_proxy and https_proxy environment variables

 Usage: yaprox USER SERVER

 Runtime options:
  -c, [--clear]     # Unset http_proxy and https_proxy
  -q, [--quiet]     # Quiet mode
  -h, [--help]      # Display this help and exit

WARNING: use wisely, the environment will store your plaintext password for the
duration of the session.
"

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
                -c | --clear)
                    unset http_proxy
                    unset HTTP_PROXY
                    unset https_proxy
                    unset HTTPS_PROXY
                    echo "Proxy variables cleared."
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

    if [[ "$#" -ne 2 ]]; then
        yaprox_help
        return
    fi 

    proxy_user=$1
    proxy_server=$2

    echo -n "Enter password: "
    read -s proxy_pwd

    proxy_url=$proxy_user:$proxy_pwd@$proxy_server
    # git seems to work best with lower case environment variable names
    export http_proxy=$proxy_url
    export HTTP_PROXY=$proxy_url
    export https_proxy=$proxy_url
    export HTTPS_PROXY=$proxy_url

    if $TALK; then
      echo
      echo "Now using proxy server $proxy_server. Run yaprox -c when done to unset."
    fi
}

