function [serial_number, Na] = NewKnapsackDeploy(m_vm, k, optimal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NewKnapsack.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2013/9/27
     %�޸��ˣ�William Yu
     %�� �ڣ�2014/1/3
     %���ܣ���n������ѡ��t������ʹ��t�����ĺ���ӽ�m
     %���룺m_vm-ÿ̨��������VM��������k-·������������optimal-��·�������ڷ�����vm����֮�͵�����ֵ
     %�����Na-ѡ���ķ�����vm��֮�ͣ�serial_number-·������������λ�õ��±�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (optimal < 0)
    optimal = 0;
end

%��������
n = length(m_vm);
%�������ĺ�
m = sum(m_vm);

if (optimal > m)
    optimal = m;
end

%���е�״̬
dp = zeros(n + 1, m + 1);
%��¼����
mark = zeros(n + 1, m + 1);

%��ʼ������
dp(1, 1) = 0;
for i = 2 : 1 : m + 1
    dp(1, i) =  Inf;
end

%������б������
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
%����ӽ������
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

