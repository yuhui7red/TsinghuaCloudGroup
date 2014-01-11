function [k, total_max, position] = MultiHostOptimize(map_data, server_number, vm_number, ...
    server_info, vm_info, speed, reduce_data, reducer_number, deploy_strategy, assign_strategy )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MultiHostOptimize.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/9
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�1.�ҳ�multihost���������ŵ�agent�� 2.���ŵ�ʱ���ۺ� 3.���ŵ�ʱ����
     %���룺map_data-���͵�����������server_number-��������������vm_number-Virtual Machine������
     %agent_number-��ƽ̨��agent��������server_info-��һ�У�server id�ڶ��У�ÿ̨server��vm��������agent_number-��ƽ̨��agent������
     %�����У�server������vm���أ������У�ֻ��һ̨vm��agent�����ܣ������У���agent�����ܱ����������У��Ƿ���agent��
     %vm_info-��һ�У���ţ��ڶ��У�����server�ı�ţ������У�����
     %speed-���ݴ��͵��ٶȣ�reduce_data-reduce�׶ε���������reducer_number-reduce�׶ε�����
     %deploy_strategy-agent�Ĳ�����ԣ�assign_strategy-agent�ķ������
     %�����k-���ŵ�ʱ�䣻total_max-���ŵ�ʱ���ܺͺ�ʱ���ȣ�position-·������λ��
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

