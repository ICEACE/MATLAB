%% Computation of production quantity of Construction firms (CstrFirms)
%Production is limeted by either the Production plan or by being rationed
%in the labor market. 
CstrFirms.FinishedProjects = zeros(1,NrAgents.CstrFirms);
CstrFirms.ProductionQty = floor(min(CstrFirms.LaborProductivity.*CstrFirms.NrEmployees,CstrFirms.ProductionPlan));
for c=1:NrAgents.CstrFirms
    NrProjectsRunning = numel(CstrFirms.Projects.MonthsLeft{1,c});
    if CstrFirms.ProductionQty(c) == 0
        CstrFirms.Projects.MonthsLeft{1,c} = CstrFirms.Projects.MonthsLeft{1,c};
    elseif NrProjectsRunning >= CstrFirms.ProductionQty(c)
        [~,Idx] = sort(CstrFirms.Projects.MonthsLeft{1,c});
        CstrFirms.Projects.MonthsLeft{1,c}(Idx(1:CstrFirms.ProductionQty(c))) =...
            CstrFirms.Projects.MonthsLeft{1,c}(Idx(1:CstrFirms.ProductionQty(c))) - 1;
    else
        NewProjects = CstrFirms.ProductionQty(c) - NrProjectsRunning;
        CstrFirms.Projects.MonthsLeft{1,c} = CstrFirms.Projects.MonthsLeft{1,c} - 1;
        CstrFirms.Projects.MonthsLeft{1,c} = [CstrFirms.Projects.MonthsLeft{1,c},(TimeConstants.HousingCstrTime-1)*ones(1,NewProjects)];        
    end
    CstrFirms.FinishedProjects(1,c) = numel(find(CstrFirms.Projects.MonthsLeft{1,c} == 0));
    CstrFirms.Projects.MonthsLeft{1,c} = CstrFirms.Projects.MonthsLeft{1,c}(CstrFirms.Projects.MonthsLeft{1,c}~=0);
    CstrFirms.Inventories(c) = CstrFirms.Inventories(c) + CstrFirms.FinishedProjects(1,c);
    
    clear Idx NrProjectsRunning 
end
CstrFirms.LaborCosts = CstrFirms.wage.*CstrFirms.NrEmployees;
%fprintf('\n Total CstrFirms Inventories: %d ',sum(CstrFirms.Inventories(1,:)))