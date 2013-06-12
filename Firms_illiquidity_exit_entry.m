%%Exit of illiquid firms, new firms replace the ones that exit

illiquid_firms = find(Firms.Liquidity < 0.001);
%fprintf('\n Illiquid firms: %d',illiquid_firms)
Fund.FirmInvestment = 0;
for f = illiquid_firms
    %% Fund will check if there is enough equity in the firm and if it has sufficiant Liquidity
    if Firms.Equity(f)/Firms.TotalAssets(f) > Fund.Parameters.MinEqRatio && Fund.Liquidity > abs(Firms.Liquidity(f))
        %% if the firm has enough equity it will get new equity
        CashNeed = abs(Firms.Liquidity(f));
        Firms.Liquidity(f) = Firms.Liquidity(f) + CashNeed;
        Firms.Equity(f) = Firms.Equity(f) + CashNeed;
        %Update the Fund balance sheet
        Fund.Liquidity = Fund.Liquidity - CashNeed;
        Fund.FirmInvestment = Fund.FirmInvestment + CashNeed;        
    else
        %% First, write off debt         
        for b = 1:NrAgents.Banks
            Idx = find(Banks.LoansArray{1,b}.FirmsId == f);            
            if isempty(Idx) ~= 1 && Firms.TotalDebts(f) > 0              
                CurrentLoans = sum(Banks.LoansArray{1,b}.Amount(Idx));
                NewLoans = max(0,Firms.EBIT(f)/PriceIndices.InterestRate);
                Ratio = max(0,NewLoans/CurrentLoans);
                if Ratio == Inf
                    Ratio = 0;
                end
                Banks.LoansArray{1,b}.Amount(Idx) = Banks.LoansArray{1,b}.Amount(Idx).*Ratio;
                Banks.TotalLoans(b) = Banks.TotalLoans(b) - CurrentLoans + NewLoans;
                Banks.Earnings(b) = Banks.Earnings(b) - CurrentLoans + NewLoans;
                Idx_Firm = find(Firms.DebtsArray{1,f}.BanksId == b);
                Firms.DebtsArray{1,f}.Amount(Idx_Firm) = Firms.DebtsArray{1,f}.Amount(Idx_Firm).*Ratio;
            end
            clear CurrentLoans NewLoans Ratio
        end
        Firms.TotalDebts(f) = sum(Firms.DebtsArray{1,f}.Amount);
    end
    clear employees2fire TotalLoans employeesremaining CashNeed
end