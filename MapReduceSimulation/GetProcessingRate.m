function [data] = GetProcessingRate(N, m, max, min)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�Willian Yu
     %�� �ڣ�2013/8/30
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ����N������Ϊm��������[min, max]�ڵ���
     %���룺N-Ҫ��������������m-N������������max-���������Ͻ磻min-���������½磻
     %�����data-��õ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%����N����Χ��[min, max]�ڵ���
data = (max-min)*rand(N, 1) + min;
judge = 0;
while (judge == 0)
	judge = 1;
    %������N����������Ϊm
    tmpsum 	= sum(data);
    tmpm 	= tmpsum / N;
    value = m / tmpm;
    data = data.*value;	
    %�ж���N�����Ƿ񶼻���[min, max]��
    for i = 1 : 1 : N
        if data(i) > max
            data(i) = (max-min)*rand(1, 1) + min;
            judge = 0;
        elseif data(i) < min
            data(i) = (max-min)*rand(1, 1) + min;
            judge = 0;
        end
    end
end
end

