%Banks_initialization

%% Banks initial state variables
BanksCentralBankDebt0 = 0;  
BanksLiquidity0       = 0;
BanksCapitalAdequacyRatio0 = 10;
BanksRetainedEarnings0 = 0;


%% Initialization of Banks Balance Sheets
for b=1:NrAgents.Banks
    Banks.LoansArray{1,b}.Amount = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.InterestRate = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.MaturityDay = zeros(1,NrAgents.Firms);
    Banks.LoansArray{1,b}.FirmsId = zeros(1,NrAgents.Firms);
    for f=1:NrAgents.Firms
        if Firms.DebtsArray{1,f}.BanksId == b
            Banks.LoansArray{1,b}.Amount(1,f) = Firms.DebtsArray{1,f}.Amount;
            Banks.LoansArray{1,b}.InterestRate(1,f) = Firms.DebtsArray{1,f}.InterestRate;
            Banks.LoansArray{1,b}.MaturityDay(1,f) = Firms.DebtsArray{1,f}.MaturityDay;
            Banks.LoansArray{1,b}.FirmsId(1,f) = f;
            %k = k + 1;
        end
    end
    Banks.TotalLoans(1,b) = sum(Banks.LoansArray{1,b}.Amount);
end
clear k b h

for b=1:NrAgents.Banks
    Banks.LoansArrayCstrF{1,b}.Amount = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.InterestRate = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.MaturityDay = zeros(1,NrAgents.CstrFirms);
    Banks.LoansArrayCstrF{1,b}.CstrFirmsId = zeros(1,NrAgents.CstrFirms);
    for c=1:NrAgents.CstrFirms
        if CstrFirms.DebtsArray{1,c}.BanksId == b
            Banks.LoansArrayCstrF{1,b}.Amount(1,c) = CstrFirms.DebtsArray{1,c}.Amount;
            Banks.LoansArrayCstrF{1,b}.InterestRate(1,c) = CstrFirms.DebtsArray{1,c}.InterestRate;
            Banks.LoansArrayCstrF{1,b}.MaturityDay(1,c) = CstrFirms.DebtsArray{1,c}.MaturityDay;
            Banks.LoansArrayCstrF{1,b}.CstrFirmsId(1,c) = c;
        end
    end
    Banks.TotalLoans(1,b) = Banks.TotalLoans(1,b) + sum(Banks.LoansArrayCstrF{1,b}.Amount);
end
clear k b h

for b=1:NrAgents.Banks
    Banks.MortgageArray{1,b}.Amount = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.InterestRate = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.MaturityDay = zeros(1,NrAgents.Households);
    Banks.MortgageArray{1,b}.HouseholdsId = zeros(1,NrAgents.Households);
    for h=1:NrAgents.Households
        if Households.MortgageArray{1,h}.BanksId == b
            Banks.MortgageArray{1,b}.Amount(1,h) = Households.MortgageArray{1,h}.Amount;
            Banks.MortgageArray{1,b}.InterestRate(1,h) = Households.MortgageArray{1,h}.InterestRate;
            Banks.MortgageArray{1,b}.MaturityDay(1,h) = Households.MortgageArray{1,h}.MaturityDay;
            Banks.MortgageArray{1,b}.HouseholdsId(1,h) = h;           
        end
    end
    Banks.TotalMortgage(1,b) = sum(Banks.MortgageArray{1,b}.Amount);
end
%Banks.Liquidity = zeros(1,NrAgents.Banks);
Banks.Liquidity = 0.1*ones(1,NrAgents.Banks).*(Banks.TotalLoans+Banks.TotalMortgage);
Banks.TotalAssets = Banks.TotalLoans + Banks.Liquidity + Banks.TotalMortgage;

%Liabilities side:
%Banks.Deposits = ones(1,NrAgents.Banks)*((sum(Households.Liquidity)+sum(Firms.Liquidity))/NrAgents.Banks);
Banks.Deposits = (Banks.TotalAssets./sum(Banks.TotalAssets))*((sum(Households.Liquidity)+sum(Firms.Liquidity))/NrAgents.Banks);
%1.9.2012%Banks.SavingsAccounts = (Banks.TotalAssets./sum(Banks.TotalAssets))*((sum(Households.Savings))/NrAgents.Banks);
Banks.Equity   = Banks.TotalAssets/BanksCapitalAdequacyRatio0;
Banks.RetainedEarnings = ones(1,NrAgents.Banks)*BanksRetainedEarnings0;
Banks.CentralBankDebt = max(Banks.TotalAssets - Banks.Deposits - Banks.Equity - Banks.RetainedEarnings,0);

if (sum(find(Banks.Deposits + Banks.Equity>Banks.TotalAssets))>0) %Banks.SavingsAccounts
    error('There is at least one bank with a wrong initial balance sheet')
end

%% Initialization of Banks Income Statement
Banks.Earnings = zeros(1,NrAgents.Banks);