function [optimal] = GetOptimalVMAgentNumber(map_data, vm_number, agent_number, r, u, speed, reduce_data, reducer_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetOptimalVMAgentNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/8
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�����ģ�͹�ʽ������ŵ�vm��Ŀ
     %3.���k�Ĳ�ͬȡֵ��·���������λ��
     %���룺map_data-���͵�����������r-��agent��vm�����ܣ�u-��agentʱvm�������ܺͣ�vm_number-Virtual Machine������
     %agent_number-��ƽ̨��agent��������server_info-��һ�У�server id�ڶ��У�ÿ̨server��vm��������
     %reduce_data-reduce�׶ε���������reducer_number-reduce�׶ε�����
     %�����optimal-���ŵ�vm����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = map_data;
N = vm_number;
k = agent_number;
B = speed;
Sr = reduce_data;
nr = reducer_number;

strS = sprintf('%s%d', 'S=', S);
strN = sprintf('%s%d', 'N=', N);
strk = sprintf('%s%d', 'k=', k);
strr = sprintf('%s%d', 'r=', r);
strSr = sprintf('%s%d', 'Sr=', Sr);
strnr = sprintf('%s%d', 'nr=', nr);
strB = sprintf('%s%d', 'B=', B);
stru = sprintf('%s%d', 'u=', u);

[x1 x2 x3 x4 x5 x6 x7 x8 x9] = solve('((-N + Na)*r*S)/(B*k*N) - ((N - Na*r)*S)/(B*k*N) + (2*nr*Sr)/(B*(-1 + k + nr)) + (nr*(-1 - k*r)*Sr)/(B*k*r) + (N^2*(1 - r)*S*u)/(N*u - Na*(1 - r)*u)^2 = 0 ', ...
    strS, strN, strk, strr, strSr, strnr, strB, stru);

optimal = -1;
Existed = [S, N, k, r, Sr, nr, B, u];
if (ismember(subs(x1(1)), Existed) == 0) 
    optimal = subs(x1(1));
elseif (ismember(subs(x2(1)), Existed) == 0) 
    optimal = subs(x2(1));
elseif (ismember(subs(x3(1)), Existed) == 0) 
    optimal = subs(x3(1));
elseif (ismember(subs(x4(1)), Existed) == 0) 
    optimal = subs(x4(1));
elseif (ismember(subs(x5(1)), Existed) == 0) 
    optimal = subs(x5(1));
elseif (ismember(subs(x6(1)), Existed) == 0) 
    optimal = subs(x6(1));
elseif (ismember(subs(x7(1)), Existed) == 0) 
    optimal = subs(x7(1));
elseif (ismember(subs(x8(1)), Existed) == 0) 
    optimal = subs(x8(1));
elseif (ismember(subs(x9(1)), Existed) == 0) 
    optimal = subs(x9(1));
end

end

