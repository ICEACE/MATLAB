function [Pn,HLiq] = Household_consumption(FSM,HCB,HLiq_old)
%%Function for household consumption
%
% Input:
%   FSM is the size measure of the firms in the economy - used to select firm for
%       consumption. Can be e.g. assets, capital or equity.
%   HCB is the household consumption budget
%   HLiq_old is the Liquidity of the household before consuming
%
% Output:
%   Pn is the index of the firm selected for consumption
%   HLiq is the Liquidity of the household after consuming
%
%Outputs can be scalars or vectors HCB and HLiq_old, while FAs can be a vector

%calculate number of households
NH = length(HCB);
%Set size of variable
Pn = zeros(1,NH);
%Select firms for consumption
for i = 1:NH
    Pn(i) = SelectFirmForConsumption(FSM);
end
%Calculate the new liquidity of households
HLiq = HLiq_old - HCB;
end