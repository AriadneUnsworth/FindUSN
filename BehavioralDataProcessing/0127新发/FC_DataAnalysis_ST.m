clear;clc;
path1='D:\翻译文件夹备份\杂物\发送文件\WSL课题整图\20240117整图\0130新发';%视频存放路径
f=fullfile(path1,'\','240102training.avi');%用通配符构造完整路径
obj=VideoReader(f);%读取视频文件
numFrames=obj.NumberOfFrames;%计算总帧数?
FramesRate = obj.FrameRate;
SecComp = 4/30; %多久比较一次，单位s
framesComp = 30*SecComp;
Cssimval = [];
for k=1:framesComp:numFrames % k = 4;
    img=read(obj,k);%读取第k帧图片
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
Timelim = [1 length(Cssimval0)];%时间段，如果全长就填[1 length(Cssimval0)]
A = sum(Cssimval0(Timelim(1):Timelim(2))<(min(Cssimval0)+0.8));
timeA = A/length(Cssimval0); %freezing的百分比




