%Households_compute_incomestatement
%If households housing expenses are lower than optimal the difference goes
%to savings to finance more housing later

%Total consumption budget
Households.C = sum(Households.QuarterlyLaborIncome) + Households.QuarterlyCapitalIncome;% + Households.Benefits;
%Optimal housing expenditure
%for h=1:NrAgents.Households
Households.H = Households.TotalMortgage/PriceIndices.AnnuityFactor;%*(PriceIndices.MortgageRate/4);
       %+ sum(Households.MortgageArray{1,h}.PayOfPrincipal)/TimeConstants.NrMonthsInQuarter);
%end
%clear h
%Household Savings
%SavingsTemp = Households.H-Households.HousingPayment;
%1.9.2012%Households.Savings = Households.Savings; %+ max(0,SavingsTemp);
%Banks.SavingsAccounts = Banks.SavingsAccounts + sum(max(0,SavingsTemp))/NrAgents.Banks;
%Banks.Liquidity = Banks.Liquidity + sum(max(0,SavingsTemp))/NrAgents.Banks;
%subtract savings from Liquidity
%Households.Liquidity = Households.Liquidity - max(0,SavingsTemp);

%clear SavingsTemp
