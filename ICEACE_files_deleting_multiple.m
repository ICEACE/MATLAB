

for RunNumber=1021:1023
    
    if isunix
        Pat = '../../runs/';
    else
        Pat = '..\..\runs\';
    end
    
    SimulationStartingDay = 60;
    SimulationDurationInQuarters = 40;
    
    SimulationDay_final = SimulationStartingDay + SimulationDurationInQuarters*3*20;
    
    fprintf('\r Deleting RunNumber: %d',RunNumber)
    
    ii = 0;
    quarter = 0;
    for d = (SimulationStartingDay+1):(SimulationDay_final-1)
        
        Filename = ['ICEACE_run', num2str(RunNumber), '_day', num2str(d), '.mat'];
        delete([Pat, Filename])
    end
  
    
end