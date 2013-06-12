%%Construction Firms compute balance sheet

%% Find value of unfinished houses
for c = 1:NrAgents.CstrFirms
    CstrFirms.ValueUnfinishedHouses(c) = sum(REmarket.HousingPrice(end).*CstrFirms.Projects.MonthsLeft{1,c}./TimeConstants.HousingCstrTime);
end
%% Compute TA and Equity according to price of housing and price of physical capital
CstrFirms.TotalAssets = (PriceIndices.CapitalGoods.*CstrFirms.PhysicalCapital) + ...
    (REmarket.HousingPrice(end).*CstrFirms.Inventories) + CstrFirms.Liquidity + CstrFirms.ValueUnfinishedHouses;
CstrFirms.Equity = CstrFirms.TotalAssets - CstrFirms.TotalDebts;
