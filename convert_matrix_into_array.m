function [newArray] = convert_matrix_into_array(matrix,NrDebitPackages)
    %this routine has been designed in order to transform the information
    %related to the packages created by banks (and stored in matrices 
    %[b x max(number of packages per bank)]) into arrays that can be more 
    %easely managed.


    newArray = zeros(1,sum(NrDebitPackages));
    for i=1:size(matrix,1)
        if i==1
            newArray(1:NrDebitPackages(i)) = matrix(i,1:NrDebitPackages(i));
        else
            newArray(NrDebitPackages(i-1)+1:NrDebitPackages(i-1)+NrDebitPackages(i)) = matrix(i,1:NrDebitPackages(i));
        end
    end
end