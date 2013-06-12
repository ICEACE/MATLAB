%%Exit of insolvent firms, new firms replace the ones that exit

insolvent_firms = find(Firms.Equity < 0.001);
%fprintf('\n Insolvent firms: %d',insolvent_firms)
for f = insolvent_firms
    
    %% First, write off debt
    for b = 1:NrAgents.Banks
        Idx = find(Banks.LoansArray{1,b}.FirmsId == f);
        if isempty(Idx) ~= 1
            CurrentLoans = max(0,sum(Banks.LoansArray{1,b}.Amount(Idx)));
            Banks.LoansArray{1,b}.Amount(Idx) = zeros(1,numel(Idx));
            Banks.TotalLoans(b) = Banks.TotalLoans(b) - CurrentLoans;
            Banks.Earnings(b) = Banks.Earnings(b) - CurrentLoans;
            Idx_Firm = find(Firms.DebtsArray{1,f}.BanksId == b);
            Firms.DebtsArray{1,f}.Amount(Idx_Firm) = zeros(1,numel(Idx_Firm));
            Firms.DebtsArray{1,f}.BanksId(Idx_Firm) = -1*ones(1,numel(Idx_Firm));
            Firms.DebtsArray{1,f}.InterestRate(Idx_Firm) = zeros(1,numel(Idx_Firm));
        end
    end
    
    %% Second, fire all but one worker, keep the one with the lowest id
    employeesremaining = min(Firms.EmployeesIds{1,f});
    employees2fire = setdiff(Firms.EmployeesIds{1,f},employeesremaining);
    for h = employees2fire
        Households.employer_id(h) = -1;
        Households.employer_class(h) = 0;
    end
    Firms.EmployeesIds{1,f} = employeesremaining;
    
    %% Third, reset firm with FirmsEntrySize (x% of average firm) and
    %FirmsEntryInventories (one employee working for one month)
    Firms.Inventories(f) = FirmsEntryInventories;
    Firms.price(f) = mean(Firms.price);
    Firms.Liquidity(f) = FirmsLiquidity0;
    Firms.PhysicalCapital(f) = Firms.PhysicalCapital(f);
    Firms.TotalAssets(f) = Firms.Inventories(f)*Firms.price(f) + ...
        Firms.PhysicalCapital(f) + Firms.Liquidity(f);
    Firms.TotalDebts(f) = Firms.TotalAssets(f)/(1+FirmsLeverage0);
    Firms.Equity(f) = Firms.TotalAssets(f) - Firms.TotalDebts(f);
    %% Firms debt array set
    Firms.DebtsArray{1,f}.BanksId = unidrnd(NrAgents.Banks);
    Firms.DebtsArray{1,f}.Amount = Firms.TotalDebts(f);
    Firms.DebtsArray{1,f}.InterestRate = PriceIndices.InterestRate;
    Firms.DebtsArray{1,f}.MaturityDay = (1+TimeConstants.LoanDuration);
    Firms.DebtsArray{1,f}.PrimeBankId = Firms.DebtsArray{1,f}.BanksId;
    %% Banks loans array and total loans set
    Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.Amount =...
        [Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.Amount,Firms.TotalDebts(f)];
    Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.InterestRate =...
        [Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.InterestRate,PriceIndices.InterestRate];
    Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.MaturityDay =...
        [Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.MaturityDay,Inf];
    Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.FirmsId =...
        [Banks.LoansArray{1,Firms.DebtsArray{1,f}.BanksId}.FirmsId,f];
    Banks.TotalLoans(1,Firms.DebtsArray{1,f}.BanksId) = ...
        Banks.TotalLoans(1,Firms.DebtsArray{1,f}.BanksId) + Firms.TotalDebts(f);
    %% Other firm variables reset
    Firms.BorrowingNeeds(f) = 0;
    Firms.LaborCosts(f) = 0;
    Firms.Revenues(f)   = 0;
    Firms.Earnings(f)   = 0;
    Firms.Earnings(f) = 0;
    Firms.NrEmployees(f) = numel(Firms.EmployeesIds{1,f});
    Firms.ProductionQty(f) = 0;
    Firms.MonthlyCapitalCosts(f) = 0;
    Firms.ProductionTotalCosts(f) = 0;
    Firms.ProductionUnitCosts(f) = 0;
    Firms.MonthlySales(f) = Firms.MonthlySales(f);
    Firms.SoldOut(f) = Firms.SoldOut(f);
    Firms.ExpectedSales(f) = Firms.ExpectedSales(f);
    
    clear employees2fire TotalLoans employeesremaining
end