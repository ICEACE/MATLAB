function fundId = findPackageOwner(bankId, packageId, Funds, NrFunds)
    fundId = 0;
    for f=1:NrFunds
        if size(Funds.data(f).packages,1) > 0 && size(Funds.data(f).packages,2) > 0 
            if Funds.data(f).packages(bankId, packageId) == 1
                fundId = f; 
                %fundId is the ID of the fund that is currently detaining 
                %that package

                break
            end 
        end
    end
end