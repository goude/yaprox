function yaprox_help() {
    printf "yaprox sets your http_proxy and https_proxy environment variables

 Usage: yaprox USER SERVER

 Runtime options:
  -h        # Display this help and exit
  -c        # Unset http_proxy and https_proxy

WARNING: use wisely, the environment will store your plaintext password for the
duration of the session.
"

}

function yaprox() {
    local proxy_user proxy_server proxy_pwd proxy_url
    while getopts ":h:c" opt; do
        case $opt in
            h)
                yaprox_help
                return
                ;;
            c)
                echo "http_proxy and https_proxy cleared."
                unset http_proxy HTTP_PROXY
                unset https_proxy HTTPS_PROXY
                return
        esac
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

    echo "\nNow using $proxy_server."
}
