$username = "sa.automate@vlaamsparlement.be"
$password = "zqLtp9AL"
$siteUrl = "https://vlapa.sharepoint.com/sites/Informatie"
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
connect-PnPOnline -url $siteUrl -Credentials $cred

$list = Get-PnPListItem -List Aanwinsten -PageSize 4500


foreach ( $it in $list) {
    if ($it.FieldValues.dateIn -eq $NULL) {
            $it.Id
            Remove-PnPListItem -List Aanwinsten -Identity $it.Id -Force
    }
}


