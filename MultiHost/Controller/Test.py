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
from Routers import ListRouters, DeleteRouter, GetRoutersID
from Subnets import ListSubnets
from Servers import ListServers, DeleteServer
from Networks import ListNetworks

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
networkIP = apiToken.GetNetworkIP()
#computeIP = apiToken.GetComputeIP()
#tenantID = apiToken.GetTenantID()
#tenantID = tenantID[4:]

#data = ListRouters(token, networkIP)
data = ListNetworks(token, networkIP)
#data = ListServers(token, computeIP, tenantID)
#temp = data['servers'][0]['id']
#DeleteServers(token, computeIP, tenantID, temp)
#result = GetRoutersID(data, tenantID)

#for element in result:
#    os.system('../NetworksConstruction/RouterInterfaceDelete.sh ' + element)

#for element in result:
#    os.system('../NetworksConstruction/RouterGatewayClear.sh ' + element)

#data = ListSubnets(token, networkIP)

print data
