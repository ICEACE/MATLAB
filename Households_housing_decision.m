%Households_housing_decision

%Random household housing decision
clear HousingBuy HousingSell s P

for h=1:NrAgents.Households
    if  Households.HousingAmount(h) < REmarket.minHousing %Households.HousingMarketAction(h) == 2 ||
         Households.HousingDecision(:,h) = [1;0]; %might want to buy
         Households.HousingMarketAction(h) = Households.HousingDecision(randi(length(Households.HousingDecision(:,h))),h);
    elseif Households.HousingPayment(h) > REmarket.FireSaleThresh*(sum(Households.QuarterlyLaborIncome(:,h))...
            + Households.QuarterlyCapitalIncome(h))
        %(Households.Liquidity(h) + Households.Savings(h)) < 0
         Households.HousingMarketAction(h) = -1;
         Households.HousingFireSale(h) = 1;
    elseif sum(Households.QuarterlyLaborIncome(:,h)) < REmarket.CapitalLaborRatio*Households.QuarterlyCapitalIncome(h)
        if REmarket.HousingPrice(end) > REmarket.HousingPrice(end-1)
              Households.HousingMarketAction(h) = 1;
        elseif REmarket.HousingPrice(end) <= REmarket.HousingPrice(end-1)
              Households.HousingMarketAction(h) = -1;
        end
    else
        xx = rand;
        if xx<0.18
            Households.HousingMarketAction(h) = -1;
        elseif xx>0.82
            Households.HousingMarketAction(h) = 1;
        else
            Households.HousingMarketAction(h) = 0;
        end
        %Households.HousingMarketAction(h) = randi(3)-2;
    end
%      %else
%      %    Households.HousingMarketAction(h) = randi(3)-2;
%      %end
%      elseif Households.HousingAmount(h) < REmarket.minHousing %Households.HousingMarketAction(h) == 2 ||
%          Households.HousingDecision(:,h) = [1;0]; %might want to buy
%          Households.HousingMarketAction(h) = Households.HousingDecision(randi(length(Households.HousingDecision(:,h))),h);
%      elseif Households.HousingReducePrice(h) == 1
%          Households.HousingMarketAction(h) = -1;
%      elseif Households.IsCapitalist(h) == 1;
%          if Stats.HousingPriceGrowth(end-HouseholdsMemory0:1:end) > REmarket.const_r
%              P = 1;
%          elseif Stats.HousingPriceGrowth(end-HouseholdsMemory0:1:end) < 0*REmarket.const_r
%              P = -1;
%          else
%              P = 0;
%          end
%          
%          Households.HousingMarketAction(h) = P;
%      else
%          if Households.HousingPayment(h)/3 <= REmarket.const_b*Households.C(h)
%              s = 1;
%          elseif Households.HousingPayment(h)/3 >= REmarket.const_a*Households.C(h)
%              s = -1;
%          else
%              s = 0;
%          end
%          %consider using a growth rate and use a memory variable
%          %if Stats.HousingPriceGrowth(end-HouseholdsMemory0:1:end) > REmarket.const_r
%          %    P = 1;
%          %elseif Stats.HousingPriceGrowth(end-HouseholdsMemory0:1:end) < -REmarket.const_r
%          %    P = -1;
%          %else
%          %    P = 0;
%          %end
%          
%          if Stats.WageGrowth(end-HouseholdsMemory0:1:end,h) > 0
%              W = 1;
%          elseif Stats.WageGrowth(end-HouseholdsMemory0:1:end,h) < 0
%              W = -1;
%          else
%              W = 0;
%          end
%          
%          
%          Households.HousingDecision(:,h) = [s;W];
%          Households.HousingMarketAction(h) = Households.HousingDecision(randi(length(Households.HousingDecision(:,h))),h);
%      end
%     %Households.HousingMarketAction(h) = round(sum(Households.HousingDecision(:,h)));
        
    
end
%HMActive = rand(1,NrAgents.Households);
%Households.HousingMarketAction(HMActive < 0.25) = 1;
%Households.HousingMarketAction(HMActive > 0.975) = -1;
%%must own at least some units of housing
%HousingCantSell = find(Households.HousingAmount < REmarket.minHousing);
%Households.HousingMarketAction(HousingCantSell) = 0;

HousingSell_Idx = find(Households.HousingMarketAction == -1);
HousingBuy_Idx = find(Households.HousingMarketAction == 1);
REmarket.Demand = numel(HousingBuy_Idx);
REmarket.Supply = numel(HousingSell_Idx);
Remarket.NumFireSale = sum(Households.HousingFireSale);