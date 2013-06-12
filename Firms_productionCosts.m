%% Computation of monthly capital costs
for f=1:NrAgents.Firms
    Firms.MonthlyCapitalCosts(f) = 0;
    for l=1:numel(Firms.DebtsArray{1,f}.Amount)
        Firms.MonthlyCapitalCosts(f) = Firms.MonthlyCapitalCosts(f) + ...
            (Firms.DebtsArray{1,f}.InterestRate(l)/12)*Firms.DebtsArray{1,f}.Amount(l);
    end
end


%% Computation of Production costs
Firms.ProductionTotalCosts = Firms.MonthlyCapitalCosts + Firms.NrEmployees.*Firms.wage;

%% Total costs of present inventories
ProductionTotalCosts_old = ProductionUnitCosts_old.*Firms.Inventories;
ProductionTotalCosts_old(isnan(ProductionTotalCosts_old)) = 0;

Firms.ProductionUnitCosts = (Firms.ProductionTotalCosts+ProductionTotalCosts_old)./...
    (Firms.ProductionQty + Firms.Inventories);

ProductionUnitCosts_old = Firms.ProductionUnitCosts;
% it is necessary to take into account of past production costs of present inventories 
