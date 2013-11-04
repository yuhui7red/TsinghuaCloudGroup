function [k, total, t_max, position] = Isomerism(S, N, m, m_vm, B, u, u_agent, u_array, u_agent_array, S_r, n_r, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Isomerism.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：Willian Yu
     %日 期：2013/9/1
     %修改人：
     %日 期：
     %功能：1.求出当总时间最小时k的取值 2.做出k与total的关系图 3.做出k与t_max的关系图
     %4.获得k的不同取值下路由器的最佳位置
     %输入：S-发送的总数据量；N-Virtual Machine的数量；m-服务器的数量；B-数据传送的速度；
     %m_vm-每台服务器上VM的数量；u-没有路由器的服务器处理数据速度的期望；u_agent-有路由器的服务器处理数据速度的期望
     %u_array-期望是u，偏差为offset_u的一组数；u_agent_array-期望是u_agent，偏差为offset_u_agent的一组数
     %输出：k-路由器的数量；total-k的不同取值下对应的VM的过程总时间；t_max-k的不同取值下N个VM中耗时最长的VM
     %position-k的不同取值下路由器的最佳位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%矩阵answer的用于做出total和k的关系图
total = zeros(m, 2);
%t_max用于每种记录每种k下耗时最长的VM的时间
t_max = zeros(m, 2);
%记录k不同取值下的路由器的位置
position = [];

t1 = S/B * N;

for k = 1: 1: m
    l = [];
    if (type == 1)%最优的情况
        %求出最理想的Na值optimal
        optimal = round(N + (k+1)*N*S_r*n_r/(2*S) + k*N*S_r*n_r/(2*S*(n_r+k-1)) - (u-u_agent)*k*B/(2*u*u_agent));
        %求出最接近最优解的Na组合，和对应的物理位置l
        [l, Na] = NewKnapsack(m_vm, k, optimal);
    elseif (type == 2)%随机的情况
        l_position = randperm(length(m_vm));
        l = m_vm(l_position); 
        l = l(1 : k);
        l_position = l_position(1: k);
        Na = sum(l);
    elseif (type == 3)%取最大k个服务器的情况
        l = sort(m_vm, 2);
        l = l(m - k + 1: m);
        Na = sum(l);
    elseif (type == 4)%取最小k个服务器的情况  
        l = sort(m_vm, 2);
        l = l(1 : k);
        Na = sum(l);
    end
    
    %通过记录路由器所在VM的数量来找到路由器的位置
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

    %开始搜索
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
      
    %n1为每台路由器需要被转发的vm数目
    n = N - Na;
    %n2为不需要被转发的vm数目
    n_agent = Na;
    %t2所有需要被转发的vm等待的总时间
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
    %获得最大虚拟机的时间
    t_max(k, :) = [k, max(t_max_u, t_max_u_agent)];
    
    % 随机分布了reducer的位置
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
    % 随机找出了工作agent的位置
    t = randi(k, 1, 1);
    work_agent_position = l(randperm(t));
    work_agent_position = work_agent_position(1:t);
    % 统计工作的agent所在server上的vm数
    Nb = 0;
    for i = 1: 1: size(work_agent_position, 1)
       Nb = Nb + m_vm(work_agent_position(i));
    end
    % 统计所在server上没有agent的reducer数
    isFind = 0;
    n_r_noagent = 0;
    for i = 1: 1: n_r
       if (reducer_position(i, 2) == 0)
           n_r_noagent = n_r_noagent + 1;
           isFind = 1;
       end
    end
    % 算出总时间
    t_reduce = (N-Na)*S_r*n_r/(k*B) + (N*S_r*n_r/B - S_r/B*Nb) + N*S_r/B*n_r_noagent + N*S_r*n_r/u;
    t_max(k, 2) = t_max(k, 2) + (N-Na)*S_r/(k*B) + N*S_r*n_r + N*S_r/u;
    if (isFind == 1)
        t_max(k, 2) = t_max(k, 2) + N*S_r/B;
    end
    % t_reduce = ((2*k+1)*N-(k+1)*Na)*S_r*n_r/(k*B) - Na*S_r*n_r/(B*(n_r+k-1))+N*S_r*n_r/u;
    
    total(k, :) = [k, t_map + t_reduce];
    %记录不同k值下路由器的位置
    temp = zeros(1, m-k);
    l = [l, temp];
    position = [position; l];
end

%找出时间最小时对应的k
t_min = total(1, 2);
k = 1;
for i = 1 : 1 : m                    
    if (t_min > total(i, 2)) 
        t_min = total(i, 2);
        k = i;
    end
end

end

