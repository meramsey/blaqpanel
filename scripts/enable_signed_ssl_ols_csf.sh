#!/usr/bin/env bash
# Enable OLS/CSF WEB UI with signed SSL from an existing domain's SSL
## How to use:
## Directly from github as root user:
# link="https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/enable_signed_ssl_ols_csf.sh";sh <(curl $link || wget -O - $link) yourdomain.com ;

## Manually download
# wget -q -O /usr/local/blaqpanel/bin/enable_signed_ssl_ols_csf.sh https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/enable_signed_ssl_ols_csf.sh && chmod +x /usr/local/blaqpanel/bin/csf_ols_reset.sh; 
## Then execute:
# /usr/local/blaqpanel/bin/enable_signed_ssl_ols_csf.sh yourdomain.com

#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


function enable_signed_ssl_ols_csf(){
    local domain
    domain="$1"
    domain_cert="/etc/letsencrypt/live/${domain}/fullchain.pem"
    domain_key="/etc/letsencrypt/live/${domain}/privkey.pem"
    
    if [[ -f ${domain_cert} ]] && [[ -f ${domain_key} ]]; then
        echo "The domain has both a cert and key file that exists!"
        echo "Symlinking LE Signed SSL for OLS/CSF WebUI"
        # Symlink domain ssl path to the same path for OLS/CSF SSL forcefully
        ln -fs "${domain_cert}" /etc/csf/ui/server.crt;
        ln -fs "${domain_key}" /etc/csf/ui/server.key;
        ln -fs "${domain_cert}" /usr/local/lsws/admin/conf/webadmin.crt;
        ln -fs "${domain_key}" /usr/local/lsws/admin/conf/webadmin.key;
        echo "Restarting OLS/CSF WebUI services"
        service lsws restart
        csf -ra
        
    fi
}

enable_signed_ssl_ols_csf "$1"
