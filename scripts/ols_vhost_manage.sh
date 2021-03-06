#!/usr/bin/env bash
## Author: Michael Ramsey
## Objective: Manage (Create|Remove) vhosts configs and insert them into main config.
## https://github.com/meramsey/blaqpanel/
## Parts are Based off : https://github.com/litespeedtech/ls-cloud-image/blob/master/Setup/vhsetup.sh
## How to use.
# ./ols_vhost_manage.sh domain action <optional args>
#./ols_vhost_manage.sh example.com add --phpver lsphp80
#
## link='https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/ols_vhost_manage.sh'; bash <(curl -s ${link} || wget -qO - ${link}) example.com add --phpver lsphp80
##
## To update options just add new argbash options and rerun `argbash -o ols_vhost_manage.sh ols_vhost_manage.sh` to update the script in place with new arguments.

version="0.1"
# Created by argbash-init v2.10.0
# ARG_POSITIONAL_SINGLE([domain],[Domain to manage vhost configs for])
# ARG_POSITIONAL_SINGLE([action],[Action to do for vhost 'add' or 'remove' vhost config for domain (optional)],[add])
# ARG_OPTIONAL_SINGLE([www],[w],[Base www file path to use for domains (optional)],[/var/www])
# ARG_OPTIONAL_SINGLE([html],[],[Html folder name to use for domains docroot (optional)],[html])
# ARG_OPTIONAL_SINGLE([phpver],[p],[LSPHP version to use for domain (optional)],[lsphp74])
# ARG_OPTIONAL_BOOLEAN([ssl],[s],[SSL setup for domain],[off])
# ARG_OPTIONAL_BOOLEAN([debug],[],[Run script with bash debugging enabled],[off])
# ARG_DEFAULTS_POS([])
# ARG_VERSION([echo v$version])
# ARG_HELP([OpenLiteSpeed domain vhost management script])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='wpsvh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
_arg_domain=
_arg_action="add"
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_www="/var/www"
_arg_html="html"
_arg_phpver="lsphp74"
_arg_ssl="off"
_arg_debug="off"


print_help()
{
	printf '%s\n' "OpenLiteSpeed domain vhost management script"
	printf 'Usage: %s [-w|--www <arg>] [--html <arg>] [-p|--phpver <arg>] [-s|--(no-)ssl] [--(no-)debug] [-v|--version] [-h|--help] <domain> [<action>]\n' "$0"
	printf '\t%s\n' "<domain>: Domain to manage vhost configs for"
	printf '\t%s\n' "<action>: Action to do for vhost 'add' or 'remove' vhost config for domain (optional) (default: 'add')"
	printf '\t%s\n' "-w, --www: Base www file path to use for domains (optional) (default: '/var/www')"
	printf '\t%s\n' "--html: Html folder name to use for domains docroot (optional) (default: 'html')"
	printf '\t%s\n' "-p, --phpver: LSPHP version to use for domain (optional) (default: 'lsphp74')"
	printf '\t%s\n' "-s, --ssl, --no-ssl: SSL setup for domain (off by default)"
	printf '\t%s\n' "--debug, --no-debug: Run script with bash debugging enabled (off by default)"
	printf '\t%s\n' "-v, --version: Prints version"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-w|--www)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_www="$2"
				shift
				;;
			--www=*)
				_arg_www="${_key##--www=}"
				;;
			-w*)
				_arg_www="${_key##-w}"
				;;
			--html)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_html="$2"
				shift
				;;
			--html=*)
				_arg_html="${_key##--html=}"
				;;
			-p|--phpver)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_phpver="$2"
				shift
				;;
			--phpver=*)
				_arg_phpver="${_key##--phpver=}"
				;;
			-p*)
				_arg_phpver="${_key##-p}"
				;;
			-s|--no-ssl|--ssl)
				_arg_ssl="on"
				test "${1:0:5}" = "--no-" && _arg_ssl="off"
				;;
			-s*)
				_arg_ssl="on"
				_next="${_key##-s}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			--no-debug|--debug)
				_arg_debug="on"
				test "${1:0:5}" = "--no-" && _arg_debug="off"
				;;
			-v|--version)
				echo v$version
				exit 0
				;;
			-v*)
				echo v$version
				exit 0
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'domain'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require between 1 and 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect between 1 and 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_domain _arg_action "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


# vvv  PLACE YOUR CODE HERE  vvv
# For example:
# printf "Value of '%s': %s\\n" 'domain' "$_arg_domain"
# printf "Value of '%s': %s\\n" 'action' "$_arg_action"
# printf "Value of '%s': %s\\n" 'phpver' "$_arg_phpver"
# printf "Value of '%s': %s\\n" 'ssl' "$_arg_ssl"

if [ "${_arg_debug}" == 'on' ] || [ "${DEBUG}" == 'true' ] || [ "${DEBUG}" == 1 ]; then
      export PS4='+ ${BASH_SOURCE##*/}:${LINENO} '
  set -x
fi

# Globals
MY_DOMAIN="$_arg_domain"
MY_DOMAIN2=''
WWW_PATH="$_arg_www"
BOTCRON='/etc/cron.d/certbot'
LSDIR='/usr/local/lsws'
WEBCF="${LSDIR}/conf/httpd_config.conf"
VHDIR="${LSDIR}/conf/vhosts"
EMAIL='localhost'
WWW='FALSE'
PHPVER="$_arg_phpver"
USER='www-data'
GROUP='www-data'
DOMAIN_PASS='ON'
DOMAIN_SKIP='OFF'
ISSUECERT="$_arg_ssl"
FORCE_HTTPS='OFF'
VHOST_REMOTE_TEMPLATE='https://raw.githubusercontent.com/meramsey/blaqpanel/main/lsws/conf/vhosts/vhost.conf'

check_root(){
    if [ $(id -u) -ne 0 ]; then
        echo "Please run this script as root user or use sudo"
        exit 2
    fi
}
check_process(){
    ps aux | grep ${1} | grep -v grep >/dev/null 2>&1
}


verify_domain() {
    curl -Is http://${MY_DOMAIN}/ | grep -i LiteSpeed >/dev/null 2>&1
    if [ ${?} = 0 ]; then
        echo "${MY_DOMAIN} check PASS"
    else
        echo "${MY_DOMAIN} inaccessible, skip!"
        DOMAIN_PASS='OFF'
    fi
    if [ ${WWW} = 'TRUE' ]; then
        curl -Is http://${MY_DOMAIN}/ | grep -i LiteSpeed >/dev/null 2>&1
        if [ ${?} = 0 ]; then
            echo "${MY_DOMAIN2} check PASS"
        else
            echo "${MY_DOMAIN2} inaccessible, skip!"
            DOMAIN_PASS='OFF'
        fi
    fi
}

create_file(){
    if [ ! -f ${1} ]; then
        touch ${1}
    fi
}
create_folder(){
    if [ ! -d "${1}" ]; then
        mkdir -p ${1}
    fi
}
change_owner() {
    chown -R ${USER}:${GROUP} ${DOCHM}
}
line_insert(){
    LINENUM=$(grep -n "${1}" ${2} | cut -d: -f 1)
    ADDNUM=${4:-0}
    if [ -n "$LINENUM" ] && [ "$LINENUM" -eq "$LINENUM" ] 2>/dev/null; then
        LINENUM=$((${LINENUM}+${4}))
        sed -i "${LINENUM}i${3}" ${2}
    fi
}

check_empty(){
    if [ -z "${1}" ]; then
        echo "\nPlease input a value! exit!\n"
        exit 1
    fi
}

check_www_domain(){
    CHECK_WWW=$(echo "${1}" | cut -c1-4)
    if [[ ${CHECK_WWW} == www. ]]; then
        WWW='TRUE'
        MY_DOMAIN2=$(echo "${1}" | cut -c 5-)
    else
        MY_DOMAIN2="${1}"
    fi
}

domain_input(){
    local domain
	domain="$1"

    check_empty ${domain}
    check_duplicate ${domain} ${WEBCF}
    if [ ${?} = 0 ]; then
        echo "domain existed, skip!"
        DOMAIN_SKIP='ON'
    fi
    check_www_domain ${domain}
}

check_duplicate() {
    grep -w "${1}" ${2} >/dev/null 2>&1
}
restart_lsws(){
    ${LSDIR}/bin/lswsctrl restart >/dev/null
}
set_vh_conf() {
    create_folder "${DOCHM}"
    create_folder "${VHDIR}/${MY_DOMAIN}"
    create_file "${VHDIR}/${MY_DOMAIN}/htpasswd"
    create_file "${VHDIR}/${MY_DOMAIN}/htgroup"
    if [ ! -f "${DOCHM}/index.php" ]; then
        cat <<'EOF' >${DOCHM}/index.php
<?php
phpinfo();
EOF
        change_owner
    fi
    if [ ! -f "${VHDIR}/${MY_DOMAIN}/vhconf.conf" ]; then
# Old inline method
        cat > ${VHDIR}/${MY_DOMAIN}/vhconf.conf << EOF
docRoot                   \$VH_ROOT/${_arg_html}
vhDomain                  \$VH_DOMAIN
vhAliases                 www.\$VH_DOMAIN
adminEmails               admin@\$VH_DOMAIN
enableGzip                1
enableBr                  1

errorlog \$VH_ROOT/${_arg_html}/logs/\$VH_NAME.error_log {
useServer               0
logLevel                ERROR
rollingSize             10M
}

accesslog \$VH_ROOT/${_arg_html}/logs/\$VH_NAME.access_log {
useServer               0
logFormat               "%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i""
logHeaders              7
rollingSize             10M
keepDays                10
}

index  {
useServer               0
indexFiles              index.php, index.html
}

scripthandler  {
add                     lsapi:${PHPVER} php
}

phpIniOverride  {
php_admin_flag log_errors On
php_admin_value error_log logs/php_error_log
}

realm Default {
  note                    Default password protected realm

  userDB  {
    location              \$SERVER_ROOT/conf/vhosts/\$VH_NAME/htpasswd
  }

  groupDB  {
    location              \$SERVER_ROOT/conf/vhosts/\$VH_NAME/htgroup
  }
}

extprocessor ${PHPVER} {
type                    lsapi
address                 uds://tmp/lshttpd/${MY_DOMAIN}.sock
maxConns                35
env                     PHP_LSAPI_CHILDREN=35
env                     PHP_INI_SCAN_DIR=:\$VH_ROOT/${_arg_html}
initTimeout             600
retryTimeout            0
persistConn             1
respBuffer              0
autoStart               1
path                    ${LSDIR}/${PHPVER}/bin/lsphp
backlog                 100
instances               1
runOnStartUp            1
priority                0
memSoftLimit            2047M
memHardLimit            2047M
procSoftLimit           400
procHardLimit           500
}

### Insert context configs below this line

context /logs/ {
  location                logs/
  allowBrowse             0
  note                    Deny public access to logs directory

  rewrite  {

  }
  addDefaultCharset       off

  phpIniOverride  {

  }
}

context / {
  allowBrowse             1
  note                    Default Context Headers
  extraHeaders            <<<END_extraHeaders
X-Frame-Options "SAMEORIGIN" always
X-XSS-Protection "1; mode=block" always;
  END_extraHeaders


  rewrite  {

  }
  addDefaultCharset       off

  phpIniOverride  {

  }
}

rewrite  {
enable                  1
autoLoadHtaccess        1
logLevel                0
}

vhssl  {
keyFile                 /etc/letsencrypt/live/\$VH_NAME/privkey.pem
certFile                /etc/letsencrypt/live/\$VH_NAME/fullchain.pem
certChain               1
sslProtocol             24
ciphers                 EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:ECDHE-RSA-AES128-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA128:DHE-RSA-AES128-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA128:ECDHE-RSA-AES128-SHA384:ECDHE-RSA-AES128-SHA128:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA128:DHE-RSA-AES128-SHA128:DHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA384:AES128-GCM-SHA128:AES128-SHA128:AES128-SHA128:AES128-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4
enableECDHE             1
renegProtection         1
sslSessionCache         1
enableSpdy              15
enableQuic              1
enableStapling           1
ocspRespMaxAge           86400
}
EOF
		# New method to install vhost from url
		# wget -O /usr/local/lsws/conf/vhosts/${MY_DOMAIN}/vhconf.conf ${VHOST_REMOTE_TEMPLATE}
        chown -R lsadm:lsadm ${VHDIR}/*
    else
        echo "Targeted vhost file: /usr/local/lsws/conf/vhosts/${MY_DOMAIN}/vhconf.conf already exist, skip!"
    fi
}
set_server_conf() {
    if [ ${WWW} = 'TRUE' ]; then
        NEWKEY="  map                     ${MY_DOMAIN2} ${MY_DOMAIN}, ${MY_DOMAIN2}"
        local TEMP_DOMAIN=${MY_DOMAIN2}
    else
        NEWKEY="  map                     ${MY_DOMAIN} ${MY_DOMAIN}"
        local TEMP_DOMAIN=${MY_DOMAIN}
    fi
    PORT_ARR=$(grep "address.*:[0-9]"  ${WEBCF} | awk '{print substr($2,3)}')
    if [  ${#PORT_ARR[@]} != 0 ]; then
        for PORT in ${PORT_ARR[@]}; do
            line_insert ":${PORT}$"  ${WEBCF} "${NEWKEY}" 3
        done
    else
        echo 'No listener port detected, listener setup skip!'
    fi
    echo "
virtualhost ${TEMP_DOMAIN} {
vhRoot                  ${WWW_PATH}/${MY_DOMAIN}
configFile              ${VHDIR}/${MY_DOMAIN}/vhconf.conf
allowSymbolLink         1
enableScript            1
restrained              1
setUIDMode              2
}" >>${WEBCF}
}
update_vh_conf(){
    sed -i 's|localhost|'${EMAIL}'|g' ${VHDIR}/${MY_DOMAIN}/vhconf.conf
    sed -i "s|\$VH_NAME|'${MY_DOMAIN}|g" ${VHDIR}/${MY_DOMAIN}/vhconf.conf
    # sed -i 's|'${LSDIR}'/conf/example.key|/etc/letsencrypt/live/'${MY_DOMAIN}'/privkey.pem|g' ${VHDIR}/${MY_DOMAIN}/vhconf.conf
    # sed -i 's|'${LSDIR}'/conf/example.crt|/etc/letsencrypt/live/'${MY_DOMAIN}'/fullchain.pem|g' ${VHDIR}/${MY_DOMAIN}/vhconf.conf
    echo "\nVhost config has been updated..."
}
main_set_vh(){
    create_folder ${WWW_PATH}
    DOCHM="${WWW_PATH}/${1}/${_arg_html}"
    if [ ${DOMAIN_SKIP} = 'OFF' ]; then
        set_vh_conf
        set_server_conf
        restart_lsws
        echo "Vhost created success!"
    fi
}

apply_lecert() {
    if [ ${WWW} = 'TRUE' ]; then
        certbot certonly --non-interactive --agree-tos --register-unsafely-without-email --webroot -w ${DOCHM} -d ${MY_DOMAIN} -d ${MY_DOMAIN2}
    else
        certbot certonly --non-interactive --agree-tos --register-unsafely-without-email --webroot -w ${DOCHM} -d ${MY_DOMAIN}
    fi
    if [ ${?} -eq 0 ]; then
        update_vh_conf
    else
        echo "Oops, something went wrong..."
        exit 1
    fi
}

hook_certbot() {
    sed -i 's/0.*/&  --deploy-hook "\/usr\/local\/lsws\/bin\/lswsctrl restart"/g' ${BOTCRON}
    check_duplicate 'restart' ${BOTCRON}
    if [ ${?} = 0 ]; then
        echo 'Certbot hook update success'
    else
        echo 'Please check certbot crond!'
    fi
}

force_https() {   
    if [ ${FORCE_HTTPS} = 'ON' ]; then
        create_file "${DOCHM}/.htaccess"
        check_duplicate 'https://' "${DOCHM}/.htaccess"   
        if [ ${?} = 1 ]; then
            echo "$(echo '
### Forcing HTTPS rule start
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
### Forcing HTTPS rule end
            ' | cat - ${DOCHM}/.htaccess)" >${DOCHM}/.htaccess
            restart_lsws
            echo "Force HTTPS rules added success!" 
        else
            echo "Force HTTPS rules already existed, skip!"
        fi
    fi 
}

issue_cert(){
    if [ ${ISSUECERT} = 'on' ]; then
        verify_domain
        if [ ${DOMAIN_PASS} = 'ON' ]; then
            apply_lecert
            hook_certbot   
        else
            echo 
        fi    
    fi
}

disable_certbot_ols_site(){
	local domain
	domain="$1"
	
    if [ -d "/etc/letsencrypt/live/$domain" ]; then
        certbot delete --cert-name $domain --noninteractive
    fi
}

remove_ols_site(){
	local domain
	domain="$1"
	
    disable_certbot_ols_site "${domain}"
    rm -rf /usr/local/lsws/conf/vhosts/${domain}
    rm -rf /usr/local/lsws/conf/vhosts-disabled/${domain}
    # remove the block like below
    # virtualhost somedomain.tld {
    # vhRoot                  /var/www/somedomain.tld
    # configFile              /usr/local/lsws/conf/vhosts/somedomain.tld/vhconf.conf
    # allowSymbolLink         1
    # enableScript            1
    # restrained              1
    # setUIDMode              2
    # user                    $VH_USER
    # group                   $VH_USER
    # }
    sed -i -re "/virtualhost ${domain} \{/{:a;N;/\}/!ba};/vhRoot                  \/var\/www\/$domain/d" /usr/local/lsws/conf/httpd_config.conf
    # remove the map lines inserted on the multiple listeners blocks like below
    # map                     somedomain.tld somedomain.tld
    sed -i "/map                     $domain $domain/d" /usr/local/lsws/conf/httpd_config.conf
    systemctl restart lsws
}


# Start doing stuff.
# check_root

if [[ "$_arg_action" = "add" ]] ; then
	echo "Adding vhost configs for $_arg_domain"
	# Add vhost actions
	domain_input "$_arg_domain"
	main_set_vh "${MY_DOMAIN}"
	if [[ "$_arg_ssl" = "on" ]] ; then
		echo "Run SSL setup for $_arg_domain"
		issue_cert
		force_https
	fi
elif [[ "$_arg_action" = "remove" ]]; then
	echo "Removing vhost configs for $_arg_domain"
	remove_ols_site "$_arg_domain"
fi



# ^^^  TERMINATE YOUR CODE BEFORE THE BOTTOM ARGBASH MARKER  ^^^

# ] <-- needed because of Argbash
