function [IPay,FLiq] = Firm_interestpayment(IRa,FDe,FLiq_old)
%%Function to calculate interestpayment of firms
%Inputs of the function are:
%   IRa is the Intrest rate of the firms debt
%   FDe is the current debt of the Firm
%   FLiq_old is the Liquidity of the firm before paying interest
%Outputs of the functions are:
%   IPay is the interest payment made
%   FLiq is the Liquidity of the firm after paying interest
%
%All inputs and outputs can be vectors

%Calculate the interest payment of each firm
IPay = FDe.*IRa;
%Calculate the liquidity of each firm after interest payment
FLiq = FLiq_old - IPay;
end