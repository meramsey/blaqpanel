<?php
// Create a blank image and add some text
//$im = imagecreatetruecolor(120, 20);
//$text_color = imagecolorallocate($im, 233, 14, 91);

//imagestring($im, 1, 5, 5,  'WebP with PHP', $text_color);

// Save the image
//imagewebp($im, 'php.webp');

// Free up memory
//imagedestroy($im);

$src="https://homepages.cae.wisc.edu/~ece533/images/fruits.png";
$dest="test.webp";
$im = new Imagick();
$im->pingImage($src);
$im->readImage($src);
//$im->resizeImage($width,$height,Imagick::FILTER_CATROM , 1,TRUE ); 
$im->setImageFormat( "webp" );
$im->setOption('webp:method', '6'); 
$im->writeImage($dest);

?>
<p>This is the source image.</p>
<img src="<?php echo $src; ?>">
<p>This is the converted image.</p>
<img src="<?php echo $dest; ?>">

<p>The Left is the source image and Right image is the webp</p>
<div>
  <img src="<?php echo $src; ?>">
  <img src="<?php echo $dest; ?>">
</div>
