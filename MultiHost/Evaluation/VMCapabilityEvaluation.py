def VMCapabilityEvaluation(maxLoad, noAgentOptimalPerformance, agentDecreaseRate, currentLoad, hasAgent):
    capability = noAgentOptimalPerformance - noAgentOptimalPerformance/(maxLoad + 2) * (currentLoad - 1)
    if (hasAgent == 1):
        capability = capability * agentDecreaseRate
    return capability

print VMCapabilityEvaluation(8, 1.634394, 0.8550, 7, 1)
