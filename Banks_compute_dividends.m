%If Banks have plentiful CAR (CAR + CARbuffer) they pay out dividends. If
%not they retain earnings. (EJE)
for k = 1:NrAgents.Banks
    if  Banks.Equity(k)/(Banks.TotalAssets(k)) > PriceIndices.CAR + PriceIndices.CARbuffer %Added by EJE
        Banks.Dividends(k) = max(0,Banks.Earnings(k));
        %Banks.RetainedEarnings(k) = 0.8*max(0,Banks.Earnings(k));
    else
        Banks.Dividends(k) = 0;
        Banks.RetainedEarnings(k) = max(0,Banks.Earnings(k));
        %Banks.Liquidity(k) = Banks.Liquidity(k) + Banks.RetainedEarnings(k);
        %Banks.Equity(k) = Banks.Equity(k) + Banks.RetainedEarnings(k);
    end
end

