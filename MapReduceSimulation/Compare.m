function [k, total, t_max, position_optimal, position_random, position_maxvm, position_minvm] ...
    = Compare(S, N, m, m_vm, B, u, offset_u, u_agent, offset_u_agent, S_r, n_r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compare.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�Willian Yu
     %�� �ڣ�2013/9/26
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ������Ƚ�4��ʵ����
     %���룺S-���͵�����������N-Virtual Machine��������m-��������������B-���ݴ��͵��ٶȣ�
     %m_vm-ÿ̨��������VM��������u-û��·�����ķ��������������ٶȵ�������u_agent-��·�����ķ��������������ٶȵ�����
     %offset_u-u�Ĳ�����Χ��offset_u_agent-u_agent�Ĳ�����Χ
     %�����k-��ͬ�����·���������������total-��ͬ����£�k�Ĳ�ͬȡֵ�¶�Ӧ��VM�Ĺ�����ʱ�䣻t_max-��ͬ����£�k�Ĳ�ͬȡֵ��N��VM�к�ʱ���VM
     % position-��ͬ�����·������λ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%���ڲ���N������Ϊu�������
u_array = GetProcessingRate(N, u, u+offset_u, u-offset_u);             
%���ڲ���N������Ϊu2�������
u_agent_array = GetProcessingRate(N, u_agent, u_agent+offset_u_agent, u_agent-offset_u_agent);

%�������
[k_optimal, total_optimal, t_max_optimal, position_optimal] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 1);
%������
[k_random, total_random, t_max_random, position_random] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 2);
%k�����vm�ķ��������
[k_maxvm, total_maxvm, t_max_maxvm, position_maxvm] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 3);
%k����Сvm�ķ��������
[k_minvm, total_minvm, t_max_minvm, position_minvm] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, 4);

k = [];
k = [k_optimal, k_random, k_maxvm, k_minvm];
total = [];
total = [total_optimal(:,2), total_random(:,2), total_maxvm(:,2), total_minvm(:,2)];
t_max = [];
t_max = [t_max_optimal(:,2), t_max_random(:,2), t_max_maxvm(:,2), t_max_minvm(:,2)];

end

