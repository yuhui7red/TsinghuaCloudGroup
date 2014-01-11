function [k, total_max, position] = MultiHostOptimize(map_data, server_number, vm_number, ...
    server_info, vm_info, speed, reduce_data, reducer_number, deploy_strategy, assign_strategy )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MultiHostOptimize.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/9
     %修改人：
     %日 期：
     %功能：1.找出multihost环境下最优的agent数 2.最优的时间综合 3.最优的时间跨度
     %输入：map_data-发送的总数据量；server_number-服务器的数量；vm_number-Virtual Machine的数量
     %agent_number-云平台中agent的数量；server_info-第一列：server id第二列：每台server上vm的数量；agent_number-云平台中agent的数量
     %第三列：server上最大的vm负载；第四列：只开一台vm无agent的性能；第五列：有agent的性能比例；第六列：是否有agent；
     %vm_info-第一列：编号；第二列：所在server的编号；第三列：性能
     %speed-数据传送的速度；reduce_data-reduce阶段的数据量；reducer_number-reduce阶段的数据
     %deploy_strategy-agent的部署策略；assign_strategy-agent的分配策略
     %输出：k-最优的时间；total_max-最优的时间总和和时间跨度；position-路由器的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_max = 1: 1: server_number;
total_max = total_max';
total_max = [total_max, zeros(server_number, 1), zeros(server_number, 1)];
position = [];

for i = 1: 1: server_number
    [total_time, max_vm_time, agent_position] = MapReduce(map_data, server_number, vm_number, i, ...
        server_info, vm_info, speed, reduce_data, reducer_number, deploy_strategy, assign_strategy);
    total_max(i, 2) = total_time;
    total_max(i, 3) = max_vm_time;
    agent_position = [agent_position, zeros(server_number-i, 1)'];
    position = [position; agent_position];
end

[temp k] = min(total_max(:, 2));

end

