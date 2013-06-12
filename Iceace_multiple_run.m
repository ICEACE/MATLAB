%clc
clear all
close all

Simulation.DurationInQuarters = 60;

BudgetConstraints_grid = [0.4];
RandomSeeds_grid = [3235400];
CapitalistProb_grid = [0.5,1];
UseIndexedMortgages_grid = [0];

SimulationRunPar.RunNumber = 3235401;

warning off

for i = 1:numel(RandomSeeds_grid)
    SimulationRunPar.RandomSeed = RandomSeeds_grid(i);
    for j = 1:numel(BudgetConstraints_grid)
        SimulationRunPar.BudgetConstraint = BudgetConstraints_grid(j);
        for k = 1:numel(CapitalistProb_grid)
            SimulationRunPar.CapitalistProb = CapitalistProb_grid(k);
            for g = 1:numel(UseIndexedMortgages_grid)
                SimulationRunPar.UseIndexedMortgages = UseIndexedMortgages_grid(g);
                SimulationRunPar.RunNumber = SimulationRunPar.RunNumber + 1;
            
                fprintf('\r run: %d RandomSeed: %d BudgetConstraint: %f CapitalistProb: %f',...
                    SimulationRunPar.RunNumber,SimulationRunPar.RandomSeed,...
                    SimulationRunPar.BudgetConstraint,SimulationRunPar.CapitalistProb)
                            
                ICEACE_initialization_multiple
                ICEACE_simulation_multiple
            
                clear Households Banks CsrtFirms Government CentralBank Firms Fund
                clear REmarket TimeConstants PriceIndices NrAgents
            end
        end
    end
end

