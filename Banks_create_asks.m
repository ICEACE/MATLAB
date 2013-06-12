function [asks] = Banks_create_asks(b, asks, riskOfPackages, returnsOfPackages, returnsRiskRatioOfPackages, Funds, Banks, NrBanksPackages, soldPackages, notAvailablePackages)
    for i=1:NrBanksPackages(b)
        if sum(size(soldPackages)) > 0
            if soldPackages(b,i)+notAvailablePackages(b,i) == 0
                asks(b,i) = returnsOfPackages(b,i)*(0.8 + rand()*0.2);
            else
                asks(b,i) = inf;
            end
        else
           asks(b,i) = returnsOfPackages(b,i)*(0.8 + rand()*0.2);
        end
    end
end