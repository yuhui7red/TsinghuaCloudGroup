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
     %agent_number-云平台中agent的数量；server_info-第一列：每台server上vm的数量；第二列：server上最大的vm负载；第三列：只开一台vm无agent的性能；
     %第四列：只开一台vm有agent的性能；第五列：是否有agent；
     %vm_info-第一列：编号；第二列：所在server的编号；第三列：性能
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
    % 利用聪哥的公式求出最优的agent所在server上的vm数
    % optimal=...
    % 利用背包求出最接近的agent部署方案
    % [agent_position, vm_agent_number] = NewKnapsack(server_info(:,1), agent_number, optimal);
elseif (deploy_strategy == 2)
    [agent_position, vm_agent_number] = MaxFirstDeploy(server_info(:,1), agent_number);
elseif (deploy_strategy == 3)
    [agent_position, vm_agent_number] = MinFirstDeploy(server_info(:,1), agent_number);
elseif (deploy_strategy == 4)
    [agent_position, vm_agent_number] = RandomDeploy(server_info(:,1), agent_number);
end

% 利用部署结果agent_position标记server_info的第三列，server上是否有agent
for i = 1: 1: length(agent_position)
    server_info(agent_position(i), 5) = 1;
end

% 利用公式计算出vm_info第四列capacity的值
for i = 1: 1: vm_number
    vm_info(i, 3) = VMCapabilityEvaluation(server_info(vm_info(i, 2), 2), ...
        server_info(vm_info(i, 2), 3), server_info(vm_info(i, 2), 4), ...
        server_info(vm_info(i, 2), 1), server_info(vm_info(i, 2), 5));
end

% 统计出所在server上没有agent的vm的capability
rest_vm_capability = [];
for i = 1: 1: vm_number
    if (server_info(vm_info(i, 2), 5) == 0) 
        rest_vm_capability = [rest_vm_capability, vm_info(i, 3)];
    end
end

% agent的分配方案
if (assign_strategy == 1) 
    [vm_assignment] = LoadBalancingAssign(rest_vm_capability, agent_number);
elseif (assign_strategy == 2)
    [vm_assignment] = RandomAssign(rest_vm_capability, agent_number);
end    

% 数据在网络上的传输远远快于在vm的处理能力
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

% t3-vm处理数据的时间
t3 =  map_data/capability * vm_number;

% map阶段所经历的时间
max_vm_time = t1/vm_number + max_transmission_time + t3/vm_number;

%% Reduce Stage
% t4-数据由vm汇聚到reducer上的时间
% 随机分布了reducer的位置
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
% 随机找出工作agent的位置
work_agent_number = randi(agent_number, 1, 1);
work_agent_position = agent_position(randperm(work_agent_number));
work_agent_position = work_agent_position(1: work_agent_number);
% 统计工作的agent所在server上的vm数
work_agent_vm = 0;
for i = 1: 1: size(work_agent_position, 1)
   work_agent_vm = work_agent_vm + server_info(work_agent_position(i), 1);
end
% 统计所在server上没有agent的reducer数
reducer_noagent = 0;
isFind = 0;
for i = 1: 1: reducer_number
   if (reducer_position(i, 2) == 0)
       reducer_noagent = reducer_noagent + 1;
       isFind = 1;
   end
end

% 算出总时间
t4 = (vm_number-vm_agent_number)*reduce_data*reducer_number/(agent_number*speed) ...
    + (vm_number*reduce_data*reducer_number/speed - reduce_data/speed*work_agent_vm) ...
    + vm_number*reduce_data/speed*reducer_noagent;

% 整个过程等待的总时间
total_time = t1 + t2 + t3 + t4;

% 整个过程经历的时间
max_vm_time = max_vm_time + (vm_number-vm_agent_number)*reduce_data/(agent_number*speed)...
    + vm_number*reduce_data*reducer_number;
if (isFind == 1)
    max_vm_time = max_vm_time + vm_number*reduce_data/speed;
end

end

