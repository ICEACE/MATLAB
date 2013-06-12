CstrFirms.EBIT = CstrFirms.Revenues - CstrFirms.LaborCosts;
CstrFirms.Earnings = CstrFirms.EBIT - CstrFirms.TotalInterestPayments;

CstrFirms.Revenues = zeros(1,NrAgents.CstrFirms);
CstrFirms.LaborCosts = zeros(1,NrAgents.CstrFirms);
