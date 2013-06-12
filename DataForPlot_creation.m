ii = d - SimulationStartingDay;

HouseholdsLiquidity(ii,:) = Households.Liquidity;
FirmsLiquidity(ii,:) = Firms.Liquidity;
BanksLiquidity(ii,:) = Banks.Liquidity;

FirmsTotalDebts(ii,:) = Firms.TotalDebts;
BanksTotalLoans(ii,:) = Banks.TotalLoans;
BanksDeposits(ii,:)   = Banks.Deposits;

HouseholdsLaborIncome(ii,:) = Households.LaborIncome;
HouseholdsQuarterlyCapitalIncome(ii,:) = Households.QuarterlyCapitalIncome;

HouseholdsHousingPayment(ii,:) = Households.HousingPayment;
HouseholdsHousingInterestPayment(ii,:) = Households.HousingInterestPayment;

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


HousingPrices(ii,:) = REmarket.HousingPrice(end);

HousingTransactions(ii,1) = REmarket.Transactions;
HousingDemand(ii,1) = REmarket.Demand;
HousingSupply(ii,1) = REmarket.Supply;
HousingsNumFireSale(ii,1) = Remarket.NumFireSale;

BanksSavingsAccounts(ii,:) = Banks.SavingsAccounts;
BanksTotalMortgages(ii,:) = Banks.TotalMortgage;

BanksMortgageBlocked(ii,1) = BankMortgageBlocked;
HouseholdsMortgageRejected(ii,1) = HouseholdMortgageRejected;

%% Save
Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
save([Pat, Filename])