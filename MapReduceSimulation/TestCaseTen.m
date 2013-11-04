time = zeros(100, 4);
position = [];
S = 0;

for i = 1: 1: 10
    S = S + 999 + randi(999001, 1, 1);  
end

[k, total, t_max, position_optimal, position_random, position_maxvm, position_minvm] = Compare(S, 1000, 100, m_vm, 100, 1.5, 0.5, 1, 0.5, 10, 300);

time = time + total;
position = [position; position_optimal; position_random; position_maxvm; position_minvm];

time = time / 10000000;

dlmwrite('time.txt', time, 'delimiter', ' ', 'newline', 'pc');
dlmwrite('position.txt', position, 'delimiter', ' ', 'newline', 'pc');