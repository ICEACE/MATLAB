%% if a firm has vacancies and its wage is lower than average, 
% the firm increases its wage above average to attract employees from other firms or unemploied workers 
for f=1:NrAgents.Firms
    if Firms.vacancies(f)>0
        Firms.wage(f) = max(Firms.wage(f),1.01*PriceIndices.wage);
    end
end