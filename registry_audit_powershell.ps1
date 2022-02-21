# This Line will automatically configure a Windows system's advanced audit policy of system object access to enable

auditpol /set /category:"System","Object Access" /success:enable /failure:enable > $null


# Code to set new ACL rule of registry
$RegPath = "\"
 Write-Host -n "RegPath: "  $RegPath
 echo ""

$LoggedOnUser = (Get-CimInstance -class Win32_ComputerSystem).username
 Write-Host -n "LoggedOnUser: "  $LoggedOnUser
 echo ""

$Username = ($LoggedOnUser -split '\\')[1]
 Write-Host -n "Username :"  $Username
 echo ""

$SID = ([System.Security.Principal.NTAccount]($LoggedOnUser)).Translate([System.Security.Principal.SecurityIdentifier]).Value
Write-Host -n "SID :"  $SID
echo ""

if (Test-Path Registry::HKEY_LOCAL_MACHINE\) {
  $UserReg = "Registry::HKEY_LOCAL_MACHINE"
   Write-Host -n "UserReg :"   $UserReg
   echo ""
}

else {
  REG LOAD "HKEY_LOCAL_MACHINE\" 
  $UserReg = "Registry::HKEY_LOCAL_MACHINE"
  Write-Host -n "UserReg :"  $UserReg
  echo ""
}

$acl = Get-ACL "$UserReg$RegPath" -Audit
Write-Host -n "acl :"  $acl
echo ""


$Identity         = "Everyone"
Write-Host -n "Identity :"  $Identity
echo ""
$Rights           = 'FullControl'
 Write-Host -n "Rights :"  $Rights
echo ""
$InheritanceFlags = "ContainerInherit"
 Write-Host -n "InheritanceFlags :"  $InheritanceFlags
echo ""
$PropogationFlags = "None"
 Write-Host -n "PropogationFlags :"  $PropogationFlags
echo ""
$AuditFlags       = "Success"
 Write-Host -n "AuditFlags :"  $AuditFlags
echo ""

$NewRule = [System.Security.AccessControl.RegistryAuditRule]::new($Identity,$Rights,$InheritanceFlags,$PropogationFlags,$AuditFlags)
 Write-Host -n "NewRule :"  $NewRule
echo ""

$ACL.SetAuditRule($NewRule)
 Write-Host -n "ACL :"  $SetAuditRule
echo ""
$ACL | Set-Acl "$UserReg$RegPath"
 Write-Host -n "ACL :"  $ACL
echo ""
