<?php

/**
 * Oh no!
 *
 * You open the hell file. Take a seat, please take a coffee too. Or two.
 */

/**
 * I need to add this header cause I'm working on a local server, but need to dispose of remote features.
 * To be able to try this, I make all my requests on the final URL.
 */
header('Access-Control-Allow-Origin: *');

/**
 * Yes I know, you've got my identifiers. So bad, this is the only db on my server, you don't need to look this.
 * I use this sql table to get city around a GPS location:
 * http://sql.sh/736-base-donnees-villes-francaises
 *
 * Feel free to use it!
 */
$db = new PDO('mysql:dbname=weather_lycorn', 'weather', 'weather');

/**
 * I'm not using any routing system or any security component, so I use this little piece of code
 * to at least check that provided parameters are formatted as expected.
 */
$params = array(
    array(
        'name'      => 'lat',
        'typeCheck' => 'floatval',
        'required'  => true
    ),

    array(
        'name'      => 'long',
        'typeCheck' => 'floatval',
        'required'  => true
    ),
    array(
        'name'      => 'results',
        'typeCheck' => 'intval',
        'required'  => false
    ),
    array(
        'name'      => 'proximity',
        'typeCheck' => 'is_string',
        'required'  => false
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
        echo 'Invalid param ' . $param['name'] . ' (must be ' . $param['typeCheck'] . ')';
        exit;
    }
}

/**
 * Hum. Here is the mystic query. Don't ask me for anything on this query. Found on the web, seems to work well.
 */
$sql = "
SELECT *,
(6366*acos(cos(radians($lat))*cos(radians(ville_latitude_deg))*cos(radians(ville_longitude_deg)-radians($long))+sin(radians($lat))*sin(radians(ville_latitude_deg))))
as Proximite
FROM villes_france
WHERE ville_population >  10
ORDER BY Proximite  " . ($proximity ? $proximity : 'ASC') . "
LIMIT 1," . ($results ? $results : 10);

$results = $db->query($sql);

$data = array();
while ($row = $results->fetch(PDO::FETCH_ASSOC)) {


    /**
     * Prepare query to retrieve weather
     * I need to get some informations in English, and some other in french, this is why you can see two query.
     */
    $weatherUrlUk = 'http://api.previmeteo.com/06eee7d1c20d0bb49d9e909acf4ddcb0/ig/api?weather=' . $row['ville_code_postal'] . ',FR&hl=en';
    $weather      = file_get_contents($weatherUrlUk);

    $weatherUrlFr = 'http://api.previmeteo.com/06eee7d1c20d0bb49d9e909acf4ddcb0/ig/api?weather=' . $row['ville_code_postal'] . ',FR&hl=fr';
    $weatherFr    = file_get_contents($weatherUrlFr);

    /**
     * That's definitive. I HATE simplexml.
     */
    $xml                   = simplexml_load_string($weather);
    $currentCondition      = (string)$xml->weather->current_conditions->condition['data'];
    $currentTemp           = (string)$xml->weather->current_conditions->temp_c['data'];
    $xml                   = simplexml_load_string($weatherFr);
    $currentConditionLabel = (string)$xml->weather->current_conditions->condition['data'];

    /**
     * Just push data into the result set
     */
    $data[] = array(
        'cityName' => $row['ville_nom'],
        'zipCode'  => $row['ville_code_postal'],
        'weather'  => array(
            'condition'      => $currentCondition,
            // Did you ever try to json_encode a non utf8 character? Result would be as simple as the empty. Nothing.
            // And no error, what question!
            'conditionLabel' => utf8_encode($currentConditionLabel),
            'temp'           => $currentTemp
        )
    );
}

echo json_encode($data);