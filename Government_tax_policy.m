%Government_tax_policy
% if rand < 0.5
%     if abs(Government.Balance) < 1e3
%         DeltaTax = 0.02;
%         DeltaBenefit = 0;
%     else
%         DeltaTax = 0.04;
%         DeltaBenefit = 0.01;
%     end
% else
%     if abs(Government.Balance) < 1e3
%         DeltaTax = 0;
%         DeltaBenefit = 0.02;
%     else
%         DeltaTax = 0.01;
%         DeltaBenefit = 0.04;
%     end
% 
% end


Unemp = numel(find(Households.employer_id == -1))/NrAgents.Households;
%DeltaBenefit = 0.01;

if Government.Balance < 0
    if Unemp > Government.Parameters.MaxUnemp;
    DeltaTax = (1-Government.Parameters.LeftishPolicy)*0.05;
    DeltaBenefit = 0.05;
    
    PriceIndices.LaborTax = max(0.1,PriceIndices.LaborTax - DeltaTax);
    PriceIndices.CapitalIncomeTax = max(0.1,PriceIndices.CapitalIncomeTax - DeltaTax);
 %   PriceIndices.UnemploymentBenefitRatio = max(0.4,PriceIndices.UnemploymentBenefitRatio + DeltaBenefit);
    PriceIndices.TransferBenefitRatio = min(0.5,PriceIndices.TransferBenefitRatio + DeltaBenefit);
    else
    DeltaTax = Government.Parameters.LeftishPolicy*0.05;
    DeltaBenefit = (1-Government.Parameters.LeftishPolicy)*0.05;
    
    PriceIndices.LaborTax = min(0.5,PriceIndices.LaborTax + DeltaTax);
    PriceIndices.CapitalIncomeTax = min(0.5,PriceIndices.CapitalIncomeTax + DeltaTax);
    
%    PriceIndices.UnemploymentBenefitRatio = max(0,PriceIndices.UnemploymentBenefitRatio - DeltaBenefit);
    PriceIndices.TransferBenefitRatio = max(0,PriceIndices.TransferBenefitRatio - DeltaBenefit);
    end
elseif Government.Balance > 5e2
    DeltaTax = (1-Government.Parameters.LeftishPolicy)*0.05;
    DeltaBenefit = Government.Parameters.LeftishPolicy*0.05;
    
    PriceIndices.LaborTax = max(0.1,PriceIndices.LaborTax - DeltaTax);
    PriceIndices.CapitalIncomeTax = max(0.1,PriceIndices.CapitalIncomeTax - DeltaTax);
 %   PriceIndices.UnemploymentBenefitRatio = max(0.4,PriceIndices.UnemploymentBenefitRatio + DeltaBenefit);
    PriceIndices.TransferBenefitRatio = min(0.4,PriceIndices.TransferBenefitRatio + DeltaBenefit);
else
    PriceIndices.LaborTax = PriceIndices.LaborTax;
    PriceIndices.CapitalIncomeTax = PriceIndices.CapitalIncomeTax;
 %   PriceIndices.UnemploymentBenefitRatio = PriceIndices.UnemploymentBenefitRatio;
    PriceIndices.TransferBenefitRatio = PriceIndices.TransferBenefitRatio;
end