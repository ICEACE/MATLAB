if isempty(NrDebitPackages) == 0


    %----------
    %PLEASE NOTE THAT THIS PART OF THE CODE HAS BEEN DEVELOPED IN ORDER TO WORK
    %PROPERLY WITH THE PREVIOUSLY IMPLEMENTED FRAMEWORK AND - CONSEQUENTLY -
    %WITH THE AIM OF BEEN COMPLIANT JUST WITH THE HYPOTHESES USED IN THAT PIECE
    %OF CODE. IN PARTICULAR THE CONSTRAINT OF HAVING JUST 1 MORTGAGE PER
    %HOUSEHOLD (IN PARTICULAR STIPULATED WITH HIS/HER PRIMARY BANK) HAS BEEN
    %CONSIDERED.
    %-----------

    %1) the bank has to verify whether the considered mortgage was included in
    %one or more packages or not.

    %compositionOfPackagesToConsider is an array that indicates for each package
    %that has been created - by the primary bank of household "h" - which is the
    %percentage of the mortgage of that household included in it.
    compositionOfPackagesToConsider = zeros(1,size(Banks.Packages(...
        Households.MortgageArray{1,h}.PrimeBankId,:),2));

    for k=1:NrDebitPackages(Households.MortgageArray{1,h}.PrimeBankId)
        compositionOfPackagesToConsider = Banks.Packages(...
            Households.MortgageArray{1,h}.PrimeBankId,k).composition(h)';
    end

    %packagesToConsider is an array that indicates which packages contain a
    %higher than 0 percentage of the mortgage of household "h".
    packagesToConsider = find(compositionOfPackagesToConsider);


    %2) if that mortgage has been included in at least 1 package then a certain
    %amount of money is trasferred from the bank to the fund that bought the
    %related package.
    if isempty(packagesToConsider) == 0
        for k=1:length(packagesToConsider)
            
            if notAvailablePackages(packagesToConsider(k)) == 0

                %for each package described above we have to determine which fund
                %is currently holding it.
                holdingFund = findPackageOwner(Households.MortgageArray{1,h}.PrimeBankId,packagesToConsider(k), Funds, NrAgents.Funds);
                
                if holdingFund > 0

                    %the bank has to transfer the money to holdingFund considering the
                    %percentage of mortgage included in that packages.
                    percentageToBeTransferred = Banks.Packages(Households.MortgageArray{1,h}.PrimeBankId, packagesToConsider(k)).composition(h);

                    %the money transfer is executed:

                    %first the previously accounted earnings (and the increase of
                    %liquidity) for the bank has to be corrected:
                    Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId) = Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId)...
                        - Households.HousingInterestPayment(h)*percentageToBeTransferred;


                    %second, the money has to be transferred to the holdingFund:
                    Funds.data(holdingFund).earnings = Funds.data(holdingFund).earnings ...
                        + Households.HousingPayment(h)*percentageToBeTransferred;
                    
                    Funds.data(holdingFund).availableCash = Funds.data(holdingFund).availableCash ...
                        + Households.HousingPayment(h)*percentageToBeTransferred;

            %--------------------------------------------------------------------------        
            %UNCOMMENT THIS BLOCK OF CODE (AND USE THE FUNCTION checkRepayedMortgage)
            %IF YOU WANT TO PLACE A FLAG ON THE PACKAGES COMPLETELY REPAYED BY THE
            %RELATED HOUSEHOLDS. IT SHOULDN'T BE NECESSARY CONSIDERING THE CURRENT
            %IMPLEMENTATION.
            %--------------------------------------------------------------------------
                    %third, if the considered package has been completely repayed by
                    %the related households it has to be deleted:        
                    isCompletelyRepayed = checkRepayedMortgage(Households.MortgageArray{1,h}.PrimeBankId, packagesToConsider(k), Banks, NrAgents.Households, Households);

                    if isCompletelyRepayed == 1
                        notAvailablePackages(Households.MortgageArray{1,h}.PrimeBankId, packagesToConsider(k)) = 1;
                    end
            %--------------------------------------------------------------------------
                end
            end
        end 
        
    end



    %Households.HousingInterestPayment(h)
    %Households.HousingPaymentOfPrincipal(h)

end