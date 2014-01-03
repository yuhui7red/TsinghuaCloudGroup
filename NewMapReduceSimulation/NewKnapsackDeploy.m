function [serial_number, Na] = NewKnapsackDeploy(m_vm, k, optimal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NewKnapsack.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2013/9/27
     %修改人：William Yu
     %日 期：2014/1/3
     %功能：在n个数中选出t个数，使这t个数的和最接近m
     %输入：m_vm-每台服务器上VM的数量；k-路由器的数量；optimal-有路由器所在服务器vm数量之和的最优值
     %输出：Na-选出的服务器vm数之和；serial_number-路由器所在最有位置的下标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (optimal < 0)
    optimal = 0;
end

%数的数量
n = length(m_vm);
%所有数的和
m = sum(m_vm);

if (optimal > m)
    optimal = m;
end

%所有的状态
dp = zeros(n + 1, m + 1);
%记录过程
mark = zeros(n + 1, m + 1);

%初始化条件
dp(1, 1) = 0;
for i = 2 : 1 : m + 1
    dp(1, i) =  Inf;
end

%算出所有背包组合
for i = 2 : 1 : n + 1
    for j = m + 1 : -1 : m_vm(i-1) + 1
        if (dp(i-1, j-m_vm(i-1)) ~=  Inf)
            dp(i, j) = dp(i-1, j-m_vm(i-1)) + 1;
            mark(i, j) = 1;
        else
            dp(i, j) = dp(i-1, j);
        end     
    end
    for j = m_vm(i-1) : -1 : 1
        dp(i, j) = dp(i-1, j);
    end
end

L = [];
%求最接近的组合
isFind = 0;
offset = 0;
while (isFind == 0)
    tmp_m = optimal + offset;
    if (tmp_m <= m)
        for i = n + 1 : -1 : 1
            if (mark(i, tmp_m+1) == 1 && dp(i, tmp_m+1) == k)
                Na = tmp_m;
                tmp_i = i;
                while (tmp_i ~= 1)
                    if (mark(tmp_i, tmp_m+1) == 1)
                        L = [L, m_vm(tmp_i-1)];
                        tmp_m = tmp_m - m_vm(tmp_i-1);
                        tmp_i = tmp_i - 1;
                    else
                        tmp_i = tmp_i - 1;
                    end
                end
                isFind = 1;
                break;
            end
        end
        if (isFind == 1)
            break;
        end
    end
    tmp_m = optimal - offset;
    if (tmp_m >= 0)
        for i = n + 1 : -1 : 1
            if (mark(i, tmp_m+1) == 1 && dp(i, tmp_m+1) == k)
                Na = tmp_m;
                tmp_i = i;
                while (tmp_i ~= 1)
                    if (mark(tmp_i, tmp_m+1) == 1)
                        L = [L, m_vm(tmp_i-1)];
                        tmp_m = tmp_m - m_vm(tmp_i-1);
                        tmp_i = tmp_i - 1;
                    else
                        tmp_i = tmp_i - 1;
                    end
                end
                isFind = 1;
                break;
            end
        end
        if (isFind == 1)
            break;
        end
    end
    offset = offset + 1;
end

[serial_number] = GetSerialNumber(m_vm, k, L);

end

