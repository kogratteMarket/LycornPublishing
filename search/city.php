<?php
header('Access-Control-Allow-Origin: *');

mysql_connect('sql.free.fr', 'nik94', 'nicolas');
mysql_select_db('nik94');

$params = array(
	array(
		'name' => 'lat',
		'typeCheck' => 'floatval',
		'required' => true
	),
	
	array(
		'name' => 'long',
		'typeCheck' => 'floatval',
		'required' => true
	),
	array(
		'name' => 'results',
		'typeCheck' => 'intval',
		'required' => false
	),
    array(
        'name' => 'proximity',
        'typeCheck' => 'is_string',
        'required' => false
    )
);

foreach ($params as $param) {
	if ($param['required'] && !isset($_GET[$param['name']])) {
	
		header('HTTP/1.0 400 Bad Request');
		echo 'Missing param ' . $param['name'];
		exit;
	}
	
	$$param['name'] = $_GET[$param['name']];
	
	if ($$param['name'] && $param['typeCheck'] && !$param['typeCheck']($$param['name'])) {
		header('HTTP/1.0 400 Bad Request');
		echo 'Invalid param ' . $param['name'] . ' (must be '.$param['typeCheck'].')';
		exit;
	}
}

$sql = "
SELECT *,
(6366*acos(cos(radians($lat))*cos(radians(ville_latitude_deg))*cos(radians(ville_longitude_deg)-radians($long))+sin(radians($lat))*sin(radians(ville_latitude_deg))))
as Proximite
FROM villes_france
ORDER BY Proximite  ".($proximity ? $proximity : 'ASC') . "
LIMIT 1," . ($results ? $results : 10);

$res = mysql_query($sql);
$data = array();
while ($row = mysql_fetch_assoc($res)) {
	$data[] = array(
		'cityName' => $row['ville_nom'],
        'zipCode' => $row['ville_code_postal']
	);

   /* $weatherUrl = 'http://api.previmeteo.com/06eee7d1c20d0bb49d9e909acf4ddcb0/ig/api?weather=' . $row['ville_code_postal'] . ',FR&hl=fr&res=json';
    $fd = fopen($weatherUrl, 'r');
    while ($content .= fread($fd));
    fclose($fd);
    var_dump(
      $content
    );

    die();*/
}

require 'jsonwrapper/jsonwrapper_inner.php';

header('Access-Control-Allow-Origin: *');


echo json_encode($data);