function [result] = Knapsack(m, k, Na)

number = length(m);
m_sum = sum(m);
dp = zeros(k+1, m_sum+1);
dp(1, 1) = 1;
server_combination = zeros((k+1)*(m_sum+1), k);

for i = 1: 1: number
    for j = k: -1: 1
        for l = 1: 1: m_sum - m(i)+1
            if dp(j, l) == 1
                dp(j+1, l+m(i)) = 1;
                server_combination((j+1)*(l+m(i)), :) = server_combination(j*l, :);
                server_combination((j+1)*(l+m(i)), j+1) = i;
            end
        end
    end
end

offset = 0;
while 1
    if dp(k+1, Na+1+offset) == 1
        result = server_combination((k+1)*(Na+1+offset), 2: length(server_combination((k+1)*(Na+1+offset), :)));
        break;
    elseif dp(k+1, Na+1-offset) == 1
        result = server_combination((k+1)*(Na+1-offset), 2: length(server_combination((k+1)*(Na+1-offset), :)));
        break;
    end
    offset = offset + 1;
end

result = sort(result);

end

