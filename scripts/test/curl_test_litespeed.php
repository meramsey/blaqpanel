<?php
  $ch = curl_init('https://www.howsmyssl.com/a/check'); 
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
  $data = curl_exec($ch); 
  curl_close($ch); 
  $json = json_decode($data); 
  echo "<h1>Your TLS version is: " . $json->tls_version . "</h1>\n";
?>