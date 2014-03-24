import sys;
if not "../Controller/" in sys.path:
    sys.path.append("../Controller/")
if not "../NetworksConstruction/" in sys.path:
    sys.path.append("../NetworksConstruction/")
if not "../Evaluation/" in sys.path:
    sys.path.append("../Evaluation/")

import os, urllib, httplib, json, base64, string
from urlparse import urlparse
from APIToken import APIToken
from Authentication import Authenticate
from ComputeNodes import GetComputeNodesInfo
from VMCapabilityEvaluation import VMCapabilityEvaluation

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication
token = apiToken.GetToken()

computeNodesInfo = GetComputeNodesInfo('166.111.143.250', 'root', 'cer.cloud', 'nova')
serverNumber = len(computeNodesInfo)
serverInfo = [[0 for i in range(4)] for i in range(serverNumber)]

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
        vmInfo[VMCount-1][2] = VMCapabilityEvaluation(serverInfo[i][2], 1.634394, 0.855, serverInfo[i][1], serverInfo[i][3])
        VMCount = VMCount + 1

for element in vmInfo:
    print element






