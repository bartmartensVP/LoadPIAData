$username="sa.automate@vlaamsparlement.be"
$password = "zqLtp9AL"
$siteUrl = "https://vlapa.sharepoint.com/sites/Informatie"
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
connect-PnPOnline -url $siteUrl -Credentials $cred

$qry="<View><Query><Where><Eq><FieldRef Name='TypePublication' /><Value Type='Choice'>book</Value></Eq></Where></Query></View>"

$exRecord = (Get-PnPListItem -List Aanwinsten -Query $qry).FieldValues
$tellerMet = 0
$tellerTotaal = 0 

foreach ($book in $exRecord) {
    $tellerTotaal += 1
    #$book.Title + $book.ISBN
    if ($book.ISBN) {
            $isbns = @()
            $isbns = $book.ISBN.Split(";") ;
            foreach ( $isbn  in $isbns) {
                $url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + $isbn
                $googleData = (irm -Uri $url)
                if ( $googleData.totalItems -gt 0){
                    $info = $googleData.items[0].volumeInfo
                    $info.title
                    if  ($info.imageLinks) {
                        $info.imageLinks
                        $tellerMet += 1
                    }    
                }
                $u = "http://covers.openlibrary.org/b/isbn/" + $isbn + "-L.jpg?default=false"
                $c = "ok"
                $res = try { (Invoke-RestMethod -Uri $u -ErrorAction Continue) } catch {$c = "Error "}
                if ( $c -eq "ok"){
                    "link found " + $u
                }
            }
        }
    
}

