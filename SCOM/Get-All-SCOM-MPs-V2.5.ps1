﻿#############################################################################################################################################################################
# Version 1.0:                                                                                                                                                              #
# Get list of all Management packs and their links from Technet Wiki                                                                                                        #
# Thanks to Stefan Stranger http://blogs.technet.com/b/stefan_stranger/archive/2013/03/13/finding-management-packs-from-microsoft-download-website-using-powershell.aspx    #
#############################################################################################################################################################################

#############################################################################################################################################################################
# Version 2.0 Changes:                                                                                                                                                      #
# - Microsoft change the layout of the MP download pages so the script was changed to get data from the new layout                                                          #
#############################################################################################################################################################################

#############################################################################################################################################################################
# Version 2.1 Changes:                                                                                                                                                      #
# modifications contributed by Anthony Bailey:                                                                                                                              #
# - checks if MP is already downloaded                                                                                                                                      #
# - writes a success log in a file                                                                                                                                          #
# - you can set the script to run as a scheduled task and SCOM can monitor the log file and alert you if new MP version is downloaded.                                      #
#############################################################################################################################################################################

#############################################################################################################################################################################
# Version 2.2 Changes:                                                                                                                                                      #
# - Microsoft has made some changes to the code of the download pages again so the script was not able to get the version of the MP. Made changes to work with the new code #
# - The script now checks if MP web pages is invoked successfully                                                                                                           #
# - If MP Page is not invoked successfully error appears. Error is also written in a Error Log.                                                                             #
# - Improvements on check if MP is already downloaded                                                                                                                       #
# - MP download links are displayed on separate lines                                                                                                                       #
# - Changes section was made more readable format                                                                                                                           #
#############################################################################################################################################################################

#############################################################################################################################################################################
# Version 2.3 Changes:                                                                                                                                                      #
# modifications contributed by Anthony Bailey:                                                                                                                              #
# - Improvements on getting the confirmation link for each MP.                                                                                                              #
# - The script now also grabs the date the MP was added to Microsoft's catalog and adds this to the logs/screen output                                                      #
# - Any duplicate download links are removed before downloading as some download pages have duplicate files in the html                                                     #
# - Improvements on check if MP is already downloaded                                                                                                                       #
#############################################################################################################################################################################
#############################################################################################################################################################################
# Version 2.4 Changes:                                                                                                                                                      #
# - Removed -and ($_.InnerHTML -like "*This link*") as some people experienced errors                                                                                       #
#############################################################################################################################################################################
#############################################################################################################################################################################
# Version 2.5 Changes:                                                                                                                                                      #
# - Using invoke-webrequest was causing cookie prompt dialog to appear due to changes on Microsoft download pages. Replaced it with .net framework function. Thanks to my   # 
#   co-worker Georgi Ivanov for helping me in this                                                                                                                          #
# - Replaced Write-Host with Write-Output. Accodring to Jeffrey Snover and Don Jones a puppy dies every time someone is using Write-Host :)                                 #
# - Added additional logic to check every file if exists not only the version folder                                                                                        #
# - MP version, Published date and download links are now being get by different way as invoke-webrequest is not used                                                       #
#############################################################################################################################################################################

$allmpspage = Invoke-WebRequest -Uri "http://social.technet.microsoft.com/wiki/contents/articles/16174.microsoft-management-packs.aspx"
$mpslist = $allmpspage.Links | Where-Object {($_.href -like "*http://www.microsoft.com/*download*") -and ($_.outerText -notlike "*Link to download page*") } | 
Select @{Label="Management Pack";Expression={$_.InnerText}}, @{Label="Download Link";Expression={$_.href}}

#Directory to save the downloaded management packs. Make sure it is created first before running the script
$dirmp = "C:\etc\MPs\"
$MPLogfile = "MPUpdates.log"
$MPErrorLogfile = "MPErrorLog.log"
$Date = Get-Date -format MM-dd-yy

#go though every MP
foreach ($mp in $mpslist)
{
#get MP link and transpose the confirmation link
$mppagelink = $mp.'Download Link'
$conflink = $mppagelink -replace "details","confirmation"

#get MP name
$mpname = $mp.'Management Pack'
Write-Output "MP Name: $mpname"
Write-Output "MP Link: $mppagelink"
Write-Output "Confirmation Link: $conflink"
Try {
#Read MP page 
#$mppage = Invoke-WebRequest -Uri "$mppagelink"


#Find the version number and release date of the MP on its page
#$mpinfo = $mppage.ParsedHtml.getElementsByTagName("p") | Select -ExpandProperty innerText -First 2
#$version = $mpinfo[0]
#$mpdate = $mpinfo[-1]

$request = [System.Net.httpWebRequest]::Create($mppagelink)

$response = $request.GetResponse()
$responseStream = $response.GetResponseStream()
$responseStreanData = New-Object -TypeName System.IO.StreamReader -ArgumentList $responseStream
$responseData = $responseStreanData.ReadToEnd()

if ($responseData -match 'Version:</span></div><p>(.+?)</p></div>')
{
    $version=$matches[1]
}


if ($responseData -match 'Date Published:</span></div><p>(.+?)</p></div>')
{
    $mpdate=$matches[1]
}


#Remove character ? in front of MP version and trim any trailing spaces left over.
$version = $version.Replace("?","").Trimend()

#Replace character / in date variable to - character.
$mpdate = $mpdate.Replace("/","-").Trimend()

#Read Confirmation page 
#$realdws = Invoke-WebRequest -Uri "$conflink" -UseBasicParsing


#Find download links for MP and Guide (If applicable as not all MPs have a guide) Also remove any duplicate download links.
#$realdws = $realdws.Links | Where-Object {($_.'href' -like "http://download.microsoft.com/download*") } | Select @{Label="Download Link";Expression={$_.'href'}} |  Get-Unique -AsString
$request1 = [System.Net.httpWebRequest]::Create($conflink)

$response1 = $request1.GetResponse()
$responseStream1 = $response1.GetResponseStream()
$responseStreanData1 = New-Object -TypeName System.IO.StreamReader -ArgumentList $responseStream1
$responseData1 = $responseStreanData1.ReadToEnd()
$myarray=@()
$myarray = $responseData1 | % { [regex]::matches( $_ , '{url:"(.+?)",id') } | select -expa value
$realdws=@()

foreach ($arr in $myarray)
{
$arr=$arr.Replace('{url:"',"").Trimend()
$arr=$arr.Replace('",id',"").Trimend()
$realdws+=$arr

}



#Remove / character from MP name if contains it beacuse can create unneeded directories
$mpname = $mpname.Replace("/"," ").Trimend()

Write-Output "MP Version: $version"
Write-Output "MP Release Date: $mpdate"
Write-Output "Download Links:" 
foreach ($dw1 in $realdws)
{
Write-Output "$dw1"
}



#Check if the folder Exists and if it is empty
if (Test-Path -path "$dirmp\$mpname\$version\*.*") {
 
} Else
{
#Create directory with the Name of the MP and subdirecotory with the version of the MP
New-Item -ItemType directory -Path $dirmp\$mpname\$version -force
}
#Get the array of found download links
#$realdws = $realdws.'Download Link'

#Get through every download link
foreach ($dw in $realdws)
{

#assign download link to $source variable
$source = $dw

#Get the name of the file that will be downloaded
$Filename = [System.IO.Path]::GetFileName($source)

if (Test-Path -path "$dirmp\$mpname\$version\$Filename") {
Write-Output "File: $Filename already exists"
}
else {
#Set directory where the file to be downloaded
$dest = "$dirmp\$mpname\$version\$Filename"

#initiate client for download
$wc = New-Object System.Net.WebClient

#download the file and put it in the destination directory
Write-Output  "Downloading - $Filename ..." 
$wc.DownloadFile($source, $dest)
Write-Output "Success." 

#Append Logfile with download date and file
"Success,$Date,$mpname,$version,$Filename,$mpdate" |Out-File "$dirmp\$MPLogfile" -Append
}
}
#empy line
Write-Output ""
Write-Output ""
Write-Output  "------------------------------------------------------------------------------------------------------" 
Write-Output ""
Write-Output ""
}
Catch {
Write-Output  "Cannot Invoke MP $mpname Web page"
Write-Output ""
Write-Output ""
Write-Output "------------------------------------------------------------------------------------------------------" 
Write-Output ""
Write-Output ""
#Append MPErrorlog with the MP page that failed during invoking
"Failure,$Date,$mpname" |Out-File "$dirmp\$MPErrorLogfile" -Append
}
}