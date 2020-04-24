$username="sa.automate@vlaamsparlement.be"
$password = "zqLtp9AL"
$siteUrl = "https://vlapa.sharepoint.com/sites/DemoSite"
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
connect-PnPOnline -url $siteUrl -Credentials $cred

$ie = New-Object -ComObject InternetExplorer.Application

$qry="<View><Query><Where><Eq><FieldRef Name='TypePublication' /><Value Type='Choice'>book</Value></Eq></Where></Query></View>"



$exRecord = (Get-PnPListItem -List Aanwinsten -Query $qry).FieldValues



foreach ( $book in $exRecord ) {
    if ( $book.item('Cover') -eq $null){
    $ie.Navigate2($book.Item('Link').Url)
    while($ie.ReadyState -ne 4) { start-sleep -m 1000} 
    start-sleep -Seconds 30
    "*"
    $img = $ie.Document.body.getElementsByTagName('img')
    foreach ($i in $img) {
         if ( $i.className -eq "main-img fan-img-1" ) {
            $i.src
            Set-PnPListItem -List "Aanwinsten" -Identity $book.Item('ID') -Values @{ 'Cover' = $i.src  }
        }  
    }
}
}