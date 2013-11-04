function [k, total, t_max, position] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Isomerism.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�Willian Yu
     %�� �ڣ�2013/9/1
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�1.�������ʱ����Сʱk��ȡֵ 2.����k��total�Ĺ�ϵͼ 3.����k��t_max�Ĺ�ϵͼ
     %4.���k�Ĳ�ͬȡֵ��·���������λ��
     %���룺S-���͵�����������N-Virtual Machine��������m-��������������B-���ݴ��͵��ٶȣ�
     %m_vm-ÿ̨��������VM��������u-û��·�����ķ��������������ٶȵ�������u_agent-��·�����ķ��������������ٶȵ�����
     %u_array-������u��ƫ��Ϊoffset_u��һ������u_agent_array-������u_agent��ƫ��Ϊoffset_u_agent��һ����
     %�����k-·������������total-k�Ĳ�ͬȡֵ�¶�Ӧ��VM�Ĺ�����ʱ�䣻t_max-k�Ĳ�ͬȡֵ��N��VM�к�ʱ���VM
     %position-k�Ĳ�ͬȡֵ��·���������λ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%����answer����������total��k�Ĺ�ϵͼ
total = zeros(m, 2);
%t_max����ÿ�ּ�¼ÿ��k�º�ʱ���VM��ʱ��
t_max = zeros(m, 2);
%��¼k��ͬȡֵ�µ�·������λ��
position = [];

t1 = S/B * N;

for k = 1: 1: m
    l = [];
    if (type == 1)%���ŵ����
        %����������Naֵoptimal
        optimal = round(N + (k+1)*N*S_r*n_r/(2*S) + k*N*S_r*n_r/(2*S*(n_r+k-1)) - (u-u_agent)*k*B/(2*u*u_agent));
        %�����ӽ����Ž��Na��ϣ��Ͷ�Ӧ������λ��l
        [l, Na] = NewKnapsack(m_vm, k, optimal);
    elseif (type == 2)%��������
        l_position = randperm(length(m_vm));
        l = m_vm(l_position); 
        l = l(1 : k);
        l_position = l_position(1: k);
        Na = sum(l);
    elseif (type == 3)%ȡ���k�������������
        l = sort(m_vm, 2);
        l = l(m - k + 1: m);
        Na = sum(l);
    elseif (type == 4)%ȡ��Сk�������������  
        l = sort(m_vm, 2);
        l = l(1 : k);
        Na = sum(l);
    end
    
    %ͨ����¼·��������VM���������ҵ�·������λ��
    m_vm_temp = m_vm';
    m_vm_temp = [m_vm_temp, m_vm_temp];
    for i = 1: 1: size(m_vm_temp, 1)
        m_vm_temp(i, 2) = i;
    end
    m_vm_temp = sortrows(m_vm_temp, 1);
    l = sort(l);
    
    if (type == 2)
        l = l_position;
    end

    %��ʼ����
    j = 1;
    for i = 1: 1: size(m_vm_temp, 1)
        if (j == k + 1)
            break;
        end
        if (l(1, j) == m_vm_temp(i, 1))
            l(1, j) = m_vm_temp(i, 2);
            j = j + 1;
        end
    end
    l = sort(l);
      
    %n1Ϊÿ̨·������Ҫ��ת����vm��Ŀ
    n = N - Na;
    %n2Ϊ����Ҫ��ת����vm��Ŀ
    n_agent = Na;
    %t2������Ҫ��ת����vm�ȴ�����ʱ��
    t2 = (N - Na)/k * S/(N*B) * (N-Na);
    t_max_u = t1/N + t2/n;
    t3 = 0;
    for i = 1: 1: n
        index = randi([1 N]);
        t3 = t3 + S/N/u_array(index);
        if (t1/N + t2/n + S/N/u_array(index) > t_max_u)
            t_max_u = t1/N + t2/n + S/N/u_array(index);
        end
    end
    t_max_u_agent = t1/N;
    for i = 1: 1: n_agent
        index = randi([1 N]);
        t3 = t3 + S/N/u_agent_array(index);
        if (t1/N + S/N/u_agent_array(index) > t_max_u_agent)
            t_max_u_agent = t1/N + S/N/u_agent_array(index);
        end
    end
    t_map = t1 + t2 + t3;
    %�������������ʱ��
    t_max(k, :) = [k, max(t_max_u, t_max_u_agent)];
    
    % ����ֲ���reducer��λ��
    reducer_position = randi(m, n_r, 1);
    reducer_position = sort(reducer_position);
    reducer_position = [reducer_position, zeros(n_r, 1)];
    l = sort(l);
    j = 1;
    for i = 1: 1: size(reducer_position, 1)
        if (j > size(l, 1))
            break;
        end
        if (reducer_position(i, 1) == l(j, 1))
            reducer_position(i, 2) = 1;
        elseif (reducer_position(i, 1) > l(j, 1))
            j = j + 1;
            i = i - 1;
        elseif (reducer_position(i, 1) < l(j, 1))
            continue;
        end
    end 
    % ����ҳ��˹���agent��λ��
    t = randi(k, 1, 1);
    work_agent_position = l(randperm(t));
    work_agent_position = work_agent_position(1:t);
    % ͳ�ƹ�����agent����server�ϵ�vm��
    Nb = 0;
    for i = 1: 1: size(work_agent_position, 1)
       Nb = Nb + m_vm(work_agent_position(i));
    end
    % ͳ������server��û��agent��reducer��
    isFind = 0;
    n_r_noagent = 0;
    for i = 1: 1: n_r
       if (reducer_position(i, 2) == 0)
           n_r_noagent = n_r_noagent + 1;
           isFind = 1;
       end
    end
    % �����ʱ��
    t_reduce = (N-Na)*S_r*n_r/(k*B) + (N*S_r*n_r/B - S_r/B*Nb) + N*S_r/B*n_r_noagent + N*S_r*n_r/u;
    t_max(k, 2) = t_max(k, 2) + (N-Na)*S_r/(k*B) + N*S_r*n_r + N*S_r/u;
    if (isFind == 1)
        t_max(k, 2) = t_max(k, 2) + N*S_r/B;
    end
    % t_reduce = ((2*k+1)*N-(k+1)*Na)*S_r*n_r/(k*B) - Na*S_r*n_r/(B*(n_r+k-1))+N*S_r*n_r/u;
    
    total(k, :) = [k, t_map + t_reduce];
    %��¼��ͬkֵ��·������λ��
    temp = zeros(1, m-k);
    l = [l, temp];
    position = [position; l];
end

%�ҳ�ʱ����Сʱ��Ӧ��k
t_min = total(1, 2);
k = 1;
for i = 1 : 1 : m                    
    if (t_min > total(i, 2)) 
        t_min = total(i, 2);
        k = i;
    end
end

end

