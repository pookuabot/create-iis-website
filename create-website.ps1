#################
### Variables ###
#################

# Used to run the IIS Console within PowerShell
set-alias iis_console "$env:windir\System32\inetsrv\appcmd.exe"
$iisdir = "F:\websites"

# Give the newly site you create a name
$sitename = Read-Host "What is the Domain (i.e. test.local)? "

# Places the newly created sites directory
# in the IIS web directory
$newsite = "$iisdir\$sitename"

# Default website location
$defaultsite = "$iisdir\Default_Web_Site"

$createcomplete = "Setup is complete.  $sitename is now ready."

######################################
### Create Website and Quota Limit ###
######################################

# Creates a new website, adds port 80, and
# sets the physical path in IIS
iis_console add site /site.name:"$sitename" /bindings:"http/*:80:$sitename" /physicalPath:"$newsite"

# Creates the new website directory
New-Item -ItemType directory -Path $newsite

# This copies everything from the default website over
# to the newly created website until the real content
# is uploaded
Get-Childitem "$defaultsite" -recurse -filter "*" | Copy-Item -Destination "$newsite"

############################
### Add Quota to Website ###
############################

function Show-Menu
{
     param (
           [string]$Title = 'Add Website Quota Limit'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' to set the Quota to 100MB"
     Write-Host "2: Press '2' to set the Quota to 200MB"
     Write-Host "3: Press '3' to set the Quota to 300MB"
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                Dirquota Quota Add /Path:$newsite /SourceTemplate:"100MB Web Space"
           }
           '2' {
                Dirquota Quota Add /Path:$newsite /SourceTemplate:"200MB Web Space"
           }
           '3' {
                Dirquota Quota Add /Path:$newsite /SourceTemplate:"300MB Web Space"
           }
     }
     pause
}
until ($input)

##########################
### Website Completion ###
##########################

Write-output `n `n
$createcomplete