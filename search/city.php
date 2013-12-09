<?php

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
from villes_france
order by Proximite
limit 1," . ($results ? $results : 10);

$res = mysql_query($sql);
$data = array();
while ($row = mysql_fetch_assoc($res)) {
	$data[] = array(
		'cityName' => $row['ville_nom']
	);
}

require 'jsonwrapper/jsonwrapper_inner.php';

echo json_encode($data);