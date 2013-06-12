function sumOfSecuredCredits = calculateSecuredCredits(bankId, Banks, Funds,NrFunds,NrDebitPackages,Households,NrHouseholds)
    sumOfSecuredCredits = 0;
    
    if isempty(NrDebitPackages) == 0
        
        mortgagesOfThatBank = zeros(1, NrHouseholds);
        for k=1:NrHouseholds
            mortgagesOfThatBank(k) = (Households.MortgageArray{k}.PrimeBankId == bankId)*Households.TotalMortgage(k);
        end
        
        for p=1:NrDebitPackages(bankId)
            if findPackageOwner(bankId,p,Funds,NrFunds) > 0
                if isempty(Banks.Packages(bankId, p)) == 0
                    sumOfSecuredCredits = sumOfSecuredCredits + (Banks.Packages(bankId,p).composition')*(mortgagesOfThatBank');
                end
            end
        end 
    end
end