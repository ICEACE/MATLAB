% we suppose that all capitalist households are equal shareholders of the banks and
% that therefore receive the same dividends amount from any bank

Banks.Liquidity = Banks.Liquidity - Banks.Dividends;

%old Households.CapitalIncomeBanks = ones(1,NrAgents.Households)*sum(Banks.Dividends)/NrAgents.Households;
%old Households.Liquidity = Households.Liquidity + Households.CapitalIncomeBanks;
%Households.CapitalIncomeBanks = Households.IsCapitalist*sum(Banks.Dividends*(1-PriceIndices.CapitalIncomeTax))/sum(Households.IsCapitalist);
%Households.Liquidity = Households.Liquidity + Households.CapitalIncomeBanks;
%% update Fund income and liquidity
Fund.Liquidity = Fund.Liquidity + sum(Banks.Dividends*(1-PriceIndices.CapitalIncomeTax));
Fund.DividendsRecieved = Fund.DividendsRecieved + sum(Banks.Dividends*(1-PriceIndices.CapitalIncomeTax));
%% Update government income statement
Government.CapitalIncomeTax = Government.CapitalIncomeTax + sum(Banks.Dividends*PriceIndices.CapitalIncomeTax);
Government.Liquidity = Government.Liquidity + sum(Banks.Dividends*PriceIndices.CapitalIncomeTax);