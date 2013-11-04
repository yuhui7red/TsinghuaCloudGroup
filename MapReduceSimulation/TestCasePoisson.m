%用于产生N个期望为u的随机数
u_array = GetProcessingRate(1000, 1.5, 2, 1);             
%用于产生N个期望为u2的随机数
u_agent_array = GetProcessingRate(1000, 1, 1.5, 0.5);
S = [64000; 256000; 1024000; 4096000; 16384000; 65536000; 262144000; 1048576000; 4194304000; 16777216000];
lambda = [2; 4; 8; 16; 32; 64; 128; 256; 512; 1024];

for count = 1: 1: 12000/ 3000
    time_split = round(exprnd(lambda));
    time_split = [time_split, S, lambda];
    %time_split = sortrows(time_split, 1);
    %max_split = time_split(10, 1);
    sum = 0;
    for i = 1: 1: 3000
        for j = 1: 1: 10
            if time_split(j, 1) == 0
                sum = sum + time_split(j, 2);
                time_split(j, 1) = round(exprnd(time_split(j, 3)));
            end
        end
        time_split(:, 1) = time_split(:, 1) - 1;
    end
    sum
    %最优情况
    [k_optimal, total_optimal, t_max_optimal, position_optimal] = Isomerism(sum, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 1);
    %随机情况
    [k_random, total_random, t_max_random, position_random] = Isomerism(sum, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 2);
    %k个最大vm的服务器情况
    [k_maxvm, total_maxvm, t_max_maxvm, position_maxvm] = Isomerism(sum, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 3);
    %k个最小vm的服务器情况
    [k_minvm, total_minvm, t_max_minvm, position_minvm] = Isomerism(sum, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 4);

    if count == 1
        total = [];
        total = [total_optimal(:,2), total_random(:,2), total_maxvm(:,2), total_minvm(:,2)];
    else
        total(:, 1) = total(:, 1) + total_optimal(:,2);
        total(:, 2) = total(:, 2) + total_random(:,2);
        total(:, 3) = total(:, 3) + total_maxvm(:,2);
        total(:, 4) = total(:, 4) + total_minvm(:,2);
    end
end

total = total / 10000000;
