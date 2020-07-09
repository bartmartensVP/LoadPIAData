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
    $isbns = $book.item('ISBN')
    if ( -not ( $isbns -eq $NULL  )) {
            $isbn = $isbns.Split(';')

            ForEach ( $i in $isbn) {
                #$i
                $url = "https://www.googleapis.com/books/v1/volumes?q=" + $i + "&maxResults=20"
                $res = (irm $url) 
                if ( $res.totalItems -eq 1){
                    $detail = ( irm $res.items[0].selfLink)
                    #$detail.volumeInfo.imageLinks.Large
                    if (-not ($detail.volumeInfo.imageLinks.large -eq $NULL))
                        {
                            $cover = $detail.volumeInfo.imageLinks.large
                            $endOfUrl = $cover.IndexOf("&printsec")
                            $cover = $cover.Substring(0,$endOfUrl) + "&printsec=frontcover&img=1&zoom=4"
                            Set-PnPListItem -List "Aanwinsten" -Identity $book.Item('ID') -Values @{ 'Cover' = $cover  }
                        }
                }
                #$res.totalItems
            }
        }
    }




