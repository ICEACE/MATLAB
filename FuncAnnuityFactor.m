%%Annuity factor calculation for household
%HMAMD is the Households Mortgage Array maturity dates
function AF = FuncAnnuityFactor(HMAMD,MortgageRate,d)
NrDaysInQuarter = 60;
n = numel(HMAMD);
AF = zeros(1,n);
for i = 1:n
    RQ = (HMAMD(i)-d+1)/NrDaysInQuarter;
    AF(1,i) = (1/(MortgageRate/4))-...
        1/((MortgageRate/4)*(1+(MortgageRate/4))^RQ);
end