function [HCB] = Household_consumptionbudget(HWage,TM,HCI,TQ)
%%Function to set the household consumption budget for each day
%Inputs
%   HWage is the last monthly wage the household got
%   TM is the number of days in one Month
%   HCI is the last dividend payment a household got
%   TQ is the number of days in one quarter
%Output
%   HCB is the daily household consumption budget

HCB = HWage/TM + HCI/TQ;

end