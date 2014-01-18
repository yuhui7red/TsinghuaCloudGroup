function [total_time, max_vm_time, agent_position] = MapReduce(map_data, server_number, vm_number, agent_number, ...
    server_info, vm_info, speed, reduce_data, reducer_number, deploy_strategy, assign_strategy)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MapReduce.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/5
     %修改人：
     %日 期：
     %功能：1.整个MapReduce阶段vm经历的时间之和 2.整个MapReduce阶段的时间
     %3.获得k的不同取值下路由器的最佳位置
     %输入：map_data-发送的总数据量；server_number-服务器的数量；vm_number-Virtual Machine的数量
     %agent_number-云平台中agent的数量；server_info-第一列：server id第二列：每台server上vm的数量；agent_number-云平台中agent的数量
     %第三列：server上最大的vm负载；第四列：只开一台vm无agent的性能；第五列：有agent的性能比例；第六列：是否有agent；
     %vm_info-第一列：编号；第二列：所在server的编号；第三列：性能；第4列：由那个agent负责
     %speed-数据传送的速度；reduce_data-reduce阶段的数据量；reducer_number-reduce阶段的数据
     %deploy_strategy-agent的部署策略；assign_strategy-agent的分配策略
     %输出：total_time-vm的总时间；max_vm_time-整个过程的历时；agent_position-路由器的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Map Stage
% t1-map_data发到agent上的时间
t1 = map_data / speed * vm_number;

% t2-agent把数据转发给vm的时间
% agent的部署方案
if (deploy_strategy == 1)
    % 利用公式计算出vm_info第四列capability的值
    for i = 1: 1: vm_number
        vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 3), ...
            server_info(vm_info(i, 2), 4), server_info(vm_info(i, 2), 5), ...
            server_info(vm_info(i, 2), 2), server_info(vm_info(i, 2), 6));
    end
    % 算出空载时vm的处理性能之和
    capability = sum(vm_info(:, 3));
    % 利用聪哥的公式求出最优的agent所在server上的vm数
    % 注意rate
    optimal = round(GetOptimalVMAgentNumber(map_data, vm_number, agent_number, server_info(1, 5), capability, speed, reduce_data, reducer_number))
    % 利用背包求出最接近的agent部署方案
    [agent_position, vm_agent_number] = NewKnapsackDeploy(server_info(:,2), agent_number, optimal);
elseif (deploy_strategy == 2)
    [agent_position, vm_agent_number] = MaxFirstDeploy(server_info(:,2), agent_number);
elseif (deploy_strategy == 3)
    [agent_position, vm_agent_number] = MinFirstDeploy(server_info(:,2), agent_number);
elseif (deploy_strategy == 4)
    [agent_position, vm_agent_number] = RandomDeploy(server_info(:,2), agent_number);
end

% 利用部署结果agent_position标记server_info的第六列，server上是否有agent
for i = 1: 1: length(agent_position)
    server_info(agent_position(i), 6) = 1;
end

% 利用公式计算出vm_info第四列capability的值
for i = 1: 1: vm_number
    vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 3), ...
        server_info(vm_info(i, 2), 4), server_info(vm_info(i, 2), 5), ...
        server_info(vm_info(i, 2), 2), server_info(vm_info(i, 2), 6));
end    

% 统计出所在server上没有agent的vm的capability
rest_vm_capability = [];
for i = 1: 1: vm_number
    if (server_info(vm_info(i, 2), 6) == 0) 
        rest_vm_capability = [rest_vm_capability; vm_info(i, 1), vm_info(i, 3)];
    else 
        vm_info(i, 4) = server_info(vm_info(i, 2), 1);
    end
end

% agent的分配方案
if (agent_number ~= server_number)
    if (assign_strategy == 1) 
        [vm_assignment, vm_info] = LoadBalancingAssign(rest_vm_capability, agent_number, agent_position, vm_info);
    elseif (assign_strategy == 2)
        [vm_assignment, vm_info] = RandomAssign(rest_vm_capability, agent_number, agent_position, vm_info);
    end    
end

% 数据在网络上的传输远远快于在vm的处理能力
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

% t3-vm处理数据的时间
t3 =  map_data/capability * vm_number;

% map阶段所经历的时间
max_vm_time = t1/vm_number + max_transmission_time + t3/vm_number;

%% Reduce Stage
% t4-数据由vm汇聚到reducer上的时间
% 随机分布了reducer的位置
reducer_info =  vm_info(randperm(vm_number), :);
reducer_info = reducer_info(1: reducer_number, :);

% 随机找出工作agent的位置
% 统计工作的agent所在server上的vm数
% 统计所在server上没有agent的reducer数
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

% 算出总时间
t4 = (vm_number-vm_agent_number)*reduce_data*reducer_number/(agent_number*speed) ...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*(work_agent_vm ...
    + (vm_number-vm_agent_number)*work_agent_vm/vm_agent_number)) ...
    + vm_number*reduce_data/speed*reducer_noagent;

% 整个过程等待的总时间
total_time = t1 + t2 + t3 + t4;

% 整个过程经历的时间
max_vm_time = max_vm_time + (vm_number-vm_agent_number)*reduce_data/(agent_number*speed)...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*(work_agent_vm ...
    + (vm_number-vm_agent_number)*work_agent_vm/vm_agent_number));
% 如果存在一个没有工作agent的reduce，就需要加上最后一项转发时间
if (isFind == 1)
    max_vm_time = max_vm_time + vm_number*reduce_data/speed;
end

end

