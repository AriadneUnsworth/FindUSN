%%
[sampling_num,cell_num]=size(x0);
view_point=8;

%��ʼ���ṹ������
clear peak_test;
peak_test.peak_imfo=[];
peak_test.mean=0;
peak_test.stu=0;
peak_test.old_sequence=[];
peak_test.new_sequence=[];
peak_test=repmat(peak_test,[cell_num view_point]);

%��ֵɸѡ���������ã�
params.upper=3;       %��ߵ����params.upper����׼��
params.lower=2;       %��͵����params.lower����׼��
params.duration=200;  %����ʱ�䣬��λms
params.duration=params.duration/50+2;



%%
%before
for i=1:cell_num
    peak=wy_peak_test(x0(:,i),params);
    peak_test(i,1)=peak;
end
% %30min
% for i=1:cell_num
%     peak=wy_peak_test(x1(:,i),params);
%     peak_test(i,2)=peak;
% end
% %2h
% for i=1:cell_num
%     peak=wy_peak_test(x2(:,i),params);
%     peak_test(i,3)=peak;
% end
% %24h
% for i=1:cell_num
%     peak=wy_peak_test(x3(:,i),params);
%     peak_test(i,4)=peak;
% end
% %7d
% for i=1:cell_num
%     peak=wy_peak_test(x4(:,i),params);
%     peak_test(i,5)=peak;
% end
% %14d
% for i=1:cell_num
%     peak=wy_peak_test(x5(:,i),params);
%     peak_test(i,6)=peak;
% end
% %21d
% for i=1:cell_num
%     peak=wy_peak_test(x6(:,i),params);
%     peak_test(i,7)=peak;
% end
% %28d
% for i=1:cell_num
%     peak=wy_peak_test(x7(:,i),params);
%     peak_test(i,8)=peak;
% end
clear i peak

%%
%GetEnergy
EnergyMatrix=GetEnergy(peak_test);
for i=1:cell_num  
    a=rand();b=rand();c=rand();
    semilogy(EnergyMatrix(i,:),'Color',[a b c]);
    hold on;
end