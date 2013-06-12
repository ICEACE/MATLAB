%Fund_initialization

%% Initialize Fund balance sheet
Fund.Liquidity = 1000;
Fund.Equity = 1000;
%% Initialize Fund Income statement
Fund.DividendsRecieved = 0;
Fund.DivedendsPaid = 0;
Fund.DividendsRetained = 0;
Fund.FirmInvestment = 0;
%% Initialize other parameters
Fund.Parameters.MinEqRatio = 0.05;