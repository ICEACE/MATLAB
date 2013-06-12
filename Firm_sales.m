function [FLiq,FRev] = Firm_sales(Pn,HCB,FLiq_old,FRev_old)
%%Function to update the Liquidity of Firms from sales
%
%[FLiq,FRev] = Firm_sales(Pn,HCB,FLiq_old,FRev_old)
%
%Input
%   Pn is the index of the firm selected for household consumption
%   HCB is the Household daily consumption budget
%   FLiq_old is the Liquidity of the firm before sales
%   FRev_old is the firms´ cumulative (over the quarter) revenues
%Output
%   FLiq is the firms´ liquidity after sales 
%   FRev is the firms´ updated cumulative (over the quarter) revenues
%
%Pn and HCB are scalar while other inputs and outputs can be vectors

%Only one firm is selected for consumption so need to copy old liquidity
FLiq = FLiq_old;
%If we are in a new quarter we set Revenues to for all firms to zero
if sum(isnan(FRev_old)) == length(FRev_old)
    FRev = zeros(1,length(FRev_old));
else
    FRev = FRev_old;
end
%The firm selected for household consumption gets Liquidity and Revenues
FLiq(1,Pn) = FLiq(1,Pn) + HCB;
FRev(1,Pn) = FRev(1,Pn) + HCB;
end