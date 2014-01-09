function [capability] = VMCapabilityEvaluation(maximum_load, noagent_optimal_performance, ...
    agent_rate, current_load, has_agent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%VMCapabilityEvaluation.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/5
     %修改人：
     %日 期：
     %功能：评估一台server上vm的性能
     %输入：maximum_load-这台server的最大负载；noagent_optimal_performance-这台server，固定配置的vm无agent能达到的最大性能；
     %agent_optimal_performance-这台server，固定配置的vm有agent能达到的最大性能；current_load-当前server的负载
     %输出：capability-vm的性能
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

capability = noagent_optimal_performance - noagent_optimal_performance/(maximum_load + 2) * (current_load - 1);
if (has_agent == 1) 
    capability = capability * agent_rate;
end

end

