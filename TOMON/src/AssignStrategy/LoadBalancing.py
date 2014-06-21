def LoadBalancing(restVM, agentNumber):
    restVM = sorted(restVM, key = lambda d:d[1], reverse = True)
    restVMNumber = len(restVM)
    agentLoad = [0 for i in range(agentNumber)]
    mapping = []

    minAgentId = 0
    for i in range(restVMNumber):
        agentLoad[minAgentId] += restVM[i][1]
        mapping.append([restVM[i][0], minAgentId+1])
        minAgentId = 0
        for j in range(agentNumber):
            if agentLoad[j] < agentLoad[minAgentId]:
                minAgentId = j
    mapping = sorted(mapping, key = lambda d:d[0])
    return mapping                  
