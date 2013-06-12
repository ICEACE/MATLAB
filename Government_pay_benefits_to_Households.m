%Government pays unemployment benefits to unemployed households.
%% Households get unemployment benefits
Households.Benefits = zeros(1,NrAgents.Households);
Households.Benefits(Households.employer_id == -1) = PriceIndices.UnemploymentBenefitRatio*mean([Firms.wage,CstrFirms.wage]);
Government.UnempBenefitsPaid = sum(Households.Benefits(Households.employer_id == -1));
Government.UnempBenefitsPaid_sum = Government.UnempBenefitsPaid_sum + ...
    Government.UnempBenefitsPaid;

%% Households get transfers from the Government
Households.Benefits = Households.Benefits + PriceIndices.TransferBenefitRatio*mean([Firms.wage,CstrFirms.wage]);
Government.GeneralBenefitsPaid = NrAgents.Households*PriceIndices.TransferBenefitRatio*mean([Firms.wage,CstrFirms.wage]);
Government.GeneralBenefitsPaid_sum = Government.GeneralBenefitsPaid_sum + ...
    Government.GeneralBenefitsPaid;

%% Update households Liquidity
Households.Liquidity = Households.Liquidity + Households.Benefits;

%% Government accounts benfits payment
Government.Liquidity = Government.Liquidity - Government.UnempBenefitsPaid -...
    Government.GeneralBenefitsPaid;