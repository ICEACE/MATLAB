%Analysis of ICEACE economy
clear all
close all
clc

load('ICEACE_t1000.mat')

%Variables for Firms Assets
[n,m] = size(FirmsAssets);
FA_VAR1 = FirmsAssets(ceil(0.2*n),:);
FA_VAR2 = FirmsAssets(ceil(0.4*n),:);
FA_VAR3 = FirmsAssets(ceil(0.6*n),:);
FA_VAR4 = FirmsAssets(ceil(0.8*n),:);
FA_VAR5 = FirmsAssets(n,:);
%Empirical SF of Firms Asets
[f1,x1] = ecdf(FA_VAR1);
[f2,x2] = ecdf(FA_VAR2);
[f3,x3] = ecdf(FA_VAR3);
[f4,x4] = ecdf(FA_VAR4);
[f5,x5] = ecdf(FA_VAR5);
%Plot empirical CDF of Assets
figure(1)
hold on
box on
grid on
plot(x1,1-f1,'--y')
plot(x2,1-f2,'--k')
plot(x3,1-f3,'--m*')
plot(x4,1-f4,'--bs')
plot(x5,1-f5,'--r<')
xlabel('Total Assets (TA) of Firms')
ylabel('Empirical survival function (SF), R(x)')
legend('Empirical SF (t = 0.2*T)','Empirical SF (t = 0.4*T)','Empirical SF (t = 0.6*T)','Empirical SF (t = 0.8*T)','Empirical SF (t = T)','Location','SouthWest');
set(gca,'yscale','log');
set(gca,'xscale','log');
%set(gca,'xlim',[min(x5) 10^2.2]);
hold off


%Time Series analysis of Household savings, Banks Deposits, Banks Equity
t = 1:1:T+1;
tm = 1:1:TM+1;
BEquity = (BanksEquity);
BDeposits = (BanksDeposits);
BLiquidity = (BanksLiquidity);
BLoans = BanksLoans;

FLiquidity = sum(FirmsLiquidity,2);
FAssets = sum(FirmsAssets,2);
FDebt = sum(FirmsDebt,2);
FCapitalCosts = sum(FirmsCapitalCosts,2);

HLiquidity = sum(HouseholdLiquidity,2);
HConsumptionBudget = sum(HouseholdConsumptionBudget,2);
HCapitalIncome = sum(HouseholdCapitalIncome,2);

FHLiquidity = FLiquidity + HLiquidity;

figure(2)
hold on
box on
grid on
plot(t,FLiquidity,'b')
plot(t,HLiquidity,'k')
plot(t,BLiquidity,'r')
plot(t,FHLiquidity,'y')
plot(t,BDeposits,'--g')
xlabel('Iterations (t)')
ylabel('Value of Balance Sheet and Income Statement entries')
legend('Firms Liquidity','Household Liquidity','Banks Liquidity','Firms + Household Liquidity','Banks Deposits','Location','SouthWest');
hold off

figure(3)
hold on
box on
grid on
plot(tm,BEquity,'b')
plot(t,BLiquidity,'k')
plot(t,BDeposits,'r')
plot(tm,BLoans,'m')
xlabel('Iterations (t)')
ylabel('Value - Banks Balance Sheet entries')
legend('Banks Equity','Banks Liquidity','Banks Deposits','Banks Loans','Location','SouthWest');
hold off

figure(4)
hold on
box on
grid on
plot(tm,HConsumptionBudget,'c')
%plot(t,HCapitalIncome,'b')
hold off

%EBIT_TA = FirmsEBIT./FirmsAssets;
[Pdf_y12,Hist_x12] = PDFestimation(FirmsEBIT(12,:)',21);
[Pdf_y24,Hist_x24] = PDFestimation(FirmsEBIT(24,:)',21);
[Pdf_y36,Hist_x36] = PDFestimation(FirmsEBIT(36,:)',21);
[Pdf_y48,Hist_x48] = PDFestimation(FirmsEBIT(48,:)',21);
figure(5)
hold on
box on
grid on
plot(Hist_x12,Pdf_y12,'ro')
plot(Hist_x24,Pdf_y24,'bo')
plot(Hist_x36,Pdf_y36,'go')
plot(Hist_x48,Pdf_y48,'mo')
set(gca,'yscale','log');
hold off

%TEST of Identity
Identity = sum(FLiquidity(1:20:end,:))+sum(HLiquidity(1:20:end,:))+(BEquity) - sum(FDebt);


