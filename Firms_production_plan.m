%% The rationale of the production plan is the following:
% 1. we are at he beginning of month m now and the planned production  
% will be available at month m+1 
% 2. the sales of past FirmsSalesMemory months are used to form expectations 
% about month m and month m+1 sales 
% 3. Note that sales at month m are still unknown (we are at the beginning of
% the month)

%% ExpectedSales are given by prvious month sales plus the average trend over 
% the last FirmsSalesMemory sales
Firms.ExpectedSales = (1+0.1*Firms.SoldOut).*Firms.MonthlySales(end,:);
% + ...
%     mean(diff(Firms.MonthlySales));
Firms.ExpectedSales = max(Firms.ExpectedSales,0);

%% ProductionPlan is given by ExpectedSales minus Inventories unsold during
% month m and then carried out ot to month m+1
Firms.ProductionPlan = Firms.ExpectedSales - max(Firms.Inventories-Firms.ExpectedSales,0);
% it is assumed that the production is at least the amount corresponding to
% 1 employee (the manager-owner of the firm)
Firms.ProductionPlan = 0.9*Firms.ProductionQty+0.1*max(Firms.ProductionPlan,Firms.LaborProductivity);
Firms.SoldOut = zeros(1,NrAgents.Firms);

%% The stack of monthly sales is updated
Firms.MonthlySales(1:FirmsSalesMemory-1,:) = Firms.MonthlySales(2:FirmsSalesMemory,:); 
Firms.MonthlySales(FirmsSalesMemory,:) = zeros(1,NrAgents.Firms);

%% the labor demand is based on the inverse of the linear production
%% function
Firms.LaborDemand = ceil(Firms.ProductionPlan./Firms.LaborProductivity);
Firms.vacancies = max(0,Firms.LaborDemand-Firms.NrEmployees);
Firms.layoffs = max(0,Firms.NrEmployees-Firms.LaborDemand);