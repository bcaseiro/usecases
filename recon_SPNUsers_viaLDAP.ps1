## Caso 1 - Identificar queries LDAP buscando por contas de serviço
## Countermeasure - Identificar host de origem e a conta de serviço utilizado. 

#Build LDAP filter to look for users with SPN values registered for current domain
$ldapFilter = "(&(objectClass=user)(objectCategory=user)(servicePrincipalName=*))"
$domain = New-Object System.DirectoryServices.DirectoryEntry
$search = New-Object System.DirectoryServices.DirectorySearcher
$search.SearchRoot = $domain
$search.PageSize = 1000
$search.Filter = $ldapFilter
$search.SearchScope = "Subtree"
#Execute Search
$results = $search.FindAll()
#Display SPN values from the returned objects
$Results = foreach ($result in $results)
{
	$result_entry = $result.GetDirectoryEntry()
 
	$result_entry | Select-Object @{
		Name = "Username";  Expression = { $_.sAMAccountName }
	}, @{
		Name = "SPN"; Expression = { $_.servicePrincipalName | Select-Object -First 1 }
	}
}
 
$Results
