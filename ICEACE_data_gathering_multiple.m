
for RunNumber=3235402:3235403
    
    if isunix
        Pat = '../../runs/';
    else
        Pat = '..\..\runs\';
    end
    
    SimulationStartingDay = 60;
    SimulationDurationInQuarters = 60;

SimulationDay_final = SimulationStartingDay + SimulationDurationInQuarters*3*20;
    
    ii = 0;
    quarter = 0;
    for d = (SimulationStartingDay+1):SimulationDay_final       
        
        clear Households Banks CsrtFirms Government CentralBank Firms
        clear REmarket TimeConstants PriceIndices NrAgents
        
        ii = ii + 1;
        Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
        load([Pat, Filename])
        
        HouseholdsLiquidity(ii,:) = Households.Liquidity;
        FirmsLiquidity(ii,:) = Firms.Liquidity;
        CstrFirmsLiquidity(ii,:) = CstrFirms.Liquidity;
        BanksLiquidity(ii,:) = Banks.Liquidity;
        
        FirmsTotalDebts(ii,:) = Firms.TotalDebts;
        CstrFirmsTotalDebts(ii,:) = CstrFirms.TotalDebts;
        BanksTotalLoans(ii,:) = Banks.TotalLoans;
        BanksDeposits(ii,:)   = Banks.Deposits;
        
        HouseholdsLaborIncome(ii,:) = Households.LaborIncome;
        HouseholdsQuarterlyCapitalIncome(ii,:) = Households.QuarterlyCapitalIncome;
        HouseholdsQuarterlyIncome(ii,:) = sum(Households.QuarterlyLaborIncome);
        HouseholdsBenefits(ii,:) = Households.Benefits;
        
        HouseholdsHousingPayment(ii,:) = Households.HousingPayment;
        HouseholdsHousingInterestPayment(ii,:) = Households.HousingInterestPayment;
        
        BanksEarnings(ii,:) = Banks.Earnings;
        FirmsEarnings(ii,:) = Firms.Earnings;
        FirmsRevenues(ii,:) = Firms.Revenues;
        CstrFirmsEarnings(ii,:) = CstrFirms.Earnings;
        CstrFirmsRevenues(ii,:) = CstrFirms.Revenues;
        
        FirmsLaborCosts(ii,:) = Firms.LaborCosts;
        CstrFirmsLaborCosts(ii,:) = CstrFirms.LaborCosts;
        
        FirmsEquity(ii,:) = Firms.Equity;
        CstrFirmsEquity(ii,:) = CstrFirms.Equity;
        
        BanksEquity(ii,:) = Banks.Equity;
        BanksRE(ii,:) = Banks.RetainedEarnings;
        BanksTotalAssets(ii,:) = Banks.TotalAssets;
        
        CentralBankDebt(ii,:) = Banks.CentralBankDebt;
        
        EmployeesVector(ii,:) = [Firms.NrEmployees,CstrFirms.NrEmployees];
        
        ExpectedSalesVector(ii,:) = Firms.ExpectedSales;
        
        UnemployedWorkers(ii,1) = numel(find(Households.employer_id==-1));
        CGPEmployedWorkers(ii,1) = numel(find(Households.employer_id==1));
        CstrFEmployedWorkers(ii,1) = numel(find(Households.employer_id==2));
        ProductionVector(ii,:) = Firms.ProductionQty;
        Production(ii,1) = sum(Firms.ProductionQty);
        Inventories(ii,1) = sum(Firms.Inventories);
        
        CstrProductionVector(ii,:) = CstrFirms.FinishedProjects;
        CstrProduction(ii,1) = sum(CstrFirms.FinishedProjects);
        CstrInventories(ii,1) = sum(CstrFirms.Inventories);
        
        SalesVector(ii,:) = Firms.MonthlySales(end,:);
        
        PriceVector(ii,:) = Firms.price;
        PriceIndex(ii,1) = mean(Firms.price);
        WageIndex(ii,1) = mean(Firms.wage);
        Inflation(ii,1) = PriceIndices.Inflation;
        
        LaborDemandVector(ii,:) = [Firms.LaborDemand,CstrFirms.LaborDemand];
        ProductionPlanVector(ii,:) = Firms.ProductionPlan;
        CstrProductionPlanVector(ii,:) = CstrFirms.ProductionPlan;
        
        InventoriesVector(ii,:) = Firms.Inventories;
        
        CBRate(ii,1) = PriceIndices.CBInterestRate;
        
        HouseholdsHousingAmount(ii,:) = Households.HousingAmount;
        HouseholdsHousingValue(ii,:) = Households.HousingValue;
        %HouseholdsSavings(ii,:) = Households.Savings;
        HouseholdsEquity(ii,:) = Households.Equity;
        HouseholdsTotalAssets(ii,:) = Households.TotalAssets;
        HouseholdsTotalMortgage(ii,:) = Households.TotalMortgage;
        HouseholdsMortgagesWrittenOff(ii,:) = Households.MortgagesWrittenOff;
        
        HousingPrices(ii,:) = REmarket.HousingPrice(end);
        
        HousingTransactions(ii,1) = REmarket.Transactions;
        HousingDemand(ii,1) = REmarket.Demand;
        HousingSupply(ii,1) = REmarket.Supply;
        HousingsNumFireSale(ii,1) = Remarket.NumFireSale;
        
        %BanksSavingsAccounts(ii,:) = Banks.SavingsAccounts;
        BanksTotalMortgages(ii,:) = Banks.TotalMortgage;
        
        BanksMortgageBlocked(ii,1) = BankMortgageBlocked;
        HouseholdsMortgageRejected(ii,1) = HouseholdMortgageRejected;
        
        GovernmentLiquidity(ii,1) = Government.Liquidity;
        GovernmentBonds(ii,1) = Government.Bonds;
        GovernmentCapitalIncomeTax(ii,1) = Government.CapitalIncomeTax;
        GovernmentLaborTax(ii,1) = Government.LaborTax;
        GovernmentEarnings(ii,1) = Government.Earnings;
        GovernmentBenefitsPaid(ii,1) = Government.BenefitsPaid;
        GovernmentExpenditures(ii,1) = Government.Expenditures;
        GovernmentBalance(ii,1) = Government.Balance;
        GovernmentUnempBenefits(ii,1) = Government.UnempBenefitsPaid_sum;
        GovernmentGeneralBenefits(ii,1) = Government.GeneralBenefitsPaid_sum;
        
        LaborTax(ii,1) = PriceIndices.LaborTax;
        CapitalIncomeTax(ii,1) = PriceIndices.CapitalIncomeTax;
        UnemploymentRatio(ii,1) = PriceIndices.UnemploymentBenefitRatio;
        BenefitRatio(ii,1) = PriceIndices.TransferBenefitRatio;
        
        FirmsInsolvency(ii,1) = numel(insolvent_firms);
        FirmsIlliquidity(ii,1) = numel(illiquid_firms);
%        CstrFirmsInsolvency(ii,1) = numel(insolvent_cstrfirms);
        CstrFirmsIlliquidity(ii,1) = numel(illiquid_cstrfirms);
        
        FundLiquidity(ii,1) = Fund.Liquidity;
        FundEquity(ii,1) = Fund.Equity;
        FundFirmInvestment(ii,1) = Fund.FirmInvestment;
        
        if mod(d,TimeConstants.NrDaysInQuarter)==1
            quarter = quarter + 1;            
            fprintf('\r run: %d quarter: %d (%d)',RunNumber,quarter,...
                SimulationDurationInQuarters)
            FirmsEBITs(quarter,:) = Firms.EBIT;
            FirmsTotalAssets(quarter,:) = Firms.TotalAssets;
            CstrFirmsEBITs(quarter,:) = CstrFirms.EBIT;
            CstrFirmsTotalAssets(quarter,:) = CstrFirms.TotalAssets;
        end
        
             
    end
    
    %% Save
    Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
    save([Pat, Filename])
    
    clear all        
end