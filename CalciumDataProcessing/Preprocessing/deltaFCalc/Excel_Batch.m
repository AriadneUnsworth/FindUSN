close, clear, clc
% select directory that contain the raw ImageJ save files
cd 'E:\Data Analysis\2P Imaging\2024 June Data processing\Mice3_ACC_vgatAi9';
files = dir('*.xlsx');
for i = 1:length(files)
    file_name = files(i).name;
    data = readcell(file_name);
    col = data(1,:);
    index = zeros(1,length(col));
    for j = 1:length(col)
        flag = strncmp(col{j},'Mean',4);
        index(j) = flag;
    end
    data_mean = data(2:end,index==1);
    writecell(data_mean,[file_name(1:end-5) '_mean.xlsx']);
end