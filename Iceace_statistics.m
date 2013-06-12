%% Iceace_statistics
%Script to calculate some statistics from multible
%runs of the Iceace model

clear all
close all
clc

if isunix
    Pat = '../../runs/';
else
    Pat = '..\..\runs\';
end

counter = 0;
for RunNumber = [1606,1612,1615,1618,1621]
    counter = counter + 1;
    Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
    load([Pat, Filename]);
    
    %% Calculations
    Data.(strcat('r',num2str(RunNumber))).InflationIndex(1,1) = 100;
    for t = 2:numel(Inflation)/TimeConstants.NrDaysInMonth
        Data.(strcat('r',num2str(RunNumber))).InflationIndex(1,t) = ...
            Data.(strcat('r',num2str(RunNumber))).InflationIndex(t-1)*...
            (1+Inflation(t*TimeConstants.NrDaysInMonth)/12);
    end
    
    Data.(strcat('r',num2str(RunNumber))).GDP = Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
        + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)/12).*HousingPrices(1:TimeConstants.NrDaysInMonth:end);
    Data.(strcat('r',num2str(RunNumber))).RealGDP = (100*Data.(strcat('r',num2str(RunNumber))).GDP)./Data.(strcat('r',num2str(RunNumber))).InflationIndex';
    Data.(strcat('r',num2str(RunNumber))).HousingPriceReal = HousingPrices(1:TimeConstants.NrDaysInMonth:end)./Data.(strcat('r',num2str(RunNumber))).InflationIndex';
    Data.(strcat('r',num2str(RunNumber))).HousingPrice = HousingPrices;
    Data.(strcat('r',num2str(RunNumber))).TotalMortgage = sum(HouseholdsTotalMortgage,2);
    Data.(strcat('r',num2str(RunNumber))).QuarterlyIncome = HouseholdsQuarterlyIncome + HouseholdsQuarterlyCapitalIncome;
    Data.(strcat('r',num2str(RunNumber))).QuarterlyRatio = HouseholdsHousingPayment./Data.(strcat('r',num2str(RunNumber))).QuarterlyIncome;
    Data.(strcat('r',num2str(RunNumber))).HousingPaymentRatio = mean(Data.(strcat('r',num2str(RunNumber))).QuarterlyRatio(1:TimeConstants.NrDaysInMonth:end,:),2);
    Data.(strcat('r',num2str(RunNumber))).GovernmentDeficit = GovernmentLiquidity;
    
    Statistics.GDP.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).GDP(end-120:end,1));
    Statistics.RealGDP.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).RealGDP(end-120:end,1));
    Statistics.HousingPrice.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).HousingPrice(end-2400:end,1));
    Statistics.HousingPriceReal.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).HousingPriceReal(end-120:end,1));
    Statistics.TotalMortgage.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).TotalMortgage(end-2400:end,1));
    Statistics.HousingPaymentRatio.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).HousingPaymentRatio(end-120:end,1));
    Statistics.GovernmentDeficit.value(counter) = mean(Data.(strcat('r',num2str(RunNumber))).GovernmentDeficit(end-2400:end,1));
end

Statistics.GDP.std = std(Statistics.GDP.value)/sqrt(5);
Statistics.RealGDP.std = std(Statistics.RealGDP.value)/sqrt(5);
Statistics.HousingPrice.std = std(Statistics.HousingPrice.value)/sqrt(5);
Statistics.HousingPriceReal.std = std(Statistics.HousingPriceReal.value)/sqrt(5);
Statistics.TotalMortgage.std = std(Statistics.TotalMortgage.value)/sqrt(5);
Statistics.HousingPaymentRatio.std = std(Statistics.HousingPaymentRatio.value)/sqrt(5);
Statistics.GovernmentDeficit.std = std(Statistics.GovernmentDeficit.value)/sqrt(5);

fprintf('\n GDP: %d %d',mean(Statistics.GDP.value),Statistics.GDP.std)
fprintf('\n RealGDP: %d %d',mean(Statistics.RealGDP.value),Statistics.RealGDP.std)
fprintf('\n HousingPrice: %d %d',mean(Statistics.HousingPrice.value),Statistics.HousingPrice.std)
fprintf('\n RealHousingPrice: %d %d',mean(Statistics.HousingPriceReal.value),Statistics.HousingPriceReal.std)
fprintf('\n TotalMortgage: %d %d',mean(Statistics.TotalMortgage.value),Statistics.TotalMortgage.std)
fprintf('\n HousingPaymentRatio: %d %d',mean(Statistics.HousingPaymentRatio.value),Statistics.HousingPaymentRatio.std)
fprintf('\n GovernmentDeficit: %d %d',mean(Statistics.GovernmentDeficit.value),Statistics.GovernmentDeficit.std)

