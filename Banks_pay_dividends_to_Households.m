% we suppose that all households are equal shareholders of the banks and
% that therefore receive the same dividends amount from any bank

Banks.Liquidity = Banks.Liquidity - Banks.Dividends;

%Households.CapitalIncomeBanks = ones(1,NrAgents.Households)*sum(Banks.Dividends)/NrAgents.Households;
%Households.Liquidity = Households.Liquidity + Households.CapitalIncomeBanks;

Households.CapitalIncomeBanks = Households.IsCapitalist*sum(Banks.Dividends*(1-PriceIndices.CapitalIncomeTax))/sum(Households.IsCapitalist);
Households.Liquidity = Households.Liquidity + Households.CapitalIncomeBanks;
%% Update government income statement
Government.CapitalIncomeTax = Government.CapitalIncomeTax + sum(Banks.Dividends*PriceIndices.CapitalIncomeTax);
Government.Liquidity = Government.Liquidity + sum(Banks.Dividends*PriceIndices.CapitalIncomeTax);