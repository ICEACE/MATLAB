%Script to initialize ICEACE economy

%Einar Jon Erlingsson
%Reykjavik University
%einare09@ru.is

%Marco Raberto
%University of Genoa
% marco.raberto@unige.it
 
clear all
close all
clc

randn('seed',1234567)
rand('seed',1234567)

%% Simulation run number and path
if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

mkdir(Pat)

RunNumber = 1503;

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
PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
PriceIndices.CAR = 0.08; %Capital adequacy ratio for banks
PriceIndices.CARbuffer = 0.01; %Capital adequancy ratio buffer for banks
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
REmarket.BudgetConstraint = 0.3; %Consumption budget of buyer must be fulfilled (see beta in paper)
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
REmarket.FireSaleThresh = 0.5;
REmarket.MortgageWriteOffRatio = 0.6;
REmarket.MortgageWriteOffThresh = 0.8;

%% LabourMarket
Firms.class_id = 1;
CstrFirms.class_id = 2;


%% Firms Initial values of variables

FirmsLeverage0 = 2; %leo
FirmsLiquidity0 = 0;
FirmsInventories0 = 0;
FirmsLaborProductivity0 = 1000;
FirmsMarkup0 = 1.1; 
FirmsSalesMemory = 4;

FirmsNetEarnings0 = 0;
FirmsEBIT0 = 0;

%% Firms Coob-Douglas production technology
% Linear

%% Households initialization
Households_initialization
%% Household employer initialization
Households.employer_id = -ones(1,NrAgents.Households);
Households.employer_class = zeros(1,NrAgents.Households);
%% Initialization of CGP Firms Employees
NrEmployeesPerFirm = floor(((1-Households.UnemploymentRate0)*NrAgents.Households*NrAgents.FirmsLaborForceShare)/NrAgents.Firms);
Firms.NrEmployees = ones(1,NrAgents.Firms)*NrEmployeesPerFirm;
for f=1:NrAgents.Firms
    Firms.EmployeesIds{1,f} = ((f-1)*NrEmployeesPerFirm+1):(f*NrEmployeesPerFirm);
    for h=((f-1)*NrEmployeesPerFirm+1):(f*NrEmployeesPerFirm)
        Households.employer_id(h) = f;
        Households.employer_class(h) = Firms.class_id; %Class 1 refers to CGP firms
    end
end
Firms.LaborProductivity = FirmsLaborProductivity0*ones(1,NrAgents.Firms);

%% Initialization of Firms Balance sheets 
% Initialization od debt (we stipulate that initial debt is such that its service
% 20 % of labor costs of any firm:
Firms.wage = ones(1,NrAgents.Firms)*PriceIndices.wage;
Firms.TotalDebts = 0.2*(Firms.wage*NrEmployeesPerFirm)/PriceIndices.InterestRate;
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
Firms.Active = ones(1,NrAgents.Firms);

%% CstrFirms_initialization
CstrFirms_initialization

%% Banks initial state variables
BanksCentralBankDebt0 = 0;  
BanksLiquidity0       = 0;
BanksCapitalAdequacyRatio0 = 10;
BanksRetainedEarnings0 = 0;


%% Initialization of Banks Balance Sheets
% Assets side:
%Banks.TotalLoans = ones(1,NrAgents.Banks)*(sum(Firms.TotalDebts)/NrAgents.Banks);
%for b=1:NrAgents.Banks
%    Banks.LoansArray{1,b}.Amount = (Banks.TotalLoans(b)/NrAgents.Firms)*ones(1,NrAgents.Firms);
%    Banks.LoansArray{1,b}.InterestRate = PriceIndices.InterestRate*ones(1,NrAgents.Firms);
%    Banks.LoansArray{1,b}.MaturityDay = (1+TimeConstants.LoanDuration)*ones(1,NrAgents.Firms);  
%    Banks.LoansArray{1,b}.FirmsId = 1:NrAgents.Firms;  
%end
%new loan structure of banks
%k = 1;
for b=1:NrAgents.Banks
    Banks.LoansArray{1,b}.Amount = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.InterestRate = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.MaturityDay = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.FirmsId = zeros(1,NrAgents.Firms);
    for f=1:NrAgents.Firms
        if Firms.DebtsArray{1,f}.BanksId == b
            Banks.LoansArray{1,b}.Amount(1,f) = Firms.DebtsArray{1,f}.Amount;
            Banks.LoansArray{1,b}.InterestRate(1,f) = Firms.DebtsArray{1,f}.InterestRate;
            Banks.LoansArray{1,b}.MaturityDay(1,f) = Firms.DebtsArray{1,f}.MaturityDay;
            Banks.LoansArray{1,b}.FirmsId(1,f) = f;
            %k = k + 1;
        end
    end
    Banks.TotalLoans(1,b) = sum(Banks.LoansArray{1,b}.Amount);
end
clear k b h

for b=1:NrAgents.Banks
    Banks.LoansArrayCstrF{1,b}.Amount = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.InterestRate = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.MaturityDay = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.CstrFirmsId = zeros(1,NrAgents.CstrFirms);
    for c=1:NrAgents.CstrFirms
        if Firms.DebtsArray{1,c}.BanksId == b
            Banks.LoansArrayCstrF{1,b}.Amount(1,c) = CstrFirms.DebtsArray{1,c}.Amount;
            Banks.LoansArrayCstrF{1,b}.InterestRate(1,c) = CstrFirms.DebtsArray{1,c}.InterestRate;
            Banks.LoansArrayCstrF{1,b}.MaturityDay(1,c) = CstrFirms.DebtsArray{1,c}.MaturityDay;
            Banks.LoansArrayCstrF{1,b}.FirmsId(1,c) = c;
            %k = k + 1;
        end
    end
    Banks.TotalLoans(1,b) = Banks.TotalLoans(1,b) + sum(Banks.LoansArrayCstrF{1,b}.Amount);
end
clear k b h

%k = 1;
for b=1:NrAgents.Banks
    Banks.MortgageArray{1,b}.Amount = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.InterestRate = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.MaturityDay = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.HouseholdsId = zeros(1,NrAgents.Households);
    for h=1:NrAgents.Households
        if Households.MortgageArray{1,h}.BanksId == b
            Banks.MortgageArray{1,b}.Amount(1,h) = Households.MortgageArray{1,h}.Amount;
            Banks.MortgageArray{1,b}.InterestRate(1,h) = Households.MortgageArray{1,h}.InterestRate;
            Banks.MortgageArray{1,b}.MaturityDay(1,h) = Households.MortgageArray{1,h}.MaturityDay;
            Banks.MortgageArray{1,b}.HouseholdsId(1,h) = h;
            %k = k + 1;
        end
    end
    Banks.TotalMortgage(1,b) = sum(Banks.MortgageArray{1,b}.Amount);
end
%Banks.Liquidity = zeros(1,NrAgents.Banks);
Banks.Liquidity = 0.1*ones(1,NrAgents.Banks).*(Banks.TotalLoans+Banks.TotalMortgage);
Banks.TotalAssets = Banks.TotalLoans + Banks.Liquidity + Banks.TotalMortgage;

% Liabilities side:
%Banks.Deposits = ones(1,NrAgents.Banks)*((sum(Households.Liquidity)+sum(Firms.Liquidity))/NrAgents.Banks);
Banks.Deposits = (Banks.TotalAssets./sum(Banks.TotalAssets))*((sum(Households.Liquidity)+sum(Firms.Liquidity))/NrAgents.Banks);
%1.9.2012%Banks.SavingsAccounts = (Banks.TotalAssets./sum(Banks.TotalAssets))*((sum(Households.Savings))/NrAgents.Banks);
Banks.Equity   = Banks.TotalAssets/BanksCapitalAdequacyRatio0;
Banks.RetainedEarnings = ones(1,NrAgents.Banks)*BanksRetainedEarnings0;
Banks.CentralBankDebt = max(Banks.TotalAssets - Banks.Deposits - Banks.Equity - Banks.RetainedEarnings,0);

if (sum(find(Banks.Deposits + Banks.Equity>Banks.TotalAssets))>0) %Banks.SavingsAccounts
    error('There is at least one bank with a wrong initial balance sheet')
end
%Banks.RetainedEarnings = ones(1,NrAgents.Banks)*BanksRetainedEarnings0;
%Banks.CentralBankDebt = max(Banks.TotalAssets - Banks.Deposits - Banks.Equity - Banks.RetainedEarnings,0);


%% Initialization of Banks Income Statement
Banks.Earnings = zeros(1,NrAgents.Banks);

%% Initialization of Government variables
Government.Liquidity = 0;
Government.Bonds = 0;
Government.LaborTax = 0;
Government.CapitalIncomeTax = 0;
Government.Earnings = 0;
Government.BenefitsPaid = 0;
Government.Expenditures = 0;
Government.Balance = 0;
Government.Equity = 0;

Government.Parameters.LeftishPolicy = 0.5;
%Government.Parameters.MinCBrate = 0.03;
Government.Parameters.MaxUnemp = Inf;

Government.UnempBenefitsPaid = 0;
Government.UnempBenefitsPaid_sum = 0;
Government.GeneralBenefitsPaid = 0;
Government.GeneralBenefitsPaid_sum = 0;

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

