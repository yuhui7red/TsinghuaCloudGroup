S = [64000 256000 1024000 4096000 16384000 65536000];
%用于产生N个期望为u的随机数
u_array = GetProcessingRate(1000, 1.5, 2, 1);             
%用于产生N个期望为u2的随机数
u_agent_array = GetProcessingRate(1000, 1, 1.5, 0.5);
time = [];
t_max = [];

for i = 1: 1: length(S)
    [k1, total1, t_max1, position1] = Uneven(S(i), 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 2);
    [k2, total2, t_max2, position2] = Uneven(S(i), 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 2);
    [k3, total3, t_max3, position3] = Isomerism(S(i), 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 2);
    [k4, total4, t_max4, position4] = Isomerism(S(i), 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 1);
    time = [time; total1(1,2), total2(60, 2), total3(60, 2), total4(60, 2)];
    t_max = [t_max; t_max1(1, 2), t_max2(60, 2), t_max3(60, 2), t_max4(60, 2)];
end

time = time / 10000000;