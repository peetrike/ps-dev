﻿$url = 'https://devblogs.microsoft.com/powershell/feed'

# show the Invoke-RestMethod output
$result = Invoke-RestMethod -Uri $url
$result.GetType()
$result | Get-Member

# Load the RSS xml from website
$Response = Invoke-WebRequest -Uri $url
$Response.Headers.'Content-Type'
$xml = [xml] ''
$xml.LoadXml($Response.Content)

# show the XmlDocument structure
$xml
$xml.rss
$xml.rss.channel
$xml.rss.channel | get-member Item
