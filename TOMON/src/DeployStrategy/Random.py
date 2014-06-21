import random

def Random(vmOnServer, agentNumber):
    random.shuffle(vmOnServer)
    result = []
    for i in range(agentNumber):
        result.append(vmOnServer[i])
    return result
