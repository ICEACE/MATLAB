
EmploymentRate = numel(find(Households.employer_id>0))/NrAgents.Households;

PriceIndices.Inflation = (PriceIndices.ConsumptionGoods_hist(d)-PriceIndices.ConsumptionGoods_hist(max(1,d-TimeConstants.NrDaysInYear)))...
    /PriceIndices.ConsumptionGoods_hist(max(1,d-TimeConstants.NrDaysInYear));

PriceIndices.CBInterestRate = PriceIndices.Inflation + ...
    0.5*(PriceIndices.Inflation-0.02) + 0.5*(EmploymentRate-1);
PriceIndices.CBInterestRate = max(0.005,PriceIndices.CBInterestRate);

PriceIndices.InterestRate = PriceIndices.CBInterestRate + PriceIndices.InterestRateSpread;
PriceIndices.MortgageRate = PriceIndices.CBInterestRate + PriceIndices.MortgageRateSpread;