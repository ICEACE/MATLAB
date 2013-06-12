% we suppose that all households are equal shareholders of the firms and
% that therefore receive the same dividends amount from any firm

%% update Firms Liquidity
Firms.Liquidity = Firms.Liquidity - Firms.Dividends;
%% Update Households income and Liquidity
Households.CapitalIncomeFirms = Households.IsCapitalist*sum(Firms.Dividends*(1-PriceIndices.CapitalIncomeTax))/sum(Households.IsCapitalist);
Households.Liquidity = Households.Liquidity + Households.CapitalIncomeFirms;
%% Update Government income statement
Government.CapitalIncomeTax = Government.CapitalIncomeTax + sum(Firms.Dividends*PriceIndices.CapitalIncomeTax);
Government.Liquidity = Government.Liquidity + sum(Firms.Dividends*PriceIndices.CapitalIncomeTax);