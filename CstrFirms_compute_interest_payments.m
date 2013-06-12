%% Construction firms pay interest on their total debt
for c=1:NrAgents.CstrFirms
    CstrFirms.TotalInterestPayments(c) = 0;
    for l=1:numel(CstrFirms.DebtsArray{1,c}.Amount)
        CstrFirms.TotalInterestPayments(c) = CstrFirms.TotalInterestPayments(c) + ...
            (CstrFirms.DebtsArray{1,c}.InterestRate(l)/4)*CstrFirms.DebtsArray{1,c}.Amount(l);
    end
end