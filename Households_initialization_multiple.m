%% Household parameters
Households.Parameters.LaborTurnoverProbability = 0.1;
Households.Parameters.Memory0 = 1; %used to remember past wages and past real estate prices
Households.Parameters.WealthEffect0 = 0.07;
Households.Parameters.IsCapitalistProb = SimulationRunPar.CapitalistProb;


%% Household initial state variables
%HouseholdsLaborIncome0 = 20;
Households.UnemploymentRate0 = 0.1;
HouseholdsLiquidity0 = 3*PriceIndices.wage;
HousingOptimalExp0 = 0.25;
HouseholdsLeverage0 = 1;
Households.HousingDecision = zeros(2,NrAgents.Households);
Households.HousingMarketAction = zeros(1,NrAgents.Households);
Households.HousingReducePrice = zeros(1,NrAgents.Households);
Households.HousingFireSale = zeros(1,NrAgents.Households);
Households.QuarterlyLaborIncome = zeros(3,NrAgents.Households);
Households.HousingPrices = zeros(1,NrAgents.Households);
Households.OldPrice = zeros(1,NrAgents.Households);
Households.TimeOnMarket = zeros(1,NrAgents.Households);
Households.IsCapitalist = zeros(1,NrAgents.Households);
%Households.IsCapitalist(rand(1,NrAgents.Households) < Households.Parameters.IsCapitalistProb) = 1;
Households.IsCapitalist(1:round(Households.Parameters.IsCapitalistProb*NrAgents.Households)) = 1;
Households.MortgagesWrittenOff  = zeros(1,NrAgents.Households);

%% Initialization of Households Balance Sheets
Households.Liquidity = ones(1,NrAgents.Households)*HouseholdsLiquidity0;
%1.9.2012%Households.Savings = zeros(1,NrAgents.Households);
Households.HousingAmount = ones(1,NrAgents.Households).*REmarket.HousingUnit;
Households.HousingValue = REmarket.HousingPrice(end).*Households.HousingAmount;
Households.TotalAssets = Households.Liquidity + Households.HousingValue; %Households.Savings
Households.Equity = Households.TotalAssets./(HouseholdsLeverage0+1);
Households.TotalMortgage = Households.TotalAssets - Households.Equity;

for h=1:NrAgents.Households
    Households.MortgageArray{1,h}.BanksId = unidrnd(NrAgents.Banks);
    Households.MortgageArray{1,h}.Amount = Households.TotalMortgage(h);
    Households.MortgageArray{1,h}.InterestRate = PriceIndices.MortgageRate;
    Households.MortgageArray{1,h}.MaturityDay = (1+TimeConstants.MortgageDurationDays); %Maturity in quarters
    Households.MortgageArray{1,h}.PrimeBankId = Households.MortgageArray{1,h}.BanksId;
    Households.MortgageArray{1,h}.PayOfPrincipal = Households.MortgageArray{1,h}.Amount/TimeConstants.MortgageDurationQuarters;
end

%% Initialization of Households Income Statement
Households.LaborIncome = zeros(1,NrAgents.Households);
% the initial condition in the labor market is (1-Households.EmploymentRate0) = 20 % unemployment
NrEmployed0 = floor((1-Households.UnemploymentRate0)*NrAgents.Households);
IdxHouseholdsEmployed_perm1= randperm2(NrAgents.Households,NrEmployed0);
Households.QuarterlyLaborIncome(1,IdxHouseholdsEmployed_perm1) = PriceIndices.wage; 
IdxHouseholdsEmployed_perm2= randperm2(NrAgents.Households,NrEmployed0);
Households.QuarterlyLaborIncome(2,IdxHouseholdsEmployed_perm2) = PriceIndices.wage;
% the initialization of the last row (more recent time) is consistent with the initialiation
% of firms' employess
Households.QuarterlyLaborIncome(3,1:NrEmployed0) = PriceIndices.wage;
Households.LaborIncome(1:NrEmployed0) = PriceIndices.wage;

Households.QuarterlyCapitalIncome = zeros(1,NrAgents.Households);
Households.QuarterlyCapitalIncome = ones(1,NrAgents.Households)*PriceIndices.wage/3;
Households.HousingPayment = Households.TotalMortgage.*(PriceIndices.MortgageRate/4);

Households.Benefits = zeros(1,NrAgents.Households);

