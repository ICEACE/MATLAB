function [HCI,HLiq,FLiq] = Firms_dividendpayment(FLiq,HLiq,FNEa)
%%Function to pay divedent from firms to households
%Input
%   FLiq is the Firms Liquidity before paying divident
%   HLiq is the Household Liqidity before getting divident payment
%   FNEa is the net earnings of the firm   
%Output
%   HCI is the household capital income
%   HLiq is the household Liquidity 
%   FLiq is the Liquidity of the firm after paying dividend

%calculate the number of households
NH = length(HLiq);
%Set the household capital income to zero for the quarter
HCI = zeros(1,NH);

%If firms have positive Net earnings distribute equally between households
for k = 1:length(FNEa)
    if FNEa(1,k) > 0
        for i = 1:NH
            HCI(i) = HCI(i) + FNEa(1,k)/NH;
        end
        FLiq(1,k) = FLiq(1,k) - FNEa(1,k);
    end
end
HLiq = HLiq + HCI;
end