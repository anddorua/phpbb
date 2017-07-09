<?php
$line = '';
while(!feof(STDIN)) {
    $line .= fgets(STDIN);
}
$data = json_decode($line);
$versions = array_map(function($chunk){ return $chunk->current; }, array_values((array)$data->stable));
$kversions = array_combine($versions, array_map(function($ver){ $a = explode('.', $ver); return ($a[0]*100 + $a[1]) * 100 + $a[2]; }, $versions));
arsort($kversions);
echo(array_keys($kversions)[0]);