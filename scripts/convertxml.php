<?php
// xml converter
// ${LS_DIR}/admin/misc/convertxml.php
// place in /usr/local/lsws/admin/misc/convertxml.php
// wget -O /usr/local/lsws/admin/misc/convertxml.php
$lsws = '/usr/local/lsws/';

ini_set(
	'include_path',
	$lsws . 'admin/html/lib/:' .
		$lsws . 'admin/html/lib/ows/:' .
		$lsws . 'admin/html/view/'
);

// $SERVROOT = $argv[1];

// ini_set('include_path', "../html.open/lib/:../html.open/lib/ows/:../html.open/view/:../html.open/view/inc/:.");

// if ($argc != 3)
//   die ("require parameter SERVER_ROOT and [recover script file path | 2xml ]");

if ($argc != 2) {
	die('require parameter recover script file path | and optional 2xml ]');
}

date_default_timezone_set('America/New_York');

spl_autoload_register( function ($class) {
	include $class . '.php';
});

if ($argv[1] == '2xml' ) {
	CData::Util_Migrate_AllConf2Xml($lsws);
} else {
	CData::Util_Migrate_AllXml2Conf($lsws, $argv[1], 1);
}
