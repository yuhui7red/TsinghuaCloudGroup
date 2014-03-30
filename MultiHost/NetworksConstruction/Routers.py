import base64, urllib, httplib, json, os
from urlparse import urlparse

def ListRouters(token, networkURL):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(networkURL)
    conn.request("GET", "/v2.0/routers", params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json

def GetRoutersID(responseJson, tenantID):
    routersID = []
    for element in responseJson['routers']:
        if element['tenant_id'] == tenantID:
            routersID.append([element['id'], element['name']])
    routersID = sorted(routersID, key=lambda d:d[1])
    return routersID

def DeleteRouter(token, networkURL, tenantID, routerID):
    # nothing to do 
    return
    
def CreateRouters(token, networkURL, routerNumbers):
    for i in range(routerNumbers):
        name = 'router' + str(i + 1)
        params = '{"router": {"name":"%s", "admin_state_up":true}}' % name
        headers = {"X-Auth-Token":token, "Content-type":"application/json"}
        connection = httplib.HTTPConnection(networkURL)
        connection.request("POST", "/v2.0/routers", params, headers)
        response = connection.getresponse()
        response_data = response.read()
        response_json = json.loads(response_data)
        connection.close()

def SetRoutersGateway(token, networkURL, networkID, routerID):
    routerNumbers = len(routerID)
    for i in range(routerNumbers):
        params = '{"router":{"external_gateway_info":{"network_id":"%s"}}}' % networkID
        headers = {"X-Auth-Token":token, "Content-type":"application/json"}
        connection = httplib.HTTPConnection(networkURL)
        connection.request("PUT", "/v2.0/routers/%s" % routerID[i][0], params, headers)
        response = connection.getresponse()
        response_data = response.read()
        response_json = json.loads(response_data)
        connection.close()

def SetRoutersInterfaces(routerID, networkID):
    routerNumbers = len(routerID)
    for i in range(routerNumbers):
        command = 'neutron router-interface-add "%s" "%s"' %(routerID[i][0], networkID[i][2][0])
        print command
        os.system(command)


