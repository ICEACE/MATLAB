clc
clear all
%close all

RunNumber = 111;

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end
font_sz = 14;

line_wdt = 1;

colore = 'r';
colore2 = 'r';
Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
load([Pat, Filename]);
%SimulationFinalDay = d
Xvector = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
Xvector2 = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;
Num_years = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInYear;
Num_quarters = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInQuarter;
quarters_visualization_step = 1;
visualization_vector = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
visualization_vector2 = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;


%% Aggregate households and Firms Liquidity
figure(1); hold on; grid on
set(gcf,'Name','Households and Firms Liquidity')
plot(Xvector,sum(HouseholdsLiquidity,2),colore)
plot(Xvector,sum(FirmsLiquidity,2),colore,'linewidth',2)
plot(Xvector,sum(HouseholdsLiquidity,2)+sum(FirmsLiquidity,2),[':', colore],'linewidth',2)
%plot(Xvector,sum(BanksDeposits,2),'g')

xlabel('quarters','fontsize',font_sz)
title('Aggregate Liquidity','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Households','Firms','Households + Firms',0)


%% Debts and Loans
figure(2); hold on; grid on
plot(Xvector,sum(FirmsTotalDebts,2),colore)
plot(Xvector,sum(BanksTotalLoans,2),colore)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Aggregate debt and Loans','fontsize',font_sz)
legend('Firms','Banks',0)


%% Iceace fundamental identity
figure(3); hold on; grid on
set(gcf,'Name','Banks balance sheet identity')
plot(Xvector,sum(BanksTotalLoans,2)+sum(BanksTotalMortgages,2)+sum(BanksLiquidity,2)-sum(HouseholdsLiquidity,2)-sum(FirmsLiquidity,2)-sum(BanksEquity,2)-sum(CentralBankDebt,2)-sum(BanksSavingsAccounts,2),'b')
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Fundamental Iceace identity','fontsize',font_sz)
legend('Constant = Banks Total Loans - Hoseuholds Liquidity - Firms Liquidity - Banks Equity - Central Bank Debt',0)

%% Earnings
figure(4); hold on; grid on
set(gcf,'Name','Aggregate Earnings')
plot(Xvector,sum(HouseholdsLaborIncome,2),[':', colore])
plot(Xvector,sum(HouseholdsQuarterlyCapitalIncome,2),[':', colore],'linewidth',2)
plot(Xvector,sum(FirmsEarnings,2),colore)
plot(Xvector,sum(BanksEarnings,2),colore,'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Aggregate Earnings','fontsize',font_sz)
legend('Firms','Banks',0)
legend('Households Labor','Households Capital','Firms','Banks',0)


%% Firms' Revenues
figure(5); hold on; grid on
set(gcf,'Name','Firms Revenues')
plot(Xvector,sum(FirmsRevenues,2),colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Firms aggregate revenues','fontsize',font_sz)

%% Firms' Equity 
figure(6); hold on; grid on
set(gcf,'Name','Firms Equity')
plot(Xvector,sum(FirmsEquity,2),colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Firms aggregate equity','fontsize',font_sz)

%% Central Bank Debt
figure(7); hold on; grid on
%ylim([0, max(max(CentralBankDebt))*2])
for b=1:NrAgents.Banks
    plot(Xvector, CentralBankDebt(:,b), 'r')
end
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Central Bank Debt','fontsize',font_sz)

%% Production, Inventories, unemployment
figure(8); hold on; grid on
set(gcf,'Name','Production, Inventories, unemployment')
subplot(3,1,1); hold on; grid on
plot(Xvector, Production,colore)
ylabel('production','fontsize',font_sz)
subplot(3,1,2); hold on; grid on
plot(Xvector, Inventories,colore)
ylabel('inventories','fontsize',font_sz)
subplot(3,1,3); hold on; grid on
plot(Xvector, UnemployedWorkers,colore)
ylabel('unemployment','fontsize',font_sz)

%% Banks' Equity 
figure(11); hold on; grid on
plot(Xvector,sum(BanksEquity,2),colore)
plot(Xvector,sum(BanksRE,2),'r')
plot(Xvector,sum(BanksDeposits,2),'b')
plot(Xvector,sum(BanksEarnings,2),'c')
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
title('Banks aggregate equity and RE','fontsize',font_sz)
legend('Equity','Retained earnings','Deposits','Earnings',0)


%% Price and wage indices
figure(20); 
set(gcf,'Name','Interests and Prices')
subplot(4,1,1); hold on; grid on
plot(Xvector, PriceIndex,colore)
ylabel('price index','fontsize',font_sz)
subplot(4,1,2); hold on; grid on
plot(Xvector, WageIndex, colore)
ylabel('wage index','fontsize',font_sz)
subplot(4,1,3); hold on; grid on
plot(Xvector, Inflation, colore)
ylabel('12m Inflation','fontsize',font_sz)

subplot(4,1,4); hold on; grid on
plot(Xvector,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)



%% Banks
figure(22); hold on; grid on
subplot(2,1,1); hold on; grid on
plot(Xvector, BanksTotalLoans(:,1),colore)
plot(Xvector, BanksTotalMortgages(:,1),'r')
plot(Xvector, BanksEquity(:,1),'g')
plot(Xvector, CentralBankDebt(:,1),'y')
plot(Xvector, BanksDeposits(:,1),'b')
plot(Xvector, BanksSavingsAccounts(:,1),'c')
plot(Xvector, BanksLiquidity(:,1),':c')
plot(Xvector, BanksRE(:,1),':r')
plot(Xvector, BanksTotalAssets(:,1),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Savings','Liquidity','RE',0)
subplot(2,1,2); hold on; grid on
plot(Xvector, BanksTotalLoans(:,2),colore)
plot(Xvector, BanksTotalMortgages(:,2),'r')
plot(Xvector, BanksEquity(:,2),'g')
plot(Xvector, CentralBankDebt(:,2),'y')
plot(Xvector, BanksDeposits(:,2),'b')
plot(Xvector, BanksSavingsAccounts(:,2),'c')
plot(Xvector, BanksLiquidity(:,2),':c')
plot(Xvector, BanksRE(:,2),':r')
plot(Xvector, BanksTotalAssets(:,2),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Savings','Liquidity','RE',0)
%plot(Xvector, sum(BanksEarnings,2), colore)
%ylabel('Banks income statement','fontsize',font_sz)
%legend('Earnings',0)

%% Households
figure(23); hold on; grid on
plot(Xvector, sum(HouseholdsEquity,2),colore)
plot(Xvector, sum(HouseholdsTotalAssets,2),'r')
plot(Xvector, sum(HouseholdsSavings,2),'g')
plot(Xvector, sum(HouseholdsHousingValue,2),'y')
plot(Xvector, sum(HouseholdsTotalMortgage,2),'b')
plot(Xvector, sum(HouseholdsLiquidity,2),'c')
ylabel('Households balance sheet','fontsize',font_sz)
legend('Equity','Total Assets','Savings','Houing Value','Mortgages','Liquidity',0)

%% Central Bank
figure(30); hold on; grid on
plot(Xvector,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)

%% Iceace check 2
figure(40); hold on; grid on; box on
plot(Xvector,sum(BanksTotalMortgages+BanksTotalLoans,2),colore)
plot(Xvector,sum(BanksDeposits,2),[':', colore])
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Mortgages +  Loans','Deposits',0)



%% Real Estate Market: Prices and Transactions
figure(51); hold on; grid on
set(gcf,'Name','REmarket: Price and Transactions')
subplot(2,1,1); hold on; grid on
plot(Xvector, HousingPrices,colore)
ylabel('Housing price index','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)

subplot(2,1,2); hold on; grid on
plot(Xvector, HousingTransactions, colore, 'linewidth',2)
plot(Xvector, HousingDemand, colore)
plot(Xvector, HousingSupply, [':', colore], 'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)

legend('No. transactions','Demand','Supply',0)

%% Real Estate Market: Income and costs
figure(52); 
set(gcf,'Name','REmarket: Income and costs')

subplot(3,1,1); hold on; grid on; box on
title('Avg income','fontsize',font_sz)
plot(Xvector, mean(HouseholdsLaborIncome,2), colore)
plot(Xvector, mean(HouseholdsQuarterlyCapitalIncome,2)/3, [':', colore], 'linewidth',2)
TotalIncome_avg_tmp = mean(HouseholdsLaborIncome,2)+mean(HouseholdsQuarterlyCapitalIncome,2)/3;
plot(Xvector, TotalIncome_avg_tmp, colore, 'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Labor','Capital','Toral',font_sz,0)

subplot(3,1,2); hold on; grid on; box on
title('Avg Housing Expenses','fontsize',font_sz)
plot(Xvector, mean(HouseholdsHousingInterestPayment,2), colore)
plot(Xvector, mean(HouseholdsHousingPayment,2), [':', colore], 'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Interests','Total',0)

subplot(3,1,3); hold on; grid on; box on
title('Housing Expenses / Total Income','fontsize',font_sz)
plot(Xvector, mean(HouseholdsHousingInterestPayment,2)./TotalIncome_avg_tmp, colore)
plot(Xvector, mean(HouseholdsHousingPayment,2)./TotalIncome_avg_tmp, [':', colore], 'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Interests / Total Income','Total / Total Income',0)

%set(gcf,'Name','Num Fire Sales')
%plot(1:numel(HouseholdsNumFireSales),HouseholdsNumFireSales,colore)
%xlabel('quarters','fontsize',font_sz)
%ylabel('Num Fire Sales','fontsize',font_sz)


%% Real Estate Market: Liquidity + Savings, Equity Ratio, NumFireSale
figure(53); 
set(gcf,'Name','REmarket: Households financial conditions')

subplot(3,1,1); hold on; grid on; box on
title('Avg Liquidity and Savings','fontsize',font_sz)
plot(Xvector, mean(HouseholdsLiquidity,2), colore)
plot(Xvector, mean(HouseholdsSavings,2), [':', colore], 'linewidth',2)
plot(Xvector, mean(HouseholdsLiquidity,2) + mean(HouseholdsSavings,2), colore, 'linewidth',2)
xlabel('quarters','fontsize',font_sz)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
legend('Liquidity','Savings','Toral',font_sz,0)

subplot(3,1,2); hold on; grid on; box on
title('EQ ratio','fontsize',font_sz)
plot(Xvector, mean(HouseholdsEquity./HouseholdsTotalAssets,2), colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)

subplot(3,1,3); hold on; grid on; box on
title('No. Fire Sales','fontsize',font_sz)
plot(Xvector, HousingsNumFireSale, colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)

%% Real Estate Market Financing
figure(54); hold on; grid on; box on
set(gcf,'Name','REmarket: Financing')
subplot(2,1,1); hold on; grid on; box on
plot(Xvector,sum(HouseholdsTotalMortgage,2),colore)
plot(Xvector,sum(BanksTotalMortgages,2),[':', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Households Mortgages','Banks Mortgages',0)

subplot(2,1,2); hold on; grid on; box on
plot(Xvector,sum(HouseholdsSavings,2),colore)
plot(Xvector,sum(BanksSavingsAccounts,2),[':', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Households Savings','Banks Savings Account',0)


%% Real Estate Market financial constraints
figure(55); hold on; grid on; box on
set(gcf,'Name','REmarket: financial comstraints')

subplot(2,1,1); hold on; grid on; box on
title('Banks mortgages blocked','fontsize',font_sz)
plot(Xvector,BanksMortgageBlocked,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)

subplot(2,1,2); hold on; grid on; box on
title('Households mortgages rejected','fontsize',font_sz)
plot(Xvector,HouseholdsMortgageRejected,colore)
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)


%% Figure 1: RE market
figure(101); 
set(gcf,'Name','REmarket: Price and Transactions')
subplot(2,1,1); hold on; grid on; box on
plot(Xvector2(1:Num_quarters:end), HousingPrices(1:Num_quarters:end),colore2,'linewidth',line_wdt)
ylabel('housing price index','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(2,1,2); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), HousingTransactions(1:Num_quarters:end), colore2, 'linewidth',line_wdt)
ylabel('# transactions','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 2: Economy
figure(102); 
set(gcf,'Name','REmarket: Economy')
subplot(2,1,1); hold on; grid on; box on
plot(Xvector2(1:Num_quarters:end), Production(1:Num_quarters:end),colore2,'linewidth',line_wdt)
ylabel('production','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(2,1,2); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), 100*UnemployedWorkers(1:Num_quarters:end)/6000, colore2, 'linewidth',line_wdt)
ylabel('unemployment rate (%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 3: Interest and Prices
figure(103); 
set(gcf,'Name','REmarket: Interest and Prices')
subplot(3,1,1); hold on; grid on; box on
plot(Xvector2(1:Num_quarters:end), PriceIndex(1:Num_quarters:end),colore2,'linewidth',line_wdt)
ylabel('price index','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,2); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), WageIndex(1:Num_quarters:end), colore2, 'linewidth',line_wdt)
ylabel('wage index','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,3); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), CBRate(1:Num_quarters:end), colore2, 'linewidth',line_wdt)
ylabel('central bank rate (\%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])


%% Figure 4: Financial fragility indicators
figure(104); 
set(gcf,'Name','REmarket: Financial fragility indicators')
subplot(3,1,1); hold on; grid on; box on
plot(Xvector2(1:Num_quarters:end), mean(HouseholdsHousingPayment(1:Num_quarters:end),2)./TotalIncome_avg_tmp(1:Num_quarters:end),colore2,'linewidth',line_wdt)
ylabel('avg hous. exp / income','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,2); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), HouseholdsMortgageRejected(1:Num_quarters:end)./HousingDemand(1:Num_quarters:end), colore2, 'linewidth',line_wdt)
ylabel('mortg. rejec. rate (\%)','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

subplot(3,1,3); hold on; grid on, box on
plot(Xvector2(1:Num_quarters:end), HousingsNumFireSale(1:Num_quarters:end), colore2, 'linewidth',line_wdt)
ylabel('# fire sales','fontsize',font_sz)
xlabel('years','fontsize',font_sz)
set(gca,'xtick',0:Num_years,'fontsize',font_sz)
set(gca,'xlim',[0 Num_years])

%% Figure 5: Government
figure(105); 
set(gcf,'Name','Government')
subplot(2,1,1); hold on; grid on; box on
plot(Xvector,GovernmentLiquidity,colore)
plot(Xvector,GovernmentBalance,[':', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Liquidity','Balance',0)
subplot(2,1,2); hold on; grid on; box on
plot(Xvector,GovernmentBenefitsPaid,colore)
plot(Xvector,GovernmentLaborTax,[':', colore])
plot(Xvector,GovernmentCapitalIncomeTax, colore2)
plot(Xvector,GovernmentBonds,[':', colore2])
plot(Xvector,GovernmentCapitalIncomeTax+GovernmentLaborTax, 'r')
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Benefits Paid','Labor tax','Capital income tax','Bonds','Total tax collection',0)

figure(106);hold on; grid on; box on
set(gcf,'Name','Tax rates and Benefit ratios')
plot(Xvector,LaborTax,colore)
plot(Xvector,CapitalIncomeTax,[':', colore])
plot(Xvector,UnemploymentRatio,['--', colore])
plot(Xvector,BenefitRatio,['-.', colore])
set(gca,'xtick',visualization_vector,'fontsize',font_sz)
xlabel('quarters','fontsize',font_sz)
legend('Labor Tax','Capital Income Tax','Unemployment ratio','Benefit ratio',0)
%% Validation statistics

%% EBIT / TA
% FirmsEBITs_10 = FirmsEBITs(10,:);
% FirmsEBITs_30 = FirmsEBITs(35,:);
% FirmsEBITs_45 = FirmsEBITs(45,:);
% FirmsEBITs_59 = FirmsEBITs(59,:);
% FirmsTotalAssets_10 = FirmsTotalAssets(10,:);
% FirmsTotalAssets_30 = FirmsTotalAssets(35,:);
% FirmsTotalAssets_45 = FirmsTotalAssets(45,:);
% FirmsTotalAssets_59 = FirmsTotalAssets(59,:);
% FirmsEBIT_TAs_10 = FirmsEBITs_10./FirmsTotalAssets_10;
% FirmsEBIT_TAs_30 = FirmsEBITs_30./FirmsTotalAssets_30;
% FirmsEBIT_TAs_45 = FirmsEBITs_45./FirmsTotalAssets_45;
% FirmsEBIT_TAs_59 = FirmsEBITs_59./FirmsTotalAssets_59;
% 
% [yH_FirmsEBIT_TAs_10, xH_FirmsEBIT_TAs_10] = hist(FirmsEBIT_TAs_10,11);
% yPDF_FirmsEBIT_TAs_10 = yH_FirmsEBIT_TAs_10/(sum(yH_FirmsEBIT_TAs_10)*(xH_FirmsEBIT_TAs_10(2)-xH_FirmsEBIT_TAs_10(1)));
% [yH_FirmsEBIT_TAs_30, xH_FirmsEBIT_TAs_30] = hist(FirmsEBIT_TAs_30,11);
% yPDF_FirmsEBIT_TAs_30 = yH_FirmsEBIT_TAs_30/(sum(yH_FirmsEBIT_TAs_30)*(xH_FirmsEBIT_TAs_30(2)-xH_FirmsEBIT_TAs_30(1)));
% [yH_FirmsEBIT_TAs_45, xH_FirmsEBIT_TAs_45] = hist(FirmsEBIT_TAs_45,11);
% yPDF_FirmsEBIT_TAs_45 = yH_FirmsEBIT_TAs_45/(sum(yH_FirmsEBIT_TAs_45)*(xH_FirmsEBIT_TAs_45(2)-xH_FirmsEBIT_TAs_45(1)));
% [yH_FirmsEBIT_TAs_59, xH_FirmsEBIT_TAs_59] = hist(FirmsEBIT_TAs_59,11);
% yPDF_FirmsEBIT_TAs_59 = yH_FirmsEBIT_TAs_59/(sum(yH_FirmsEBIT_TAs_59)*(xH_FirmsEBIT_TAs_59(2)-xH_FirmsEBIT_TAs_59(1)));
% 
% Normal Dist fit
% m_10 = mean(FirmsEBIT_TAs_10);
% s_10 = std(FirmsEBIT_TAs_10);
% xPDFnorm_10 = linspace(min(FirmsEBIT_TAs_10),max(FirmsEBIT_TAs_10),1000);
% yPDFnorm_10 = normpdf(xPDFnorm_10,m_10,s_10);
% m_30 = mean(FirmsEBIT_TAs_30);
% s_30 = std(FirmsEBIT_TAs_30);
% xPDFnorm_30 = linspace(min(FirmsEBIT_TAs_30),max(FirmsEBIT_TAs_30),1000);
% yPDFnorm_30 = normpdf(xPDFnorm_30,m_30,s_30);
% m_45 = mean(FirmsEBIT_TAs_45);
% s_45 = std(FirmsEBIT_TAs_45);
% xPDFnorm_45 = linspace(min(FirmsEBIT_TAs_45),max(FirmsEBIT_TAs_45),1000);
% yPDFnorm_45 = normpdf(xPDFnorm_45,m_45,s_45);
% m_59 = mean(FirmsEBIT_TAs_59);
% s_59 = std(FirmsEBIT_TAs_59);
% xPDFnorm_59 = linspace(min(FirmsEBIT_TAs_59),max(FirmsEBIT_TAs_59),1000);
% yPDFnorm_59 = normpdf(xPDFnorm_59,m_59,s_59);
% Laplace Dist fit
% med_10 = median(FirmsEBIT_TAs_10);
% med_30 = median(FirmsEBIT_TAs_30);
% med_45 = median(FirmsEBIT_TAs_45);
% med_59 = median(FirmsEBIT_TAs_59);
% scale_10 = 0;
% scale_30 = 0;
% scale_45 = 0;
% scale_59 = 0;
% N = length(FirmsEBIT_TAs_10);
% for k = 1:N
%     scale_10 = scale_10 + (1/N)*abs(FirmsEBIT_TAs_10(k)-med_10);
%     scale_30 = scale_30 + (1/N)*abs(FirmsEBIT_TAs_30(k)-med_30);
%     scale_45 = scale_45 + (1/N)*abs(FirmsEBIT_TAs_45(k)-med_45);
%     scale_59 = scale_59 + (1/N)*abs(FirmsEBIT_TAs_59(k)-med_59);
% end
% f_lap = inline('(1/(2*scale))*exp(-(abs(x-mu)/scale))');
% 
% figure(101)
% subplot(2,2,1);hold on; grid on; box on
% title('Quarter no. 10')
% plot(xH_FirmsEBIT_TAs_10,yPDF_FirmsEBIT_TAs_10,'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',3)
% plot(xPDFnorm_10,f_lap(med_10,scale_10,xPDFnorm_10),'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(xPDFnorm_10,yPDFnorm_10,'--','linewidth',1,'Color',[0.5 0.5 0.5])
% legend('Estimated PDF','Fitted Laplace PDF','Fitted Normal PDF',0)
% set(gca,'yscale','log')
% set(gca,'ylim',[10^1.2 10^3.2]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs_10)-0.001 max(xH_FirmsEBIT_TAs_10)+0.001]);
% hold off
% subplot(2,2,2);hold on; grid on; box on
% title('Quarter no. 35')
% plot(xH_FirmsEBIT_TAs_30,yPDF_FirmsEBIT_TAs_30,'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',3)
% plot(xPDFnorm_30,f_lap(med_30,scale_30,xPDFnorm_30),'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(xPDFnorm_30,yPDFnorm_30,'--','linewidth',1,'Color',[0.5 0.5 0.5])
% legend('Estimated PDF','Fitted Laplace PDF','Fitted Normal PDF',0)
% set(gca,'yscale','log')
% set(gca,'ylim',[10^1 10^2.7]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs_30)-0.001 max(xH_FirmsEBIT_TAs_30)+0.001]);
% hold off
% subplot(2,2,3);hold on; grid on; box on
% title('Quarter no. 45')
% plot(xH_FirmsEBIT_TAs_45,yPDF_FirmsEBIT_TAs_45,'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',3)
% plot(xPDFnorm_45,f_lap(med_45,scale_45,xPDFnorm_45),'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(xPDFnorm_45,yPDFnorm_45,'--','linewidth',1,'Color',[0.5 0.5 0.5])
% legend('Estimated PDF','Fitted Laplace PDF','Fitted Normal PDF',0)
% set(gca,'yscale','log')
% 
% set(gca,'ylim',[10^1 10^2.7]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs_45)-0.001 max(xH_FirmsEBIT_TAs_45)+0.001]);
% hold off
% subplot(2,2,4);hold on; grid on; box on
% title('Quarter no. 59')
% plot(xH_FirmsEBIT_TAs_59,yPDF_FirmsEBIT_TAs_59,'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',3)
% plot(xPDFnorm_59,f_lap(med_59,scale_59,xPDFnorm_59),'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(xPDFnorm_59,yPDFnorm_59,'--','linewidth',1,'Color',[0.5 0.5 0.5])
% legend('Estimated PDF','Fitted Laplace PDF','Fitted Normal PDF',0)
% set(gca,'yscale','log')
% set(gca,'ylim',[10^1 10^2.5]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs_59)-0.001 max(xH_FirmsEBIT_TAs_59)+0.001]);
% hold off
% 
% % Total assets
% [TA_f_q1,TA_x_q1] = ecdf(FirmsTotalAssets);
% TA_q10_sort = sort(FirmsTotalAssets_10,'descend');
% X_q10 = 1:1:length(TA_q10_sort);
% TA_q20_sort = sort(FirmsTotalAssets_30,'descend');
% X_q20 = 1:1:length(TA_q20_sort);
% TA_q30_sort = sort(FirmsTotalAssets_45,'descend');
% X_q30 = 1:1:length(TA_q30_sort);
% TA_q45_sort = sort(FirmsTotalAssets_59,'descend');
% X_q45 = 1:1:length(TA_q45_sort);
% TA_q59_sort = sort(FirmsTotalAssets_59,'descend');
% X_q59 = 1:1:length(TA_q59_sort);
% 
% figure(102); hold on; grid on; box on
% title('Firms Total Assets','fontsize',font_sz)
% plot(X_q10,TA_q10_sort,'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(X_q20,TA_q20_sort,':','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(X_q30,TA_q30_sort,'--','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(X_q45,TA_q45_sort,'-','linewidth',1,'Color',[0.5 0.5 0.5])
% plot(X_q59,TA_q59_sort,':','linewidth',1,'Color',[0.5 0.5 0.5])
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% legend('TA quarter 10','TA quarter 20','TA quarter 30','TA quarter 45','TA quarter 59',0)
% set(gca,'ylim',[10^3.4 10^4.1]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs)-0.001 max(xH_FirmsEBIT_TAs)+0.001]);
% hold off
% 
% % Total Debt
% [TA_f_q1,TA_x_q1] = ecdf(FirmsTotalAssets);
% D_q10_sort = sort(FirmsTotalDebts(10,:),'descend');
% DX_q10 = 1:1:length(D_q10_sort);
% D_q20_sort = sort(FirmsTotalDebts(20,:),'descend');
% DX_q20 = 1:1:length(D_q20_sort);
% D_q30_sort = sort(FirmsTotalDebts(30,:),'descend');
% DX_q30 = 1:1:length(D_q30_sort);
% D_q45_sort = sort(FirmsTotalDebts(45,:),'descend');
% DX_q45 = 1:1:length(D_q45_sort);
% D_q59_sort = sort(FirmsTotalDebts(59,:),'descend');
% DX_q59 = 1:1:length(D_q59_sort);
% 
% figure(103); hold on; grid on; box on
% title('Firms Total Debt','fontsize',font_sz)
% plot(DX_q10,D_q10_sort,'-','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(DX_q20,D_q20_sort,':','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(DX_q30,D_q30_sort,'--','linewidth',1,'Color',[0.1 0.1 0.1])
% plot(DX_q45,D_q45_sort,'-','linewidth',1,'Color',[0.5 0.5 0.5])
% plot(DX_q59,D_q59_sort,':','linewidth',1,'Color',[0.5 0.5 0.5])
% set(gca,'yscale','log')
% set(gca,'xscale','log')
% legend('Debt quarter 10','Debt quarter 20','Debt quarter 30','Debt quarter 45','Debt quarter 59',0)
% set(gca,'ylim',[10^1.4 10^2.1]);
% set(gca,'xlim',[min(xH_FirmsEBIT_TAs)-0.001 max(xH_FirmsEBIT_TAs)+0.001]);
% hold off
% 
% % Statistical testing
% [w2_10,D_10,V_10] = LaplaceStats(FirmsEBIT_TAs_10);
% [w2_30,D_30,V_30] = LaplaceStats(FirmsEBIT_TAs_30);
% [w2_45,D_45,V_45] = LaplaceStats(FirmsEBIT_TAs_45);
% [w2_59,D_59,V_59] = LaplaceStats(FirmsEBIT_TAs_59);
% 
% LapStat_PR = {'w2','sqrt(n)*D','sqrt(n)*V';...
%               w2_10,D_10,V_10;...
%               w2_30,D_30,V_30;...
%               w2_45,D_45,V_45;...
%               w2_59,D_59,V_59}
%           
% 
% 
% [pTA_10,DTA_10] = PowerLawStats(FirmsTotalAssets_10);
% [pTA_30,DTA_30] = PowerLawStats(FirmsTotalAssets_30);
% [pTA_45,DTA_45] = PowerLawStats(FirmsTotalAssets_45);
% [pTA_59,DTA_59] = PowerLawStats(FirmsTotalAssets_59);
% 
% [pD_10,DD_10] = PowerLawStats(FirmsTotalDebts(10,:));
% [pD_30,DD_30] = PowerLawStats(FirmsTotalDebts(35,:));
% [pD_45,DD_45] = PowerLawStats(FirmsTotalDebts(45,:));
% [pD_59,DD_59] = PowerLawStats(FirmsTotalDebts(59,:));
% 
% 
% % Ordinary least squares estimaition of powerlaw exponent
% OLS_TA_q10 = cov(log(X_q10),log(TA_q10_sort))/var(log(X_q10));
% OLS_TA_q30 = cov(log(X_q30),log(TA_q30_sort))/var(log(X_q30));
% OLS_TA_q45 = cov(log(X_q45),log(TA_q45_sort))/var(log(X_q45));
% OLS_TA_q59 = cov(log(X_q59),log(TA_q59_sort))/var(log(X_q59));
% 
% OLS_D_q10 = cov(log(DX_q10),log(D_q10_sort))/var(log(DX_q10));
% OLS_D_q30 = cov(log(DX_q30),log(D_q30_sort))/var(log(DX_q30));
% OLS_D_q45 = cov(log(DX_q45),log(D_q45_sort))/var(log(DX_q45));
% OLS_D_q59 = cov(log(DX_q59),log(D_q59_sort))/var(log(DX_q59));
% 
% OLS_TA = [OLS_TA_q10(1,2),OLS_TA_q30(1,2),OLS_TA_q45(1,2),OLS_TA_q59(1,2)]
% OLS_D = [OLS_D_q10(1,2),OLS_D_q30(1,2),OLS_D_q45(1,2),OLS_D_q59(1,2)]
% % Save
% save([Pat, Filename, 'All'])
