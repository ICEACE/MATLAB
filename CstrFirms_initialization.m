%CstrFirms_initialization

%% Initialization of Cstr Firms Employees
CstrFirms.EmployeesIds = {};
NrEmployeesPerCstrFirm = floor(((1-Households.UnemploymentRate0)*NrAgents.Households*NrAgents.CstrFirmsLaborForceShare)/NrAgents.CstrFirms);
CstrFirms.NrEmployees = ones(1,NrAgents.CstrFirms)*NrEmployeesPerCstrFirm;
%h0 = NrAgents.Firms*NrEmployeesPerFirm; %the first h0 households are employed by CGP firms
h0 = sum(NrEmployeesPerFirm);
for c=1:NrAgents.CstrFirms
    CstrFirms.EmployeesIds{1,c} = (h0+(c-1)*NrEmployeesPerCstrFirm+1):(h0+c*NrEmployeesPerCstrFirm);
    for h=(h0+(c-1)*NrEmployeesPerCstrFirm+1):(h0+c*NrEmployeesPerCstrFirm)
        Households.employer_id(h) = NrAgents.Firms+c;
        Households.employer_class(h) = CstrFirms.class_id; %Class 2 (Cstr_class) refers to Cstr firms
    end
end

%% Cstr Firms Initial values of variables
CstrFirms.Par.YearlyGrowthRateHousingMax = 0.015;
CstrFirms.Par.CapacityUtilization0 = 0.7;
CstrFirms.Par.LaborProductivity0 = sum(Households.HousingAmount)*...
    CstrFirms.Par.YearlyGrowthRateHousingMax*CstrFirms.Par.CapacityUtilization0/...
    sum(CstrFirms.NrEmployees);  % Productivity depends on the maximum growth rate of housing and on number of employees in the construction sector
CstrFirms.Par.MaxInventories = 15;
CstrFirms.LaborProductivity = CstrFirms.Par.LaborProductivity0*ones(1,NrAgents.CstrFirms); 

CstrFirms.Par.Leverage0 = 1;
CstrFirms.Par.Liquidity0 = 0;
CstrFirms.Par.Inventories0 = 0;

%% Initialization of CstrFirms Balance sheets 
% Initialization od debt (we stipulate that initial debt is such that its service
% 20 % of labor costs of any firm:
CstrFirms.wage = ones(1,NrAgents.CstrFirms)*PriceIndices.wage;
CstrFirms.TotalDebts = 0.2*(CstrFirms.wage*NrEmployeesPerCstrFirm)/PriceIndices.InterestRate;
for c=1:NrAgents.CstrFirms
    CstrFirms.DebtsArray{1,c}.BanksId = unidrnd(NrAgents.Banks);
    CstrFirms.DebtsArray{1,c}.Amount = Firms.TotalDebts(c);
    CstrFirms.DebtsArray{1,c}.InterestRate = PriceIndices.InterestRate;
    CstrFirms.DebtsArray{1,c}.MaturityDay = (1+TimeConstants.LoanDuration);
    CstrFirms.DebtsArray{1,c}.PrimeBankId = Firms.DebtsArray{1,c}.BanksId;
end
CstrFirms.Equity = CstrFirms.TotalDebts./CstrFirms.Par.Leverage0;
CstrFirms.TotalAssets = CstrFirms.TotalDebts + CstrFirms.Equity;

CstrFirms.Inventories     = ones(1,NrAgents.CstrFirms)*CstrFirms.Par.Inventories0;
CstrFirms.Liquidity       = ones(1,NrAgents.CstrFirms)*CstrFirms.Par.Liquidity0;

CstrFirms.PhysicalCapital = ceil((CstrFirms.TotalAssets - REmarket.HousingPrice(end)*CstrFirms.Inventories -...
    CstrFirms.Liquidity)/PriceIndices.CapitalGoods);

CstrFirms.KapitalProductivity = (CstrFirms.LaborProductivity*NrEmployeesPerCstrFirm)./...
    (CstrFirms.Par.CapacityUtilization0*CstrFirms.PhysicalCapital);
CstrFirms.ProductionCapacity = floor(CstrFirms.KapitalProductivity.*CstrFirms.PhysicalCapital);

for c=1:NrAgents.CstrFirms
    CstrFirms.Projects.MonthsLeft{1,c} = unidrnd(TimeConstants.HousingCstrTime,[1,unidrnd(CstrFirms.ProductionCapacity(c),1)]); %For projects running
    CstrFirms.Projects.NPV{1,c} = []; %for proposed projects
    CstrFirms.ProductionPlan(c) = numel(CstrFirms.Projects.MonthsLeft{1,c});
end
CstrFirms.FinishedProjects = zeros(1,NrAgents.CstrFirms);
CstrFirms.MinPrice = Inf*ones(1,NrAgents.CstrFirms);
CstrFirms.Earnings = zeros(1,NrAgents.CstrFirms);
CstrFirms.Revenues = zeros(1,NrAgents.CstrFirms);
CstrFirms.LaborCosts = CstrFirms.wage.*CstrFirms.NrEmployees;