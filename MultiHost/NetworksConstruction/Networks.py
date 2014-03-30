import base64, urllib, httplib, json, os
from urlparse import urlparse

def ListNetworks(token, networkURL):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(networkURL)
    conn.request("GET", "/v2.0/networks", params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json

def CreateNetworks(token, networkURL, networkNumbers):
    for i in range(networkNumbers):
        name = 'network' + str(i + 1)
        params = '{"network": {"name":"%s", "admin_state_up":true}}' % name
        headers = {"X-Auth-Token":token, "Content-type":"application/json"}
        connection = httplib.HTTPConnection(networkURL)
        connection.request("POST", "/v2.0/networks", params, headers)
        response = connection.getresponse()
        response_data = response.read()
        response_json = json.loads(response_data)
        connection.close()

def GetNetworksID(responseJson, tenantID):
    networksID = []
    for element in responseJson['networks']:
        if element['tenant_id'] == tenantID and element['name'][0:7] == 'network':
            networksID.append([element['id'], element['name'], element['subnets']])
    networksID = sorted(networksID, key=lambda d:d[1])
    return networksID

