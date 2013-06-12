randn('seed',SimulationRunPar.RandomSeed)
rand('seed',SimulationRunPar.RandomSeed)

%% Simulation run number and path
if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

mkdir(Pat)

RunNumber = SimulationRunPar.RunNumber;

%% Global Time Variables
TimeConstants.NrMonthsInQuarter = 3;    % Number of Months in 1 Quarter
TimeConstants.NrMonthsInYear = TimeConstants.NrMonthsInQuarter*4;
TimeConstants.NrDaysInWeek = 5;         % Number of days in one week
TimeConstants.NrWeeksInMonth = 4;       % Number of weeks in one month
TimeConstants.NrWeeksInQuarter = TimeConstants.NrWeeksInMonth*TimeConstants.NrMonthsInQuarter;
TimeConstants.NrDaysInMonth = TimeConstants.NrDaysInWeek*TimeConstants.NrWeeksInMonth; % Number of days in one month
TimeConstants.NrDaysInQuarter = TimeConstants.NrMonthsInQuarter*TimeConstants.NrDaysInMonth;
TimeConstants.NrDaysInYear = TimeConstants.NrDaysInQuarter*4;
TimeConstants.LoanDuration = +inf;
TimeConstants.MortgageDurationQuarters = 40*4; % the mortage will last 40 years
TimeConstants.MortgageDurationDays = 40*TimeConstants.NrDaysInYear; % the mortage will last 40 years
TimeConstants.HousingCstrTime = 12; %Construction time of housing is 12 months
q = 1;  % current quarter
m = TimeConstants.NrMonthsInQuarter;  % current day  
d = TimeConstants.NrDaysInQuarter;  % current month


%% Agents' population
NrAgents.Households = 8000;
NrAgents.CstrFirmsLaborForceShare = 0.075;
NrAgents.FirmsLaborForceShare = 1-NrAgents.CstrFirmsLaborForceShare;
NrAgents.Banks = 2;
%NrAgents.NrFirmsPerBank = 100;
%NrAgents.NrHouseholdsPerFirm = 30;
NrAgents.CstrFirms = 25; %statice: 5000 units in 2007, divide by scalefactor of 20 and again by 10 due to the equal initialization
NrAgents.Firms = 150-NrAgents.CstrFirms; %statice: 30000 total nr of firms in 2007, divide by scalefactor of 20 and again by 10 due to the equal initialization
%% Initial values of key economic variables
PriceIndices.wage = 5;
PriceIndices.CBInterestRate = 0.02;
PriceIndices.InterestRateSpread = 0.01;
PriceIndices.MortgageRateSpread = 0.02;
PriceIndices.MortgageRateSpread_IIM = 0.01;
PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
PriceIndices.CAR = 0.085; %Capital adequacy ratio for banks
PriceIndices.CARbuffer = 0.0075; %Capital adequancy ratio buffer for banks
PriceIndices.Inflation = zeros(1,60);
PriceIndices.LaborTax = 0.2;
PriceIndices.CapitalIncomeTax = 0.2;
PriceIndices.UnemploymentBenefitRatio = 0.5;
PriceIndices.TransferBenefitRatio = 0.3;
PriceIndices.AnnuityFactor = (1/(PriceIndices.MortgageRate/4))-...
    1/((PriceIndices.MortgageRate/4)*(1+(PriceIndices.MortgageRate/4))^TimeConstants.MortgageDurationQuarters);

%Initial values of real estate market variables
REmarket.const_q = 1; %Portion of housing for sale seen by each buyer (see q in paper)
REmarket.const_theta = 0.025; %Interval for pricing decision of sellers (see theta in paper)
REmarket.EQratio = -Inf; %Equity ratio demanded by banks (see alpha in paper)
REmarket.BudgetConstraint = SimulationRunPar.BudgetConstraint; %Consumption budget of buyer must be fulfilled (see beta in paper)
REmarket.HousingUnit = 5;
REmarket.Price2WageRatio = 20;
REmarket.HousingPrice = [PriceIndices.wage*REmarket.Price2WageRatio,...
    PriceIndices.wage*REmarket.Price2WageRatio,PriceIndices.wage*REmarket.Price2WageRatio];
REmarket.Transactions = 0; %To count the number of transactions in the Real estate market
REmarket.minHousing = 2; %minimum amount of housing owned by any household
REmarket.const_b = 0.20; 
REmarket.const_a = 0.40;
REmarket.CstrFirmsPriceInterval = 0.025;
REmarket.FireSalePriceReduction = 0.05;
REmarket.FireSaleThresh = 0.6;
REmarket.MortgageWriteOffRatio = 0.5;
REmarket.MortgageWriteOffThresh = 0.7;
REmarket.AR1Process = [0.002647,0.551130];
REmarket.UseInflIndexedMortgages = SimulationRunPar.UseIndexedMortgages;
REmarket.CapitalLaborRatio = 1;

%% LabourMarket
Firms.class_id = 1;
CstrFirms.class_id = 2;

%% Firms Initial values of variables
FirmsLeverage0 = 4; %leo
FirmsLiquidity0 = 0;
FirmsInventories0 = 0;
FirmsLaborProductivity0 = 1000;
FirmsMarkup0 = 1.1; 
FirmsSalesMemory = 4;
FirmsNetEarnings0 = 0;
FirmsEBIT0 = 0;
FirmsEntrySize = 0.5;
FirmsEntryInventories = FirmsLaborProductivity0;
FirmsEntryCapital = 0.1;

%% Firms Coob-Douglas production technology

%% Households initialization
Households_initialization_multiple

%% Household employer initialization
Households.employer_id = -ones(1,NrAgents.Households);
Households.employer_class = zeros(1,NrAgents.Households);
%% Initialization of CGP Firms Employees
%NrEmployeesPerFirm = floor(((1-Households.UnemploymentRate0)*NrAgents.Households*NrAgents.FirmsLaborForceShare)/NrAgents.Firms);
NrEmployeesPerFirm = floor((NrAgents.Households*(1-Households.UnemploymentRate0))/(NrAgents.Firms*2)) +...
    randi(floor(NrAgents.Households*(1-Households.UnemploymentRate0)/NrAgents.Firms),1,NrAgents.Firms);
%Firms.NrEmployees = ones(1,NrAgents.Firms)*NrEmployeesPerFirm;
Firms.NrEmployees = NrEmployeesPerFirm;
CumulativeEmployees = cumsum(NrEmployeesPerFirm);
Firms.EmployeesIds{1,1} = 1:Firms.NrEmployees(1);
Households.employer_id(1,1:Firms.NrEmployees(1)) = 1;
for f=2:NrAgents.Firms
    %Firms.EmployeesIds{1,f} = ((f-1)*NrEmployeesPerFirm(f)+1):(f*NrEmployeesPerFirm(f));
    Firms.EmployeesIds{1,f} = (CumulativeEmployees(f-1)+1):(CumulativeEmployees(f));
    %for h=((f-1)*NrEmployeesPerFirm(f)+1):(f*NrEmployeesPerFirm(f))
    for h = Firms.EmployeesIds{1,f}
        Households.employer_id(h) = f;
        Households.employer_class(h) = Firms.class_id; %Class 1 refers to CGP firms
    end
end
Firms.LaborProductivity = FirmsLaborProductivity0*ones(1,NrAgents.Firms);
%Firms.LaborProductivity = floor(750+500*rand(1,NrAgents.Firms));

%% Initialization of Firms Balance sheets 
% Initialization od debt (we stipulate that initial debt is such that its service
% 20 % of labor costs of any firm:
Firms.wage = ones(1,NrAgents.Firms)*PriceIndices.wage;
Firms.TotalDebts = 0.2*(Firms.wage.*NrEmployeesPerFirm)/PriceIndices.InterestRate;
Firms.Equity = Firms.TotalDebts./FirmsLeverage0;
Firms.TotalAssets = Firms.TotalDebts + Firms.Equity;

Firms.Inventories     = ones(1,NrAgents.Firms)*FirmsInventories0;
Firms.Liquidity       = ones(1,NrAgents.Firms)*FirmsLiquidity0;

for f=1:NrAgents.Firms
    Firms.DebtsArray{1,f}.BanksId = unidrnd(NrAgents.Banks);
    Firms.DebtsArray{1,f}.Amount = Firms.TotalDebts(f);
    Firms.DebtsArray{1,f}.InterestRate = PriceIndices.InterestRate;
    Firms.DebtsArray{1,f}.MaturityDay = (1+TimeConstants.LoanDuration);
    Firms.DebtsArray{1,f}.PrimeBankId = Firms.DebtsArray{1,f}.BanksId;
end

%% Initialization of Firms Income Statement
Firms.LaborCosts = zeros(1,NrAgents.Firms);
Firms.Revenues   = zeros(1,NrAgents.Firms);
Firms.Earnings   = zeros(1,NrAgents.Firms);

%% Initialization of Firms variables
Firms_production; % this is to set Inventories and ProductionQty to their initial values
Firms_productionCosts_initialization   % Computation of Production costs
Firms.Markup = ones(1,NrAgents.Firms)*FirmsMarkup0; 
Firms_pricing

%% Firms+ capital initialization
PriceIndices.ConsumptionGoods = mean(Firms.price);
PriceIndices.ConsumptionGoods_hist(1:TimeConstants.NrDaysInQuarter) = mean(Firms.price);
PriceIndices.CapitalGoods = 100*PriceIndices.ConsumptionGoods;
Firms.PhysicalCapital = ceil((Firms.TotalAssets - PriceIndices.ConsumptionGoods*Firms.Inventories - Firms.Liquidity)/PriceIndices.CapitalGoods); 

Firms.MonthlySales = repmat(Firms.ProductionQty,[FirmsSalesMemory, 1]);
Firms.Inventories = Firms.Inventories + Firms.ProductionQty;
Firms.SoldOut = zeros(1,NrAgents.Firms);
Firms.ExpectedSales = zeros(1,NrAgents.Firms);
Firms.LaborDemand = zeros(1,NrAgents.Firms);
%Firms.Active = ones(1,NrAgents.Firms);

%% CstrFirms_initialization
CstrFirms_initialization

%% Fund_initialization
Fund_initialization

%% Banks_initialization
Banks_initialization

%% Government_initialization
Government_initialization

%% Funds_initialization
UseSecuritization = 0;
if UseSecuritization == 1
    Funds_initialization
end
%% Stats
Stats.Wage = [Households.LaborIncome;Households.LaborIncome];
Stats.MonthlyNominalGDP = sum(Firms.ProductionQty*PriceIndices.ConsumptionGoods);
Stats.MonthlyNominalGDP_RE = 0;        

Stats.MonthlyNominalGDP_vect = repmat(Stats.MonthlyNominalGDP,[1, 3]);
Stats.MonthlyNominalGDP_RE_vect = repmat(Stats.MonthlyNominalGDP_RE,[1, 3]);

Stats.QuartelyNominalGDP = sum(Stats.MonthlyNominalGDP_vect);
Stats.QuartelyNominalGDP_RE = sum(Stats.MonthlyNominalGDP_RE_vect);

REmarket.const_r = repmat(0.01,1,2);
REmarket.const_w = repmat(0.005,2,1);
%% save the ICEACE simulation file
Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
save([Pat, Filename]);