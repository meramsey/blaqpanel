<?php
# https://docs.litespeedtech.com/lsws/bubblewrap/
#
echo "Scanning / filesystem...";
$dir    = '/';
$files1 = scandir($dir);
echo '<pre>';
print_r($files1);
echo '</pre>';
echo "==============\n\n";
echo '<pre>';
echo 'Contents of /etc/passwd';
echo '</pre>';
echo '<pre>' . file_get_contents("/etc/passwd") . '</pre>';
echo "==============\n\n";
echo '<pre>';
echo 'Contents of /etc/group';
echo '</pre>';
echo '<pre>' . file_get_contents("/etc/group") . '</pre>';
?>
