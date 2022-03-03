#!/usr/bin/env bash
# Reset OLS/CSF WEB UI admin passes all
## How to use:
## Directly from github as root user:
# link="https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/csf_ols_reset.sh";sh <(curl $link || wget -O - $link);

## Manually download
# wget -q -O /usr/local/blaqpanel/bin/csf_ols_reset.sh https://raw.githubusercontent.com/meramsey/blaqpanel/main/scripts/csf_ols_reset.sh && chmod +x /usr/local/blaqpanel/bin/csf_ols_reset.sh; 
## Then execute:
# /usr/local/blaqpanel/bin/csf_ols_reset.sh



#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi


ols_user_pass_reset(){
    local admin_pass
    local admin_user
    default_admin_username='admin'
    admin_user="${1:-$default_admin_username}" # optional param so we can selectively change admin username from default 'admin' but only if provided
    admin_pass="$2"
    ENCRYPT_PASS=`"/usr/local/lsws/admin/fcgi-bin/admin_php" -q "/usr/local/lsws/admin/misc/htpasswd.php" $admin_pass`
    if [ $? = 0 ] ; then
        echo "${admin_user}:$ENCRYPT_PASS" > "/usr/local/lsws/admin/conf/htpasswd"
        if [ $? = 0 ] ; then
            echo "Set OpenLiteSpeed Web Admin access."
        else
            echo "OpenLiteSpeed WebAdmin password not changed."
        fi
    fi
}


csf_webui_user_pass_reset(){
    local admin_pass
    local admin_user
    default_admin_username='admin'
    admin_user="${1:-$default_admin_username}" # optional param so we can selectively change admin username from default 'admin' but only if provided
    admin_pass="$2"
    
    sed -i 's/^UI_USER =.*/UI_USER = "'$admin_user'"/g' /etc/csf/csf.conf
    sed -i 's/^UI_PASS =.*/UI_PASS = "'$admin_pass'"/g' /etc/csf/csf.conf
}

restart_csf_ols(){
  csf -ra
  systemctl stop lsws >/dev/null 2>&1
	systemctl start lsws >/dev/null 2>&1
}

reset_ols_csf_admin_passes(){
  local admin_pass
  local admin_user
  admin_user="${1:-$default_admin_username}" # optional param so we can selectively change admin username from default 'admin' but only if provided
  admin_pass="$2"
  ENCRYPT_PASS=`"/usr/local/lsws/admin/fcgi-bin/admin_php" -q "/usr/local/lsws/admin/misc/htpasswd.php" $admin_pass`
  echo "${admin_user}:$ENCRYPT_PASS" > "/usr/local/lsws/admin/conf/htpasswd"
  csf_webui_user_pass_reset "$admin_user" "$admin_pass"
  if [ $? = 0 ] ; then
      echo "Success: OLS/CSF Admin password Updated"
      restart_csf_ols
  else
      echo "OpenLiteSpeed WebAdmin password not changed."
  fi
}

reset_ols_csf_admin_passes "$1" "$2"


