yaprox
======

yaprox sets your HTTP_PROXY and HTTPS_PROXY environment variables

    $ git clone https://github.com/goude/yaprox.git
    $ source yaprox/yaprox.sh
    $ yaprox
    
    Usage: yaprox USER SERVER
    
     Runtime options:
      -h        # Display this help and exit
      -c        # Unset http_proxy and https_proxy
    
    WARNING: use wisely, the environment will store your plaintext password for the
    duration of the session.
    
    $ yaprox user proxy.company.com:8080
    Enter password:
    Now using proxy.company.com:8080.
    
    $ env | grep -i http
    http_proxy=user:acererak@proxy.company.com:8080
    HTTP_PROXY=user:acererak@proxy.company.com:8080
    https_proxy=user:acererak@proxy.company.com:8080
    HTTPS_proxy=user:acererak@proxy.company.com:8080
