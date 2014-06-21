def MinGreedy(vmOnServer, agentNumber):
    serverNumber = len(vmOnServer)
    temp = [[] for i in range(serverNumber)]
    for i in range(serverNumber):
        temp[i].append(i+1)
        temp[i].append(vmOnServer[i])
    temp = sorted(temp, key=lambda d:d[1])
    result = []
    for i in range(agentNumber):
        result.append(temp[i][0])
    return result
