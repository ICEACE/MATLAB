%%Producion plan for housing by CstrFirms
%We build if the forcasted revenue (in 12 months) is higher than the
%forcasted production cost.

for c=1:NrAgents.CstrFirms
   CstrFirms.Projects.NrCurrentProjects(c) = numel(CstrFirms.Projects.MonthsLeft{1,c});
end
CstrFirms.ProductionCapacity = floor(CstrFirms.KapitalProductivity.*CstrFirms.PhysicalCapital);
%cost = ((TimeConstants.HousingCstrTime./CstrFirms.LaborProductivity).*CstrFirms.wage).*(1+PriceIndices.InterestRate)...
%    + (CstrFirms.PhysicalCapital.*PriceIndices.CapitalGoods./CstrFirms.ProductionCapacity).*PriceIndices.InterestRate;
%rev = REmarket.HousingPrice(end)/(1+PriceIndices.InterestRate);
%fprintf('CstrF cost/rev: %f %f', mean(cost),rev)
%for c=1:NrAgents.CstrFirms
%    if  cost(c) <= rev && CstrFirms.Inventories(c) < CstrFirms.Par.MaxInventories
%        CstrFirms.ProductionPlan(c) = min(CstrFirms.ProductionCapacity(c),floor(CstrFirms.ProductionPlan(c)*1.05));
%    else
%        CstrFirms.ProductionPlan(c) = max(0,floor(CstrFirms.ProductionPlan(c)*0.75));
%    end
%end

if diff(REmarket.HousingPrice(end-1:end)) > 0
    CstrFirms.ProductionPlan = max(CstrFirms.Projects.NrCurrentProjects,unidrnd(CstrFirms.ProductionCapacity,[1,NrAgents.CstrFirms])); %should be between no of current project and capacity
else
    CstrFirms.ProductionPlan = unidrnd(CstrFirms.Projects.NrCurrentProjects,[1,NrAgents.CstrFirms]);
end
CstrFirms.LaborDemand = ceil(CstrFirms.ProductionPlan./CstrFirms.LaborProductivity);
CstrFirms.vacancies = max(0,CstrFirms.LaborDemand-CstrFirms.NrEmployees);
CstrFirms.layoffs = max(0,CstrFirms.NrEmployees-CstrFirms.LaborDemand);