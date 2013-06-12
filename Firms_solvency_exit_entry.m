%%Exit of insolvent firms, new firms replace the ones that exit

insolvent_firms = find(Firms.Equity < 0.001);

for f = insolvent_firms
    %First write off debt
    for b = 1:NrAgents.Banks
        Idx = find(Banks.LoansArray{1,b}.FirmsId == f);
        Loans(b,:) = Banks.LoansArray{1,b}.Amount(Idx);
        Banks.LoansArray{1,b}.Amount(Idx) = zeros(1,numel(Idx));
        Banks.TotalLoans(b) = Banks.TotalLoans(b) - sum(Loans(b),2);
        Banks.Earnings(b) = Banks.Earnings - sum(Loans(b),2);
    end
    %Fire all but one worker
    employees = Firms.EmployeesIds{1,f}
    for h = employees
        
    end
    %Reset firm with FirmsEntrySize
    TotalLoans = sum(Loans,2);
    Firms.Equity(f) = FirmsEntrySize*mean(Firms.Equity);
    Firms.Liquidity(f) = FirmsLiquidity0;
    Firms.TotalDebts(f) = 0;
    Firms.TotalAssets(f) = Firms.TotalDebts(f) + Firms.Equity(f);
    Firms.BorrowingNeeds(f) = 0;
    Firms.LaborCosts(f) = 0;
    Firms.Revenues(f)   = 0;
    Firms.Earnings(f)   = 0;
    Firms.Inventories(f) = FirmsInventories0;
    Firms.Earnings(f) = 0;
    Firms.NrEmployees = 1;
    Firms.EmployeesIds{1,f} = min(Firms.EmployeesIds{1,f});
end