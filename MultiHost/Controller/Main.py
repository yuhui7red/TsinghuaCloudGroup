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

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication
token = apiToken.GetToken()
computeIP = apiToken.GetComputeIP()
tenantID = apiToken.GetTenantID()

computeNodesInfo = GetComputeNodesInfo('166.111.143.250', 'root', 'cer.cloud', 'nova')
serverNumber = len(computeNodesInfo)
serverInfo = [[0 for i in range(4)] for i in range(serverNumber)]

flavorJson = ListFlavors(token, computeIP, tenantID)
flavorTemplate =  GetFlavors(flavorJson)
flavor = (1, 512)
for i in range(len(computeNodesInfo)):
    serverInfo[i][0] = computeNodesInfo[i][0]
    serverInfo[i][2] = min(computeNodesInfo[i][1]/flavor[0], computeNodesInfo[i][2]/flavor[1])

vm = (6, 3, 2, 7, 6, 1, 4, 3)
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

'''for element in vmInfo:
    print element

for element in serverInfo:
    print element'''

#k = GetOptimalAgentNumber(N, S, nr, Sr, u0, r, B)
#Na = GetOptimalNa(N, S, nr, Sr, u0, r, B, k)
k = 3
Na = 14

position = NewKnapsack(vm, k, Na)
routerPositions = []
i = 1
for element in position:
    serverInfo[element-1][3] = 'router' + str(i)
    i = i + 1
    routerPositions.append(serverInfo[element-1][0])

routerPositions.sort()

vmInfo = sorted(vmInfo, key=lambda d:d[1])
#serverInfo = sorted(serverInfo, key=lambda d:d[0])

'''
for element in vmInfo:
    print element

for element in serverInfo:
    print element
'''

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
        if vmInfo[j+1][1] > agentServerInfo[i][0]:
            i = i + 1

decreaseRate = 0.855
restVM = []
for element in vmInfo:
    if element[3] != 0:
        element[2] = element[2] * decreaseRate
    else:
        restVM.append([element[0], element[2]])


mapping = LoadBalancing(restVM, k)
#print mapping

vmInfo = sorted(vmInfo, key=lambda d:d[0])

i = 0
for element in vmInfo:
    if i == len(mapping):
        break
    if mapping[i][0] == element[0]:
        element[3] = 'router' + str(mapping[i][1])
        i = i + 1

'''for element in mapping:
    print element

for element in vmInfo:
    print element'''

routerNumbers = k
# routerPositions
# vm
for elem in vmInfo:
    print elem
relations = []
vmPosition = []

for element in vmInfo:
    relations.append(element[1])
    vmPosition.append(element[3])

print routerNumbers
print routerPositions
print relations
print vmPosition
