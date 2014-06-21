import base64, urllib, httplib, json, os, string
from urlparse import urlparse

def ListSubnets(token, networkURL):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(networkURL)
    conn.request("GET", "/v2.0/subnets", params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json

def CreateSubnets(token, networkURL, networksID):
    subnetNumbers = len(networksID)
    dns1 = '166.111.8.29'
    dns2 = '8.8.8.8'
    for i in range(subnetNumbers):
        ip = '192.168.%s.0/24' % str(i+20)
        command = 'neutron subnet-create --dns-nameserver "%s" "%s" "%s"' % (dns1, networksID[i][0], ip)
        os.system(command)
        

    
