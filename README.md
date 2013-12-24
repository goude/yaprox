# yaprox
yaprox sets your HTTP_PROXY and HTTPS_PROXY environment variables, prompting
for a password.

This avoids tainting your history with passwords and having to
store login credentials in a plain text file.

curl, wget, git and other tools will respect these proxy variables, so you
can get on with your work.

## Installation
Download https://raw.github.com/goude/yaprox/master/yaprox.sh with your web
browser or equivalent proxy-enabled program.

## Usage

    $ source yaprox.sh
    $ yaprox
    yaprox sets your http_proxy and https_proxy environment variables.

    Usage: yaprox [options] USER SERVER

    Runtime options:
      -c, [--clear]     # Unset http_proxy and https_proxy
      -q, [--quiet]     # Quiet mode
      -h, [--help]      # Display this help and exit

    Note:
      If you wish to specify a domain USER, use the format <domain>\\<user>
      (note the double backslash).

    Warning:
      Use wisely, the environment will store your plaintext password for
      the duration of the session.

    $ yaprox user proxy.company.com:8080
    Enter password for user@proxy.company.com:
    Now using proxy.company.com:8080.

    $ env | grep -i http
    http_proxy=user:acererak@proxy.company.com:8080
    HTTP_PROXY=user:acererak@proxy.company.com:8080
    https_proxy=user:acererak@proxy.company.com:8080
    HTTPS_PROXY=user:acererak@proxy.company.com:8080
