A=xlsread('power.xlsx');
[r,c]=size(A);

for i=1:c
    temp=A(:,i);
    
    ymax=1;%Ҫ��һ�ķ�Χ�����ֵ
    ymin=0;  %Ҫ��һ�ķ�Χ����Сֵ
    xmax=max(temp);%��������������
    xmin=min(temp);%������������С��
    for j=1:r
        B(j,i)=((ymax-ymin)*(temp(j)-xmin)/(xmax-xmin)+ymin);
    end
    B(:,i)=B(:,i)-B(1,i);
end
plot(B);
axis([1 12 -1 1]);

for j=1:(r-1)
    C(j,:)=B(j+1,:)-B(j,:);
end
figure;
imagesc(C);
colorbar
colormap jet
caxis([-1 1]);