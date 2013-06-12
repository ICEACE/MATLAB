Households.LaborIncome = zeros(1,NrAgents.Households);
Tax = 0;
for f=1:NrAgents.Firms
    
    for e=1:Firms.NrEmployees(f)
         employee_id = Firms.EmployeesIds{1,f}(e);
         Households.LaborIncome(employee_id) = Firms.wage(f)...
             - PriceIndices.LaborTax*Firms.wage(f);
         Households.Liquidity(employee_id) = Households.Liquidity(employee_id) + Households.LaborIncome(employee_id);
         Tax = Tax + PriceIndices.LaborTax*Firms.wage(f);
    end
    
end

for c=1:NrAgents.CstrFirms
    
    for e=1:CstrFirms.NrEmployees(c)
         employee_id = CstrFirms.EmployeesIds{1,c}(e);
         Households.LaborIncome(employee_id) = CstrFirms.wage(c)...
             - PriceIndices.LaborTax*CstrFirms.wage(c);
         Households.Liquidity(employee_id) = Households.Liquidity(employee_id) + Households.LaborIncome(employee_id);
         Tax = Tax + PriceIndices.LaborTax*CstrFirms.wage(c);
    end
    
end

%% Update the quarterly labor income matrix 
Households.QuarterlyLaborIncome(1:2,:) = Households.QuarterlyLaborIncome(2:3,:);
Households.QuarterlyLaborIncome(3,:) = Households.LaborIncome+Households.Benefits;
%% Update Firm Liquidity
Firms.Liquidity = Firms.Liquidity - Firms.NrEmployees.*Firms.wage;
CstrFirms.Liquidity = CstrFirms.Liquidity - CstrFirms.NrEmployees.*CstrFirms.wage;
%% Update Govenment Liquidity
Government.Liquidity = Government.Liquidity + Tax;
Government.LaborTax = Government.LaborTax + Tax;
%% Firms.LaborCosts 
Firms.LaborCosts = Firms.LaborCosts + Firms.NrEmployees.*Firms.wage;
% Firms.LaborCosts is quarterly basis flow variable that is used for income
% statement accounting and then is set to zero every quarter 