function [Funds, Households, disinvestedMoney] = householdExitsFund(Funds, Households, h, neededMoney)

    %--------------
    %NOTE: if further modifications will allow the households to invest in 
    %more than one fund the following piece of code will need to be 
    %modified (and a logic for defining from which fund withdraw the money 
    %will be needed).
    %--------------
    
    disinvestedMoney = 0;
    
    %we have to verify in which fund the household invested in:
    f = find(Households.fundsInvestments(:,h));
    %f = Households.fundsInvestments(:,h) > 0;
    
    
    %we have to update the information related to:
    %1) Households.fundInvestments;
    %2) Households.Liquidity;
    %3) Funds.Capital;
    %4) Funds.availableCash;
    
    if sum(f) > 0
        
        moneyToTransfer = max(0, min([Households.fundsInvestments(f,h) , neededMoney, Funds.data(1,f).availableCash]));

        Households.fundsInvestments(f,h) = Households.fundsInvestments(f,h) - moneyToTransfer;
        Households.Liquidity = Households.Liquidity + moneyToTransfer;

        Funds.data(1,f).capital(h) = Funds.data(1,f).capital(h) - moneyToTransfer;
        Funds.data(1,f).availableCash = Funds.data(1,f).availableCash - moneyToTransfer; 
        
        disinvestedMoney = moneyToTransfer;
    end 
end