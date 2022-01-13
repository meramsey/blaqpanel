<?php
// ols config to lsws xml converter
// ${LS_DIR}/admin/misc/converter.php
// place in /usr/local/lsws/admin/misc/converter.php
// wget -O /usr/local/lsws/admin/misc/converter.php
// $lsws = dirname(dirname(__DIR__)) . '/';
$lsws = '/usr/local/lsws/';
ini_set(
	'include_path',
	$lsws . 'admin/html/lib/:' .
		$lsws . 'admin/html/lib/ows/:' .
		$lsws . 'admin/html/view/'
);
date_default_timezone_set('America/New_York');
spl_autoload_register( function ($class) {
	include $class . '.php';
});
CData::Util_Migrate_AllConf2Xml($lsws);
