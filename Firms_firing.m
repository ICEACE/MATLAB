for f=1:NrAgents.Firms
    if Firms.layoffs(f)>0
        % the employees with the highest id are fired (deterministic
        % choice)
        employees2fire_tmp = sort(Firms.EmployeesIds{1,f},'descend');
        employees2fire = employees2fire_tmp(1:Firms.layoffs(f));
        employees_fired = [];
        for employee_id = employees2fire
            Households.employer_id(employee_id) = -1;  % the employee is fired
            Households.employer_class(employee_id) = 0;
            employees_fired = [employees_fired, employee_id];
            clear employee_id
        end
        
        % Check
        if (numel(intersect(Firms.EmployeesIds{1,f},employees_fired))~=Firms.layoffs(f))
            debug
           % error('Error in the firing process')
        end
        
        Firms.EmployeesIds{1,f} = setdiff(Firms.EmployeesIds{1,f},employees_fired);
        Firms.NrEmployees(f) = Firms.NrEmployees(f) - Firms.layoffs(f);
        clear employess2fire employees_fired employees2fire_tmp
    end
end