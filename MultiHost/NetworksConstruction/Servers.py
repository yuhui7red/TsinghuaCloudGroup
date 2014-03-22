import base64, urllib, httplib, json, os
from urlparse import urlparse

def ListServers(token, computeURL):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(computeURL)
    conn.request("GET", "/Servers/detail", params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(reponse_data)
    conn.close()
    return response_json
