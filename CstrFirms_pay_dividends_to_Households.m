% we suppose that all households are equal shareholders of the firms and
% that therefore receive the same dividends amount from any firm

%% update Firms Liquidity
CstrFirms.Liquidity = CstrFirms.Liquidity - CstrFirms.Dividends;
%% Update Households income and Liquidity
Households.CapitalIncomeCstrFirms = Households.IsCapitalist*sum(CstrFirms.Dividends*(1-PriceIndices.CapitalIncomeTax))/sum(Households.IsCapitalist);
Households.Liquidity = Households.Liquidity + Households.CapitalIncomeCstrFirms;
%% Update Government income statement
Government.CapitalIncomeTax = Government.CapitalIncomeTax + sum(CstrFirms.Dividends*PriceIndices.CapitalIncomeTax);
Government.Liquidity = Government.Liquidity + sum(CstrFirms.Dividends*PriceIndices.CapitalIncomeTax);