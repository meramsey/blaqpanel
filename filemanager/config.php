<?php

/*
#################################################################################################################
This is an OPTIONAL configuration file. rename this file into config.php to use this configuration 
The role of this file is to make updating of "tinyfilemanager.php" easier.
So you can:
-Feel free to remove completely this file and configure "tinyfilemanager.php" as a single file application.
or
-Put inside this file all the static configuration you want and forgot to configure "tinyfilemanager.php".
#################################################################################################################
*/

//Application Title
define('APP_TITLE', 'FileManager');

// Auth with login/password
// set true/false to enable/disable it
// Is independent from IP white- and blacklisting
$use_auth = true;

// Login user name and password
// Users: array('Username' => 'Password', 'Username2' => 'Password2', ...)
// Generate secure password hash - https://tinyfilemanager.github.io/docs/pwd.html
$auth_users = array(
//     'admin' => '$2y$10$/K.hjNr84lLNDt8fTXjoI.DBp6PpeyoJ.mGwrrLuCZfAwfSAGqhOW', //admin@123
//     'user' => '$2y$10$Fg6Dz8oH9fPoZ2jJan5tZuv6Z4Kp7avtQ9bDfrdRntXtPeiMAZyGO' //12345
  // Insert user and pass below this line.
  //'admin' => 'ADMIN_HASHED_PASSWORD',
  //'user' => 'USER_HASHED_PASSWORD',
  //'admin' => password_hash('ADMIN_PASSWORD', PASSWORD_DEFAULT),
  //'user' => password_hash('USER_PASSWORD', PASSWORD_DEFAULT),
  // For replacing via scripted setups
  
  'ADMIN_USERNAME' => 'ADMIN_HASHED_PASSWORD',

  
  // Insert user and pass above this line.
);

// Readonly users
// e.g. array('users', 'guest', ...)
$readonly_users = array(
    'user'
);

// Enable highlight.js (https://highlightjs.org/) on view's page
$use_highlightjs = true;

// highlight.js style
// for dark theme use 'ir-black'
$highlightjs_style = 'ir-black';

// Set light or dark theme
$theme = 'dark';
define('FM_THEME', $theme);

// Enable ace.js (https://ace.c9.io/) on view's page
$edit_files = true;

// Default timezone for date() and time()
// Doc - http://php.net/manual/en/timezones.php
$default_timezone = 'Etc/UTC'; // UTC

// Root path for file manager
// use absolute path of directory i.e: '/var/www/folder' or $_SERVER['DOCUMENT_ROOT'].'/folder'
// $root_path = $_SERVER['DOCUMENT_ROOT'];

$root_path = dirname(__FILE__, 2); // Set's this to parent directory /var/www/domain/html instead of /var/www/domain/html/filemanager

// Root url for links in file manager.Relative to $http_host. Variants: '', 'path/to/subfolder'
// Will not working if $root_path will be outside of server document root
$root_url = '';

// Server hostname. Can set manually if wrong
$http_host = $_SERVER['HTTP_HOST'];

// user specific directories
// https://github.com/prasathmani/tinyfilemanager/wiki/Security-and-User-Management#user-specific-directories
// array('Username' => 'Directory path', 'Username2' => 'Directory path', ...)
$directories_users = array(
  'ADMIN_USERNAME' => $root_path, // restricts user to their own /var/www/domain/html 
);

// input encoding for iconv
$iconv_input_encoding = 'UTF-8';

// date() format for file modification date
// Doc - https://www.php.net/manual/en/datetime.format.php
$datetime_format = 'd.m.y H:i:s';

// Allowed file extensions for create and rename files
// e.g. 'txt,html,css,js'
$allowed_file_extensions = '';

// Allowed file extensions for upload files
// e.g. 'gif,png,jpg,html,txt'
$allowed_upload_extensions = '';

// Favicon path. This can be either a full url to an .PNG image, or a path based on the document root.
// full path, e.g http://example.com/favicon.png
// local path, e.g images/icons/favicon.png
$favicon_path = 'https://raw.githubusercontent.com/meramsey/blaqpanel/main/filemanager/images/favicon.ico';

// Files and folders to excluded from listing
// https://github.com/prasathmani/tinyfilemanager/wiki/Exclude-Files-&-Folders
// e.g. array('myfile.html', 'personal-folder', '*.php', ...)
$exclude_items = array(
    'phpMyAdmin',
    'filemanager',
    'filemanager/index.php',
    'filemanager/config.php',
);

// Online office Docs Viewer
// Availabe rules are 'google', 'microsoft' or false
// google => View documents using Google Docs Viewer
// microsoft => View documents using Microsoft Web Apps Viewer
// false => disable online doc viewer
$online_viewer = 'google';

// Sticky Nav bar
// true => enable sticky header
// false => disable sticky header
$sticky_navbar = true;


// max upload file size
$max_upload_size_bytes = 50000000;

// https://github.com/prasathmani/tinyfilemanager/wiki/IP-Blacklist-and-Whitelist
// Possible rules are 'OFF', 'AND' or 'OR'
// OFF => Don't check connection IP, defaults to OFF
// AND => Connection must be on the whitelist, and not on the blacklist
// OR => Connection must be on the whitelist, or not on the blacklist
$ip_ruleset = 'OFF';

// Should users be notified of their block?
$ip_silent = true;

// IP-addresses, both ipv4 and ipv6
$ip_whitelist = array(
    '127.0.0.1',    // local ipv4
    '::1'           // local ipv6
);

// IP-addresses, both ipv4 and ipv6
$ip_blacklist = array(
    '0.0.0.0',      // non-routable meta ipv4
    '::'            // non-routable meta ipv6
);


//?> // commented it out so it doesn't add this to output at top of the file like it would do otherwise
