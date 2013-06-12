%Households_compute_balance_sheet
Households.TotalAssetsOld = Households.TotalAssets;
Households.HousingValue = Households.HousingAmount.*REmarket.HousingPrice(end);
if UseSecuritization == 1
    Households.TotalAssets = Households.HousingValue + Households.Liquidity + sum(Households.fundsInvestments); % + Households.Savings;
else
    Households.TotalAssets = Households.HousingValue + Households.Liquidity;
end
Households.Equity = Households.TotalAssets - Households.TotalMortgage;
Households.TotalAssetsDelta = Households.TotalAssets - Households.TotalAssetsOld;