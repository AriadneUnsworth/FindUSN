function [Energy]=Sum_of_Squares(k)
len=length(k);
Energy=0;
temp=k-min(k);
for i=1:len
    Energy=Energy+temp(i).*temp(i);
end
 