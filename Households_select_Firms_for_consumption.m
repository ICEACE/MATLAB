
%% the queue of households for purchasing goods is randomized
IdxAgents_new = randperm(NrAgents.Households);

for h=IdxAgents_new
    
    WeeklyConsumptionBudget = (Households.LaborIncome(h)/TimeConstants.NrWeeksInMonth) + ...
        Households.QuarterlyCapitalIncome(h)/(TimeConstants.NrWeeksInMonth*TimeConstants.NrMonthsInQuarter);

    %% firms with empty shelves are excluded
    IdxNonEmptyShelves = find(Firms.Inventories>0);
    if numel(IdxNonEmptyShelves)==0
        break
    end
    price_min = min(Firms.price(IdxNonEmptyShelves));
    
    while(WeeklyConsumptionBudget>=price_min)   % the household can buy at least from the cheapest firm

        %% Selection of firm (among the ones with non empty shelves) where to
        %% buy. The selection is based on price discrimination
        FirmSelectionProb = (1./Firms.price(IdxNonEmptyShelves))/sum(1./Firms.price(IdxNonEmptyShelves));
        FirmSelectionProb_cumsum = cumsum(FirmSelectionProb);
        x = rand;
        IdxSelectedFirm_tmp = min(find((FirmSelectionProb_cumsum-x)>=0));
        IdxSelectedFirm = IdxNonEmptyShelves(IdxSelectedFirm_tmp);

        price = Firms.price(IdxSelectedFirm);
        if WeeklyConsumptionBudget>=price
            demand = floor(WeeklyConsumptionBudget/price);
            supply = Firms.Inventories(IdxSelectedFirm);
            trade = min(demand,supply);
             
            %% Accounting of sale on the side of the firm
            Firms.Inventories(IdxSelectedFirm) = Firms.Inventories(IdxSelectedFirm) - trade;
            Firms.Revenues(IdxSelectedFirm) = Firms.Revenues(IdxSelectedFirm) + trade*price;
            Firms.Liquidity(IdxSelectedFirm) = Firms.Liquidity(IdxSelectedFirm) + trade*price;
            
            %% Accounting of purchase on the side of the household
            Households.Liquidity(h) = Households.Liquidity(h) - trade*price;
            WeeklyConsumptionBudget = WeeklyConsumptionBudget - trade*price;
        end
        
        %% (again) firms with empty shelves are excluded
        IdxNonEmptyShelves = find(Firms.Inventories>0);
        if numel(IdxNonEmptyShelves)==0
            break
        end
        price_min = min(Firms.price(IdxNonEmptyShelves));

    end


    clear WeeklyConsumptionBudget x IdxSelectedFirm IdxSelectedFirm_tmp price_min

end
