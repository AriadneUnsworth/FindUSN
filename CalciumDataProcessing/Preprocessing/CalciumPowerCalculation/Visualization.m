A=xlsread('power.xlsx');
[r,c]=size(A);

for i=1:c
    temp=A(:,i);
    
    ymax=1;%要归一的范围的最大值
    ymin=0;  %要归一的范围的最小值
    xmax=max(temp);%所有数据中最大的
    xmin=min(temp);%所有数据中最小的
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