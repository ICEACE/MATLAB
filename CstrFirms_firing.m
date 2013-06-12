for c=1:NrAgents.CstrFirms
    if CstrFirms.layoffs(c)>0
        % the employees with the highest id are fired (deterministic
        % choice)
        employees2fire_tmp = sort(CstrFirms.EmployeesIds{1,c},'descend');
        employees2fire = employees2fire_tmp(1:CstrFirms.layoffs(c));
        employees_fired = [];
        for employee_id = employees2fire
            Households.employer_id(employee_id) = -1;  % the employee is fired
            Households.employer_class(employee_id) = 0;
            employees_fired = [employees_fired, employee_id];
            clear employee_id
        end
        
        % Check
        if (numel(intersect(CstrFirms.EmployeesIds{1,c},employees_fired))~=CstrFirms.layoffs(c))
            debug
           % error('Error in the firing process')
        end
        
        CstrFirms.EmployeesIds{1,c} = setdiff(CstrFirms.EmployeesIds{1,c},employees_fired);
        CstrFirms.NrEmployees(c) = CstrFirms.NrEmployees(c) - CstrFirms.layoffs(c);
        clear employess2fire employees_fired employees2fire_tmp
    end
end