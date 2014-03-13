import os, base64, urllib, httplib, json

def Authenticate(controller_ip, tenantName, userName, password):
    url = controller_ip + ':35357'
    params = '{"auth": {"tenantName": "%s", "passwordCredentials":{"username": "%s", "password": "%s"}}}' %(tenantName, userName, password)
    headers = {"Content-Type": 'application/json'}
    connection = httplib.HTTPConnection(url)
    connection.request("POST", "/v2.0/tokens", params, headers)
    response = connection.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    connection.close() 
    return response_json



