function [FLiq,FDebt] = Firms_borrowing(FLiq_old,FDeb_old)
%%Function to let firms borrow funds if they lack liquidity
%
%[FLiq,FDebt] = Firms_borrowing(FLiq_old,FDebt_old)
%
%Input
%   FLiq_old is the liquidity of the firms before borrowing
%   FDeb_old is the debt of the firms before borrowing
%Output
%   FLiq is the liquidity of the firm after borrowing - set to 0
%   FDeb is the Debt of the firms after borrowing

FDebt = FDeb_old - min(FLiq_old,0);
FLiq = FLiq_old - min(FLiq_old,0);

end