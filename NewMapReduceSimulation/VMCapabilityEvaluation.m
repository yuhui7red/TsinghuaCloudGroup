function [capability] = VMCapabilityEvaluation(maximum_load, noagent_optimal_performance, ...
    agent_rate, current_load, has_agent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%VMCapabilityEvaluation.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/5
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�����һ̨server��vm������
     %���룺maximum_load-��̨server������أ�noagent_optimal_performance-��̨server���̶����õ�vm��agent�ܴﵽ��������ܣ�
     %agent_optimal_performance-��̨server���̶����õ�vm��agent�ܴﵽ��������ܣ�current_load-��ǰserver�ĸ���
     %�����capability-vm������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

capability = noagent_optimal_performance - noagent_optimal_performance/(maximum_load + 2) * (current_load - 1);
if (has_agent == 1) 
    capability = capability * agent_rate;
end

end

