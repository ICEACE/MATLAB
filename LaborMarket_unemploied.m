%[Dummy, IdxWages] = sort(Firms.wage,'descend');
for h=1:NrAgents.Households  % deterministic sampling with privilege to househols with lower id
    if sum(Employers.vacancies)==0
        break
    end
    
    % household h is unemploied
    if (Households.employer_id(h)==-1)
        
        % Indices of employers with job openings ordered with decreasing wages
        Indices = find(Employers.vacancies(IdxWages)>0);
        % index of the best paying employer with job openings
        e = IdxWages(Indices(1));
        
        % Household h is hired by employer e
        Households.employer_id(h) = Employers.id(e);
        Households.employer_class(h) = Employers.class(e);
        Employers.EmployeesIds{1,e} = [Employers.EmployeesIds{1,e}, h];
        Employers.NrEmployees(e) = Employers.NrEmployees(e) + 1;
        Employers.vacancies(e) = Employers.vacancies(e) - 1;
        
        clear Indices e
    end
end

%Set temporary structure back to separate agent structure
f = 0;
c = 0;
for e=1:numel(Employers.id)
if Employers.class(e) == Firms.class_id
    f = f + 1;
    Firms.vacancies(f) = Employers.vacancies(e);
    Firms.EmployeesIds{1,f} = Employers.EmployeesIds{1,e};
    Firms.NrEmployees(f) = Employers.NrEmployees(e);
elseif Employers.class(e) == CstrFirms.class_id
    c = c + 1;
    CstrFirms.vacancies(c) = Employers.vacancies(e);
    CstrFirms.EmployeesIds{1,c} = Employers.EmployeesIds{1,e};
    CstrFirms.NrEmployees(c) = Employers.NrEmployees(e);
end
end

clear Employers c f