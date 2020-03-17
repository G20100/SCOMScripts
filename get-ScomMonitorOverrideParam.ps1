param(
[Parameter(Mandatory=$true)]
[string]
$ScomManagementServer
)

function GetScomMonitorOverridenParams(
                                     [String] $MonitorName,
                                     [String] $MonitorDisplayName,
                                     [String] $MonitorTarget,
                                     [String] $MonitorConfig,
                                     [String] $MonitorOverridenParamaters
                                   ) {

    $Object = New-Object PSObject;
    $Object | Add-Member -MemberType NoteProperty -Name "MonitorName" $MonitorName;
    $Object | Add-Member -MemberType NoteProperty -Name "MonitorDisplayName" $MonitorDisplayName;
    $Object | Add-Member -MemberType NoteProperty -Name "MonitorTarget" $MonitorTarget;
    $Object | Add-Member -MemberType NoteProperty -Name "MonitorConfig" $MonitorConfig;
    $Object | Add-Member -MemberType NoteProperty -Name "MonitorOverridenParamater" $MonitorOverridenParamaters;

    return $Object
}

# module Load and Connection
import-module OperationsManager
New-SCOMManagementGroupConnection $ScomManagementServer

$ScomMonitors = Get-SCOMMonitor |? {$_.XmlTag -eq 'UnitMonitor'}

$ScomMonitorsOverRidenParams = @()

foreach ($ScomMonitor in $ScomMonitors)
{
    $ScomMonitorsOverRidenParams += GetScomMonitorOverridenParams $ScomMonitor.Name $ScomMonitor.DisplayName $ScomMonitor.Target.Identifier.Path $ScomMonitor.Configuration $ScomMonitor.GetOverrideableParameters().name;
}

$ScomMonitorsOverRidenParams

