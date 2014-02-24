def NewKnapsack(vmOnServer, agentNumber, optimal):  
    serverNumber = len(vmOnServer)
    vmSum = sum(vmOnServer)
    if optimal > vmSum:
        optimal = vmSum
    elif optimal < 0:
        optimal = 0
    dp = [[0 for i in range(vmSum+1)] for i in range(serverNumber+1)]
    record = [[0 for i in range(vmSum+1)] for i in range(serverNumber+1)]
    processVM = vmOnServer[0:serverNumber]
    processVM.sort()
    dp[0][0] = 0
    for i in range(1, vmSum+1):
        dp[0][i] = -1

    for i in range(1, serverNumber+1):
        for j in range(vmSum, processVM[i-1]-1, -1):
            if dp[i-1][j-processVM[i-1]] != -1:
                dp[i][j] = dp[i-1][j-processVM[i-1]] + 1
                record[i][j] = 1
            else:
                dp[i][j] = dp[i-1][j]
        for j in range(processVM[i-1]-1, -1, -1):
            dp[i][j] = dp[i-1][j]

    offset = 0
    left = 0
    right = 0
    position = 0
    while True:
        for i in range(agentNumber, serverNumber+1): 
            if optimal + offset <= serverNumber \
                and record[i][optimal+offset] == 1 \
                and dp[i][optimal+offset] == agentNumber:
                right = 1
                position = i
                break
            elif optimal - offset >= 0 \
                and record[i][optimal-offset] == 1 \
                and dp[i][optimal-offset] == agentNumber:
                left = 1
                position = i
                break
        if right == 1 or left == 1:
            break
        else:
            offset += 1

    if left == 1:
        optimal = optimal - offset
    else:
        optimal = optimal + offset

    selectedServer = []
    for i in range(position, -1, -1):
        if record[i][optimal] == 1:
            selectedServer.append(processVM[i-1])
            optimal = optimal - processVM[i-1]

    selectedServer.sort()
    j = 0
    for i in range(serverNumber):
        if j == len(selectedServer):
            break
        if selectedServer[j] == processVM[i]:
            selectedServer[j] = i + 1
            j += 1
        
    return selectedServer

    
        
    
        

