
%per ogni pacchetto emesso:

%stimiamo il tasso di sconto:

sumOfinterestRates = 0;
for i=1:NrAgents.Households
    sumOfinterestRates = sumOfinterestRates + Households.MortgageArray{i}.InterestRate;
end

r = sumOfinterestRates/(sum(Households.TotalMortgage > 0));

%calcoliamo il valore attuale della rendita che quel pacchetto può produrre per un fondo o per la banca stessa:


%2) calcoliamo il valore attuale dei ritorni di tutti i mutui

%yieldFactor = zeros(1, NrAgents.Households);
expectedRevenuesFromMortgages = zeros(1,NrAgents.Households);
sumOfRemainingDuration = 0;
mortgageDurationList = zeros(1, NrAgents.Households);

for m=1:NrAgents.Households
    if Households.TotalMortgage(m) > 0 && Households.MortgageArray{m}.MaturityDay > d
        yieldFactor = 1/r - 1/(r*((1+r)^((Households.MortgageArray{m}.MaturityDay-d)/TimeConstants.NrDaysInYear)));
        expectedRevenuesFromMortgages(m) = Households.HousingPayment(m)*yieldFactor;
        sumOfRemainingDuration = sumOfRemainingDuration + (Households.MortgageArray{m}.MaturityDay-d);
        mortgageDurationList(m) = Households.MortgageArray{m}.MaturityDay-d;
    end
end

avgRemainingDuration = sumOfRemainingDuration/(sum(Households.TotalMortgage > 0 & Households.MortgageArray{m}.MaturityDay > d));


%3) note le composizioni calcoliamo quelli dei pacchetti:

returnsOfPackages = zeros(NrAgents.Banks,size(Banks.Packages,2));

for b=1:NrAgents.Banks
    tmp = zeros(size(Banks.Packages,2),NrAgents.Households);
    for p=1:TotNrDebitPackages(b)
        if isempty(Banks.Packages(b,p).composition) == 0
            tmp(p,:) = Banks.Packages(b,p).composition'; 
        else
            TotNrDebitPackages(b) = TotNrDebitPackages(b)-1;
        end
    end
    
    returnsOfPackages(b,:) = expectedRevenuesFromMortgages * tmp';
end


%passiamo al calcolo del rischio: questo verrà stimato sulla base del
%rapporto Equity/TotalAssets del singolo household. Per ottenere misure
%relative ai pacchetti si passerà alla media pesata dei rischi ove i pesi
%per calcolarla saranno dati dai ritorni attesi delle singole porzioni di
%mutui.
%il rischio viene poi amplificato dalla maggiore durata e ridotto dalla 
%minore durata del mutuo:

mortgageDurationRiskFactor = mortgageDurationList * (1/avgRemainingDuration);

equityAssetsRatio = zeros(1,NrAgents.Households);
mortgageRiskRating = zeros(1,NrAgents.Households);
mortgageReturnsRiskRatio = zeros(1,NrAgents.Households);

for x = 1:NrAgents.Households
    equityAssetsRatio(x) = Households.Equity(x)/Households.TotalAssets(x);
    mortgageRiskRating(x) = equityAssetsRatio(x)/mortgageDurationRiskFactor(x);
    
    %calcolato il rischio in primis calcoliamo il rapporto rendimento/rischio
    %per ogni mutuo e successivamente quella dei pacchetti sulla base della
    %composizione di questi ultimi.

    mortgageReturnsRiskRatio(x) = expectedRevenuesFromMortgages(x)/mortgageRiskRating(x);
end 


%calcolo il rischio dei singoli pacchetti e il rapporto rendimento/rischio
riskOfPackages = zeros(NrAgents.Banks,size(Banks.Packages,2));
returnsRiskRatioOfPackages = zeros(NrAgents.Banks,size(Banks.Packages,2));
for b=1:NrAgents.Banks
    tmp = zeros(size(Banks.Packages,2),NrAgents.Households);
    for p=1:TotNrDebitPackages(b)
        if isempty(Banks.Packages(b,p).composition) == 0
            tmp(p,:) = Banks.Packages(b,p).composition'; 
        else
            TotNrDebitPackages(b) = TotNrDebitPackages(b)-1;
        end
    end
    
    tmp( tmp == inf) = 0;
    mortgageRiskRating( mortgageRiskRating == inf) = 0;
    
    riskOfPackages(b,:) = mortgageRiskRating * tmp';
    returnsRiskRatioOfPackages(b,:) = mortgageReturnsRiskRatio * tmp';
end

% tmp = chop(tmp,4); 
% tmp2 = tmp;
% for q=1:NrAgents.Households
%    tmp(:,q) = tmp(:,q)* 1000*mortgageRiskRating(q);
%    tmp2(:,q) = tmp2(:,q)*1000* mortgageReturnsRiskRatio(q);
% end
% riskOfPackages = (sum(tmp'))' *(1/1000);
% returnsRiskRatioOfPackages = (sum(tmp2'))' * (1/1000);

%abbiamo quindi riskOfPackages, returnsOfPackages e
%returnsRiskRatioOfPackages contenenti i dati che ci interessano per il
%prosieguo (e che verranno scelti dai singoli fondi per scegliere su quali
%pacchetti fare le offerte).

% %calcoliamo ora un prezzo base che verrà utilizzato dai singoli
% %fondi/banche per asks e bids:
% 
% %il prezzo base è pari al ritorno scontato del pacchetto ridotto in
% %funzione del rischio di quest'ultimo rispetto alla media di quelli
% %venduti.
% 
% basePriceOfPackages = returnsOfPackages - 




