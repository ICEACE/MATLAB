function [HCI,HLiq] = Banks_dividendpayment(HLiq,BNEa,HCI)
%%Function to pay dividend from banks to households
%Input
%   HLiq is the Household Liqidity before getting divident payment
%   BNEa is the net earnings of the bank for the quarter   
%   HCI is the household capital income
%Output
%   HCI is the household capital income
%   HLiq is the household Liquidity 

%Calculate the number of households
NH = length(HCI);
%If banks have positive net earnings they pay dividend to households
%distributed equally between households
if BNEa > 0
    HCI = HCI + BNEa/NH;
    HLiq = HLiq + BNEa/NH;
end

end