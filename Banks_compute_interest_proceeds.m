for b=1:NrAgents.Banks
    Banks.TotalInterestProceeds(b) = 0;
    for l=1:numel(Banks.LoansArray{1,b}.Amount)
        Banks.TotalInterestProceeds(b) = Banks.TotalInterestProceeds(b) + ...
            (Banks.LoansArray{1,b}.InterestRate(l)/4)*Banks.LoansArray{1,b}.Amount(l);
    end
    
    for l=1:numel(Banks.LoansArrayCstrF{1,b}.Amount)
        Banks.TotalInterestProceeds(b) = Banks.TotalInterestProceeds(b) + ...
            (Banks.LoansArrayCstrF{1,b}.InterestRate(l)/4)*Banks.LoansArrayCstrF{1,b}.Amount(l);
    end
end