function isRepayed = checkRepayedMortgage(bankId, packageId, Banks, NrHouseholds, Households)
    
    %the composition of the package has to be analysed:
    mortgageList = find(Banks.Packages(bankId,packageId).composition);
    
    isRepayed = 1;
    
    
    mortgagesOfThatBank = zeros(1, NrHouseholds);
    for k=1:NrHouseholds
        mortgagesOfThatBank(k) = (Households.MortgageArray{k}.PrimeBankId == bankId)*Households.TotalMortgage(k);
    end
    
    
    if (Banks.Packages(bankId,packageId).composition')*(mortgagesOfThatBank') == 0
        isRepayed = 1;
    else
        isRepayed = 0;
    end
end