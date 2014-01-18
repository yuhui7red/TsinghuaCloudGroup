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
     %agent_number-��ƽ̨��agent��������server_info-��һ�У�server id�ڶ��У�ÿ̨server��vm��������agent_number-��ƽ̨��agent������
     %�����У�server������vm���أ������У�ֻ��һ̨vm��agent�����ܣ������У���agent�����ܱ����������У��Ƿ���agent��
     %vm_info-��һ�У���ţ��ڶ��У�����server�ı�ţ������У����ܣ���4�У����Ǹ�agent����
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
    % ���ù�ʽ�����vm_info������capability��ֵ
    for i = 1: 1: vm_number
        vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 3), ...
            server_info(vm_info(i, 2), 4), server_info(vm_info(i, 2), 5), ...
            server_info(vm_info(i, 2), 2), server_info(vm_info(i, 2), 6));
    end
    % �������ʱvm�Ĵ�������֮��
    capability = sum(vm_info(:, 3));
    % ���ôϸ�Ĺ�ʽ������ŵ�agent����server�ϵ�vm��
    % ע��rate
    optimal = round(GetOptimalVMAgentNumber(map_data, vm_number, agent_number, server_info(1, 5), capability, speed, reduce_data, reducer_number))
    % ���ñ��������ӽ���agent���𷽰�
    [agent_position, vm_agent_number] = NewKnapsackDeploy(server_info(:,2), agent_number, optimal);
elseif (deploy_strategy == 2)
    [agent_position, vm_agent_number] = MaxFirstDeploy(server_info(:,2), agent_number);
elseif (deploy_strategy == 3)
    [agent_position, vm_agent_number] = MinFirstDeploy(server_info(:,2), agent_number);
elseif (deploy_strategy == 4)
    [agent_position, vm_agent_number] = RandomDeploy(server_info(:,2), agent_number);
end

% ���ò�����agent_position���server_info�ĵ����У�server���Ƿ���agent
for i = 1: 1: length(agent_position)
    server_info(agent_position(i), 6) = 1;
end

% ���ù�ʽ�����vm_info������capability��ֵ
for i = 1: 1: vm_number
    vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 3), ...
        server_info(vm_info(i, 2), 4), server_info(vm_info(i, 2), 5), ...
        server_info(vm_info(i, 2), 2), server_info(vm_info(i, 2), 6));
end    

% ͳ�Ƴ�����server��û��agent��vm��capability
rest_vm_capability = [];
for i = 1: 1: vm_number
    if (server_info(vm_info(i, 2), 6) == 0) 
        rest_vm_capability = [rest_vm_capability; vm_info(i, 1), vm_info(i, 3)];
    else 
        vm_info(i, 4) = server_info(vm_info(i, 2), 1);
    end
end

% agent�ķ��䷽��
if (agent_number ~= server_number)
    if (assign_strategy == 1) 
        [vm_assignment, vm_info] = LoadBalancingAssign(rest_vm_capability, agent_number, agent_position, vm_info);
    elseif (assign_strategy == 2)
        [vm_assignment, vm_info] = RandomAssign(rest_vm_capability, agent_number, agent_position, vm_info);
    end    
end

% �����������ϵĴ���ԶԶ������vm�Ĵ�������
t2 = 0;
max_transmission_time = 0;
capability = sum(vm_info(:, 3));
if (agent_number ~= server_number)
    max_transmission_time = vm_assignment(1, 2) / capability * map_data / speed;
    for i = 1: 1: agent_number
        transmission_time = vm_assignment(i, 2) / capability * map_data / speed;
        t2 = t2 + transmission_time;
        if transmission_time > max_transmission_time
            max_transmission_time = transmission_time;
        end
    end
end
t2 = t2 / agent_number;

% t3-vm�������ݵ�ʱ��
t3 =  map_data/capability * vm_number;

% map�׶���������ʱ��
max_vm_time = t1/vm_number + max_transmission_time + t3/vm_number;

%% Reduce Stage
% t4-������vm��۵�reducer�ϵ�ʱ��
% ����ֲ���reducer��λ��
reducer_info =  vm_info(randperm(vm_number), :);
reducer_info = reducer_info(1: reducer_number, :);

% ����ҳ�����agent��λ��
% ͳ�ƹ�����agent����server�ϵ�vm��
% ͳ������server��û��agent��reducer��
reducer_noagent = 0;
work_agent_vm = 0;
isFind = 0;
existed_index = [];
for i = 1: 1: size(reducer_info, 1) 
    if (server_info(reducer_info(i, 2), 6) == 0)
        reducer_noagent = reducer_noagent + 1;
        isFind = 1;
        index = find(vm_assignment(:, 3) == reducer_info(i, 4));
        if (ismember(index, existed_index) == 0)
            work_agent_vm = work_agent_vm + server_info(vm_assignment(index, 3), 2);
            existed_index = [existed_index, index];
        end    
    else 
        if (ismember(server_info(reducer_info(i, 2), 1), existed_index) == 0)
            work_agent_vm = work_agent_vm + server_info(reducer_info(i, 2), 2);
            existed_index = [existed_index, server_info(reducer_info(i, 2), 1)];
        end
    end
end

% �����ʱ��
t4 = (vm_number-vm_agent_number)*reduce_data*reducer_number/(agent_number*speed) ...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*(work_agent_vm ...
    + (vm_number-vm_agent_number)*work_agent_vm/vm_agent_number)) ...
    + vm_number*reduce_data/speed*reducer_noagent;

% �������̵ȴ�����ʱ��
total_time = t1 + t2 + t3 + t4;

% �������̾�����ʱ��
max_vm_time = max_vm_time + (vm_number-vm_agent_number)*reduce_data/(agent_number*speed)...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*(work_agent_vm ...
    + (vm_number-vm_agent_number)*work_agent_vm/vm_agent_number));
% �������һ��û�й���agent��reduce������Ҫ�������һ��ת��ʱ��
if (isFind == 1)
    max_vm_time = max_vm_time + vm_number*reduce_data/speed;
end

end

