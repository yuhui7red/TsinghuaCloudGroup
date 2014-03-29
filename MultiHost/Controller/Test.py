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
from Routers import ListRouters, DeleteRouter, GetRoutersID, CreateRouters, SetRoutersGateway
from Subnets import ListSubnets, CreateSubnets
from Servers import ListServers, DeleteServer
from Networks import ListNetworks, CreateNetworks, GetNetworksID
from L3Agent import GetL3AgentID, GetL3AgentPosition, RemoveRouterFromL3Agent

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
networkURL = apiToken.GetNetworkIP()
#computeIP = apiToken.GetComputeIP()
tenantID = apiToken.GetTenantID()
tenantID = tenantID[4:]

#data = ListRouters(token, networkURL)
data = ListNetworks(token, networkURL)
#data = ListServers(token, computeIP, tenantID)
#temp = data['servers'][0]['id']
#DeleteServers(token, computeIP, tenantID, temp)
#result = GetRoutersID(data, tenantID)
#CreateRouters(token, networkIP, '9ba6e69f-9b97-47b4-8268-9f98769627b4', 3)
#SetRoutersGateway(token, networkURL, '9ba6e69f-9b97-47b4-8268-9f98769627b4', result) 
#CreateNetworks(token, networkURL, 3)
#data = GetL3AgentID(token, networkURL, result[0])
#networksID = GetNetworksID(data, tenantID)
#result = CreateSubnets(token, networkURL, networksID)
#for element in result:
#    os.system('../NetworksConstruction/RouterInterfaceDelete.sh ' + element)
#agentPosition = GetL3AgentPosition('166.111.143.250', 'root', 'cer.cloud', 'neutron')

#for element in result:
#    os.system('../NetworksConstruction/RouterGatewayClear.sh ' + element)

#data = ListSubnets(token, networkIP)
#print agentPosition
print data
