clc
clear all
%close all

RunNumber = 16;
SimulationDurationInQuarters = 25;
if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end
font_sz = 14;

SimulationDay0 = 60;
SimulationDay_final = SimulationDurationInQuarters*3*20+SimulationDay0;
visualization_step = 80;

Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
load([Pat, Filename]);
colore = 'r';

%% Aggregate households and Firms Liquidity
figure(1); hold on; grid on
set(gcf,'Name','Households and Firms Liquidity')
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsLiquidity,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(FirmsLiquidity,2),colore,'linewidth',2)
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsLiquidity,2)+sum(FirmsLiquidity,2),[':', colore],'linewidth',2)
%plot(SimulationDay0:SimulationDay_final,sum(BanksDeposits,2),'g')

xlabel('days','fontsize',font_sz)
title('Aggregate Liquidity','fontsize',font_sz)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
legend('Households','Firms','Households + Firms',0)


%% Debts and Loans
figure(2); hold on; grid on
plot(SimulationDay0:SimulationDay_final,sum(FirmsTotalDebts,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksTotalLoans,2),colore)
xlabel('days','fontsize',font_sz)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Aggregate debt and Loans','fontsize',font_sz)
legend('Firms','Banks',0)


%% Iceace fundamental identity
figure(3); hold on; grid on
plot(SimulationDay0:SimulationDay_final,sum(BanksTotalLoans,2)+sum(BanksTotalMortgages,2)+sum(BanksLiquidity,2)-sum(HouseholdsLiquidity,2)-sum(FirmsLiquidity,2)-sum(BanksEquity,2)-sum(CentralBankDebt,2)-sum(BanksSavingsAccounts,2),'b')
xlabel('days','fontsize',font_sz)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Fundamental Iceace identity','fontsize',font_sz)
legend('Constant = Banks Total Loans - Hoseuholds Liquidity - Firms Liquidity - Banks Equity - Central Bank Debt',0)

%% Earnings
figure(4); hold on; grid on
set(gcf,'Name','Aggregate Earnings')
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsLaborIncome,2),':')
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsQuarterlyCapitalIncome,2),[':', colore],'linewidth',2)
plot(SimulationDay0:SimulationDay_final,sum(FirmsEarnings,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksEarnings,2),colore,'linewidth',2)
xlabel('days','fontsize',font_sz)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Aggregate Earnings','fontsize',font_sz)
legend('Firms','Banks',0)
legend('Households Labor','Households Capital','Firms','Banks',0)


%% Firms' Revenues
figure(5); hold on; grid on
set(gcf,'Name','Firms Revenues')
plot(SimulationDay0:SimulationDay_final,sum(FirmsRevenues,2),colore)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Firms aggregate revenues','fontsize',font_sz)

%% Firms' Equity 
figure(6); hold on; grid on
set(gcf,'Name','Firms Equity')
plot(SimulationDay0:SimulationDay_final,sum(FirmsEquity,2),colore)
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Firms aggregate equity','fontsize',font_sz)

%% Central Bank Debt
figure(7); hold on; grid on
%ylim([0, max(max(CentralBankDebt))*2])
for b=1:NrAgents.Banks
    plot(SimulationDay0:SimulationDay_final, CentralBankDebt(:,b), 'r')
end
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Central Bank Debt','fontsize',font_sz)

%% Production, Inventories, unemployment
figure(8); hold on; grid on
set(gcf,'Name','Production, Inventories, unemployment')
subplot(3,1,1); hold on; grid on
plot(SimulationDay0:SimulationDay_final, Production,colore)
ylabel('production','fontsize',font_sz)
subplot(3,1,2); hold on; grid on
plot(SimulationDay0:SimulationDay_final, Inventories,colore)
ylabel('inventories','fontsize',font_sz)
subplot(3,1,3); hold on; grid on
plot(SimulationDay0:SimulationDay_final, UnemployedWorkers,colore)
ylabel('unemployment','fontsize',font_sz)

%% Banks' Equity 
figure(11); hold on; grid on
plot(SimulationDay0:SimulationDay_final,sum(BanksEquity,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksRE,2),'r')
plot(SimulationDay0:SimulationDay_final,sum(BanksDeposits,2),'b')
plot(SimulationDay0:SimulationDay_final,sum(BanksEarnings,2),'c')
set(gca,'xtick',SimulationDay0:visualization_step:SimulationDay_final,'fontsize',font_sz)
title('Banks aggregate equity and RE','fontsize',font_sz)
legend('Equity','Retained earnings','Deposits','Earnings',0)


%% Price and wage indices
figure(20); hold on; grid on
subplot(4,1,1); hold on; grid on
plot(SimulationDay0:SimulationDay_final, PriceIndex,colore)
ylabel('price index','fontsize',font_sz)
subplot(4,1,2); hold on; grid on
plot(SimulationDay0:SimulationDay_final, WageIndex, colore)
ylabel('wage index','fontsize',font_sz)
subplot(4,1,3); hold on; grid on
plot(SimulationDay0:SimulationDay_final, Inflation, colore)
ylabel('12m Inflation','fontsize',font_sz)
set(gca,'ylim',[0 0.15]);
set(gca,'xlim',[0 1600]);
subplot(4,1,4); hold on; grid on
plot(SimulationDay0:SimulationDay_final,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)


%% Real Estate Market
figure(21); hold on; grid on
set(gcf,'Name','Real Estate Market 1')
subplot(3,1,1); hold on; grid on
plot(1:1:length(HousingPrices), HousingPrices,colore)
ylabel('Housing price index','fontsize',font_sz)
subplot(3,1,2); hold on; grid on
plot(1:1:length(HousingPrices)-1, diff(HousingPrices),colore)
ylabel('Housing price change','fontsize',font_sz)
subplot(3,1,3); hold on; grid on
plot([1,2,3,4:1:length(HousingTransactions(1:20:end))+3], [0;0;0;HousingTransactions(1:20:end)], colore)
ylabel('No. of transactions','fontsize',font_sz)

%% Banks
figure(22); hold on; grid on
subplot(2,1,1); hold on; grid on
plot(SimulationDay0:SimulationDay_final, BanksTotalLoans(:,1),colore)
plot(SimulationDay0:SimulationDay_final, BanksTotalMortgages(:,1),'r')
plot(SimulationDay0:SimulationDay_final, BanksEquity(:,1),'g')
plot(SimulationDay0:SimulationDay_final, CentralBankDebt(:,1),'y')
plot(SimulationDay0:SimulationDay_final, BanksDeposits(:,1),'b')
plot(SimulationDay0:SimulationDay_final, BanksSavingsAccounts(:,1),'c')
plot(SimulationDay0:SimulationDay_final, BanksLiquidity(:,1),':c')
plot(SimulationDay0:SimulationDay_final, BanksRE(:,1),':r')
plot(SimulationDay0:SimulationDay_final, BanksTotalAssets(:,1),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Savings','Liquidity','RE',0)
subplot(2,1,2); hold on; grid on
plot(SimulationDay0:SimulationDay_final, BanksTotalLoans(:,2),colore)
plot(SimulationDay0:SimulationDay_final, BanksTotalMortgages(:,2),'r')
plot(SimulationDay0:SimulationDay_final, BanksEquity(:,2),'g')
plot(SimulationDay0:SimulationDay_final, CentralBankDebt(:,2),'y')
plot(SimulationDay0:SimulationDay_final, BanksDeposits(:,2),'b')
plot(SimulationDay0:SimulationDay_final, BanksSavingsAccounts(:,2),'c')
plot(SimulationDay0:SimulationDay_final, BanksLiquidity(:,2),':c')
plot(SimulationDay0:SimulationDay_final, BanksRE(:,2),':r')
plot(SimulationDay0:SimulationDay_final, BanksTotalAssets(:,2),':b')
ylabel('Banks balance sheet','fontsize',font_sz)
legend('Total loans','Total Mortgages','Equity','CB debt','Deposits','Savings','Liquidity','RE',0)
%plot(SimulationDay0:SimulationDay_final, sum(BanksEarnings,2), colore)
%ylabel('Banks income statement','fontsize',font_sz)
%legend('Earnings',0)

%% Households
figure(23); hold on; grid on
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsEquity,2),colore)
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsTotalAssets,2),'r')
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsSavings,2),'g')
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsHousingValue,2),'y')
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsTotalMortgage,2),'b')
plot(SimulationDay0:SimulationDay_final, sum(HouseholdsLiquidity,2),'c')
ylabel('Households balance sheet','fontsize',font_sz)
legend('Equity','Total Assets','Savings','Houing Value','Mortgages','Liquidity',0)

%% Central Bank
figure(30); hold on; grid on
plot(SimulationDay0:SimulationDay_final,CBRate,colore)
ylabel('CB policy rate','fontsize',font_sz)

%% Iceace check 2
figure(40); hold on; grid on; box on
plot(SimulationDay0:SimulationDay_final,sum(BanksTotalMortgages+BanksTotalLoans,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksDeposits,2),[':', colore])
xlabel('days','fontsize',font_sz)
legend('Mortgages +  Loans','Deposits',0)


%% Num Fire Sales
%figure(41); hold on; grid on; box on
%set(gcf,'Name','Num Fire Sales')
%plot(1:numel(HouseholdsNumFireSales),HouseholdsNumFireSales,colore)
%xlabel('days','fontsize',font_sz)
%ylabel('Num Fire Sales','fontsize',font_sz)

%% Real Estate Market Financing
figure(42); hold on; grid on; box on
set(gcf,'Name','Real Estate Market Financing')
subplot(2,1,1); hold on; grid on; box on
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsTotalMortgage,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksTotalMortgages,2),[':', colore])
legend('Households Mortgages','Banks Mortgages',0)
xlabel('days','fontsize',font_sz)

subplot(2,1,2); hold on; grid on; box on
plot(SimulationDay0:SimulationDay_final,sum(HouseholdsSavings,2),colore)
plot(SimulationDay0:SimulationDay_final,sum(BanksSavingsAccounts,2),[':', colore])
legend('Households Savings','Banks Savings Account',0)

xlabel('days','fontsize',font_sz)

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
