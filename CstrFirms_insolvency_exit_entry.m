insolvent_cstrfirms = find(CstrFirms.Equity < 0.001);
%fprintf('\n Insolvent cstrfirms: %d',insolvent_cstrfirms)
for c = insolvent_cstrfirms
        %% First, write off debt
        for b = 1:NrAgents.Banks
            Idx = find(Banks.LoansArrayCstrF{1,b}.CstrFirmsId == c);
            if isempty(Idx) ~= 1
                Loans(1,b) = sum(Banks.LoansArrayCstrF{1,b}.Amount(Idx));
                Banks.LoansArrayCstrF{1,b}.Amount(Idx) = zeros(1,numel(Idx));
                Banks.TotalLoans(b) = Banks.TotalLoans(b) - Loans(1,b);
                Banks.Earnings(b) = Banks.Earnings(b) - Loans(1,b);
            end
        end
    
        %% Second, fire all but one worker, keep the one with the lowest id
        employeesremaining = min(CstrFirms.EmployeesIds{1,c});
        employees2fire = setdiff(CstrFirms.EmployeesIds{1,c},employeesremaining);
        for h = employees2fire
            Households.employer_id(h) = -1;
            Households.employer_class(h) = 0;
        end
        CstrFirms.EmployeesIds{1,c} = employeesremaining;
    
        %% Third, reset firm with FirmsEntrySize (x% of average firm) and
        %FirmsEntryInventories (one employee working for one month)
        CstrFirms.PhysicalCapital(c) = CstrFirms.PhysicalCapital(c);
        CstrFirms.Inventories(c) = CstrFirms.Inventories(c);
        CstrFirms.Liquidity(c) = CstrFirms.Par.Liquidity0;
        
        CstrFirms.TotalAssets(c) = CstrFirms.Inventories(c)*REmarket.HousingPrice(end) + ...
            CstrFirms.PhysicalCapital(c) + CstrFirms.Liquidity(c);
        CstrFirms.TotalDebts(c) = CstrFirms.TotalAssets(c)/(1+CstrFirms.Par.Leverage0);
        CstrFirms.Equity(c) = CstrFirms.TotalAssets(c) - CstrFirms.TotalDebts(c);
         
        %% Firms debt array set
        CstrFirms.DebtsArray{1,c}.BanksId = unidrnd(NrAgents.Banks);
        CstrFirms.DebtsArray{1,c}.Amount = CstrFirms.TotalDebts(c);
        CstrFirms.DebtsArray{1,c}.InterestRate = PriceIndices.CBInterestRate...
            + PriceIndices.InterestRateSpread;
        CstrFirms.DebtsArray{1,c}.MaturityDay = (1+TimeConstants.LoanDuration);
        CstrFirms.DebtsArray{1,c}.PrimeBankId = CstrFirms.DebtsArray{1,c}.BanksId;
        %% Banks loans array and total loans set
        Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.Amount =...
            [Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.Amount,CstrFirms.TotalDebts(c)];
        Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.InterestRate =...
            [Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.InterestRate,PriceIndices.InterestRate];
        Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.MaturityDay =...
            [Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.MaturityDay,Inf];
        Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.CstrFirmsId =...
            [Banks.LoansArrayCstrF{1,CstrFirms.DebtsArray{1,c}.BanksId}.CstrFirmsId,c];
        Banks.TotalLoans(1,CstrFirms.DebtsArray{1,c}.BanksId) = ...
            Banks.TotalLoans(1,CstrFirms.DebtsArray{1,c}.BanksId) + CstrFirms.TotalDebts(c);
        %% Other firm variables reset
        CstrFirms.BorrowingNeeds(c) = 0;
        CstrFirms.ProductionPlan(c) = 0;
        CstrFirms.FinishedProjects(c) = 0;
        CstrFirms.MinPrice(c) = REmarket.HousingPrice(end);
        CstrFirms.LaborCosts(c) = 0;
        CstrFirms.Revenues(c) = 0;
        CstrFirms.Earnings(c) = 0;
        CstrFirms.NrEmployees(c) = numel(CstrFirms.EmployeesIds{1,c});
        CstrFirms.vacancies(c) = 0;
        CstrFirms.LaborDemand(c) = 0;
        CstrFirms.Projects.MonthsLeft{1,c} = CstrFirms.Projects.MonthsLeft{1,c};%unidrnd(TimeConstants.HousingCstrTime,[1,unidrnd(CstrFirms.ProductionCapacity(c),1)]); %For projects running
        CstrFirms.Projects.NPV{1,c} = []; %for proposed projects

    clear employees2fire TotalLoans employeesremaining CashNeed
end