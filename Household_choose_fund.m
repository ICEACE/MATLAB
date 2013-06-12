function [chosenFund] = Household_choose_fund(hRiskPropensity, NrFunds, NrVisibleFunds, Funds)

    %% if more than one fund exists the household will have to decide which one he/she preferes
    % he/she will do that considering the previous performance of the funds
    % available to him.

    if NrFunds > 1

        % the funds that are visible to the considered household are:

        visibleFunds = randperm(NrFunds);
        visibleFunds = visibleFunds(1:NrVisibleFunds);

        %the household "h" will choose among the funds included in the
        %"visibleFunds" array.

        for i=1:length(visibleFunds)
            fundsRiskPropensityArray = Funds.data.riskPropensity;
        end

        perfectFunds = find(fundsRiskPropensityArray == hRiskPropensity);
        %PerfectFunds contains the IDs of the funds that have the same
        %riskPropensity of the considered household. The underlying idea is
        %that if at least one fund with the same riskPropensity is available to
        %the user then 

        if length(perfectFunds) == 1

            %the household has already determined in which fund he/she will
            %invest

            chosenFund = perfectFunds(1);

        elseif isempty(perfectFunds) == 1

            %in this case a different policy has to be defined:
            %it could be - for example - a random choice.

            chosenFund = visibleFunds(round(1+rand()*(length(visibleFunds)-1)));

        else %if more than 1 visible fund present the risk propensity level of the considered household

            %hp: in this case a random decision is taken.
            %(so the household will randomly choose one of the funds among
            %those that present his/her risk propensity level
            chosenFund = perfectFunds(round((1+rand())*(length(perfectFunds)-1)));
            
            %------------------------------------------------------------------------
            % UNCOMMENT THIS BLOCK OF CODE IF TRACKING THE PERFOMANCE
            % OF THE FUNDS ON WHICH THE HOUSEHOLDS WILL BASE THEIR DECISION.
            %perfectFundsPerformance = zeros(1, length(perfectFunds));
            %for j=1:length(perfectFunds)   
            %   perfectFundsPerformance(j) = Funds.performance(perfectFunds(j));
            %end
            % 
            %[~, bestPerformerPos] = max(perfectFundsPerfomance);
            % 
            %chosenFund = perfectFunds(bestPerformerPos);
            %------------------------------------------------------------------------
        end
    else
    %% if there's just one fund the household (that has already decided to invest his/her money) will just enter it.
        chosenFund = 1;
        
    end 