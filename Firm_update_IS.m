function [FEBIT,FNEa] = Firm_update_IS(FLab,FRev,FIP)
%%Function to update the Income Statement of firms
%Input
%   FLab is the Labour cost of the firm for the month
%   FRev is the Revenues of the firm in the month
%   FIP is the interest payments of the firm in the month
%Output
%   FEBIT is the the EBIT of the firm in the month
%   FNEa are the net earnings of the firm in the month
%
%All outputs are vectors as well as FRev and FIP while FLab is a matrix of
%labor costs of the firm in the month

%Calculate the EBIT of the firms in the month
FEBIT = FRev - FLab;
%Calculate the Net earnings of the firms in the month
FNEa = FEBIT - FIP;
end