import sys;
if not "../Controller/" in sys.path:
    sys.path.append("../Controller/")
if not "../NetworksConstruction/" in sys.path:
    sys.path.append("../NetworksConstruction/")
if not "../ComputeConstruction/" in sys.path:
    sys.path.append("../ComputeConstruction/")
if not "../Evaluation/" in sys.path:
    sys.path.append("../Evaluation/")
if not "../DeployStrategy/" in sys.path:
    sys.path.append("../DeployStrategy")
if not "../AssignStrategy/" in sys.path:
    sys.path.append("../AssignStrategy/")

import os, urllib, httplib, json, base64, string
from urlparse import urlparse
from APIToken import APIToken
from Authentication import Authenticate
from ComputeNodes import GetComputeNodesInfo
from VMCapabilityEvaluation import VMCapabilityEvaluation
from Flavors import ListFlavors, GetFlavors
from Optimal import GetOptimalAgentNumber, GetOptimalNa
from NewKnapsack import NewKnapsack
from LoadBalancing import LoadBalancing
from Routers import ListRouters, DeleteRouter, GetRoutersID, CreateRouters, SetRoutersGateway, SetRoutersInterfaces
from Subnets import ListSubnets, CreateSubnets
from Servers import ListServers
from Networks import ListNetworks, CreateNetworks, GetNetworksID
from L3Agent import GetL3AgentID, GetL3AgentPosition, RemoveRouterFromL3Agent, ScheduleRouterToL3Agent
from VM import CreateVM

print '''Welcome to the Tomon[version: 1.0.0].

Copyright (c) 2014, TsinghuaCloud and/or its affiliates. All rights reserved.
'''

controllerIP = raw_input('controller ip address: ')
userName = raw_input('username: ')
tenantName = raw_input('tenant name: ')
HorizonPW = raw_input('dashboard password: ')
mysqlPW = raw_input('mysql password: ')

#authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
authentication = Authenticate(controllerIP, userName, tenantName, HorizonPW)
apiToken = APIToken()
apiToken._authentication = authentication
token = apiToken.GetToken()
computeIP = apiToken.GetComputeIP()
tenantID = apiToken.GetTenantID()

#computeNodesInfo = GetComputeNodesInfo('166.111.143.250', 'root', 'cer.cloud', 'nova')
computeNodesInfo = GetComputeNodesInfo(controllerIP, 'root', mysqlPW, 'nova')
serverNumber = len(computeNodesInfo)
serverInfo = [[0 for i in range(4)] for i in range(serverNumber)]

flavorJson = ListFlavors(token, computeIP, tenantID)
flavorTemplate =  GetFlavors(flavorJson)
#flavorCPU = raw_input('flavor cpu number: ')
#flavorMem = raw_input('flavor memory size: ')
flavor = (1, 512)
#flavor = (flavorCPU, flavorMem)
for i in range(len(computeNodesInfo)):
    serverInfo[i][0] = computeNodesInfo[i][0]
    serverInfo[i][2] = int(min(computeNodesInfo[i][1]/flavor[0], computeNodesInfo[i][2]/flavor[1]))

vm = []
for i in range(len(computeNodesInfo)):
    temp = int(raw_input("vm number in server %s[At most %s]: " %(i+1, serverInfo[i][2])))
    if temp > serverInfo[i][2]:
        vm.append(serverInfo[i][2])
    else:
        vm.append(temp)
print vm

#vm = (6, 3, 2, 7, 6, 1, 4, 3)
vmNumber = sum(vm)
for i in range(len(vm)):
    serverInfo[i][1] = vm[i]

vmInfo = [[0 for i in range(4)] for i in range(vmNumber)]
VMCount = 1
for i in range(serverNumber):
    for r in range(vm[i]):
        vmInfo[VMCount-1][0] = VMCount
        vmInfo[VMCount-1][1] = serverInfo[i][0]
        vmInfo[VMCount-1][2] = VMCapabilityEvaluation(serverInfo[i][2], 1.634394, serverInfo[i][1])
        VMCount = VMCount + 1

S = float(raw_input('data size: '))
nr = int(raw_input('reduce vm number: '))
Sr = float(raw_input('reduce data size: '))
u0 = 1.634394
r = 0.855
B = float(raw_input('the network transmission rate: '))

# get the optimal agent number
k = GetOptimalAgentNumber(vmNumber, S, nr, Sr, u0, r, B)
Na = GetOptimalNa(vmNumber, S, nr, Sr, u0, r, B, k)

print k, Na

if k < 0:
    k = 1
elif k > serverNumber:
    k = serverNumber
if Na < 0:
    Na = min(vm)
elif Na > vmNumber:
    Na = vmNumber

print k, Na

# get the optimal agent position
position = NewKnapsack(vm, k, Na)
routerPositions = []
i = 1
for element in position:
    serverInfo[element-1][3] = 'router' + str(i)
    i = i + 1
    routerPositions.append(serverInfo[element-1][0])

routerPositions.sort()

vmInfo = sorted(vmInfo, key=lambda d:d[1])

agentServerInfo = []
for element in serverInfo:
    if element[3] != 0:
        agentServerInfo.append(element)

agentServerInfo = sorted(agentServerInfo, key=lambda d:d[0])

i = 0
for j in range(len(vmInfo)):
    if i == len(agentServerInfo):
        break
    if vmInfo[j][1] == agentServerInfo[i][0]:
        vmInfo[j][3] = agentServerInfo[i][3]
        if j != len(vmInfo) - 1 and vmInfo[j+1][1] > agentServerInfo[i][0]:
            i = i + 1

decreaseRate = 0.855
restVM = []
for element in vmInfo:
    if element[3] != 0:
        element[2] = element[2] * decreaseRate
    else:
        restVM.append([element[0], element[2]])

# get the optimal relationship between vm and agent
mapping = LoadBalancing(restVM, k)

vmInfo = sorted(vmInfo, key=lambda d:d[0])

i = 0
for element in vmInfo:
    if i == len(mapping):
        break
    if mapping[i][0] == element[0]:
        element[3] = 'router' + str(mapping[i][1])
        i = i + 1

routerNumbers = k
for elem in vmInfo:
    print elem
relations = []
vmPosition = []

for element in vmInfo:
    relations.append(element[3])
    vmPosition.append(element[1])

print 'optimal agent number: %s' % routerNumbers
print 'optimal agent Positions: \n %s' % routerPositions
print 'optimal relationship between vm and agent: \n %s' %relations
#print routerNumbers
#print routerPositions
#print relations
#print vmPosition


authentication = Authenticate(controllerIP, userName, tenantName, HorizonPW)
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
l3Position = GetL3AgentPosition(controllerIP, 'root', mysqlPW, 'neutron')
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
