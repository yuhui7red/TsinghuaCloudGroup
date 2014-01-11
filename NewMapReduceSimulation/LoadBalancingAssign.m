function [vm_assignment] = LoadBalancingAssign(r_vm_u, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LoadBalancingAssign.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/3
     %修改人：
     %日 期：
     %功能：load balancing algorithm来指定每台agent负责哪些server上没有agent的vm
     %输入：r_vm_u-所在server上没有agent的vm性能；k-路由器的数量
     %输出：vm_assignment(:, 1)每台agent负责多少台vm；vm_assignment(:, 2)每台agent负责vm的u和
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vm_assignment = zeros(k, 1);
vm_assignment = [vm_assignment, vm_assignment];
r_vm_u = sort(r_vm_u, 'descend');

for i = 1: 1: min(k, r_vm_u)
    vm_assignment(i, 1) = vm_assignment(i, 1) + 1;
    vm_assignment(i, 2) = vm_assignment(i, 2) + r_vm_u(i);
end

for i = k+1: 1: length(r_vm_u)
    [Max, index] = min(vm_assignment(:, 2));
    vm_assignment(index, 1) = vm_assignment(index, 1) + 1;
    vm_assignment(index, 2) = vm_assignment(index, 2) + r_vm_u(i);
end

end

