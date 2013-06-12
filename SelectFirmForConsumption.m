function [Pn] = SelectFirmForConsumption(FSM)
%%Function to select firm for consumption using a logit model
%
%[Pn] = SelectFirmForConsumption(FAs)
%
%Input
%   FSM is the firms´ size measure - used to select a firm for consumption so
%   that a "larger" firm is more likely to be selected than those
%   with that are smaller
%Output
%   Pn is the index of the firm selected for consumption

%Calculate the beta - in this case it is simply 1 over the number of firms
Beta = 1/length(FSM);
%Calculate the probability that a given firm will be 
x = exp(Beta.*FSM)./sum(exp(Beta.*FSM));
%Create the cumulative probability
p = cumsum(x);
%Create a random number
U = rand;
%Select a firm given the random number
idx = find(p>U);
%Save the index of the firm selected
Pn = idx(1);
end