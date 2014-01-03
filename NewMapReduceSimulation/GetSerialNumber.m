function [serial_number] = GetSerialNumber(m_vm, k, L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetSerialNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ�һ��������һ�����е��±�λ��
     %���룺m_vm-ÿ̨��������VM��������k-·������������L-·�������ڵ�����λ��
     %�����serial_number-·������������λ�õ��±�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ͨ����¼·��������VM���������ҵ�·������λ��
m_vm_temp = m_vm';
m_vm_temp = [m_vm_temp, m_vm_temp];
for i = 1: 1: size(m_vm_temp, 1)
    m_vm_temp(i, 2) = i;
end
m_vm_temp = sortrows(m_vm_temp, 1);
serial_number = sort(L);
%��ʼ����
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

