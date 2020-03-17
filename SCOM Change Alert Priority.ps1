Import-Module -Name "OperationsManager" 
New-SCManagementGroupConnection -ComputerName "scom12jpn-ms1"

$AlertCsvFile = "C:\scripts\alertcsvfile.csv"
$ManagementPackName = "test.override.mp"

$monitors = Get-SCOMMonitor |Where-Object {$_.alertsettings -ne $null}
#$monitors
#$Rules = get-scomrule | Where-Object {$_.WriteActionCollection.Name -eq "GenerateAlert"}

$AlertList = Import-Csv $AlertCsvFile
$AlertListCount = ($AlertList | Measure-Object).count
#$AlertList

$MP = Get-SCOMManagementPack -name $ManagementPackName
#$MP

for($i = 0; $i -lt $AlertListCount ; $i++){
#    Write-Output "Forin"
    $AlertName = $AlertList[$i].AlertName.Tostring()
    $AlertName
    $MonitorTemp = $monitors | ? {$_.AlertSettings.AlertMessage.getElement().Displayname -eq "$AlertName"}
#    $Monitor = $MonitorTemp[0]


    if ($Monitor.AlertSettings.AlertPriority -eq "Normal")
    {
    foreach ($Monitor in $MonitorTemp)
    {
    $MonitorName = $Monitor.Name
#    Write-Output "IfIn"
    $Class = Get-ScomClass -id $Monitor.Target.id
    $OverrideName = "OV_" + $MonitorName
    $MonitorOverride = New-Object Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitorPropertyOverride($MP, $OverrideName)
    $MonitorOverride.Monitor = $Monitor
    $MonitorOverride.Property = "AlertPriority"
    $MonitorOverride.Value = "High"
    $MonitorOverride.Context = $Class
    }
    }
}

$MP.Verify()
$MP.AcceptChanges()

Get-SCOMOverride |? {$_.name -like "OV_*"}
