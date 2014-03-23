import base64, urllib, httplib, json, os
from urlparse import urlparse

def ListServers(token, computeURL, tenantID):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(computeURL)
    conn.request("GET", "%s/servers" % tenantID, params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json
