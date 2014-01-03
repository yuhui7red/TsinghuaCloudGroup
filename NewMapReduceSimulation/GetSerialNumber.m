function [serial_number] = GetSerialNumber(m_vm, k, L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetSerialNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/3
     %修改人：
     %日 期：
     %功能：一组数在另一组数中的下标位置
     %输入：m_vm-每台服务器上VM的数量；k-路由器的数量；L-路由器所在的最优位置
     %输出：serial_number-路由器所在最有位置的下标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%通过记录路由器所在VM的数量来找到路由器的位置
m_vm_temp = m_vm';
m_vm_temp = [m_vm_temp, m_vm_temp];
for i = 1: 1: size(m_vm_temp, 1)
    m_vm_temp(i, 2) = i;
end
m_vm_temp = sortrows(m_vm_temp, 1);
serial_number = sort(L);
%开始搜索
j = 1;
for i = 1: 1: size(m_vm_temp, 1)
    if (j == k + 1)
        break;
    end
    if (serial_number(1, j) == m_vm_temp(i, 1))
        serial_number(1, j) = m_vm_temp(i, 2);
        j = j + 1;
    end
end
serial_number = sort(serial_number);

end

