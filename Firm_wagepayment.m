function [FLab,FLiq] = Firm_wagepayment(FAs,Wage,FLiq_old)
%%Function for payment of wages from firm to household
%
%[FLab,FLiq] = Firm_wagepayment(FAs,Wage,FLiq_old)
%
% Input:
%   FAs is the Assets of the firms - firms pay wage according to their
%   assets
%   Wage is the total wage payment for all firms
%   FLiq_old is the liquidity of the firm before wage payment
%
% Output:
%   FLab is the labor cost of the firms
%   FLiq is the liquidity of the firms after wage payment
%
% Inputs and outputs can be vectors

%Calculate the share of each firm is the wage payment accoriding to their
%assets
FLab = (FAs./sum(FAs))*Wage;
%Calculate the new liquidity of the firms
FLiq = FLiq_old - FLab;
end