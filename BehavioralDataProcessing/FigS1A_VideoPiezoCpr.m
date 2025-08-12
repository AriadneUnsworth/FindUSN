plot(data_PiezoMonitor(100000:200000));
% Downsampling to 7.5Hz
% 降采样到7.5,原始32k，
pktemp = [];
for i = 1 : 4911
    pktemp(i) = mean(data_PiezoMonitor((4000*(i-1)+1):(4000*i)));
end

plot(pktemp);
hold on
plot(Cssimval0);
plot(a11(:,2));

% i=8;
% figure
% plot(data_PiezoMonitor);
% plot(data_PiezoMonitor(i*90*30000:(i+1)*90*30000));
% ylim([-0.05 0.1]);
% 
% a11 = data_PiezoMonitor(i*10*30000:(i+1)*10*30000)';
% 
% tone1 = zeros(8000,1)+0.4;
% tone1(1:1778) = tone1(1:1778) +0.1;
% trace1 = zeros(8000,1)+0.7;
% trace1(1779:3378) = trace1(1779:3378) +0.1;
% shock1 = zeros(8000,1)+0.8;
% shock1(3379:3556) = shock1(3379:3556) +0.1;
% iti1 = zeros(8000,1)+0.9;
% iti1(3557:8000) = iti1(3557:8000) +0.1;
% 
% figure
% plot(a11(:,2));
% hold on 
% plot(tone1);
% plot(trace1);
% plot(shock1);
% plot(iti1);
% hold off
% 
% figure
% plot(bt);