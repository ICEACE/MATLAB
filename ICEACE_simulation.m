%Simulation of the ICEACE economy

clear all
close all
clc

randn('seed',1234567)
rand('seed',1234567)

%% Set the run number, the simulation starting day and duration
RunNumber = 221;
SimulationStartingDay = 60;
SimulationDurationInQuarters = 40;

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(SimulationStartingDay), '.mat'];
load([Pat, Filename])

SimulationFinalDay = SimulationStartingDay + SimulationDurationInQuarters*TimeConstants.NrDaysInQuarter;
SimulationDurationInDays = SimulationDurationInQuarters*TimeConstants.NrDaysInQuarter;
fprintf('\n Simulation run: %d Start at day: %d and end at day %d',RunNumber,SimulationStartingDay+1,...
    SimulationFinalDay)

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
        
        %Stats - Growth of housing prices and wages$

        Households_savings
        Households_housing_decision
        Households_housingmarket   
        
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
        %Households_save_excess_liq
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
        
        %% Interest flows accounting
        Firms_subtract_interest_payments
        CstrFirms_subtract_interest_payments
        Banks_account_interest_flows
 
        %% Dividends payment (quarterly capital income)
        Firms_pay_dividends_to_Households
        CstrFirms_pay_dividends_to_Households
        Banks_pay_dividends_to_Households
        Households.QuarterlyCapitalIncome = Households.CapitalIncomeFirms + Households.CapitalIncomeCstrFirms + Households.CapitalIncomeBanks;
    
        %% Government income statement and balance sheet
        Government_compute_income_statement
        %bond issue??
        Government_compute_balance_sheet
        %Government
        Government_set_taxes_to_zero
        %% Deposits update (according to the previous-period total assets share)
        BanksDepositsOld = Banks.Deposits;
        Banks.Deposits = (Banks.TotalAssets/sum(Banks.TotalAssets))*...
            (sum(Households.Liquidity)+sum(Firms.Liquidity)+sum(CstrFirms.Liquidity));
        %% Banks liquidity update according to deposits changes
        Banks.Liquidity = Banks.Liquidity + (Banks.Deposits - BanksDepositsOld);
        %% Balance sheet computation
        Firms_compute_balance_sheet
        CstrFirms_compute_balance_sheet
        Banks_compute_balance_sheet
        Households_compute_balance_sheet
        %% Government tax and benefit policy
        Government_tax_policy
%       %% Print to screen some key information
%       fprintf('\n Banks Deposits: %d %d %d %d %d',Banks.Deposits)
%       fprintf('\n Banks Savings: %d %d %d %d %d',Banks.SavingsAccounts)
%       fprintf('\n Banks CB debt: %d %d %d %d %d',Banks.CentralBankDebt)
%        fprintf('\n Banks Equity: %d %d %d %d %d',Banks.Equity)
%        fprintf('\n Banks RE: %d %d %d %d %d',Banks.RetainedEarnings)
%       fprintf('\n Banks Liabilities: %d %d %d %d %d',Banks.Deposits +  Banks.Equity + Banks.CentralBankDebt)
%       fprintf('\n Banks Liquidity: %d %d %d %d %d',Banks.Liquidity)
%       fprintf('\n Banks Total Loans: %d %d %d %d %d',Banks.TotalLoans)
%       fprintf('\n Banks Mortgages: %d %d %d %d %d',Banks.TotalMortgage)
%       fprintf('\n Banks-Hh Mortgages: %d %d',sum(Banks.TotalMortgage)-sum(Households.TotalMortgage))
%       fprintf('\n Banks Assets: %d %d %d %d %d',Banks.TotalLoans + Banks.TotalMortgage + Banks.Liquidity)
%       fprintf('\n Households mean worker [EqRatio,Households.H,Households.C]: %f %f %f',[mean(Households.Equity(Households.IsCapitalist == 0)./Households.TotalAssets(Households.IsCapitalist == 0)),mean(Households.H(Households.IsCapitalist == 0)),mean(Households.C(Households.IsCapitalist == 0))])
%       fprintf('\n Households mean capitalist [EqRatio,Households.H,Households.C]: %f %f %f',[mean(Households.Equity(Households.IsCapitalist == 1)./Households.TotalAssets(Households.IsCapitalist == 1)),mean(Households.H(Households.IsCapitalist == 1)),mean(Households.C(Households.IsCapitalist == 1))])
%       fprintf('\n Households mean [Expenditure, Labour rev, Capital rev]: %f %f %f',[mean(Households.HousingPayment), 0.25*mean(Households.LaborIncome*3), 0.25*mean(Households.QuarterlyCapitalIncome)])
%       fprintf('\n Interest rates [CB, Firms, Households, Infl]: %f %f %f %f',[PriceIndices.CBInterestRate,PriceIndices.InterestRate,PriceIndices.MortgageRate,PriceIndices.Inflation])
        
    end
    
%     %% Production planning
%     if mod(d,TimeConstants.NrDaysInMonth) == 1    %  Beginning of month       
%         Firms_production_planning
%     end
    
    %% Weekly consumption
    if mod(d,TimeConstants.NrDaysInWeek) == 1
        Households_buy_consumption_goods_pay_Firms
    end
    
    
    %% Central Bank Policy
%     if mod(d,TimeConstants.NrDaysInMonth) == 1    %  Beginning of month
%         PriceIndices.Inflation = (PriceIndices.price(d)-PriceIndices.price(max(1,d-TimeConstants.NrDaysInYear)))/PriceIndices.price(max(1,d-TimeConstants.NrDaysInYear));
%         %if sum(Firms.ProductionQty)<(NrAgents.Households*FirmsLaborProductivity0)
%         if PriceIndices.Inflation < 0
%             PriceIndices.CBInterestRate = 0.02;
%             PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
%             PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
%         elseif PriceIndices.Inflation > PriceIndices.CBInterestRate + 0.005
%             PriceIndices.CBInterestRate = PriceIndices.CBInterestRate + 0.005;
%             PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
%             PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
%         elseif PriceIndices.Inflation < PriceIndices.CBInterestRate - 0.005
%             PriceIndices.CBInterestRate = PriceIndices.CBInterestRate - 0.005;
%             PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
%             PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
%         else
%             PriceIndices.CBInterestRate = PriceIndices.CBInterestRate;
%             PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
%             PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;
%         end
%     end   

    CentralBank_TaylorPolicy
    
     %% Saving
     Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
     save([Pat, Filename])
    if (mod(d,60)==0)
        fprintf('\n Simulation run: %d day: %d of %d',RunNumber,d,SimulationFinalDay)
        
    end
    
     
    
end
