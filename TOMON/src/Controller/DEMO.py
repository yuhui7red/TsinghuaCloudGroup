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
from Routers import ListRouters, DeleteRouter, GetRoutersID, CreateRouters, SetRoutersGateway, SetRoutersInterfaces
from Subnets import ListSubnets, CreateSubnets
from Servers import ListServers, DeleteServer
from Networks import ListNetworks, CreateNetworks, GetNetworksID
from L3Agent import GetL3AgentID, GetL3AgentPosition, RemoveRouterFromL3Agent, ScheduleRouterToL3Agent
from VM	import CreateVM

routerNumbers = 4
routerPositions = ['cernet52', 'cernet53', 'cernet55', 'cernet58']
vm = (2, 1, 2, 2, 1, 1, 2, 1)
relations = ['router1', 'router1', 'router1', 'router2', 'router2', 'router3', 'router3', 'router3', 'router3', 'router4', 'router4', 'router4',]
vmPosition = ['cernet51', 'cernet51', 'cernet52', 'cernet53', 'cernet53', 'cernet54', 'cernet54', 'cernet55', 'cernet56', 'cernet57', 'cernet57', 'cernet57']

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
networkURL = apiToken.GetNetworkIP()
tenantID = apiToken.GetTenantID()
tenantID = tenantID[4:]

# create the routers
CreateRouters(token, networkURL, routerNumbers)
# schedule router to l3 agent
responseRouter = ListRouters(token, networkURL)
routersID = GetRoutersID(responseRouter, tenantID)
l3Position = GetL3AgentPosition('166.111.143.250', 'root', 'cer.cloud', 'neutron')
j = 0
for i in range(len(l3Position)):
    if j == len(routersID):
        break
    if routerPositions[j] == l3Position[i][1]:
        ScheduleRouterToL3Agent(routersID[j][0], l3Position[i][0])
        j = j + 1

# set the gateway
SetRoutersGateway(token, networkURL, '9ba6e69f-9b97-47b4-8268-9f98769627b4', routersID)

# create the net
networkNumbers = routerNumbers
CreateNetworks(token, networkURL, networkNumbers)
responseNetwork = ListNetworks(token, networkURL)
networksID = GetNetworksID(responseNetwork, tenantID)
CreateSubnets(token, networkURL, networksID)

# set the interface
responseNetwork = ListNetworks(token, networkURL)
networksID = GetNetworksID(responseNetwork, tenantID)
SetRoutersInterfaces(routersID, networksID)

# create the virtual machine
vmSum = sum(vm)
for i in range(vmSum):
    netIndex = int(relations[i][6:]) - 1
    netID = networksID[netIndex][0]
    availabilityZone = vmPosition[i]
    if i == 0:
        name = 'master'
    else:
        name = 'slave%s' %i
    CreateVM('1', '668bbb0c-36e6-46aa-a79a-6ed52a6569a9', availabilityZone, netID, name)



