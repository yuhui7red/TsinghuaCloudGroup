function [total_time, max_vm_time, agent_position] = MapReduce(map_data, server_number, vm_number, agent_number, ...
    server_info, vm_info, speed, reduce_data, reducer_number, deploy_strategy, assign_strategy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MapReduce.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/5
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�1.����MapReduce�׶�vm������ʱ��֮�� 2.����MapReduce�׶ε�ʱ��
     %3.���k�Ĳ�ͬȡֵ��·���������λ��
     %���룺map_data-���͵�����������server_number-��������������vm_number-Virtual Machine������
     %agent_number-��ƽ̨��agent��������server_info-��һ�У�ÿ̨server��vm���������ڶ��У�server������vm���أ������У�ֻ��һ̨vm��agent�����ܣ�
     %�����У�ֻ��һ̨vm��agent�����ܣ������У��Ƿ���agent��
     %vm_info-��һ�У���ţ��ڶ��У�����server�ı�ţ������У�����
     %speed-���ݴ��͵��ٶȣ�reduce_data-reduce�׶ε���������reducer_number-reduce�׶ε�����
     %deploy_strategy-agent�Ĳ�����ԣ�assign_strategy-agent�ķ������
     %�����total_time-vm����ʱ�䣻max_vm_time-�������̵���ʱ��agent_position-·������λ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Map Stage
% t1-map_data����agent�ϵ�ʱ��
t1 = map_data / speed * vm_number;

% t2-agent������ת����vm��ʱ��
% agent�Ĳ��𷽰�
if (deploy_strategy == 1)
    % ���ôϸ�Ĺ�ʽ������ŵ�agent����server�ϵ�vm��
    % optimal=...
    % ���ñ��������ӽ���agent���𷽰�
    % [agent_position, vm_agent_number] = NewKnapsack(server_info(:,1), agent_number, optimal);
elseif (deploy_strategy == 2)
    [agent_position, vm_agent_number] = MaxFirstDeploy(server_info(:,1), agent_number);
elseif (deploy_strategy == 3)
    [agent_position, vm_agent_number] = MinFirstDeploy(server_info(:,1), agent_number);
elseif (deploy_strategy == 4)
    [agent_position, vm_agent_number] = RandomDeploy(server_info(:,1), agent_number);
end

% ���ò�����agent_position���server_info�ĵ����У�server���Ƿ���agent
for i = 1: 1: length(agent_position)
    server_info(agent_position(i), 5) = 1;
end

% ���ù�ʽ�����vm_info������capacity��ֵ
for i = 1: 1: vm_number
    vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 2), ...
        server_info(vm_info(i, 2), 3), server_info(vm_info(i, 2), 4), ...
        server_info(vm_info(i, 2), 1), server_info(vm_info(i, 2), 5));
end

% ͳ�Ƴ�����server��û��agent��vm��capability
rest_vm_capability = [];
for i = 1: 1: vm_number
    if (server_info(vm_info(i, 2), 5) == 0) 
        rest_vm_capability = [rest_vm_capability, vm_info(i, 3)];
    end
end

% agent�ķ��䷽��
if (assign_strategy == 1) 
    [vm_assignment] = LoadBalancingAssign(rest_vm_capability, agent_number);
elseif (assign_strategy == 2)
    [vm_assignment] = RandomAssign(rest_vm_capability, agent_number);
end    

% �����������ϵĴ���ԶԶ������vm�Ĵ�������
t2 = 0;
capability = sum(vm_info(:, 3));
max_transmission_time = vm_assignment(1, 2) / capability * map_data / speed;
for i = 1: 1: agent_number
    transmission_time = vm_assignment(i, 2) / capability * map_data / speed;
    t2 = t2 + transmission_time;
    if transmission_time > max_transmission_time
        max_transmission_time = transmission_time;
    end
end

% t3-vm�������ݵ�ʱ��
t3 =  map_data/capability * vm_number;

% map�׶���������ʱ��
max_vm_time = t1/vm_number + max_transmission_time + t3/vm_number;

%% Reduce Stage
% t4-������vm��۵�reducer�ϵ�ʱ��
% ����ֲ���reducer��λ��
reducer_position = randi(server_number, reducer_number, 1);
reducer_position = sort(reducer_position);
reducer_position = [reducer_position, zeros(reducer_number, 1)];
agent_position = sort(agent_position);
j = 1;
for i = 1: 1: size(reducer_position, 1)
    if (j > size(agent_position, 1))
        break;
    end
    if (reducer_position(i, 1) == agent_position(j, 1))
        reducer_position(i, 2) = 1;
    elseif (reducer_position(i, 1) > agent_position(j, 1))
        j = j + 1;
        i = i - 1;
    elseif (reducer_position(i, 1) < agent_position(j, 1))
        continue;
    end
end 
% ����ҳ�����agent��λ��
work_agent_number = randi(agent_number, 1, 1);
work_agent_position = agent_position(randperm(work_agent_number));
work_agent_position = work_agent_position(1: work_agent_number);
% ͳ�ƹ�����agent����server�ϵ�vm��
work_agent_vm = 0;
for i = 1: 1: size(work_agent_position, 1)
   work_agent_vm = work_agent_vm + server_info(work_agent_position(i), 1);
end
% ͳ������server��û��agent��reducer��
reducer_noagent = 0;
isFind = 0;
for i = 1: 1: reducer_number
   if (reducer_position(i, 2) == 0)
       reducer_noagent = reducer_noagent + 1;
       isFind = 1;
   end
end

% �����ʱ��
t4 = (vm_number-vm_agent_number)*reduce_data*reducer_number/(agent_number*speed) ...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*work_agent_vm) ...
    + vm_number*reduce_data/speed*reducer_noagent;

% �������̵ȴ�����ʱ��
total_time = t1 + t2 + t3 + t4;

% �������̾�����ʱ��
max_vm_time = max_vm_time + (vm_number-vm_agent_number)*reduce_data/(agent_number*speed)...
    + vm_number*reduce_data*reducer_number;
if (isFind == 1)
    max_vm_time = max_vm_time + vm_number*reduce_data/speed;
end

end

