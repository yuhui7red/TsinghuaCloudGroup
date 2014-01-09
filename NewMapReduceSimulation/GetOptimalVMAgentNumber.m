function [optimal] = GetOptimalVMAgentNumber(map_data, vm_number, agent_number, r, u, speed, reduce_data, reducer_number)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetOptimalVMAgentNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/8
     %修改人：
     %日 期：
     %功能：利用模型公式求出最优的vm数目
     %3.获得k的不同取值下路由器的最佳位置
     %输入：map_data-发送的总数据量；r-有agent后vm的性能；u-无agent时vm的性能总和；vm_number-Virtual Machine的数量
     %agent_number-云平台中agent的数量；server_info-第一列：server id第二列：每台server上vm的数量；
     %reduce_data-reduce阶段的数据量；reducer_number-reduce阶段的数据
     %输出：optimal-最优的vm数；
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

