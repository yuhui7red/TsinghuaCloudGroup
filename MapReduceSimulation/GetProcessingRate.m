function [data] = GetProcessingRate(N, m, max, min)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GetNumber.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：Willian Yu
     %日 期：2013/8/30
     %修改人：
     %日 期：
     %功能：获得N个期望为m，在区间[min, max]内的数
     %输入：N-要生成数的数量；m-N个数的期望；max-这组数的上界；min-这组数的下界；
     %输出：data-获得的数组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%生成N个范围在[min, max]内的数
data = (max-min)*rand(N, 1) + min;
judge = 0;
while (judge == 0)
	judge = 1;
    %调整这N个数的期望为m
    tmpsum 	= sum(data);
    tmpm 	= tmpsum / N;
    value = m / tmpm;
    data = data.*value;	
    %判断这N个数是否都还在[min, max]内
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

