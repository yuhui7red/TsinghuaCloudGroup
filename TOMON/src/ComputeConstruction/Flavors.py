import base64, urllib, httplib, json, os
from urlparse import urlparse

def ListFlavors(token, computeURL, tenantID):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(computeURL)
    conn.request("GET", "%s/flavors/detail" % tenantID, params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json

def GetFlavors(response_json):
    flavorTemplate = []
    for element in response_json['flavors']:
        flavorTemplate.append([element['name'], element['ram'], element['vcpus']])
    return flavorTemplate
