for h=1:NrAgents.Households
   
    if Households.Liquidity(h) > 0 %he/she might consider to invest some money in one of the funds
       
        %he/she decides the amount of money to invest:
        
        %----------
        % HP: the household will invest a percentage of his/her savings
        % that is almost randomly chosen.
        %----------
        
        %this almost randomly chosen percentage will depend on how rich the
        %household is, i.e. it will be higher if the household is rich and
        %lower in the opposite case.
        
        %in order to determine whether he/she is rich or not we will
        %consider the amount of his/her savings compared to the ones of the
        %person that present the maximum amount of them.
        %DIFFERNT WAYS FOR LINKING WEALTH AND PERCENTAGE OF SAVINGS
        %INVESTED CAN BE DEVELOPED MODIFYING THE FOLLOWING PIECE OF CODE.
        %----------
        savingRatio = Households.Liquidity(h)/max(Households.Liquidity);
        investedSum = 0.5*rand()*savingRatio*Households.Liquidity(h);
        %----------
        %the 0.5 above is used in order to limit the maximum percentage of
        %investment to the 50% of the available liquidity
        %----------
        
        %he/she decides in which fund to invest:
        
        %----------
        % HP: each household will invest his/her money just in 1 fund. 
        % If you want to remove this hypothesis just remove the following 
        % if statement:
        %----------
        
        if sum(Households.fundsInvestments(:,h)) > 0 %i.e. if the household has already invested some money in 1 fund:
            chosenFund = find(Households.fundsInvestments(:,h));
        else %in the opposite case he/she will choose among the funds visible to him/her
            chosenFund = Household_choose_fund(Households.riskPropensity(h), NrAgents.Funds, NrVisibleFunds, Funds);
        end
        
        %the money transfer is processed and all the structures related to
        %the fund investment have to be update:
        
        Funds.data(chosenFund).capital(h) = Funds.data(chosenFund).capital(h) + investedSum;
        Funds.data(chosenFund).availableCash = Funds.data(chosenFund).availableCash + investedSum;
        
        %Households.Savings(h) = Households.Savings(h) - investedSum;
        Households.Liquidity(h) = Households.Liquidity(h) - investedSum;
        Households.fundsInvestments(chosenFund,h) = Households.fundsInvestments(chosenFund,h) + investedSum;
         
    end
end