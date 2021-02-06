function Add-ControlVariables {	
New-Variable -Name 'MainWindow' -Value $window.FindName('MainWindow') -Scope 1 -Force
New-Variable -Name 'DataGrid1' -Value $window.FindName('DataGrid1') -Scope 1 -Force

}

[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

function Import-Xaml {
	[xml]$xaml = Get-Content -Path $PSScriptRoot\WpfWindow1.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xaml.SelectNodes("//*[@x:Name='MainWindow']", $manager)[0].RemoveAttribute('Loaded')
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}


function Set-EventHandler {
	$MainWindow.add_Loaded({
		param([System.Object]$sender,[System.Windows.RoutedEventArgs]$e)
		LoadedFunction($sender,$e)
	})
}


$window = Import-XamlAdd-ControlVariables
Set-EventHandler

function LoadedFunction
{
	param($sender, $e)
    $groups ='[{
        "Name":  "groepA",
        "Email":  "GroupA@domain.tld",
        "Type":  "Mailgroup",
        "Sync":  "False",
        "Members":  [
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        }
                    ]
    },
    {
        "Name":  "groepB",
        "Email":  "GroupA@domain.tld",
        "Type":  "Mailgroup",
        "Sync":  "True",
        "Members":  [
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        },
                        {
                            "DN":  "cn=de,ou=aa, dc=bb, dc=uu"
                        }
                    ]
    }]'
    $groups = ConvertFrom-Json $groups
    
   $DataGrid1.ItemsSource =$groups
     
    
}


$window.ShowDialog()