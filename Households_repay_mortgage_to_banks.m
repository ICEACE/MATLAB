%Households_repay_mortgage_to_banks

Households.HousingPayment = zeros(1,NrAgents.Households);
Households.HousingInterestPayment = zeros(1,NrAgents.Households);

if REmarket.UseInflIndexedMortgages == 1
    OldPrice = PriceIndices.ConsumptionGoods_hist(d-TimeConstants.NrDaysInMonth);
    NewPrice = PriceIndices.ConsumptionGoods_hist(d);
    InflIndexChange = (1+(NewPrice-OldPrice)/OldPrice);
else
    RemainingQuarters = (TimeConstants.MortgageDurationDays-d+1)/TimeConstants.NrDaysInQuarter;
    PriceIndices.AnnuityFactor = (1/(PriceIndices.MortgageRate/4))-...
    1/((PriceIndices.MortgageRate/4)*(1+(PriceIndices.MortgageRate/4))^RemainingQuarters);    
end

%Housing payments of mortgages (paym. of principal + interest)
for h=1:NrAgents.Households
    
    if REmarket.UseInflIndexedMortgages == 1
        AF = FuncAnnuityFactor(Households.MortgageArray{1,h}.MaturityDay,PriceIndices.MortgageRateSpread_IIM,d);
        Households.MortgageArray{1,h}.Amount = Households.MortgageArray{1,h}.Amount.*InflIndexChange;
        Households.TotalMortgage(h) = sum(Households.MortgageArray{1,h}.Amount);
        Households.HousingPayment(h) = max(0,Households.MortgageArray{1,h}.Amount./AF);
        Households.HousingInterestPayment(h) = max(0,Households.TotalMortgage(h)*(PriceIndices.MortgageRateSpread_IIM/4));
        PriceIndices.AnnuityFactor = AF;
    else
        %Households.HousingPayment(h) = Households.HousingInterestPayment(h)...
        %    + sum(Households.MortgageArray{1,h}.PayOfPrincipal);
        Households.HousingPayment(h) = max(0,Households.TotalMortgage(h)/PriceIndices.AnnuityFactor);
        Households.HousingInterestPayment(h) = max(0,Households.TotalMortgage(h)*(PriceIndices.MortgageRate/4));
    end  
    if Households.HousingPayment(h) > REmarket.MortgageWriteOffThresh*(sum(Households.QuarterlyLaborIncome(:,h)) + ...
            Households.QuarterlyCapitalIncome(h))

        %% the housing payment is lowered to X% of quarterly income
        HousingPayment_target = REmarket.MortgageWriteOffRatio*(sum(Households.QuarterlyLaborIncome(:,h)) + ...
            Households.QuarterlyCapitalIncome(h));
        Households.HousingPayment(h) = HousingPayment_target;
        
        %% the mortgage amount is made consistent with the new housing payment
        % the new mortagage amount is set to HousingPayment_target*PriceIndices.AnnuityFactor
        MortagageReduction = Households.TotalMortgage(h)-HousingPayment_target*PriceIndices.AnnuityFactor;
        Households.TotalMortgage(h) = HousingPayment_target*PriceIndices.AnnuityFactor;
        Households.MortgageArray{1,h}.Amount = HousingPayment_target*PriceIndices.AnnuityFactor;

        %% we track memory about the cumulated amount of mortagages written off
        Households.MortgagesWrittenOff(h) =  Households.MortgagesWrittenOff(h) + MortagageReduction;
        
        %% the bank accounts are updated accordingly
        Banks.TotalMortgage(Households.MortgageArray{1,h}.PrimeBankId) = ...
            Banks.TotalMortgage(Households.MortgageArray{1,h}.PrimeBankId) - MortagageReduction;
        Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId) = ...
            Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId) - MortagageReduction;
        
    end
    
    Households.HousingPaymentOfPrincipal(h) = max(0, Households.HousingPayment(h) - Households.HousingInterestPayment(h));
    Households.Liquidity(h) = Households.Liquidity(h) - Households.HousingPayment(h);

    %Households.TotalMortgage(h) = Households.TotalMortgage(h) - sum(Households.MortgageArray{1,h}.PayOfPrincipal);
    Households.TotalMortgage(h) = Households.TotalMortgage(h) - Households.HousingPaymentOfPrincipal(h);
    %Households.MortgageArray{1,h}.Amount = Households.MortgageArray{1,h}.Amount...
    %    - Households.MortgageArray{1,h}.PayOfPrincipal;
    Households.MortgageArray{1,h}.Amount = Households.MortgageArray{1,h}.Amount...
        - Households.HousingPaymentOfPrincipal(h);
    %Banks.MortgageArray{1,Households.MortgageArray{1,h}.BanksId}.Amount(h) = ...
    %    Banks.MortgageArray{1,Households.MortgageArray{1,h}.BanksId}.Amount(h) - Households.MortgageArray{1,h}.PayOfPrincipal;
    Banks.TotalMortgage(Households.MortgageArray{1,h}.PrimeBankId) = ...
        Banks.TotalMortgage(Households.MortgageArray{1,h}.PrimeBankId) - Households.HousingPaymentOfPrincipal(h);
    Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId) = Banks.Earnings(Households.MortgageArray{1,h}.PrimeBankId)...
        + Households.HousingInterestPayment(h);
    Banks.Liquidity(Households.MortgageArray{1,h}.PrimeBankId) = ...
        Banks.Liquidity(Households.MortgageArray{1,h}.PrimeBankId) +  Households.HousingPayment(h);
        %Banks.Deposits(Households.MortgageArray{1,h}.BanksId(j)) = ...
            %Banks.Deposits(Households.MortgageArray{1,h}.BanksId(j)) - Households.HousingPayment(h);
     
end

if UseSecuritization == 1
    Banks_transfer_money_to_funds
end


%Banks deposits and liqidity corrected
%Banks.Deposits = Banks.Deposits - (Banks.TotalAssets/sum(Banks.TotalAssets))*(sum(Households.HousingPayment));
%Banks.Liquidity = Banks.Liquidity - (Banks.TotalAssets/sum(Banks.TotalAssets))*(sum(Households.HousingPayment));