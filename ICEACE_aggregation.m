%% Calculations to compare three simulations
clear all
close all
clc

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

%% USER INPUT REQUIRED
SYIA = 7;          %Start Year in Aggregation
EYIA = 15;         %End Year in Aggregation
SQIA = SYIA*4-3;   %Start Quarter in Aggregation
EQIA = EYIA*4;     %End Quarter in Aggregation
SMIA = SQIA*3-2;   %Start Month in Aggregation
EMIA = EQIA*3;     %End Month in Aggregation
SDIA = SMIA*20-19; %Start Day in Aggregation
EDIA = EMIA*20;    %End Day in Aggregation

Seeds = [3234151:3234154,3234161:3234164,3234175:3234178,3234181:3234188,...
         3234195:3234198,4454101:4454104,4453101:4453104,4452101:4452104,...
         4451101:4451104,4448101:4448104,4447101:4447104,3234229:3234244,...
         3234249:3234260,4444101:4444104,3234209:3234228,3234401:3234436,...
         3234501:3234504,3234509:3234512,3234517:3234532,3234701:3234708,...
         3234713:3234716,3234721:3234732,3234605:3234608,3234613:3234616,3234625:3234632];% 3234621:3234632]; % 3234201:3234204,4451001:4451004,
%% For loop start
count = 0;

for RunNumber = Seeds

    count = count + 1;
    Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
    load([Pat, Filename]);    
    
    %% Inflation Index
    InflationIndex(count,1) = 100;
    for t = 2:numel(Inflation)/TimeConstants.NrDaysInMonth
        InflationIndex(count,t) =  InflationIndex(count,t-1)*(1+Inflation(t*TimeConstants.NrDaysInMonth)/12);
    end
    %% GDP aggregation
    GDP_monthly(count,:) = (Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
        + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)/12).*HousingPrices(1:TimeConstants.NrDaysInMonth:end))';
    RealGDP_monthly(count,:) = (100*GDP_monthly(count,:))./InflationIndex(count,:);
    
    for q = 1:SimulationDurationInQuarters
        month_end = q*3;
        month_start = q*3-2;
        RealGDP_quarterly(count,q) = sum(RealGDP_monthly(count,month_start:month_end));
    end
    for y = 1:SimulationDurationInQuarters/4
        year_end = y*12;
        year_start = y*12-11;
        RealGDP_yearly(count,y) = sum(RealGDP_monthly(count,year_start:year_end));
    end
    
    RealGDP_monthly_change(count,:) = diff(RealGDP_monthly(count,:));
    RealGDP_quarterly_change(count,:) = diff(RealGDP_quarterly(count,:));
    RealGDP_yearly_change(count,:) = diff(RealGDP_yearly(count,:));
    
    RealGDP_monthly_volatility(count,:) = std(RealGDP_monthly(count,SMIA:EMIA));
    RealGDP_quarterly_volatility(count,:) = std(RealGDP_quarterly(count,SQIA:EQIA));
    RealGDP_yearly_volatility(count,:) = std(RealGDP_yearly(count,SYIA:EYIA));
    
    %% Unemployment aggregation
    EC_Unemployment(count,:) = UnemployedWorkers(1:TimeConstants.NrDaysInMonth:end);
    FI_EmploymentCGP(count,:) = CGPEmployedWorkers(1:TimeConstants.NrDaysInMonth:end);
    FI_EmploymentCstrF(count,:) = CstrFEmployedWorkers(1:TimeConstants.NrDaysInMonth:end);
    
    %% Housing stock
    HM_HousingStock_temp = sum(HouseholdsHousingAmount,2);
    HM_HousingStock(count,:) = HM_HousingStock_temp(SDIA:TimeConstants.NrDaysInMonth:EDIA);
    
    %% Pricelevel, wage level and housing price
    EC_Pricelevel(count,:) = PriceIndex(1:TimeConstants.NrDaysInMonth:end);
    EC_Wagelevel(count,:) = WageIndex(1:TimeConstants.NrDaysInMonth:end);
    EC_InterestRate(count,:) = CBRate(1:TimeConstants.NrDaysInMonth:end);
    HM_Housingpricelevel(count,:) = HousingPrices(1:TimeConstants.NrDaysInMonth:end);
    
    %% Loans, Mortgages and Leverage
    %Household Mortgages
    HH_TotalMortgages_temp = sum(HouseholdsTotalMortgage,2);
    HH_TotalMortgages(count,:) = HH_TotalMortgages_temp(SDIA:TimeConstants.NrDaysInMonth:EDIA);
    %Household Total assets
    HH_TotalAssets_temp = sum(HouseholdsTotalAssets,2);
    HH_TotalAssets(count,:) = HH_TotalAssets_temp(SDIA:TimeConstants.NrDaysInMonth:EDIA);
    %Household Equity
    HH_Equity_temp = sum(HouseholdsEquity,2);
    HH_Equity(count,:) = HH_Equity_temp(SDIA:TimeConstants.NrDaysInMonth:EDIA);
    %Household Leverage
    HH_Leverage(count,:) = HH_TotalMortgages(count,:)./HH_Equity(count,:);
    %Firm and CstrFirm Loans
    FI_TotalLoans_temp = sum(FirmsTotalDebts,2);
    FI_TotalLoans(count,:) = FI_TotalLoans_temp(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    CFI_TotalLoans_temp = sum(CstrFirmsTotalDebts,2);
    CFI_TotalLoans(count,:) = CFI_TotalLoans_temp(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    %Firm and CstrFirm Total Assets
    FI_TotalAsstes_temp = sum(FirmsTotalAssets,2);
    FI_TotalAssets(count,:) = FI_TotalAsstes_temp(SQIA:EQIA);
    CFI_TotalAsstes_temp = sum(CstrFirmsTotalAssets,2);
    CFI_TotalAssets(count,:) = CFI_TotalAsstes_temp(SQIA:EQIA);
    %Firm and CstrFirm Equity
    FI_Equity_temp = sum(FirmsEquity,2);
    FI_Equity(count,:) = FI_Equity_temp(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    CFI_Equity_temp = sum(CstrFirmsEquity,2);
    CFI_Equity(count,:) = CFI_Equity_temp(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    %Firm and CstrFirm Leverage
    FI_Leverage(count,:) = FI_TotalLoans(count,:)./FI_Equity(count,:);
    CFI_Leverage(count,:) = CFI_TotalLoans(count,:)./CFI_Equity(count,:);
    %Firm and CstrFirm Bankruptcies
    FI_Illiquidity(count,:) = FirmsIlliquidity(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    FI_Insolvency(count,:) = FirmsInsolvency(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    CFI_Illiquidity(count,:) = CstrFirmsIlliquidity(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    FI_TotalBankruptcies(count,:) = FI_Illiquidity(count,:) + FI_Insolvency(count,:) + CFI_Illiquidity(count,:);
    
    %% Additional values
    GDP_Growth_monthly(count,:) = diff(RealGDP_monthly(count,:))./RealGDP_monthly(count,1:(end-1));
    GDP_Growth_yearly(count,:) = diff(RealGDP_yearly(count,:))./RealGDP_yearly(count,1:(end-1));
    HM_MortgageRR(count,:) = BanksMortgageBlocked(1:TimeConstants.NrDaysInMonth:end) + ...
        HouseholdsMortgageRejected(1:TimeConstants.NrDaysInMonth:end);
    HM_Trades(count,:) = HousingTransactions(1:TimeConstants.NrDaysInMonth:end);
    BA_Equity_temp = sum(BanksEquity,2);
    BA_Equity(count,:) = BA_Equity_temp(SDIA:TimeConstants.NrDaysInQuarter:EDIA);
    HM_FireSales(count,:) = HousingsNumFireSale(1:TimeConstants.NrDaysInMonth:end);
    HH_QuarterlyRatio_temp = mean(HouseholdsHousingPayment,2)./(mean(HouseholdsQuarterlyIncome,2) + mean(HouseholdsQuarterlyCapitalIncome,2));
    HH_QuarterlyRatio(count,:) = HH_QuarterlyRatio_temp(1:TimeConstants.NrDaysInMonth:end);
    HH_TotalExp_Div_TotalIncome(count,:) = 1+diff(sum(HouseholdsLiquidity(1:TimeConstants.NrDaysInQuarter:end,:),2))./(sum(HouseholdsQuarterlyIncome(61:TimeConstants.NrDaysInQuarter:end,:),2) + sum(HouseholdsQuarterlyCapitalIncome(61:TimeConstants.NrDaysInQuarter:end,:),2));
    
    %% Note the parameter being changed
    SimBeta(count) = SimulationRunPar.BudgetConstraint;
    
    %% Clear values to save memory
    clear Household* Governmen* Firm* Cstr* Bank* Fund* InflationIndex t q y Housin* 
end
%% Create index
Idx_b02 = find(SimBeta == 0.2);
Idx_b025 = find(SimBeta == 0.25);
Idx_b03 = find(SimBeta == 0.3);
Idx_b04 = find(SimBeta == 0.4);
Idx_all = [Idx_b02;Idx_b025;Idx_b03;Idx_b04];
NrSeeds = numel(Idx_b02);
%% Create Table

for w = 1:4
    %% Table 1: Real values
    RealValues(1,w) = mean(mean(RealGDP_monthly(Idx_all(w,:),SMIA:EMIA)));
    RealValues(2,w) = mean(var(RealGDP_monthly_change(Idx_all(w,:),SMIA:(EMIA-1))));
    RealValues(3,w) = mean(mean(EC_Unemployment(Idx_all(w,:),SMIA:EMIA)./NrAgents.Households));
    RealValues(4,w) = mean(mean(HM_HousingStock(Idx_all(w,:),:)));
    RealValuesStd(1,w) = std(mean(GDP_monthly(Idx_all(w,:),SMIA:EMIA))/sqrt(NrSeeds));
    RealValuesStd(2,w) = std(var(RealGDP_monthly_change(Idx_all(w,:),SMIA:(EMIA-1))))/sqrt(NrSeeds);
    RealValuesStd(3,w) = std(mean(EC_Unemployment(Idx_all(w,:),SMIA:EMIA)./NrAgents.Households)/sqrt(NrSeeds));
    RealValuesStd(4,w) = std(mean(HM_HousingStock(Idx_all(w,:),:))/sqrt(NrSeeds));
    
    %% Table 2: Nominal values
    NominalValues(1,w) = mean(mean(EC_Pricelevel(Idx_all(w,:),SMIA:EMIA)));
    NominalValues(2,w) = mean(mean(EC_Wagelevel(Idx_all(w,:),SMIA:EMIA)));
    NominalValues(3,w) = mean(mean(HM_Housingpricelevel(Idx_all(w,:),SMIA:EMIA)));
    NominalValues(4,w) = mean(mean(EC_InterestRate(Idx_all(w,:),SMIA:EMIA)));
    NominalValuesStd(1,w) = std(mean(EC_Pricelevel(Idx_all(w,:),SMIA:EMIA))/sqrt(NrSeeds));
    NominalValuesStd(2,w) = std(mean(EC_Wagelevel(Idx_all(w,:),SMIA:EMIA))/sqrt(NrSeeds));
    NominalValuesStd(3,w) = std(mean(HM_Housingpricelevel(Idx_all(w,:),SMIA:EMIA))/sqrt(NrSeeds));
    NominalValuesStd(4,w) = std(mean(EC_InterestRate(Idx_all(w,:),SMIA:EMIA))/sqrt(NrSeeds));
    
    %% Table 3: Financing       
    FinancialValues(1,w) = mean(mean(HH_TotalMortgages(Idx_all(w,:),:)));
    FinancialValues(2,w) = mean(mean(HH_Leverage(Idx_all(w,:),:)));
    FinancialValues(3,w) = mean(mean(FI_TotalLoans(Idx_all(w,:),:)));
    FinancialValues(4,w) = mean(mean(FI_Leverage(Idx_all(w,:),:)));
    FinancialValuesStd(1,w) = std(mean(HH_TotalMortgages(Idx_all(w,:),:))/sqrt(NrSeeds));
    FinancialValuesStd(2,w) = std(mean(HH_Leverage(Idx_all(w,:),:))/sqrt(NrSeeds));
    FinancialValuesStd(3,w) = std(mean(FI_TotalLoans(Idx_all(w,:),:))/sqrt(NrSeeds));
    FinancialValuesStd(4,w) = std(mean(FI_Leverage(Idx_all(w,:),:))/sqrt(NrSeeds));
    
    %% Table 4: Additional variables
    AdditionalValues(1,w) = mean(mean(GDP_Growth_monthly(Idx_all(w,:),SMIA:(EMIA-1))));
    AdditionalValues(2,w) = mean(mean(GDP_Growth_yearly(Idx_all(w,:),SYIA:(EYIA-1))));
    AdditionalValues(3,w) = mean(mean(HM_MortgageRR(Idx_all(w,:),SMIA:EMIA)));
    AdditionalValues(4,w) = mean(mean(FI_TotalBankruptcies(Idx_all(w,:),:)));
    AdditionalValues(5,w) = mean(mean(HM_Trades(Idx_all(w,:),SMIA:EMIA)));
    AdditionalValues(6,w) = mean(mean(FI_Equity(Idx_all(w,:),:)));
    AdditionalValues(7,w) = mean(mean(BA_Equity(Idx_all(w,:),:)));
    AdditionalValues(8,w) = mean(mean(HM_FireSales(Idx_all(w,:),SMIA:EMIA)));
    AdditionalValues(9,w) = mean(mean(HH_QuarterlyRatio(Idx_all(w,:),SMIA:EMIA)));
    AdditionalValues(10,w) = mean(mean(HH_TotalExp_Div_TotalIncome(Idx_all(w,:),SQIA:(EQIA-1))));
    AdditionalValues(11,w) = mean(RealGDP_yearly_volatility(Idx_all(w,:),:));
    
    
    
    AdditionalValuesStd(1,w) = std(mean(GDP_Growth_monthly(Idx_all(w,:),SMIA:(EMIA-1))))/sqrt(NrSeeds);
    AdditionalValuesStd(2,w) = std(mean(GDP_Growth_yearly(Idx_all(w,:),SYIA:(EYIA-1))))/sqrt(NrSeeds);
    AdditionalValuesStd(3,w) = std(mean(HM_MortgageRR(Idx_all(w,:),SMIA:EMIA)))/sqrt(NrSeeds);
    AdditionalValuesStd(4,w) = std(mean(FI_TotalBankruptcies(Idx_all(w,:),:)))/sqrt(NrSeeds);
    AdditionalValuesStd(5,w) = std(mean(HM_Trades(Idx_all(w,:),SMIA:EMIA)))/sqrt(NrSeeds);
    AdditionalValuesStd(6,w) = std(mean(FI_Equity(Idx_all(w,:),:)))/sqrt(NrSeeds);
    AdditionalValuesStd(7,w) = std(mean(BA_Equity(Idx_all(w,:),:)))/sqrt(NrSeeds);
    AdditionalValuesStd(8,w) = std(mean(HM_FireSales(Idx_all(w,:),SMIA:EMIA)))/sqrt(NrSeeds);
    AdditionalValuesStd(9,w) = std(mean(HH_QuarterlyRatio(Idx_all(w,:),SMIA:EMIA)))/sqrt(NrSeeds);
    AdditionalValuesStd(10,w) = std(mean(HH_TotalExp_Div_TotalIncome(Idx_all(w,:),SQIA:(EQIA-1))))/sqrt(NrSeeds);
    AdditionalValuesStd(11,w) = std(RealGDP_yearly_volatility(Idx_all(w,:),:))/sqrt(NrSeeds);
end

%% Write to LaTeX

Output.RealValues{1} = RealValues;
Output.RealValues{2} = RealValuesStd;
Output.NominalValues{1} = NominalValues;
Output.NominalValues{2} = NominalValuesStd;
Output.FinancialValues{1} = FinancialValues;
Output.FinancialValues{2} = FinancialValuesStd;
Output.AdditionalValues{1} = AdditionalValues;
Output.NrSeeds{1} = NrSeeds;

TablesName = ['ICEACE_Tabels_NrSeeds_',num2str(NrSeeds),'_days_',num2str(SDIA),'_',num2str(EDIA),'.txt'];
TablesName2 = ['ICEACE_Tabels_NrSeeds_',num2str(NrSeeds),'_days_',num2str(SDIA),'_',num2str(EDIA),'.mat'];
save([Pat, TablesName],'RealValues','RealValuesStd','NominalValues','NominalValuesStd','FinancialValues','FinancialValuesStd','AdditionalValues','AdditionalValuesStd','-ascii', '-tabs')
save([Pat, TablesName2],'Output')