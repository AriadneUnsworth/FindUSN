%function:��ֵ��⺯��
%input:ԭʼʱ������
%output:ֻ��������ʱ������
%algorithm: (1)����ʱ������ƽ��ֵ�ͱ�׼��
%           (2)���߽���
%           (3)������д���������׼���ʱ���
%           (4)ɸѡ����ʱ��С���������������ʱ��ε�ʱ���
%           (5)ɸѡ�ַ�ֵ����������׼���ʱ���


function [peak_test]=wy_peak_test(temp,params)
%%
%%%=========================ʱ�����еĻ���ͳ����=============================
%temp=x0(:,21);
up=params.upper;
low=params.lower;
time=params.duration;
len=length(temp);                     %ʱ�����г��ȼ�Ϊlen
flag=[];j=1;k=1;count=[];newtemp=temp;%��ʼ��
me=mean(temp);sd=std(temp);           %���ֵ�ͱ�׼��ֱ��¼��me��sd��

%%
%%%=================�����������׼���ʱ��ε���ʼ��ͳ���====================
%%%====================��¼��count�����ĵ�һ�к͵ڶ���=======================
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
%%%=================�����������׼���ʱ��ε���ߵ�����λ��================
%%%====================��¼��count�����ĵ����к͵�����=======================
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
%%%(1)��ֵ����4����׼��
peak=count(count(:,3)>=(up*sd),:);
%%%(2)����ʱ�����2*fs
peak=peak(peak(:,2)>time,:);

%%
%%%=========================output=========================================
ME=ones(len,1).*me;
newtemp=newtemp.*0+ME;clear ME;
[h,w]=size(peak);
for i=1:h
    newtemp(peak(i,1):(peak(i,1)+peak(i,2)-1))=temp(peak(i,1):(peak(i,1)+peak(i,2)-1));
end

%�����Ҫ���ͼ��ȥ��73~76�е�ע��
% plot((temp),'k','LineWidth',2);                          %����ԭʼʱ������ͼ
% hold on;
% plot(newtemp,'r','LineWidth',1);                         %������ʱ������ͼ
% hold on;
peak_test.peak_imfo=peak;
peak_test.mean=me;
peak_test.stu=sd;
peak_test.old_sequence=temp;
peak_test.new_sequence=newtemp;
end

