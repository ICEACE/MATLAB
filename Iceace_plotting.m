clc
clear all
%close all

RunNumber = 1504;

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end
font_sz = 14;

line_wdt = 1;

colore = 'b';
colore2 = 'b';
Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
load([Pat, Filename]);
%SimulationFinalDay = d
XVector_quarter = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
XVector_year = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;
XVector_month = (1:(SimulationFinalDay-SimulationStartingDay)/TimeConstants.NrDaysInMonth);
Num_years = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInYear;
Num_quarters = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInQuarter;
quarters_visualization_step = 1;
visualization_vector = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
visualization_vector_quarter = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;


%% Aggregate households and Firms Liquidity
figure(1); hold on; grid on
set(gcf,'Name','Households and Firms Liquidity')
plot(XVector_year,sum(HouseholdsLiquidity,2),colore)
plot(XVector_year,sum(FirmsLiquidity,2)+sum(CstrFirmsLiquidity,2),colore,'linewidth',2)
plot(XVector_year,sum(HouseholdsLiquidity,2)+sum(FirmsLiquidity,2)+sum(CstrFirmsLiquidity,2),[':', colore],'linewidth',2)
%plot(XVector_year,sum(BanksDeposits,2),'g')

xlabel('quarters','fontsize',font_sz)
title('Aggregate Liquidity','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Households','All Firms','Households + All Firms',0)


%% Debts and Loans
figure(2); hold on; grid on
plot(XVector_year,sum(FirmsTotalDebts,2),colore)
plot(XVector_year,sum(CstrFirmsTotalDebts,2),colore)
plot(XVector_year,sum(BanksTotalLoans,2),colore)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Aggregate debt and Loans','fontsize',font_sz)
legend('Firms','CstrFirms','Banks',0)


%% Iceace fundamental identity
figure(3); hold on; grid on
set(gcf,'Name','Banks balance sheet identity')
plot(XVector_year,sum(BanksTotalLoans,2)+sum(BanksTotalMortgages,2)+sum(BanksLiquidity,2)-sum(HouseholdsLiquidity,2)-sum(FirmsLiquidity,2)-sum(BanksEquity,2)-sum(CentralBankDebt,2),'b') %-sum(BanksSavingsAccounts,2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Fundamental Iceace identity','fontsize',font_sz)
legend('Constant = Banks Total Loans - Hoseuholds Liquidity - Firms Liquidity - Banks Equity - Central Bank Debt',0)

%% Earnings
figure(4); hold on; grid on
set(gcf,'Name','Aggregate Earnings')
plot(XVector_year,sum(HouseholdsLaborIncome,2),[':', colore])
plot(XVector_year,sum(HouseholdsQuarterlyCapitalIncome,2),[':', colore],'linewidth',2)
plot(XVector_year,sum(FirmsEarnings,2),colore)
plot(XVector_year,sum(BanksEarnings,2),colore,'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Aggregate Earnings','fontsize',font_sz)
legend('Firms','Banks',0)
legend('Households Labor','Households Capital','Firms','Banks',0)


%% Firms' Revenues
figure(5); hold on; grid on
set(gcf,'Name','Firms Revenues')
plot(XVector_year,sum(FirmsRevenues,2),colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Firms aggregate revenues','fontsize',font_sz)

%% Firms' Equity 
figure(6); hold on; grid on
set(gcf,'Name','Firms Equity')
plot(XVector_year,sum(FirmsEquity,2),colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Firms aggregate equity','fontsize',font_sz)

%% Central Bank Debt
figure(7); hold on; grid on
%ylim([0, max(max(CentralBankDebt))*2])
for b=1:NrAgents.Banks
    plot(XVector_year, CentralBankDebt(:,b), colore)
end
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Central Bank Debt','fontsize',font_sz)

%% Production, Inventories, unemployment
figure(8); hold on; grid on
set(gcf,'Name','Production, Inventories, unemployment')
subplot(3,1,1); hold on; grid on
plot(XVector_year, Production,colore)
ylabel('production','fontsize',font_sz)
subplot(3,1,2); hold on; grid on
plot(XVector_year, Inventories,colore)
ylabel('inventories','fontsize',font_sz)
subplot(3,1,3); hold on; grid on
plot(XVector_year, UnemployedWorkers,colore)
ylabel('unemployment','fontsize',font_sz)

%% Banks' Equity 
figure(11); hold on; grid on
plot(XVector_year,sum(BanksEquity,2),colore)
plot(XVector_year,sum(BanksRE,2),'r')
plot(XVector_year,sum(BanksDeposits,2),'b')
plot(XVector_year,sum(BanksEarnings,2),'c')
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Banks aggregate equity and RE','fontsize',font_sz)
legend('Equity','Retained earnings','Deposits','Earnings',0)


%% Price and wage indices
figure(20); 
set(gcf,'Name','Interests and Prices')
subplot(4,1,1); hold on; grid on
plot(XVector_year, PriceIndex,colore)
ylabel('price index','fontsize',font_sz)
subplot(4,1,2); hold on; grid on
plot(XVector_year, WageIndex, colore)
ylabel('wage index','fontsize',font_sz)
subplot(4,1,3); hold on; grid on
plot(XVector_year, Inflation, colore)
ylabel('12m Inflation','fontsize',font_sz)

subplot(4,1,4); hold on; grid on
plot(XVector_year,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)



%% Banks
figure(22); hold on; grid on
subplot(2,1,1); hold on; grid on
plot(XVector_year, BanksTotalLoans(:,1),colore)
plot(XVector_year, BanksTotalMortgages(:,1),'r')
plot(XVector_year, BanksEquity(:,1),'g')
plot(XVector_year, CentralBankDebt(:,1),'y')
plot(XVector_year, BanksDeposits(:,1),'b')
%plot(XVector_year, BanksSavingsAccounts(:,1),'c')
plot(XVector_year, BanksLiquidity(:,1),':c')
plot(XVector_year, BanksRE(:,1),':r')
plot(XVector_year, BanksTotalAssets(:,1),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Liquidity','RE','TA',0)
subplot(2,1,2); hold on; grid on
plot(XVector_year, BanksTotalLoans(:,2),colore)
plot(XVector_year, BanksTotalMortgages(:,2),'r')
plot(XVector_year, BanksEquity(:,2),'g')
plot(XVector_year, CentralBankDebt(:,2),'y')
plot(XVector_year, BanksDeposits(:,2),'b')
%plot(XVector_year, BanksSavingsAccounts(:,2),'c')
plot(XVector_year, BanksLiquidity(:,2),':c')
plot(XVector_year, BanksRE(:,2),':r')
plot(XVector_year, BanksTotalAssets(:,2),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Liquidity','RE','TA',0) %'Savings',
%plot(XVector_year, sum(BanksEarnings,2), colore)
%ylabel('Banks income statement','fontsize',font_sz)
%legend('Earnings',0)

%% Households
figure(23); hold on; grid on
plot(XVector_year, sum(HouseholdsEquity,2),colore)
plot(XVector_year, sum(HouseholdsTotalAssets,2),'r')
%plot(XVector_year, sum(HouseholdsSavings,2),'g')
plot(XVector_year, sum(HouseholdsHousingValue,2),'y')
plot(XVector_year, sum(HouseholdsTotalMortgage,2),'b')
plot(XVector_year, sum(HouseholdsLiquidity,2),'c')
ylabel('Households balance sheet','fontsize',font_sz)
legend('Equity','Total Assets','Houing Value','Mortgages','Liquidity',0) %'Savings',

%% Central Bank
figure(30); hold on; grid on
plot(XVector_year,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)

%% Iceace check 2
figure(40); hold on; grid on; box on
plot(XVector_year,sum(BanksTotalMortgages+BanksTotalLoans,2),colore)
plot(XVector_year,sum(BanksDeposits,2),[':', colore])
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Mortgages +  Loans','Deposits',0)



%% Real Estate Market: Prices and Transactions
figure(51); hold on; grid on
set(gcf,'Name','REmarket: Price and Transactions')
subplot(2,1,1); hold on; grid on
plot(XVector_year, HousingPrices,colore)
ylabel('housing price index','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)

subplot(2,1,2); hold on; grid on
plot(XVector_year, HousingDemand, colore)
plot(XVector_year, HousingSupply, [':', colore], 'linewidth',2)
plot(XVector_year, HousingTransactions, colore, 'linewidth',2)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
ylabel('# housing units','fontsize',font_sz)
legend('Demand','Supply','trades',0)

%% Real Estate Market: Income and costs
figure(52); 
set(gcf,'Name','REmarket: Income and costs')

subplot(3,1,1); hold on; grid on; box on
title('Avg income','fontsize',font_sz)
plot(XVector_year, mean(HouseholdsLaborIncome,2), colore)
plot(XVector_year, mean(HouseholdsQuarterlyCapitalIncome,2)/3, [':', colore], 'linewidth',2)
TotalIncome_avg_tmp = mean(HouseholdsLaborIncome,2)+mean(HouseholdsQuarterlyCapitalIncome,2)/3;
plot(XVector_year, TotalIncome_avg_tmp, colore, 'linewidth',2)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Labor','Capital','Total',font_sz,0)

subplot(3,1,2); hold on; grid on; box on
title('Avg Housing Expenses','fontsize',font_sz)
plot(XVector_year, mean(HouseholdsHousingInterestPayment,2), colore)
plot(XVector_year, mean(HouseholdsHousingPayment,2), [':', colore], 'linewidth',2)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Interests','Total',0)

subplot(3,1,3); hold on; grid on; box on
title('Housing Expenses / Total Income','fontsize',font_sz)
plot(XVector_year, mean(HouseholdsHousingInterestPayment,2)./TotalIncome_avg_tmp, colore)
plot(XVector_year, mean(HouseholdsHousingPayment,2)./TotalIncome_avg_tmp, [':', colore], 'linewidth',2)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Interests / Total Income','Total / Total Income',0)



%% Real Estate Market: Liquidity + Savings, Equity Ratio, NumFireSale
figure(53); 
set(gcf,'Name','REmarket: Households financial conditions')

subplot(3,1,1); hold on; grid on; box on
title('Avg Liquidity','fontsize',font_sz)
plot(XVector_year, mean(HouseholdsLiquidity,2), colore)
%plot(XVector_year, mean(HouseholdsSavings,2), [':', colore], 'linewidth',2)
%plot(XVector_year, mean(HouseholdsLiquidity,2) + mean(HouseholdsSavings,2), colore, 'linewidth',2)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Liquidity',font_sz,0) %'Savings','Total'

subplot(3,1,2); hold on; grid on; box on
title('EQ ratio','fontsize',font_sz)
plot(XVector_year, mean(HouseholdsEquity./HouseholdsTotalAssets,2), colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)

subplot(3,1,3); hold on; grid on; box on
title('No. Fire Sales','fontsize',font_sz)
plot(XVector_year, HousingsNumFireSale, colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)

%% Real Estate Market Financing
figure(54); hold on; grid on; box on
set(gcf,'Name','REmarket: Financing')
plot(XVector_year,sum(HouseholdsTotalMortgage,2),colore)
%plot(XVector_year,sum(BanksTotalMortgages,2),[':', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
legend('Households Mortgages','Banks Mortgages',0)

%subplot(2,1,2); hold on; grid on; box on
%plot(XVector_year,sum(HouseholdsSavings,2),colore)
%plot(XVector_year,sum(BanksSavingsAccounts,2),[':', colore])
%set(gca,'xtick',visualization_vector,'fontsize',font_sz)
%xlabel('years','fontsize',font_sz)
%legend('Households Savings','Banks Savings Account',0)


%% Real Estate Market financial constraints
figure(55); hold on; grid on; box on
set(gcf,'Name','REmarket: financial comstraints')

subplot(2,1,1); hold on; grid on; box on
title('Banks mortgages blocked','fontsize',font_sz)
plot(XVector_year,BanksMortgageBlocked,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)

subplot(2,1,2); hold on; grid on; box on
title('Households mortgages rejected','fontsize',font_sz)
plot(XVector_year,HouseholdsMortgageRejected,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)


%% Figure 1: RE market
figure(101); 
set(gcf,'Name','REmarket: Price and Transactions')
subplot(2,1,1); hold on; grid on; box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), HousingPrices(1:TimeConstants.NrDaysInMonth:end),colore2,'linewidth',line_wdt)
ylabel('housing price index','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(2,1,2); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), HousingTransactions(1:TimeConstants.NrDaysInMonth:end), colore2, 'linewidth',line_wdt)
ylabel('# transactions','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 2: Economy
figure(102); 
set(gcf,'Name','REmarket: Economy')
subplot(2,1,1); hold on; grid on; box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), Production(1:TimeConstants.NrDaysInMonth:end),colore2,'linewidth',line_wdt)
ylabel('production','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(2,1,2); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), 100*UnemployedWorkers(1:TimeConstants.NrDaysInMonth:end)/NrAgents.Households, colore2, 'linewidth',line_wdt)
ylabel('unemployment rate (%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 3: Interest and Prices
figure(103); 
set(gcf,'Name','REmarket: Interest and Prices')
subplot(3,1,1); hold on; grid on; box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), PriceIndex(1:TimeConstants.NrDaysInMonth:end),colore2,'linewidth',line_wdt)
ylabel('price index','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,2); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), WageIndex(1:TimeConstants.NrDaysInMonth:end), colore2, 'linewidth',line_wdt)
ylabel('wage index','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,3); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), CBRate(1:TimeConstants.NrDaysInMonth:end), colore2, 'linewidth',line_wdt)
ylabel('central bank rate (\%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 4: Financial fragility indicators
figure(104); 
set(gcf,'Name','REmarket: Financial fragility indicators')
subplot(3,1,1); hold on; grid on; box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), mean(HouseholdsHousingPayment(1:TimeConstants.NrDaysInMonth:end),2)./TotalIncome_avg_tmp(1:TimeConstants.NrDaysInMonth:end),colore2,'linewidth',line_wdt)
ylabel('avg hous. exp / income','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,2); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), HouseholdsMortgageRejected(1:TimeConstants.NrDaysInMonth:end)./HousingDemand(1:TimeConstants.NrDaysInMonth:end), colore2, 'linewidth',line_wdt)
ylabel('mortg. rejec. rate (\%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,3); hold on; grid on, box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), HousingsNumFireSale(1:TimeConstants.NrDaysInMonth:end), colore2, 'linewidth',line_wdt)
ylabel('# fire sales','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

%% Figure 5-6: Government
figure(105); 
set(gcf,'Name','Government')
subplot(2,1,1); hold on; grid on; box on
plot(XVector_year,GovernmentLiquidity',colore)
plot(XVector_year,GovernmentBalance',[':', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Liquidity','Balance',0)
subplot(2,1,2); hold on; grid on; box on
plot(XVector_year,Government.UnempBenefitsPaid_sum,colore)
plot(XVector_year,Government.GeneralBenefitsPaid_sum,colore)
plot(XVector_year,GovernmentLaborTax,[':', colore])
plot(XVector_year,GovernmentCapitalIncomeTax,['--', colore])
%plot(XVector_year,GovernmentBonds,[':', colore2])
%plot(XVector_year,GovernmentCapitalIncomeTax+GovernmentLaborTax, 'linewidth',2,'color',colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('UnempBenefits','GeneralBenefits','LaborTax','CapitalTax',0)
%% Tax and benefits rates
figure(106);hold on; grid on; box on
set(gcf,'Name','Tax rates and Benefit ratios')
plot(XVector_year,LaborTax,colore)
plot(XVector_year,CapitalIncomeTax,[':', colore])
plot(XVector_year,UnemploymentRatio,['--', colore])
plot(XVector_year,BenefitRatio,['-.', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Labor Tax','Capital Income Tax','Unemployment ratio','Benefit ratio',0)
%% Figure 7: Employment by sector

figure(107);hold on; grid on; box on
set(gcf,'Name','Employment by sector')
plot(XVector_year,NrAgents.Households-UnemployedWorkers,colore)
plot(XVector_year,sum(EmployeesVector(:,1:NrAgents.Firms),2),[':', colore])
plot(XVector_year,sum(EmployeesVector(:,(NrAgents.Firms+1):(NrAgents.Firms+NrAgents.CstrFirms)),2),['--', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Total employed','CGP firms','Construction firms',0)
hold off


%% Figure 8: Real prices of housing
figure(108); hold on; grid on
set(gcf,'Name','REmarket: Nominal and real price of housing')
subplot(2,1,1); hold on; grid on
plot(XVector_year, HousingPrices,colore)
ylabel('Nominal housing price','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
InflationIndex(1) = 100;
for t = 2:numel(Inflation)/TimeConstants.NrDaysInMonth
   InflationIndex(t) =  InflationIndex(t-1)*(1+Inflation(t*TimeConstants.NrDaysInMonth)/12);
end
InflationIndexOld = InflationIndex;
HousingPriceChange = [0;diff(HousingPrices)]./HousingPrices;
HousingPriceChange = HousingPriceChange(1:TimeConstants.NrDaysInMonth:end);
HousingPriceChange = [0;HousingPriceChange];
for t = 2:numel(Inflation)/TimeConstants.NrDaysInMonth
   InflationIndex(t) =  InflationIndex(t)*(1+HousingPriceChange(t));
end

subplot(2,1,2); hold on; grid on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end),HousingPrices(1:TimeConstants.NrDaysInMonth:end)'./InflationIndex,colore)
%plot(XVector_year(1:TimeConstants.NrDaysInMonth:end),HousingPrices(1:TimeConstants.NrDaysInMonth:end)'./InflationIndexOld,'--g')
ylabel('Real housing price','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)

%% Figure 9: GDP and Employment
GDP = Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
   + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)/12).*HousingPrices(1:TimeConstants.NrDaysInMonth:end);
figure(109); 
set(gcf,'Name','REmarket: Economy')
subplot(2,1,1); hold on; grid on; box on
plot(XVector_year(1:TimeConstants.NrDaysInMonth:end), GDP,colore,'linewidth',line_wdt)
ylabel('production','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])
hold off
subplot(2,1,2);hold on; grid on; box on
plot(XVector_year,NrAgents.Households-UnemployedWorkers,colore)
plot(XVector_year,sum(EmployeesVector(:,1:NrAgents.Firms),2),[':', colore])
plot(XVector_year,sum(EmployeesVector(:,(NrAgents.Firms+1):(NrAgents.Firms+NrAgents.CstrFirms)),2),['--', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
ylabel('Employment','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
legend('Total employed','CGP firms','Construction firms',0)
hold off
%% Figures by Linda

PriceIndexInfl = PriceIndex(1:TimeConstants.NrDaysInMonth:end);
WageIndexInfl = WageIndex(1:TimeConstants.NrDaysInMonth:end);
HousingPricesInfl = HousingPrices(1:TimeConstants.NrDaysInMonth:end);

InflationPrice   = ((PriceIndexInfl(13:end)-PriceIndexInfl(1:end-12))./PriceIndexInfl(1:end-12))*100;
InflationWages   = ((WageIndexInfl(13:end)-WageIndexInfl(1:end-12))./WageIndexInfl(1:end-12))*100;
InflationHousing = ((HousingPricesInfl(13:end)-HousingPricesInfl(1:end-12))./HousingPricesInfl(1:end-12))*100;

figure(200); 
set(gcf,'Name','Inflation')
subplot(3,1,1); hold on; grid on; box on
plot(XVector_month(13:end),InflationPrice,colore)
%set(gca,'xtick',visualization_vector,'fontsize',font_sz)
set(gca,'fontsize',font_sz)
xlabel('months','fontsize',font_sz)
ylabel('Prices Inflation','fontsize',font_sz)
%legend('Liquidity','Balance',0)
subplot(3,1,2); hold on; grid on; box on
plot(XVector_month(13:end),InflationWages,colore)
set(gca,'fontsize',font_sz)
xlabel('months','fontsize',font_sz)
ylabel('Wages Inflation','fontsize',font_sz)
%legend('Benefits Paid','Labor tax','Capital income tax','Bonds','Total tax collection',0)
subplot(3,1,3); hold on; grid on; box on
plot(XVector_month(13:end),InflationHousing,colore)
set(gca,'fontsize',font_sz)
xlabel('months','fontsize',font_sz)
ylabel('Housing Prices Inflation','fontsize',font_sz)
%legend('Benefits Paid','Labor tax','Capital income tax','Bonds','Total tax collection',0)

%% 
pop = ones(length(HouseholdsEquity(1,:)),1);
%pop = [1:1:10];

makeplot=0;
for i=1:length(HouseholdsEquity(:,1))
    [g_netto(i),l_netto,a_netto] = gini(pop,HouseholdsEquity(i,:),makeplot);
    [g_lordo(i),l_lordo,a_lordo] = gini(pop,HouseholdsTotalAssets(i,:),makeplot);
end

figure(300);
set(gcf,'Name','Gini')
subplot(2,1,1); hold on; grid on; box on
plot(XVector_year(1:end),g_netto,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
set(gca,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
ylabel('Gini Index N','fontsize',font_sz)
%legend('Liquidity','Balance',0)
subplot(2,1,2); hold on; grid on; box on
plot(XVector_year(1:end),g_lordo,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
ylabel('Gini Index L','fontsize',font_sz)

%% Validation statistics
%% Housing Stock
figure(301); hold on; grid on
plot(XVector_year,sum(HouseholdsHousingAmount,2),colore)
xlabel('years','fontsize',font_sz)
ylabel('Aggregate Housing Stock','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
%title('Aggregate debt of firms and households','fontsize',font_sz)
hold off
