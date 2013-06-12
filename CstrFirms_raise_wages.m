%% if a Cstr firm has vacancies and its wage is lower than average, 
% the firm increases its wage above average to attract employees from other firms or unemploied workers 
for c=1:NrAgents.CstrFirms
    if CstrFirms.vacancies(c)>0
        CstrFirms.wage(c) = max(CstrFirms.wage(c),1.01*PriceIndices.wage);
    end
end