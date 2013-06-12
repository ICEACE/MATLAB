%%The fund pays dividends to capitalists households and can retain
%%dividends if needed for new investments in Firms

if Fund.FirmInvestment > 0
    Fund.DividendsRetained = Fund.FirmInvestment;
    Fund.DivedendsPaid = Fund.DividendsRecieved - Fund.DividendsRetained;
    Fund.Liquidity = Fund.Liquidity - Fund.DivedendsPaid;
else
    Fund.DividendsRetained = 0;
    Fund.DivedendsPaid = Fund.DividendsRecieved;
    Fund.Liquidity = Fund.Liquidity - Fund.DivedendsPaid;
end

%% Update Households income and Liquidity
Households.CapitalIncomeFirms = Households.IsCapitalist*sum(Fund.DivedendsPaid)/sum(Households.IsCapitalist);
Households.Liquidity = Households.Liquidity + Households.CapitalIncomeFirms;
