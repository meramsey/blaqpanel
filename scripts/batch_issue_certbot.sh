#!/usr/bin/env bash
# Issue/Renew all domains via certbot after DNS switched over from another server.
## How to use:
## Directly from github as root user:
# link="https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/batch_issue_certbot.sh";sh <(curl $link || wget -O - $link);

## Manually download
# wget -q -O /usr/local/blaqpanel/bin/batch_issue_certbot.sh https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/batch_issue_certbot.sh && chmod +x /usr/local/blaqpanel/bin/batch_issue_certbot.sh; 
## Then execute:
# /usr/local/blaqpanel/bin/batch_issue_certbot.sh

### OLS functions
WWW_PATH='/var/www'
LSDIR='/usr/local/lsws'
VHDIR="${LSDIR}/conf/vhosts"
BOTCRON='/etc/cron.d/certbot'
WWW='FALSE'

restart_lsws(){
    # kill detached lsphp processes and restart ols
    killall -9 lsphp >/dev/null 2>&1
    systemctl stop lsws >/dev/null 2>&1
    systemctl start lsws   
}

for dir in $(ls -d /var/www/*/html); do
	domain=$(echo $dir|sed -e 's|/var/www/||g' -e 's|/html||g');
	DOCHM="/var/www/$domain/html"
	echo "Requesting SSL for Domain: $domain and www.$domain path: /var/www/$domain/html/";
	certbot certonly --non-interactive --agree-tos --register-unsafely-without-email --webroot -w ${DOCHM} -d ${domain} -d www.${domain}||certbot certonly --non-interactive --agree-tos --register-unsafely-without-email --webroot -w ${DOCHM} -d ${domain}
	sed -i "s|\$VH_NAME|$domain|g" ${VHDIR}/${domain}/vhconf.conf
	echo
	echo "SSL for Domain: $domain has been requested"
	echo "=========================================="
done


echo 'Killing detached lsphp processes and restarting OLS/LSWS webserver'
restart_lsws
