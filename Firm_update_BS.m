function [FLiq,FCap,FAs,FEq,FDe] = Firm_update_BS(FLiq_old,FCap_old,FDe_old)
%%Function to update firms Balance Sheet
%
%[FLiq,FCap,FAs,FEq,FDe] = Firm_update_BS(FLiq_old,FCap_old,FDe_old)
%
%Inputs of the function are:
%   FLiq_old is the previous Liquidity of the firm
%   FCap_old is the previous Capital of the firm
%   FDe_old is the previous Debt of the firm
%Outputs of the functions are:
%   FLiq is the Liquidity of the firm after household consumption
%   FCap is the new Capital of the firm
%   FAs is the new Assets of the firm
%   FEq is the new Equity of the firm
%   FDe is the new Debt of the firm
%
%Inputs and Outputs can be vectors

FLiq = FLiq_old;
FCap = FCap_old;
FAs = FCap + FLiq;
FDe = FDe_old;
FEq = FAs - FDe;

end