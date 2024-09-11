<?php

$arquivos = $_FILES['arquivos'];
$names = $_arquivos['name'];
$tmp_name = $_arquivos['tmp_name'];

foreach ($arquivos as $index => $name){
    $extension = pathinfo($name, PATHINFO_EXTENSION);
    $newName = uniqid().'.'.$extension;
    move_uploaded_file($tmp_name[$index], 'uplods/'.$newName);
}

// var_dump($_arquivos);

?>