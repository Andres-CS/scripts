# -------------------- 
#   G VARIABLES 
# -------------------- 

$locationFolder = $env:HOMEPATH
$folderName = ".gotoCommand"
$fileName = "gotoConfig.json"
$helpFile = "gotoHelp.txt"
$configFlag = 0 

$gotoBlueprint = @{
    "1" = @{
        "name" = "aName"
        "path" = "/destination/path/1"
    }
    "2" = @{
        "name" = "aName"
        "path" = "/destination/path/2"
    }
}

# -------------------- 
#   FUNCTIONS Def
# -------------------- .

function greetingMsg {
    param(
        $msg
    )

    Write-Ascii -InputObject $msg
    Write-Host
    Write-Host " These are the following paths: "
    Write-Host -ForegroundColor "Magenta" " [Help H/h]" -NoNewline
    Write-Host -ForegroundColor "Blue" " [Add A/a]" 
    Write-Host
}

function Create-gotoInfo {
    param(
        $location,
        $type,
        $fileName
        )
    
    switch($type){
        "d" { 
            New-Item -ItemType "Directory" -Path $location -Name $fileName
            break
         }
         "f" {
            New-Item -ItemType "file" -Path $location -Name $fileName
            break
         }
    }
}

function callhelp {
    notepad ($locationFolder+"/"+$folderName+"/"+$helpFile)
}

function addingObjPath {
    param(
        $currentItem
    )
    $newObjPath = @{
        "name" = ""
        "path" = ""
    }

    $newObjPath["name"] = Read-Host "  Name"
    $newObjPath["path"] = Read-Host "  Path"

    $tmpKey = $currentItem.count + 1
    if ( ! ($currentItem.ContainsKey("$tmpKey"))){

        $currentItem.add("$tmpKey", $newObjPath)
    }

}

# -------------------- 
#   START SCRIPT 
# -------------------- 

#Check "goto" folder exisits
if ( Test-Path -Path ($locationFolder+"\"+$folderName)){
    #Check "config" file exisists
    if(Test-Path -Path ($locationFolder+"\"+$folderName+"\"+$fileName)){  }
    else{  $configFlag = 1  }
}
else{  $configFlag = 2  }

switch($configFlag){
    1 { 
        Write-Host " ** FILE CREATED ** "
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
    
    2 {
        Write-Host " ** FOLDER AND FILE CREATED ** "
        Create-gotoInfo -type "d" -location $locationFolder -fileName $folderName
        Copy-Item -Path $helpFile -Destination ($locationFolder+"\"+$folderName)
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
}

#Read gotoConfig file
$gotoData = Get-Content ($locationFolder+"\"+$folderName+"\"+$fileName) | ConvertFrom-Json -AsHashtable 


#Greeting message
greetingMsg -msg 'Go-To'

If ($gotoData.count -lt 1) {
    Write-Host "  No Active paths to follow"
    Write-Host "  Please go to " $locationFolder"\"$folderName"\"$fileName" and set up.`r"
    $rspn = Read-Host -Prompt "  Do you want to open the gotoConfig.json file [y/n]?"
    switch ($rspn) {
        "y" { 
                Write-Host -ForegroundColor "Yellow" "  Opening gotoConfig.json ... "
                $gotoBlueprint | ConvertTo-Json |  Out-File -FilePath ($locationFolder+"\"+$folderName+"\"+$fileName)
                start ($locationFolder+"\"+$folderName+"\"+$fileName)
                Write-host -ForegroundColor "Yellow" "  After setting up gotoConfig re-run goto."
                Write-host -ForegroundColor "Green" "  Script has exited."
                Write-host
                exit
            }
        Default { 
                Write-host -ForegroundColor "Green" "  Script has exited." 
                exit 
            }
        
    }
}

#Display Menu Path
foreach ($k in $gotoData.keys){
    Write-Host "  $k -> " $gotoData["$k"]["name"] "  " $gotoData["$k"]["path"]
}

#User choice
Write-host
$usrRsp = Read-host -Prompt "  Select a path [Command]"

switch($usrRsp){
    "a" {
        Write-Host -ForegroundColor "Yellow" "  Add Object ... "
        addingObjPath -currentItem $gotoData
        #Write updated HashTable back to config file.
        $gotoData | ConvertTo-Json | set-content -Path ($locationFolder+"\"+$folderName+"\"+$fileName)
        Write-Host -ForegroundColor "Yellow" "  Add Object ... "
        Write-host -ForegroundColor "Green" "  Script has exited."
    }
    "h" {
        Write-Host -ForegroundColor "Yellow" "  Help Menu ... "
        callhelp
        Write-host -ForegroundColor "Green" "  Script has exited."
    }
    Default{
        #cd to user choice
        foreach($p in $gotoData.keys){
            if ( $p -eq $usrRsp ){
                Write-host -ForegroundColor "Yellow" "  Heading over ... "
                cd $gotoData["$p"]["path"]
                exit
            }
        }

        #Wrong choice
        write-host -ForegroundColor "Red" "  Option '$usrRsp' not found."
        Write-host -ForegroundColor "Green" "  Script has exited." 
    }

}


