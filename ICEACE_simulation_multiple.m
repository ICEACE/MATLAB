
randn('seed',SimulationRunPar.RandomSeed)
rand('seed',SimulationRunPar.RandomSeed)

%% Set the run number, the simulation starting day and duration
RunNumber = SimulationRunPar.RunNumber;
SimulationStartingDay = 60;
SimulationDurationInQuarters = Simulation.DurationInQuarters;

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(SimulationStartingDay), '.mat'];
load([Pat, Filename])

SimulationFinalDay = SimulationStartingDay + SimulationDurationInQuarters*TimeConstants.NrDaysInQuarter;
SimulationDurationInDays = SimulationDurationInQuarters*TimeConstants.NrDaysInQuarter;
% %fprintf('\n Simulation run: %d Start at day: %d and end at day %d',RunNumber,SimulationStartingDay+1,...
%     SimulationFinalDay)

%% Main simulation loop

month_no = SimulationStartingDay/TimeConstants.NrDaysInMonth;
for d = (SimulationStartingDay+1):(SimulationStartingDay+SimulationDurationInDays)
    % Current month
    
    %% production and wage payment (monthly labor income)
    if mod(d,TimeConstants.NrDaysInMonth) == 0    %  End of month       
        Firms_production
        Firms_productionCosts   % Computation of Production costs
        Firms.Inventories = Firms.Inventories + Firms.ProductionQty;
        CstrFirms_production %Housing projects are either advanced or finished
        Government_pay_benefits_to_Households
        Firms_pay_wages_to_Households
    end
     
    %% pricing and production plan
    if mod(d,TimeConstants.NrDaysInMonth) == 1    %  Beginning of month
        
        month_no = month_no + 1;
        
        Firms_pricing 
        Firms_production_plan
        Firms_firing
        Firms_raise_wages
        
        CstrFirms_production_plan
        CstrFirms_firing
        CstrFirms_raise_wages
        
        LaborMarket_employees_turnover
        LaborMarket_unemploied

        Households_savings
        Households_housing_decision
        Households_housingmarket
        
        if UseSecuritization == 1
            Households_fund_access_decision
        end
        
        %% Statistical Office
        PriceIndices.wage = mean([Firms.wage,CstrFirms.wage]);
        PriceIndices.ConsumptionGoods = mean(Firms.price);
        
        Stats.MonthlyNominalGDP = sum(Firms.ProductionQty*PriceIndices.ConsumptionGoods)+...
            sum(CstrFirms.FinishedProjects*REmarket.HousingPrice(end));
        Stats.MonthlyNominalGDP_vect = ...
            [Stats.MonthlyNominalGDP_vect(2:3), Stats.MonthlyNominalGDP];
        
        Stats.MonthlyNominalGDP_RE = sum(CstrFirms.FinishedProjects*REmarket.HousingPrice(end));
        Stats.MonthlyNominalGDP_RE_vect = ...
            [Stats.MonthlyNominalGDP_RE_vect(2:3), Stats.MonthlyNominalGDP_RE];

    end
    
    PriceIndices.ConsumptionGoods_hist(d) = PriceIndices.ConsumptionGoods;

    if mod(d,TimeConstants.NrDaysInQuarter) == 1    %  Beginning of quarter
        Banks.Earnings = zeros(1,NrAgents.Banks);
        Stats.QuartelyNominalGDP = sum(Stats.MonthlyNominalGDP_vect);
        Stats.QuartelyNominalGDP_RE = sum(Stats.MonthlyNominalGDP_RE_vect);

        %% Households repay mortgages to banks
        Households_repay_mortgage_to_banks
        %% Interest flows computation
        Firms_compute_interest_payments
        CstrFirms_compute_interest_payments
        Banks_compute_interest_proceeds
        Consistency_Check_Interests_Flows
        Banks_compute_interest_payments
         
        %% Income statement computation
        Firms_compute_income_statement
        CstrFirms_compute_income_statement
        Firms_compute_dividends
        CstrFirms_compute_dividends
        Banks_compute_income_statement
        Banks_compute_dividends
        
        %% Firms' borrowing
        Firms_compute_borrowing_needs
        CstrFirms_compute_borrowing_needs
        Firms_borrow_from_Banks
        Firms_illiquidity_exit_entry
        CstrFirms_illiquidity_exit_entry
        
        %% Interest flows accounting
        Firms_subtract_interest_payments
        CstrFirms_subtract_interest_payments
        Banks_account_interest_flows
 
        %% Dividends payment (quarterly capital income)
        %Firms_pay_dividends_to_Households
        Firms_pay_dividends_to_Fund
        %CstrFirms_pay_dividends_to_Households
        CstrFirms_pay_dividends_to_Fund
        %Banks_pay_dividends_to_Households
        Banks_pay_dividends_to_Fund
        Fund_pay_dividends_to_Households
        Households.QuarterlyCapitalIncome = Households.CapitalIncomeFirms; %+ Households.CapitalIncomeCstrFirms + Households.CapitalIncomeBanks;
        %% Government income statement and balance sheet
        Government_compute_income_statement
        Government_compute_balance_sheet
        Government_set_taxes_to_zero
        %% Balance sheet computation of Fund, Firms, CstrFirms and Households
        Fund_compute_balance_sheet
        Firms_compute_balance_sheet       
        Firms_insolvency_exit_entry
        CstrFirms_compute_balance_sheet
        %CstrFirms_insolvency_exit_entry
        Households_compute_balance_sheet
        %% Deposits update (according to the previous-period total assets share)
        BanksDepositsOld = Banks.Deposits;
        Banks.Deposits = (Banks.TotalAssets/sum(Banks.TotalAssets))*...
            (sum(Households.Liquidity)+sum(Firms.Liquidity)+sum(CstrFirms.Liquidity));
        %% Banks liquidity update according to deposits changes
        Banks.Liquidity = Banks.Liquidity + (Banks.Deposits - BanksDepositsOld);
        %% Banks Compute Balance sheet
        Banks_compute_balance_sheet
        %% Government tax and benefit policy
        Government_tax_policy
    end
    
    if UseSecuritization == 1
        %Funds pay interests to households:
        Funds_pay_interests_to_households
        %the credit securitization market will happen twice a year
        if mod((d-1)/TimeConstants.NrDaysInQuarter,2) == 0
            credit_securitization_market_start_trigger
        end
    end
    
    %% Weekly consumption
    if mod(d,TimeConstants.NrDaysInWeek) == 1
        Households_buy_consumption_goods_pay_Firms
    end
    
    
    %% Central Bank Policy
    CentralBank_TaylorPolicy
    
     %% Saving
     Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
     save([Pat, Filename])
    
end
