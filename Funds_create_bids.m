function [bids] = Funds_create_bids(f, bids,riskOfPackages, returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, NrBanksPackages,packagesRiskPropensity, orderedPackages,returnsOfOrderedPackages, NrDebitPackages)

    percentageOfCashInvested = 1;
    
    cashForBids = Funds.data(f).availableCash * percentageOfCashInvested;
       
%     %creo una struttura per capire a quale banca fa riferimento ogni
%     %pacchetto
%     bankOfPackages = zeros(1, sum(NrBanksPackages));
%     tmp = 1;
%     for x=1:size(NrBanksPackages,2)
%         bankOfPackages(tmp:tmp+NrBanksPackages(x)-1) = x;
%         tmp = tmp+NrBanksPackages(x);
%     end
%     bankOfPackages = bankOfPackages(orderedPackages);
%     
%     clear tmp;
    

    %bankOfPackages = NrBanksPackages(orderedPackages); 
    
    %----
    bankOfPackages = zeros(1, sum(NrDebitPackages'));
    for i=1:size(NrDebitPackages,1)
        if i==1
            bankOfPackages(1:NrDebitPackages(i)) = i;
        else
            bankOfPackages(NrDebitPackages(i-1)+1:NrDebitPackages(i-1)+NrDebitPackages(i)) = i;
        end
    end
    %---
    
    
    
    
    pkgInternalIndex = zeros(1,size(orderedPackages,2)); 
    for i=1:size(Banks.Packages,1)
        if i == 1
            pkgInternalIndex(1:NrDebitPackages(i)) = 1:NrDebitPackages(i);
        else
            pkgInternalIndex(NrDebitPackages(i-1)+1:NrDebitPackages(i-1)+NrDebitPackages(i)) = 1:NrDebitPackages(i);
        end
    end
   
    sumOfBids = 0;
    
    for x=Funds.data(f).riskPropensity:-1:1
        if cashForBids - sumOfBids == 0
            break
        end
            
        [~, packagesToExplore] = find(packagesRiskPropensity == x);
        for p=1:size(packagesToExplore,2)

            b = bankOfPackages(p);

            singleBid = returnsOfPackages(b,pkgInternalIndex(packagesToExplore(p)))*(0.9 + rand()*0.1);
            sumOfBids = sumOfBids + singleBid;

            if cashForBids - sumOfBids > 0 %if the amount of remaining cash is sufficient to create that bid:
                bids(b,pkgInternalIndex(packagesToExplore(p)),f) = singleBid;
            else
                %the bank try to create a bid for the best package that it can
                %afford.
                bestPossiblePackageWithRemainingBudget = find(returnsOfPackages(packagesToExplore) <= cashForBids - sumOfBids);

                if isempty(bestPossiblePackageWithRemainingBudget) == 0 
                    singleBid = returnsOfPackages(b,packagesToExplore(bestPossiblePackageWithRemainingBudget))*(0.9 + rand()*0.1);
                    bids(b,pkgInternalIndex(packagesToExplore(bestPossiblePackageWithRemainingBudget)),f) = singleBid;
                    break

                else
                    %if it cannot afford any other package a kind of "all in" policy is utilized (in this case the bank offers the ramaining cash
                    %on the p-th package).

                    bids(b,pkgInternalIndex(packagesToExplore(bestPossiblePackageWithRemainingBudget)),f) = cashForBids - sumOfBids;
                    break
                end
            end
        end
    end 

end