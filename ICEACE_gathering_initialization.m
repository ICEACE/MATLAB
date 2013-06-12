Sim_lenght = SimulationDay_final - SimulationStartingDay;

        HouseholdsLiquidity = zeros(Sim_lenght,NrAgents.Households);
        FirmsLiquidity = zeros(Sim_lenght,NrAgents.Firms);
        CstrFirmsLiquidity = zeros(Sim_lenght,NrAgents.CstrFirms);
        BanksLiquidity = zeros(Sim_lenght,NrAgents.Banks);
        
        FirmsTotalDebts = zeros(Sim_lenght,NrAgents.Firms);
        CstrFirmsTotalDebts = zeros(Sim_lenght,NrAgents.CstrFirms);
        BanksTotalLoans = zeros(Sim_lenght,NrAgents.Banks);
        BanksDeposits   = zeros(Sim_lenght,NrAgents.Banks);
        
        HouseholdsLaborIncome = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsQuarterlyCapitalIncome = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsQuarterlyIncome = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsBenefits = zeros(Sim_lenght,NrAgents.Households);
        
        HouseholdsHousingPayment = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsHousingInterestPayment = zeros(Sim_lenght,NrAgents.Households);
        
        BanksEarnings = zeros(Sim_lenght,NrAgents.Banks);
        FirmsEarnings = zeros(Sim_lenght,NrAgents.Firms);
        FirmsRevenues = zeros(Sim_lenght,NrAgents.Firms);
        CstrFirmsEarnings = zeros(Sim_lenght,NrAgents.CstrFirms);
        CstrFirmsRevenues = zeros(Sim_lenght,NrAgents.CstrFirms);
        
        FirmsLaborCosts = zeros(Sim_lenght,NrAgents.Firms);
        CstrFirmsLaborCosts = zeros(Sim_lenght,NrAgents.CstrFirms);
        
        FirmsEquity = zeros(Sim_lenght,NrAgents.Firms);
        CstrFirmsEquity = zeros(Sim_lenght,NrAgents.CstrFirms);
        
        BanksEquity = zeros(Sim_lenght,NrAgents.Banks);
        BanksRE = zeros(Sim_lenght,NrAgents.Banks);
        BanksTotalAssets = zeros(Sim_lenght,NrAgents.Banks);
        
        CentralBankDebt = zeros(Sim_lenght,NrAgents.Banks);
        
        EmployeesVector = zeros(Sim_lenght,NrAgents.CstrFirms+NrAgents.Firms);
        
        ExpectedSalesVector = zeros(Sim_lenght,NrAgents.Firms);
        
        ProductionVector = zeros(Sim_lenght,NrAgents.Firms);
               
        CstrProductionVector = zeros(Sim_lenght,NrAgents.CstrFirms);
        CstrProduction = zeros(Sim_lenght,1);
        CstrInventories = zeros(Sim_lenght,1);
        
        SalesVector = zeros(Sim_lenght,NrAgents.Firms);
        
        PriceVector = zeros(Sim_lenght,NrAgents.Firms);
        PriceIndex = zeros(Sim_lenght,1);
        WageIndex = zeros(Sim_lenght,1);
        Inflation = zeros(Sim_lenght,1);
        
        LaborDemandVector = zeros(Sim_lenght,NrAgents.CstrFirms+NrAgents.Firms);
        ProductionPlanVector = zeros(Sim_lenght,NrAgents.Firms);
        CstrProductionPlanVector = zeros(Sim_lenght,NrAgents.CstrFirms);
        
        InventoriesVector = zeros(Sim_lenght,NrAgents.Firms);
        
        CBRate = zeros(Sim_lenght,1);
        
        HouseholdsHousingAmount = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsHousingValue = zeros(Sim_lenght,NrAgents.Households);
        %HouseholdsSavings = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsEquity = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsTotalAssets = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsTotalMortgage = zeros(Sim_lenght,NrAgents.Households);
        HouseholdsMortgagesWrittenOff = zeros(Sim_lenght,NrAgents.Households);
        
        HousingPrices = zeros(Sim_lenght,1);
        
        HousingTransactions = zeros(Sim_lenght,1);
        HousingDemand = zeros(Sim_lenght,1);
        HousingSupply = zeros(Sim_lenght,1);
        HousingsNumFireSale = zeros(Sim_lenght,1);
        
        %BanksSavingsAccounts = Banks.SavingsAccounts;
        BanksTotalMortgages = zeros(Sim_lenght,NrAgents.Banks);
        
        BanksMortgageBlocked = zeros(Sim_lenght,1);
        HouseholdsMortgageRejected = zeros(Sim_lenght,1);
        
        GovernmentLiquidity = zeros(Sim_lenght,1);
        GovernmentBonds =  zeros(Sim_lenght,1);
        GovernmentCapitalIncomeTax = zeros(Sim_lenght,1);
        GovernmentLaborTax = zeros(Sim_lenght,1);
        GovernmentEarnings = zeros(Sim_lenght,1);
        GovernmentBenefitsPaid = zeros(Sim_lenght,1);
        GovernmentExpenditures = zeros(Sim_lenght,1);
        GovernmentBalance = zeros(Sim_lenght,1);
        GovernmentUnempBenefits = zeros(Sim_lenght,1);
        GovernmentGeneralBenefits = zeros(Sim_lenght,1);
        
        LaborTax = zeros(Sim_lenght,1);
        CapitalIncomeTax = zeros(Sim_lenght,1);
        UnemploymentRatio = zeros(Sim_lenght,1);
        BenefitRatio = zeros(Sim_lenght,1);
        
        FirmsInsolvency = zeros(Sim_lenght,1);
        FirmsIlliquidity = zeros(Sim_lenght,1);
%        CstrFirmsInsolvency = zeros(Sim_lenght,1);
        CstrFirmsIlliquidity = zeros(Sim_lenght,1);
        
        FundLiquidity = zeros(Sim_lenght,1);
        FundEquity = zeros(Sim_lenght,1);
        FundFirmInvestment = zeros(Sim_lenght,1);
        
        
         FirmsEBITs = zeros(Sim_lenght/60,NrAgents.Firms);
            FirmsTotalAssets = zeros(Sim_lenght/60,NrAgents.Firms);
            CstrFirmsEBITs = zeros(Sim_lenght/60,NrAgents.CstrFirms);
            CstrFirmsTotalAssets= zeros(Sim_lenght/60,NrAgents.CstrFirms);