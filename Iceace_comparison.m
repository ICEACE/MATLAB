%% Calculations to compare three simulations
clear all
close all
clc

if isunix
   Pat = '../../runs/';
else
   Pat = '..\..\runs\';
end

count = 0;

for RunNumber = [3234151,3234154]
    count = count + 1;
    Filename = ['ICEACE_run',num2str(RunNumber),'_All','.mat'];
    load([Pat, Filename]);
    
    font_sz = 14;
    line_wdt = 1;
    colori = {'k';'b';'g';'r';'y';'m'};
    colore = colori{count};
    Num_years = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInYear;
    Num_quarters = (SimulationFinalDay-SimulationStartingDay)./TimeConstants.NrDaysInQuarter;
    quarters_visualization_step = 1;
    visualization_vector = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
    visualization_vector_quarter = (0:(quarters_visualization_step*TimeConstants.NrDaysInQuarter):(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;
    XVector_quarter = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInQuarter;
    XVector_year = (1:(SimulationFinalDay-SimulationStartingDay))/TimeConstants.NrDaysInYear;
    XVector_month = (1:(SimulationFinalDay-SimulationStartingDay)/TimeConstants.NrDaysInMonth);
    
    InflationIndex(count,1) = 100;
    for t = 2:numel(Inflation)/TimeConstants.NrDaysInMonth
        InflationIndex(count,t) =  InflationIndex(count,t-1)*(1+Inflation(t*TimeConstants.NrDaysInMonth)/12);
    end
    
    GDP_mothly(count,:) = (Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
        + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)/12).*HousingPrices(1:TimeConstants.NrDaysInMonth:end))';
    RealGDP_monthly(count,:) = (100*GDP_mothly(count,:))./InflationIndex(count,:);
    
    for q = 1:SimulationDurationInQuarters
        month_end = q*3;
        month_start = q*3-2;
        RealGDP_quarterly(count,q) = sum(RealGDP_monthly(count,month_start:month_end));
    end
    for y = 1:SimulationDurationInQuarters/4
        year_end = y*12;
        year_start = y*12-11;
        RealGDP_yearly(count,y) = sum(RealGDP_monthly(count,year_start:year_end));
    end
    
    RealGDP_monthly_change(count,:) = diff(RealGDP_monthly(count,:));
    RealGDP_quarterly_change(count,:) = diff(RealGDP_quarterly(count,:));
    RealGDP_yearly_change(count,:) = diff(RealGDP_yearly(count,:));
    
    
    figure(1)
    set(gcf,'Name','Economy')
    subplot(2,1,1); hold on; grid on; box on
    plot(XVector_month, RealGDP_monthly(count,:),colore,'linewidth',line_wdt)
    ylabel('Monthly Real GDP','fontsize',font_sz)
    xlabel('years','fontsize',font_sz)
    hold off
    subplot(2,1,2);hold on; grid on; box on
    plot(1:(SimulationDurationInQuarters*3-1),RealGDP_monthly_change(count,:),colore)
    ylabel('Monthly Real GDP change','fontsize',font_sz)
    xlabel('months','fontsize',font_sz)
    hold off
    
    figure(2)
    set(gcf,'Name','Economy')
    subplot(2,1,1); hold on; grid on; box on
    plot(1:SimulationDurationInQuarters, RealGDP_quarterly(count,:),colore,'linewidth',line_wdt)
    ylabel('Quarterly Real GDP','fontsize',font_sz)
    xlabel('quarters','fontsize',font_sz)
    hold off
    subplot(2,1,2);hold on; grid on; box on
    plot(2:SimulationDurationInQuarters,RealGDP_quarterly_change(count,:),colore)
    ylabel('Quarterly Real GDP change','fontsize',font_sz)
    xlabel('years','fontsize',font_sz)
    hold off
    
    figure(3)
    set(gcf,'Name','Economy')
    subplot(2,1,1); hold on; grid on; box on
    plot(1:SimulationDurationInQuarters/4, RealGDP_yearly(count,:),colore,'linewidth',line_wdt)
    ylabel('Yearly Real GDP','fontsize',font_sz)
    xlabel('years','fontsize',font_sz)
    hold off
    subplot(2,1,2);hold on; grid on; box on
    plot(2:(SimulationDurationInQuarters/4),RealGDP_yearly_change(count,:),colore)
    ylabel('Yearly Real GDP change','fontsize',font_sz)
    xlabel('years','fontsize',font_sz)
    hold off
      
    clear Households Firms CstrFirms Banks Fund InflationIndex
end
%% First simulation


% AvUnemp1 = mean(UnemployedWorkers);
% GDP = Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
%    + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)).*HousingPrices(1:TimeConstants.NrDaysInMonth:end);
% AvGDP1 =  mean(GDP);
% 
% AvREPrice1 = mean(HousingPrices);
% AvMortgage1 = mean(sum(HouseholdsTotalMortgage,2));
% 
% AvGovLiq1 = mean(GovernmentLiquidity);
% AvGovBal1 = mean(GovernmentBalance);
% 
% AvCBrate1 = mean(CBRate);
% AvInfl1 = mean(Inflation);
% %% Second simulation
% Filename = ['ICEACE_run',num2str(RunNumber2),'_All','.mat'];
% load([Pat, Filename]);
% 
% AvUnemp2 = mean(UnemployedWorkers);
% GDP = Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
%    + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)).*HousingPrices(1:TimeConstants.NrDaysInMonth:end);
% AvGDP2 =  mean(GDP);
% AvREPrice2 = mean(HousingPrices);
% AvMortgage2 = mean(sum(HouseholdsTotalMortgage,2));
% 
% AvGovLiq2 = mean(GovernmentLiquidity);
% AvGovBal2 = mean(GovernmentBalance);
% 
% AvCBrate2 = mean(CBRate);
% AvInfl2 = mean(Inflation);
% 
% %% Second simulation
% Filename = ['ICEACE_run',num2str(RunNumber3),'_All','.mat'];
% load([Pat, Filename]);
% 
% AvUnemp3 = mean(UnemployedWorkers);
% GDP = Production(1:TimeConstants.NrDaysInMonth:end).*PriceIndex(1:TimeConstants.NrDaysInMonth:end)...
%    + (CstrProduction(1:TimeConstants.NrDaysInMonth:end)).*HousingPrices(1:TimeConstants.NrDaysInMonth:end);
% AvGDP3 =  mean(GDP);
% AvREPrice3 = mean(HousingPrices);
% AvMortgage3 = mean(sum(HouseholdsTotalMortgage,2));
% 
% AvGovLiq3 = mean(GovernmentLiquidity);
% AvGovBal3 = mean(GovernmentBalance);
% 
% AvCBrate3 = mean(CBRate);
% AvInfl3 = mean(Inflation);