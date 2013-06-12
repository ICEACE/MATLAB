function [packagesRiskPropensity] = calculatePackagesRiskPropensity(riskOfPackages, TotNrDebitPackages, NrRiskPropensityLevels)


    tmp = convert_matrix_into_array(riskOfPackages,TotNrDebitPackages);
    minRisk = min(tmp);
    maxRisk = max(tmp);

    riskPropensityClusters = minRisk*ones(1,NrRiskPropensityLevels+1) + (maxRisk-minRisk)/NrRiskPropensityLevels* (0:NrRiskPropensityLevels);
    packagesRiskPropensity = zeros(1,sum(TotNrDebitPackages));

    reshapedArray = tmp;
    clear tmp

    for k=1:size(riskPropensityClusters,2)-1
        tmp = reshapedArray >= riskPropensityClusters(k) & reshapedArray <= riskPropensityClusters(k+1);
        packagesRiskPropensity = packagesRiskPropensity + (tmp*k);
    end


end