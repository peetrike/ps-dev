$url = 'https://devblogs.microsoft.com/powershell/feed'

# Load the RSS xml from website
$Response = Invoke-WebRequest -Uri $url
$Response.Headers.'Content-Type'
$xml = [xml] ''
$xml.LoadXml($Response.Content)

# Display all the items from channel
$xml.rss.channel.item
$xml.SelectNodes('//item')

# Find the PowerShell team investments article
$xml.SelectNodes('//item/title')
$xml.SelectNodes('//item') | Where-Object title -Match 'investments'
$xml.SelectNodes('//item[contains(title, "investments")]')

# Find the creator of PowerShell team investments article
$query = '//item[contains(title, "investments")]'
$xml.SelectNodes($query).creator.InnerText

# find the creator using namespaces
$xml.rss
$manager = [Xml.XmlNamespaceManager]::new($xml.NameTable)
$manager.AddNamespace('dc', $xml.rss.dc)
$query = '//item[contains(title, "investments")]/dc:creator'
$xml.SelectNodes($query, $manager)
$xml.SelectNodes($query, $manager).InnerText
