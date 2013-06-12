%ogni banca crea i proprio pacchetti
Banks_packages_creation  

%aggiorno la struttura Funds.data.Packages in modo da essere in grado di
%ospitare i dati dei pacchetti appena creati:
for y=1:NrAgents.Funds
    if size(Funds.data(y).packages,2) < size(Banks.Packages,2)
        Funds.data(y).packages = [Funds.data(y).packages, ...
            zeros(size(Banks.Packages,1), ...
            size(Banks.Packages,2)-size(Funds.data(y).packages,2))];
    end
end

asks = zeros(NrAgents.Banks, size(Banks.Packages,2));
bids = zeros(NrAgents.Banks, size(Banks.Packages,2), NrAgents.Funds);


common_knowledge_evaluation_of_packages

%----
        
if size(soldPackages,2) < size(returnsRiskRatioOfPackages,2)
    soldPackages = [soldPackages, zeros(size(returnsRiskRatioOfPackages,1), ...
        size(returnsRiskRatioOfPackages,2)-size(soldPackages,2))]; 
    soldPackagesList = convert_matrix_into_array(soldPackages,TotNrDebitPackages);
end
%zeros(size(returnsRiskRatioOfPackages,1),size(returnsRiskRatioOfPackages,2));
if size(notAvailablePackages,2) < size(soldPackages,2)
    notAvailablePackages = [notAvailablePackages, zeros(size(soldPackages,1), ...
        size(soldPackages,2)-size(notAvailablePackages,2))]; 
    notAvailablePackagesList = convert_matrix_into_array(notAvailablePackages,TotNrDebitPackages);
end
%----

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


%----
%creo alcune strutture dati utili nel prosieguo:
%----
%ordino i pacchetti in funzione del ratio returns/risk
returnsRiskRatioOfPackagesArray = convert_matrix_into_array(returnsRiskRatioOfPackages,TotNrDebitPackages);
[~, orderedPackages] = sort(returnsRiskRatioOfPackagesArray);

%filtro gli elementi in orderedPackages in modo da eliminare quelli non
%più disponibili. (ciò va effettuato solo se non è la prima asta).

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

%calcolo il riskPropensityLevel in modo da far considerare al fondo solo i
%pacchetti concordi con la propria propensione al rischio:

%calcolo min e max rischio presenti:

if sum(sum(isnan(riskOfPackages))) == 0 

%     tmp = convert_matrix_into_array(riskOfPackages,TotNrDebitPackages);
%     minRisk = min(tmp);
%     maxRisk = max(tmp);
%     %clear tmp
    
    %if isempty(minRisk) == 0 && isempty(maxRisk) == 0

%         %riskPropensityClusters = zeros(1,NrRiskPropensityLevels+1);
%         riskPropensityClusters = minRisk*ones(1,NrRiskPropensityLevels+1) + (maxRisk-minRisk)/NrRiskPropensityLevels* (0:NrRiskPropensityLevels);
%         packagesRiskPropensity = zeros(1,sum(TotNrDebitPackages));
%         %reshapedArray = convert_matrix_into_array(returnsRiskRatioOfPackages,NrDebitPackages);
%         reshapedArray = tmp;
%         clear tmp
%         
%         
%         for k=1:size(riskPropensityClusters,2)-1
%             tmp = reshapedArray >= riskPropensityClusters(k) & reshapedArray <= riskPropensityClusters(k+1);
%             packagesRiskPropensity = packagesRiskPropensity + (tmp*k);
%         end
%         %clear reshapedArray

       
       packagesRiskPropensity = calculatePackagesRiskPropensity(riskOfPackages, TotNrDebitPackages, NrRiskPropensityLevels); 


        firmsPermutation = randperm(NrAgents.Funds);
        for b=1:NrAgents.Banks
            %each bank determines which is the selling price for its packages
            asks = Banks_create_asks(b, asks, riskOfPackages, returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, TotNrDebitPackages, soldPackages, notAvailablePackages);
        end

        for f=1:NrAgents.Funds
            %each fund creates its offers:
            bids = Funds_create_bids(firmsPermutation(f),bids, riskOfPackages, returnsOfPackages, ...
                returnsRiskRatioOfPackages, Funds, Banks, NrDebitPackages_newstruct, ...
                packagesRiskPropensity, orderedPackages,returnsOfOrderedPackages, TotNrDebitPackages);  
        end

        %we now check which firm has been able to buy the packages

        %avremo una struttura asks che ha un numero di righe pari al numero di
        %banks e un numero di colonne pari al numero di pacchetti di ciascuna banca

        %la struttura delle bids invece sarà tridimensionale: bids(i,j,k) sarà
        %riferita alla bid del fondo k-esimo in 
        %relazione al pacchetto j-esimo emesso dalla i-esima bank.

        %per ogni pacchetto andiamo quindi a verificare chi ha fatto l'offerta
        %massima
        
       
        
        sp = 0;
        for b=1:NrAgents.Banks
            for p=(TotNrDebitPackages(b)-NrDebitPackages(b)+1):TotNrDebitPackages(b)
                [bestBid, bestBidder] = max(bids(b,p,:));

                if bestBid >= asks(b,p) %the transaction has to be processed
                    %we have to verify if more than one firm has offered the maximum
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
        
        %display(sp)
        
        soldPackagesList = convert_matrix_into_array(soldPackages,TotNrDebitPackages);
    %end

end


MortgageProperty_correction
