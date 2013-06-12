function [asks] = Banks_create_asks_auction2(b, asks, riskOfPackages, returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, NrBanksPackages, soldPackages,bidsAuction1, asksAuction1, notAvailablePackages)
    for i=1:NrBanksPackages(b)
        if sum(size(notAvailablePackages)) > 0
            if soldPackages(b,i)+notAvailablePackages(b,i) == 0
                asks(b,i) = asksAuction1(b,i) - asksAuction1(b,i)*(rand()*0.65); %/ ...
                    %min(2,max(1,sum(bidsAuction1(b,i,:) > 0)));
            else
                asks(b,i) = inf;
            end
        else
            if soldPackages(b,i) == 0
            asks(b,i) = asksAuction1(b,i) - asksAuction1(b,i)*(rand()*0.65);%/ ...
                %sum(bidsAuction1(b,i,:) > 0);
            else
                asks(b,i) = inf;
            end
        end
    end
end