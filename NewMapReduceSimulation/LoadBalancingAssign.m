function [vm_assignment] = LoadBalancingAssign(r_vm_u, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LoadBalancingAssign.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�load balancing algorithm��ָ��ÿ̨agent������Щserver��û��agent��vm
     %���룺r_vm_u-����server��û��agent��vm���ܣ�k-·����������
     %�����vm_assignment(:, 1)ÿ̨agent�������̨vm��vm_assignment(:, 2)ÿ̨agent����vm��u��
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

