% ICEACE data structuring for plotting

clc
clear all
close all

RunNumber = 18;
SimulationDurationInQuarters = 25;

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end
font_sz = 14;

SimulationDay0 = 80;
SimulationDay_final = SimulationDurationInQuarters*3*20+60;
visualization_step = 80;



ii = 0;
quarter = 0;
for d = SimulationDay0:SimulationDay_final
    
    clear Households Firms Banks
    
    ii = ii + 1;
    Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
    load([Pat, Filename])
    
    HouseholdsLiquidity(ii,:) = Households.Liquidity;
    FirmsLiquidity(ii,:) = Firms.Liquidity;
    BanksLiquidity(ii,:) = Banks.Liquidity;
       
    FirmsTotalDebts(ii,:) = Firms.TotalDebts;
    BanksTotalLoans(ii,:) = Banks.TotalLoans;
    BanksDeposits(ii,:)   = Banks.Deposits;
    
    HouseholdsLaborIncome(ii,:) = Households.LaborIncome;
    HouseholdsQuarterlyCapitalIncome(ii,:) = Households.QuarterlyCapitalIncome;
    HouseholdsHousingPayment(ii,:) = Households.HousingPayment;

    BanksEarnings(ii,:) = Banks.Earnings;
    FirmsEarnings(ii,:) = Firms.Earnings;
    FirmsRevenues(ii,:) = Firms.Revenues;
    
    FirmsLaborCosts(ii,:) = Firms.LaborCosts;
    
    FirmsEquity(ii,:) = Firms.Equity;
    
    BanksEquity(ii,:) = Banks.Equity;
    BanksRE(ii,:) = Banks.RetainedEarnings;
    BanksTotalAssets(ii,:) = Banks.TotalAssets;
    
    CentralBankDebt(ii,:) = Banks.CentralBankDebt;
    
    EmployeesVector(ii,:) = Firms.NrEmployees;
    
    ExpectedSalesVector(ii,:) = Firms.ExpectedSales;
    
    UnemployedWorkers(ii,1) = numel(find(Households.employer==-1));
    ProductionVector(ii,:) = Firms.ProductionQty;
    Production(ii,1) = sum(Firms.ProductionQty);
    Inventories(ii,1) = sum(Firms.Inventories);
    
    SalesVector(ii,:) = Firms.MonthlySales(end,:);
    
    PriceVector(ii,:) = Firms.price;
    PriceIndex(ii,1) = mean(Firms.price);
    WageIndex(ii,1) = mean(Firms.wage);
    Inflation(ii,1) = PriceIndices.Inflation;
    
    LaborDemandVector(ii,:) = Firms.LaborDemand;
    ProductionPlanVector(ii,:) = Firms.ProductionPlan;
    
    InventoriesVector(ii,:) = Firms.Inventories;
    
    CBRate(ii,1) = PriceIndices.CBInterestRate;
    
    HouseholdsHousingAmount(ii,:) = Households.HousingAmount;
    HouseholdsHousingValue(ii,:) = Households.HousingValue;
    HouseholdsSavings(ii,:) = Households.Savings;
    HouseholdsEquity(ii,:) = Households.Equity;
    HouseholdsTotalAssets(ii,:) = Households.TotalAssets;
    HouseholdsTotalMortgage(ii,:) = Households.TotalMortgage;
    
    HouseholdsHousingPayment(ii,:) = Households.HousingPayment;
    HousingTransactions(ii,:) = REmarket.Transactions;
        
    BanksSavingsAccounts(ii,:) = Banks.SavingsAccounts;
    BanksTotalMortgages(ii,:) = Banks.TotalMortgage;
    
    
    if mod(d,TimeConstants.NrDaysInQuarter)==1     
        quarter = quarter + 1
        FirmsEBITs(quarter,:) = Firms.EBIT;
        FirmsTotalAssets(quarter,:) = Firms.TotalAssets;
    end

  
    
end
HousingPrices = REmarket.HousingPrice;
%% Save
Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
save([Pat, Filename])