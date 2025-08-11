clear;clc;
path1='D:\�����ļ��б���\����\�����ļ�\WSL������ͼ\20240117��ͼ\0130�·�';%��Ƶ���·��
f=fullfile(path1,'\','240102training.avi');%��ͨ�����������·��
obj=VideoReader(f);%��ȡ��Ƶ�ļ�
numFrames=obj.NumberOfFrames;%������֡��?
FramesRate = obj.FrameRate;
SecComp = 4/30; %��ñȽ�һ�Σ���λs
framesComp = 30*SecComp;
Cssimval = [];
for k=1:framesComp:numFrames % k = 4;
    img=read(obj,k);%��ȡ��k֡ͼƬ
    img=rgb2gray(img);
    if k == 1 
        temp = img;
    else
        [Cssimval(floor(k/framesComp)), ~] = ssim(img,temp);
        temp = img;
    end
end
Cssimval0 = 100-100*Cssimval;
clearvars -except Cssimval Cssimval0 f FramesRate numFrames;
plot(Cssimval0');
Timelim = [1 length(Cssimval0)];%ʱ��Σ����ȫ������[1 length(Cssimval0)]
A = sum(Cssimval0(Timelim(1):Timelim(2))<(min(Cssimval0)+0.8));
timeA = A/length(Cssimval0); %freezing�İٷֱ�




