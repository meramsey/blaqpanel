#!/usr/bin/env bash

CUR_DIR=`dirname "$0"`
cd $CUR_DIR
CUR_DIR=`pwd`

echo "Coverting XML format configuration files to plain text configuration files."

# if [ "x$1" = "x" ] ; then
#         echo Need server_root as parameter, such as /usr/local/lsws
#         echo Usage: $0 Server_Root
#         echo .
#         exit 1
# fi

SERVER_ROOT_DEFAULT='/usr/local/lsws'
SERVER_ROOT="${1:-$SERVER_ROOT_DEFAULT}"
echo "Server_root is $SERVER_ROOT, converting ..."

#The below command will convert XML to conf, if the second parameter is 2xml, 
#such as   
#         php convertxml.php $SERVER_ROOT 2xml
#then it will cpnvert conf to xml
#$SERVER_ROOT/admin/fcgi-bin/admin_php convertxml.php $SERVER_ROOT $SERVER_ROOT/backup/recover_xml.sh

# Converting to plaintext
# $SERVER_ROOT/admin/fcgi-bin/admin_php convertxml.php $SERVER_ROOT/backup/recover_xml.sh
/usr/local/lsws/admin/fcgi-bin/admin_php convertxml.php /usr/local/lsws/backup/recover_xml.sh

# Converting to xml
# $SERVER_ROOT/admin/fcgi-bin/admin_php convertxml.php $SERVER_ROOT/backup/recover_xml.sh
# /usr/local/lsws/admin/fcgi-bin/admin_php convertxml.php 2xml

echo "Converting finished."