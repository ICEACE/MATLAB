
%% Funds.data contains all the relevant information of the funds
for f=1:NrAgents.Funds
    Funds.data(f) = struct('capital', zeros(1, NrAgents.Households), 'packages', [], 'availableCash', 0, 'earnings', 0, 'riskPropensity', round(1+rand()*(NrRiskPropensityLevels-1)));
end

%% Funds.performance is an array that contains the average yearly return obtained by the funds during the simulation.
% this measure will be used by the households in order to determine in
% which fund to invest their money.

Funds.performance = zeros(1,NrAgents.Funds);



%% The information related to the packages are added to the agents "banks" as well.
%Banks.Packages(1:NrAgents.Banks) = struct('percentage', [] , 'mortgage', [] ); %OLD VERSION

%----
%USE THE FOLLOWING STATEMENT WHEN YOU CREATE A NEW PACKAGE
%----
Banks.Packages(1:NrAgents.Banks,1) = struct('composition', zeros(1,NrAgents.Households));
%----


%% The information regarding the investments of the households in the funds are added to the agents "households".
Households.fundsInvestments = zeros(NrAgents.Funds,NrAgents.Households);

%%let's create another structure that will be used for the credit
%%securitization market:
soldPackages = [];
soldPackagesList = [];
notAvailablePackages = [];
notAvailablePackagesList = [];



sp1  = 0; % serve solo per tener conto di quanti pacchetti vengono venduti nelle varie aste
sp2  = 0;