import os, base64, urllib, httplib, json
from urlparse import urlparse

def Authenticate(controller_ip, tenantname, userName, password):
    url = controller_ip + ':35357'
    params = '{"auth": {"tenantname": "' +  tenantname + '", "passwordCredentials":{"username": "' + userName + '", "password": "' + password + '"}}}'
    headers = {"Content-Type": 'application/json'}
    connection = httplib.HTTPConnection(url)
    connection.request("POST", "/v2.0/tokens", params, headers)
    response = connection.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    connection.close()
    
    token = response_json['access']['token']['id']
    apiurlt = urlparse(response_json['access']['serviceCatalog'][1]['endpoints'][0]['publicURL'])
   # print token
    print token
    print apiurlt

'''    url2 = url
    params2 = urllib.urlencode({})
    headers2 = {"X-Auth-Token": token, "Content-Type": 'application/json'}
    conn2 = httplib.HTTPConnection(url2)
    conn2.request("GET", "/v2.0/networks", params2, headers2)
    response2 = conn2.getresponse()
    data2 = response2.read()
    print data2
    dd2 = json.loads(data2)
    print dd2
    conn2.close()'''

    #return dd2

Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')


