%function:峰值检测函数
%input:原始时间序列
%output:只保留尖峰的时间序列
%algorithm: (1)计算时间序列平均值和标准差
%           (2)基线矫正
%           (3)检测所有大于两倍标准差的时间段
%           (4)筛选持续时间小于三倍采样间隔的时间段的时间段
%           (5)筛选持峰值大于三倍标准差的时间段


function [peak_test]=wy_peak_test(temp,params)
%%
%%%=========================时间序列的基本统计量=============================
%temp=x0(:,21);
up=params.upper;
low=params.lower;
time=params.duration;
len=length(temp);                     %时间序列长度记为len
flag=[];j=1;k=1;count=[];newtemp=temp;%初始化
me=mean(temp);sd=std(temp);           %求均值和标准差，分别记录在me和sd中

%%
%%%=================求大于两倍标准差的时间段的起始点和长度====================
%%%====================记录在count变量的第一列和第二列=======================
for i=1:len
    newtemp(i)=temp(i)-me;
    if newtemp(i)>=low*sd
        flag(j)=i;
        j=j+1;     
    end
end

for i=1:(length(flag)-1)
    newflag(i+1)=flag(i+1)-flag(i);
end
newflag(1)=2;

for i=1:(length(newflag))
    if newflag(i)~=1;
        count(k,1)=flag(i);
        k=k+1;
    end
end
for i=1:(length(count)-1)
    count(i,2)=find(flag==count((i+1),1))-find(flag==count((i),1));
end
count((length(count)),2)=(length(flag))-find(flag==(count((length(count)),1)))+1;
count(:,2)=count(:,2)+2;
count(length(count),2)=min(count(length(count),2),(1801-count(length(count),1)));
clear i j k flag newflag;
%%%=================求大于两倍标准差的时间段的最高点和最高位置================
%%%====================记录在count变量的第三列和第四列=======================
for i=1:(length(count))
    mmax=(count(i,2)+count(i,1)-3);
    if (count(i,2)+count(i,1)-3)<(count(i,1))
        mmax=1800;
    end
    [count(i,3),I]=max(temp(count(i,1):mmax));
    count(i,4)=I+count(i,1)-1;
end
clear i I

%%
%%%(1)峰值大于4倍标准差
peak=count(count(:,3)>=(up*sd),:);
%%%(2)持续时间大于2*fs
peak=peak(peak(:,2)>time,:);

%%
%%%=========================output=========================================
ME=ones(len,1).*me;
newtemp=newtemp.*0+ME;clear ME;
[h,w]=size(peak);
for i=1:h
    newtemp(peak(i,1):(peak(i,1)+peak(i,2)-1))=temp(peak(i,1):(peak(i,1)+peak(i,2)-1));
end

%如果需要检查图像去掉73~76行的注释
% plot((temp),'k','LineWidth',2);                          %画出原始时间序列图
% hold on;
% plot(newtemp,'r','LineWidth',1);                         %画出新时间序列图
% hold on;
peak_test.peak_imfo=peak;
peak_test.mean=me;
peak_test.stu=sd;
peak_test.old_sequence=temp;
peak_test.new_sequence=newtemp;
end

