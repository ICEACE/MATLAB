for f=1:NrAgents.Firms
    Firms.TotalInterestPayments(f) = 0;
    for l=1:numel(Firms.DebtsArray{1,f}.Amount)
        Firms.TotalInterestPayments(f) = Firms.TotalInterestPayments(f) + ...
            (Firms.DebtsArray{1,f}.InterestRate(l)/4)*Firms.DebtsArray{1,f}.Amount(l);
    end
end
