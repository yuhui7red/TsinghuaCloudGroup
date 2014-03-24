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
from Flavors import ListFlavors
from Routers import ListRouters
from Servers import ListServers

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
#networkIP = apiToken.GetNetworkIP()
computeIP = apiToken.GetComputeIP()
print computeIP
tenantID = apiToken.GetTenantID()
print tenantID	

#data = ListRouters(token, networkIP)
#data = ListNetworks(token, networkIP)
data = ListFlavors(token, computeIP, tenantID)

print data

