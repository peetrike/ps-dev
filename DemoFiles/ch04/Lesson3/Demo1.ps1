# Use the sample REST API at
# https://petstore.swagger.io/

# show the documentation page and the _Try it out_ button

# Get the list of Pets
$Url = 'https://petstore.swagger.io/v2/pet/findByStatus?status=available'
Invoke-RestMethod -Uri $Url

# Show that response is in JSON format
$result = Invoke-WebRequest -Uri $url
$result.Content
$result.Headers.'Content-Type'

# Get the specific pet from the list
$Url = 'https://petstore.swagger.io/v2/pet/1'
Invoke-RestMethod -Uri $Url


# add api key to request
$header = @{
    'api_key' = 'special-key'
}
Invoke-RestMethod -Uri $Url -Headers $header

# get the result in XML format
$header['Accept'] = 'application/xml'
$result = Invoke-RestMethod -Uri $Url -Headers $header
$result.Pet
$result.GetType()
$result | Get-Member
$result.InnerXml

# Post an order to the store
$Url = 'https://petstore.swagger.io/v2/store/order'
$orderId = 101
$body = @{
    id       = $orderId
    petId    = 1
    quantity = 3
    shipDate = [datetime]::Now.AddHours(5)
    status   = 'placed'
    complete = $false
} | ConvertTo-Json
Invoke-RestMethod -Uri $Url -Method Post -Body $body -ContentType 'application/json'

# Get the order
$Url = "https://petstore.swagger.io/v2/store/order/$orderId"
Invoke-RestMethod -Uri $Url

# Delete the order
Invoke-RestMethod -Uri $Url -Method Delete
