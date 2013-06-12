for b=1:NrAgents.Banks
    if (Banks.Liquidity(b) < 0)
        Banks.CentralBankDebt(b) = Banks.CentralBankDebt(b) - Banks.Liquidity(b);
        Banks.Liquidity(b) = 0;
    elseif ((Banks.Liquidity(b) > 0)&(Banks.CentralBankDebt(b) > 0))
        liquidity = Banks.Liquidity(b);
        Banks.Liquidity(b) = max(0,Banks.Liquidity(b)-Banks.CentralBankDebt(b));
        Banks.CentralBankDebt(b) = max(0,Banks.CentralBankDebt(b)-liquidity);        
    end
end

Banks.TotalAssets = Banks.TotalLoans + Banks.Liquidity + Banks.TotalMortgage;
Banks.Equity = Banks.TotalAssets - Banks.Deposits - Banks.CentralBankDebt; % - Banks.SavingsAccounts;