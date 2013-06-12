bidsAuction1 = bids;
asksAuction1 = asks;

asks = zeros(NrAgents.Banks, size(Banks.Packages,2));
bids = zeros(NrAgents.Banks, size(Banks.Packages,2), NrAgents.Funds);

% %ogni banca crea i proprio pacchetti
% Banks_packages_creation    
%     
% common_knowledge_evaluation_of_packages

%----
%rivedo la struttura orderedPackages che mi servirà nel prosieguo:
%----
if size(notAvailablePackagesList,2) < size(soldPackagesList,2)
    notAvailablePackages = [notAvailablePackages, zeros(size(soldPackages,1), ...
        size(soldPackages,2)-size(notAvailablePackages,2))]; 
    notAvailablePackagesList = convert_matrix_into_array(notAvailablePackages,TotNrDebitPackages);
end

setFilter = 0;
if isempty(soldPackagesList) == 0 && isempty(notAvailablePackagesList) == 0
    [~, stillOnSalePackages] = find((soldPackagesList+notAvailablePackagesList-ones(size(soldPackagesList,1),size(soldPackagesList,2)))*-1);
    setFilter = 1;
elseif isempty(soldPackagesList) == 0 && isempty(notAvailablePackagesList) == 1
    [~, stillOnSalePackages] = find((soldPackagesList-ones(size(soldPackagesList,1),size(soldPackagesList,2)))*-1);
    setFilter = 1;
elseif isempty(soldPackagesList) == 1 && isempty(notAvailablePackagesList) == 0
    [~, stillOnSalePackages] = find((notAvailablePackagesList-ones(size(soldPackagesList,1),size(soldPackagesList,2)))*-1);
    setFilter = 1;
end
    
%display(size(stillOnSalePackages))

%trasformo returnsRiskRationOfPackages in un vettore monodimensionale:

if sum(sum(isnan(returnsRiskRatioOfPackages))) == 0 %&& isempty(minRisk) == 0 && isempty(maxRisk) == 0

    returnsRiskRatioOfPackagesArray = convert_matrix_into_array(returnsRiskRatioOfPackages,TotNrDebitPackages);

    %ordino i packagesToExplore in funzione del ratio
    %rendimento/rischio:
    [~, orderedPackages] = sort(returnsRiskRatioOfPackagesArray);
    
    
    %filtro gli elementi in orderedPackages in modo da eliminare quelli non
    %più disponibili.
    
    if setFilter == 1
        tmp = zeros(1,size(stillOnSalePackages,2));
        positionInList = 1;
        for x=1:size(orderedPackages,2)
            if isempty(stillOnSalePackages(stillOnSalePackages == orderedPackages(x))) == 0 
                tmp(positionInList) = orderedPackages(x);
                positionInList = positionInList +1;
            end
        end
    
        orderedPackages = tmp(1:positionInList-1);
    end
    
    
    tmp = convert_matrix_into_array(returnsOfPackages,TotNrDebitPackages);
    returnsOfOrderedPackages = tmp(orderedPackages);

    %----
    
    packagesRiskPropensity = calculatePackagesRiskPropensity(riskOfPackages, TotNrDebitPackages, NrRiskPropensityLevels); 

    
    firmsPermutation = randperm(NrAgents.Funds);

    for b=1:NrAgents.Banks
        %each bank determines which is the selling price for its packages
        asks = Banks_create_asks_auction2(b, asks, riskOfPackages, ...
            returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, ...
            TotNrDebitPackages,soldPackages,bidsAuction1, asksAuction1, notAvailablePackages);
    end

    for f=1:NrAgents.Funds
        %each fund creates its offers:
        bids = Funds_create_bids_auction2(firmsPermutation(f),bids, riskOfPackages, ...
            returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, ...
            NrDebitPackages_newstruct,soldPackagesList, bidsAuction1, asksAuction1, ...
            packagesRiskPropensity, orderedPackages,returnsOfOrderedPackages, TotNrDebitPackages);
    end

    %we now check which firm has been able to buy the packages

    %avremo una struttura asks che ha un numero di righe pari al numero di
    %banks e un numero di colonne pari al numero di pacchetti di ciascuna banca

    %la struttura delle bids invece sarà tridimensionale: bid(i,j,k) sarà
    %riferita alla bid del fondo in posizione i-esima in firmsPermutation in 
    %relazione al pacchetto k-esima emesso dalla j-esima bank.

    %per ogni pacchetto andiamo quindi a verificare chi ha fatto l'offerta
    %massima
    
    sp = 0; %utilizzato solo per fare il print con il numero di pacchetti venduti
    
    for b=1:NrAgents.Banks
        for p=(TotNrDebitPackages(b)-NrDebitPackages(b)+1):TotNrDebitPackages(b)
            [bestBid, bestBidder] = max(bids(b,p,:));
            
            
            if bestBid >= asks(b,p) && bestBid > 0 && asks(b,p) < inf && asks(b,p) > 0 && soldPackages(b,p) == 0 && notAvailablePackages(b,p) == 0%the transaction has to be processed
                %we have to verify if more than one firm has offered the
                %maximums
                %bid

                %firmsPermutation(bestBidder) represents now the index of the 
                %fund that has won the auction

                Banks.Liquidity(b) = Banks.Liquidity(b) + bestBid;
                Funds.data(firmsPermutation(bestBidder)).packages(b,p) = 1;
                Funds.data(firmsPermutation(bestBidder)).availableCash = ... 
                    Funds.data(firmsPermutation(bestBidder)).availableCash - ...
                    bestBid;
                
                soldPackages(b,p) = 1;
                Banks.MortgageProperty(b,:)= Banks.MortgageProperty(b,:)- Banks.Packages(b, p).composition';
                sp = sp+1;
            end 
        end
    end
end

%display(sp)
%segnalo come non più disponibili i pacchetti invenduti che verranno
%potenzialmente ricomposti diversamente alla prossima asta. 

for x=1:NrAgents.Banks
    notAvailablePackages(x,1:TotNrDebitPackages(x)) = (soldPackages(x,1:TotNrDebitPackages(x))-ones(1,TotNrDebitPackages(x)))*-1;
end

soldPackagesList = convert_matrix_into_array(soldPackages,TotNrDebitPackages);
notAvailablePackagesList = convert_matrix_into_array(notAvailablePackages,TotNrDebitPackages);

MortgageProperty_correction