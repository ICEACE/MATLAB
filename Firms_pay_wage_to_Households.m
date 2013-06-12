for f=1:NrAgents.Firms
    
    Firms.Liquidity(f) = Firms.Liquidity(f) - Firms.NrEmployees(f)*PriceIndices.wage;
    
    for e=1:Firms.NrEmployees(f)
         employee_id = Firms.EmployeesIds{1,f}(e);
         Households.Liquidity(employee_id) = Households.Liquidity(employee_id) + PriceIndices.wage;
    end
    
end