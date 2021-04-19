$v = @("BARTphysical","LINDAonline","NICKY")

$bart = "book"
$linda = "test"

if ( ($bart -eq "book") -and -not ( $linda -eq "test")){
    "ok"
}

foreach ($i in $v){
    $i=$i.Replace('physical','').Replace('online','') ;
    $i
}