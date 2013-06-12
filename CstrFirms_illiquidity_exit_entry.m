illiquid_cstrfirms = find(CstrFirms.Liquidity < 0.001);
%fprintf('\n Illiquid cstrfirms: %d',illiquid_cstrfirms)

for c = illiquid_cstrfirms
    %% Fund will check if there is enough equity in the firm and if it has sufficiant Liquidity
    if CstrFirms.Equity(c)/CstrFirms.TotalAssets(c) > Fund.Parameters.MinEqRatio && Fund.Liquidity > abs(CstrFirms.Liquidity(c))
        %% if the firm has enough equity it will get new equity
        CashNeed = abs(CstrFirms.Liquidity(c));
        CstrFirms.Liquidity(c) = CstrFirms.Liquidity(c) + CashNeed;
        CstrFirms.Equity(c) = CstrFirms.Equity(c) + CashNeed;
        %Update the Fund balance sheet
        Fund.Liquidity = Fund.Liquidity - CashNeed;
        Fund.FirmInvestment = Fund.FirmInvestment + CashNeed;
    else
        %% First, write off debt        
        for b = 1:NrAgents.Banks
            Idx = find(Banks.LoansArrayCstrF{1,b}.CstrFirmsId == c);
            if isempty(Idx) ~= 1 && CstrFirms.TotalDebts(c) > 0
                CurrentLoans = sum(Banks.LoansArray{1,b}.Amount(Idx));
                NewLoans = max(0,CstrFirms.EBIT(c)/PriceIndices.InterestRate);
                Ratio = max(0,NewLoans/CurrentLoans);
                if Ratio == Inf
                    Ratio = 0;
                end
                Banks.LoansArrayCstrF{1,b}.Amount(Idx) = Banks.LoansArrayCstrF{1,b}.Amount(Idx).*Ratio;
                Banks.TotalLoans(b) = Banks.TotalLoans(b) - CurrentLoans + NewLoans;
                Banks.Earnings(b) = Banks.Earnings(b) - CurrentLoans + NewLoans;
                Idx_CstrFirm = find(CstrFirms.DebtsArray{1,c}.BanksId == b);
                CstrFirms.DebtsArray{1,c}.Amount(Idx_CstrFirm) = CstrFirms.DebtsArray{1,c}.Amount(Idx_CstrFirm).*Ratio;
            end
            clear CurrentLoans NewLoans Ratio
        end
        CstrFirms.TotalDebts(c) = sum(CstrFirms.DebtsArray{1,c}.Amount);
    end
    clear employees2fire TotalLoans employeesremaining CashNeed
end