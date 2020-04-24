$username="sa.automate@vlaamsparlement.be"
$password = "zqLtp9AL"
$siteUrl = "https://vlapa.sharepoint.com/sites/DemoSite"
$qry = "<View><Query><Where><Eq><FieldRef Name='IDLimo' /><Value Type='Text'>param</Value></Eq></Where></Query></View>"
$restUrl = "http://resolver.libis.be/l/ingests/day?token=CACHED&institution=VLP&from=0&step=99999"
$encpassword = convertto-securestring -String $password -AsPlainText -Force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $encpassword
connect-PnPOnline -url $siteUrl -Credentials $cred



for ($day=1 ; $day -lt 6 ; $day++) {

$restData = Invoke-RestMethod -Uri $restUrl.Replace('day',$day)

ForEach ( $it in $restData.body.records) { 
    if (-not($it.acqDate -eq $NULL)){

        if ( $it.title.GetType().fullname -eq 'System.Object[]' ) { $Title = $it.title[0]} else {$Title = $it.title}
        
        $TypePublication = $it.type
        $BackLink = $it.backlink
        
        $IDLimo = $it.id
        $ISBN = ""

        foreach ( $i in $it.identifiers){
            foreach ($ii in $i.ISBN){
                if ( $ISBN.Length -gt 0 ) { $ISBN += ";"}
                $ISBN += $ii.Replace('-','')
            }
        }

        $acqDateField = $it.acqDate
        $acqDate = ""
        if ( -not( $acqDateField -eq $NULL)) {
            $acqDateParts = $acqDateField.Replace('VLP',';').Split(';')
            foreach ( $acqDatePart in $acqDateParts){
                if ( $acqDatePart.Substring(0,1) -eq "2") { $acqDate = $acqDatePart}
            }
        }

        $acqTagRecords = $it.acqTag
        $acqTag = @()
        foreach ( $acqTagRecord in $acqTagRecords){
            $acqTagParts = $acqTagRecord.Replace('VLP',';').Split(';')
            foreach ($acqTagPart in $acqTagParts){
                if ( $acqTagPart.length -gt 0) {
                    if ( $acqTagPart.substring(0,1) -eq 'R'){
                        $acqTag += $acqTagPart.Substring(1)
                    }
                }
            }
            
        }

        $query = $qry.Replace('param',$IDLimo)

        $exRecord = (Get-PnPListItem -List Aanwinsten -Query $query ).FieldValues

        if (-not($exRecord -eq $NULL)){
            Set-PnPListItem -List "Aanwinsten" -Identity $exRecord.ID -Values @{'Title' = $Title;'TypePublication' = $TypePublication; 'Link' = $BackLink ; 'acqDate' = $acqDate; 'Tag' = $acqTag ; 'ISBN' =$ISBN }
        }
        else {
            Add-PnPListItem -List "Aanwinsten" -ContentType Item -values @{'Title' = $Title; 'TypePublication' = $TypePublication; 'Link' = $BackLink;'IDLimo'=$IDLimo ; 'acqDate' = $acqDate;  'Tag' = $acqTag ; 'ISBN' =$ISBN } 
        }

    }
}

}