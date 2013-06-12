%% firms with empty shelves are excluded
IdxNonEmptyShelves = find(Firms.Inventories>0);
if numel(IdxNonEmptyShelves)>0
    price_min = min(Firms.price(IdxNonEmptyShelves));

    %% the queue of households for purchasing goods is randomized
    IdxAgents_new = randperm(NrAgents.Households);

    for h=IdxAgents_new
        QuarterlyCashOnHand = ...
            sum(Households.QuarterlyLaborIncome(:,h))+Households.QuarterlyCapitalIncome(h)-Households.HousingPayment(h);
        WealthEffect = (Households.TotalAssetsDelta(h)*Households.Parameters.WealthEffect0)/TimeConstants.NrWeeksInQuarter;
        
        QuarterlyConsumptionBudget = QuarterlyCashOnHand+0.1*(Households.Liquidity(h)-1*QuarterlyCashOnHand);
         WeeklyConsumptionBudget = WealthEffect + QuarterlyConsumptionBudget/TimeConstants.NrWeeksInQuarter;
         
        WeeklyConsumptionBudget = min(WeeklyConsumptionBudget,Households.Liquidity(h)); % + Households.Savings(h)); 
         WeeklyConsumptionBudget = max(0,WeeklyConsumptionBudget);
         
 %       WeeklyConsumptionBudget = WealthEffect + (Households.LaborIncome(h)/TimeConstants.NrWeeksInMonth) + ...
%            (Households.QuarterlyCapitalIncome(h)-Households.HousingPayment(h))/(TimeConstants.NrWeeksInMonth*TimeConstants.NrMonthsInQuarter);
%        WeeklyConsumptionBudget = (Households.LaborIncome(h)/TimeConstants.NrWeeksInMonth + (Households.QuarterlyCapitalIncome(h)-Households.HousingPayment(h))./(TimeConstants.NrMonthsInQuarter*TimeConstants.NrWeeksInMonth));
            %min(Households.Liquidity(h)/TimeConstants.NrWeeksInMonth,(1-HousingOptimalExp0)*Households.LaborIncome(h)/TimeConstants.NrWeeksInMonth + Households.QuarterlyCapitalIncome(h)/(TimeConstants.NrMonthsInQuarter*TimeConstants.NrWeeksInMonth)); % Households.Liquidity(h)/4; % The division by 4 is because households
        % spread their budget (made by their liquid wealth) over the entir
        % emonth (made by 4 weeks)
        
        
        
        
        while(WeeklyConsumptionBudget>=price_min)   % the household can buy at least from the cheapest firm

            %% Selection of firm (among the ones with non empty shelves) where to
            %% buy. The selection is based on price discrimination
            FirmSelectionProb = (1./Firms.price(IdxNonEmptyShelves))/sum(1./Firms.price(IdxNonEmptyShelves));
            FirmSelectionProb_cumsum = cumsum(FirmSelectionProb);
            x = rand;
            IdxSelectedFirm_tmp = min(find((FirmSelectionProb_cumsum-x)>=0));
            IdxSelectedFirm = IdxNonEmptyShelves(IdxSelectedFirm_tmp);

            price = Firms.price(IdxSelectedFirm);
            
            if UseSecuritization == 1
                %THE FOLLOWING PIECE OF CODE HAS BEEN ADDED IN ORDER TO ALLOW THE 
                %HOUSEHOLD TO DISINVEST SOME CAPITAL FROM A FUND IN ORDER TO BE
                %ABLE TO BUY SOME COMSUMPTION GOODS
                if WeeklyConsumptionBudget < price
                    [Funds, Households, disinvestedMoney] = householdExitsFund(Funds,Households,h,price);
                    if disinvestedMoney > 0
                        %Households.Liquidity(idx_buyer) = Households.Liquidity(idx_buyer) - disinvestedMoney;
                        %Households.Savings(idx_buyer) = Households.Savings(idx_buyer) + disinvestedMoney;
                        WeeklyConsumptionBudget = WealthEffect + QuarterlyConsumptionBudget/TimeConstants.NrWeeksInQuarter;
                        WeeklyConsumptionBudget = min(WeeklyConsumptionBudget,Households.Liquidity(h)); 
                        WeeklyConsumptionBudget = max(0,WeeklyConsumptionBudget);
                    end
                end
            end
            
            if WeeklyConsumptionBudget>=price
                demand = floor(WeeklyConsumptionBudget/price);
                supply = Firms.Inventories(IdxSelectedFirm);
                trade = min(demand,supply);

                %% Accounting of sale on the side of the firm
                Firms.Inventories(IdxSelectedFirm) = Firms.Inventories(IdxSelectedFirm) - trade;
                Firms.MonthlySales(FirmsSalesMemory,IdxSelectedFirm) = ...
                    Firms.MonthlySales(FirmsSalesMemory,IdxSelectedFirm) + trade;
                Firms.Revenues(IdxSelectedFirm) = Firms.Revenues(IdxSelectedFirm) + trade*price;
                Firms.Liquidity(IdxSelectedFirm) = Firms.Liquidity(IdxSelectedFirm) + trade*price;
                

                %% Accounting of purchase on the side of the household
                Households.Liquidity(h) = Households.Liquidity(h) - trade*price;
                WeeklyConsumptionBudget = WeeklyConsumptionBudget - trade*price;
                
                clear demand supply trade
            end

            %% (again) firms with empty shelves are excluded
            IdxNonEmptyShelves = find(Firms.Inventories>0);
            if numel(IdxNonEmptyShelves)==0
                break
            end
            price_min = min(Firms.price(IdxNonEmptyShelves));

        end

        clear WeeklyConsumptionBudget x IdxSelectedFirm IdxSelectedFirm_tmp WealthEffect

    end
else
    fprintf('\n\t day: %d All firms have empty shelves !!',d)
   % warning('All firms have empty shelves !!')
end

Firms.SoldOut(find(Firms.Inventories==0)) = 1;
