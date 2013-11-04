S = 0;

for i = 1: 1: 10
    S = S + 999 + randi(999001, 1, 1);  
end

%���ڲ���N������Ϊu�������
u_array = GetProcessingRate(1000, 1.5, 2, 1);             
%���ڲ���N������Ϊu2�������
u_agent_array = GetProcessingRate(1000, 1, 1.5, 0.5);

[k1, total1, t_max1, position1] = Isomerism(S, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 1);
[k2, total2, t_max2, position2] = Uneven(S, 1000, 100, m_vm, 100, 1.5, 1, u_array, u_agent_array, 10, 300, 1);

time = [total1(:,2), total2(:,2)];
position = [position1; position2];

time = time / 10000000;

dlmwrite('timeUneven.txt', time, 'delimiter', ' ', 'newline', 'pc');
dlmwrite('positionUneven.txt', position, 'delimiter', ' ', 'newline', 'pc');
