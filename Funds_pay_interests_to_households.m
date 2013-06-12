for f=1:NrAgents.Funds
    
    %the fund checks the amount of profits realized in the considered
    %period (quarter). Note: depending which period of time is chosen
    %the trigger that will execute this script will be positioned in a
    %different part of the ICEACE_simulation file.

    %-----
    %VERIFICA QUESTA PARTE QUANDO L'IMPLEMENTAZIONE DEL TRASFERIMENTO DI
    %DENARO (RATE MUTUI) È STATA COMPLETATA
    %-----
    if Funds.data(f).earnings > 0
    
        %The fund decides which percentage of the profits has to be distributed
        %to the households:

        %--------
        %HP: the entire amount of profits/earnings is distributed.
        percentageEarningsDistributed = 1;
        %--------


        %it subdivides those profits (a percentage of them) between the
        %households that invested in the fund according to their percentage of
        %equity.
        earningsPerHousehold = (Funds.data(f).capital/sum(Funds.data(f).capital))*(min(Funds.data(f).availableCash,Funds.data(f).earnings*percentageEarningsDistributed));


        %the transaction between fund and households is realised. (and the
        %balance sheets of both parties are updated accordingly)
        Households.Liquidity = Households.Liquidity + earningsPerHousehold;
        Funds.data(f).availableCash = max(0,Funds.data(f).availableCash - Funds.data(f).earnings*percentageEarningsDistributed);
        Funds.data(f).earnings = Funds.data(f).earnings-max(Funds.data(f).availableCash,Funds.data(f).earnings*percentageEarningsDistributed);
        
    end 
end