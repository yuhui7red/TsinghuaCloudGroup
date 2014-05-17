def NewKnapsack(vmOnServer, agentNumber, optimal):
    serverNumber = len(vmOnServer)
    vmSum = sum(vmOnServer)
    dp = [[0 for i in range(vmSum+1)] for i in range(agentNumber+1)]
    dp[0][0] = 1
    serverCombination = [[[] for i in range(vmSum+1)] for i in range(agentNumber+1)]
    
    for i in range(serverNumber):
        for j in range(agentNumber-1, -1, -1):
            for l in range(vmSum-vmOnServer[i]+1):
                if dp[j][l] == 1:
                    dp[j+1][l+vmOnServer[i]] = 1
                    serverCombination[j+1][l+vmOnServer[i]] = serverCombination[j][l][:]
                    serverCombination[j+1][l+vmOnServer[i]].append(i+1)
                       
    offset = 0
    while True:
        if dp[agentNumber][optimal+offset] == 1:
            result = serverCombination[agentNumber][optimal+offset]
            break
        elif dp[agentNumber][optimal-offset] == 1:
            result = serverCombination[agentNumber][optimal-offset]
            break
        offset = offset + 1
    
    result.sort()
    return result

