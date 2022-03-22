
function ProcessFolderContents($path) {
    $rootContent = Get-RsFolderContent -RsFolder $path
    
    foreach ($content in $rootContent) {
      "Processing " + $content.Name + "..."
      if ($content.TypeName -eq "Folder") {
        ProcessFolderContents -path $content.Path
      }

      elseif ($content.TypeName -eq "Report") {
        Get-RsSubscription -Proxy $proxy -RsItem $content.Path | Export-RsSubscriptionXml "$($env:USERPROFILE)\Desktop\$($content.Name)_Subscriptions.xml"
      }
    }
}

$sourceRsUri = 'http://Reporting/ReportServer/ReportService2010.asmx?wsdl'
$proxy = New-RsWebServiceProxy -ReportServerUri $sourceRsUri
ProcessFolderContents -path "/Reports"
