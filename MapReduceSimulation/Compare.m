function [k, total, t_max, position_optimal, position_random, position_maxvm, position_minvm] ...
    = Compare(S, N, m, m_vm, B, u, offset_u, u_agent, offset_u_agent, S_r, n_r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compare.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：Willian Yu
     %日 期：2013/9/26
     %修改人：
     %日 期：
     %功能：用来比较4种实验结果
     %输入：S-发送的总数据量；N-Virtual Machine的数量；m-服务器的数量；B-数据传送的速度；
     %m_vm-每台服务器上VM的数量；u-没有路由器的服务器处理数据速度的期望；u_agent-有路由器的服务器处理数据速度的期望
     %offset_u-u的波动范围；offset_u_agent-u_agent的波动范围
     %输出：k-不同情况下路由器的最佳数量；total-不同情况下，k的不同取值下对应的VM的过程总时间；t_max-不同情况下，k的不同取值下N个VM中耗时最长的VM
     % position-不同情况下路由器的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%用于产生N个期望为u的随机数
u_array = GetProcessingRate(N, u, u+offset_u, u-offset_u);             
%用于产生N个期望为u2的随机数
u_agent_array = GetProcessingRate(N, u_agent, u_agent+offset_u_agent, u_agent-offset_u_agent);

%最优情况
[k_optimal, total_optimal, t_max_optimal, position_optimal] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 1);
%随机情况
[k_random, total_random, t_max_random, position_random] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 2);
%k个最大vm的服务器情况
[k_maxvm, total_maxvm, t_max_maxvm, position_maxvm] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 3);
%k个最小vm的服务器情况
[k_minvm, total_minvm, t_max_minvm, position_minvm] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 4);

k = [];
k = [k_optimal, k_random, k_maxvm, k_minvm];
total = [];
total = [total_optimal(:,2), total_random(:,2), total_maxvm(:,2), total_minvm(:,2)];
t_max = [];
t_max = [t_max_optimal(:,2), t_max_random(:,2), t_max_maxvm(:,2), t_max_minvm(:,2)];

end

