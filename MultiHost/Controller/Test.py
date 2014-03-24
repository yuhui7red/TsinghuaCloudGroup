import sys;
if not "../Controller/" in sys.path:
    sys.path.append("../Controller/")
if not "../ComputeConstruction/" in sys.path:
    sys.path.append("../ComputeConstruction")
if not "../NetworksConstruction/" in sys.path:
    sys.path.append("../NetworksConstruction/")

import os, urllib, httplib, json, base64
from urlparse import urlparse
from APIToken import APIToken
from Authentication import Authenticate
from Flavors import ListFlavors, GetFlavors
from Routers import ListRouters
from Servers import ListServers, DeleteServers

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
#networkIP = apiToken.GetNetworkIP()
computeIP = apiToken.GetComputeIP()
tenantID = apiToken.GetTenantID()

#data = ListRouters(token, networkIP)
#data = ListNetworks(token, networkIP)
data = ListServers(token, computeIP, tenantID)
temp = data['servers'][0]['id']
DeleteServers(token, computeIP, tenantID, temp)

