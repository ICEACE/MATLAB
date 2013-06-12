%First we construct a temporary structure for all employers in the economy.
%Employers are firms, e.g. CGP firms and Construction (Cstr) firms.
Employers.wage = [Firms.wage,CstrFirms.wage];
Employers.id = [1:numel(Firms.wage),(numel(Firms.wage)+1):(numel(Firms.wage)+numel(CstrFirms.wage))];
Employers.class = [Firms.class_id*ones(1,NrAgents.Firms),CstrFirms.class_id*ones(1,NrAgents.CstrFirms)];
Employers.vacancies = [Firms.vacancies,CstrFirms.vacancies];
Employers.EmployeesIds = [Firms.EmployeesIds,CstrFirms.EmployeesIds];
Employers.NrEmployees = [Firms.NrEmployees,CstrFirms.NrEmployees];
[Dummy, IdxWages] = sort(Employers.wage,'descend');
for h=1:NrAgents.Households  % deterministic sampling with privilege to househols with lower id
    if sum(Employers.vacancies)==0
        break
    end
    
    % household h is employed
    if (Households.employer_id(h)>0)
        
        % present employer of household h
        e_present_id = Households.employer_id(h);
        e_present_class = Households.employer_class(h);
        % Indices of employers with job openings ordered with decreasign wages
        Indices = find(Employers.vacancies(IdxWages)>0);
        % index of the best paying employer with job openings
        e = IdxWages(Indices(1));
        
        % if household h is employed by an employer different from e with lower wage
        if ((e_present_id~=e)&&(Employers.wage(e_present_id)<Employers.wage(e)))
            if rand<Households.Parameters.LaborTurnoverProbability
                
                % Household h resigns from employer e_present_id
                % Check                
                if (sum(ismember(Employers.EmployeesIds{1,e_present_id},h))~=1)
                    error('Error in the resigning process')
                end                
                Employers.EmployeesIds{1,e_present_id} = setdiff(Employers.EmployeesIds{1,e_present_id},h);
                Employers.NrEmployees(e_present_id) = Employers.NrEmployees(e_present_id) - 1;
                Employers.vacancies(e_present_id) = Employers.vacancies(e_present_id) + 1;
                
                % Household h is hired by employer e
                Households.employer_id(h) = Employers.id(e);
                Households.employer_class(h) = Employers.class(e);
                
                Employers.EmployeesIds{1,e} = [Employers.EmployeesIds{1,e}, h];
                Employers.NrEmployees(e) = Employers.NrEmployees(e) + 1;
                Employers.vacancies(e) = Employers.vacancies(e) - 1;
                
            end
        end
        clear Indices e e_present_id e_present_class
    end
end



%         
%     if (Households.employer(h)>0) % The household is employed already
%         
%         Households.employer(h) = f;
%         Firms.EmployeesIds{1,f} = [Firms.EmployeesIds{1,f}, h];
%         Firms.NrEmployees(f) = Firms.NrEmployees(f) + 1;
%         Firms.vacancies(f) = Firms.vacancies(f) - 1;
%         clear Indices f
%     end
%         
%     if (Households.employer(h)==-1)
%         Indices = find(Firms.vacancies(IdxWages)>0);
%         
%         f = IdxWages(Indices(1));
%         Households.employer(h) = f;
%         Firms.EmployeesIds{1,f} = [Firms.EmployeesIds{1,f}, h];
%         Firms.NrEmployees(f) = Firms.NrEmployees(f) + 1;
%         Firms.vacancies(f) = Firms.vacancies(f) - 1;
%         clear Indices f
%     end
%     
% end