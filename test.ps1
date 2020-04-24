$bart = 123
$bart
$ll = Invoke-RestMethod -Uri "http://resolver.libis.be/l/ingests/5?token=CACHED&institution=VLP&from=0&step=1000"
ForEach ( $ii in $ll.body.records) { 
    if (-not($ii.acqDate -eq $NULL)){ 
        "item:/" + $ii.acqTag + "/" + $ii.acqDate + "/" + $ii.title
        $tags = $ii.acqTag.Replace("VLP",";").Split(";")
        $tttt = @()
        ForEach ($t in $tags)
        {
            if ( $t.Length -gt 0)
            {
                $first = $t.Substring(0,1)
                if ( $first -eq "R") 
                {
                     $tttt += $t.Substring(1)
                }
            }
        }
        $tttt
    } 
}