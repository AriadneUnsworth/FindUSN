function [EnergyMatrix]=GetEnergy(peak_test)
[cell_num,view_point]=size(peak_test);
EnergyMatrix=ones(cell_num,view_point);
for j=1:view_point
    for i=1:cell_num
        EnergyMatrix(i,j)=Sum_of_Squares(peak_test(i,j).new_sequence);
        if EnergyMatrix(i,j)==0
            EnergyMatrix(i,j)=1;
        end
    end
end

end

