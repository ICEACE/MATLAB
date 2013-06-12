credit_securitization_market_auction1

% countAlreadySoldPkg = sp1;
% for xxx=1:NrAgents.Funds
%    sp1 = sp1 + sum(sum(Funds.data(1,xxx).packages)); 
% end


if exist('stillOnSalePackages','var') ~= 0
    fprintf('\n Credit Securitization Market - Auction 1. Sold Packages: %d out of %d',sp,size(stillOnSalePackages,2))
    %fprintf('\n Credit Securitization Market - Auction 1. Available Packages: [%d, %d]',NrDebitPackages(1), NrDebitPackages(2));
else
    fprintf('\n Credit Securitization Market - Auction 1. Sold Packages: %d out of %d',sp,size(orderedPackages,2))
    %fprintf('\n Credit Securitization Market - Auction 1. Available Packages: [%d, %d]',NrDebitPackages(1), NrDebitPackages(2));
end

credit_securitization_market_auction2

% sp2  = 0;
% for xxx=1:NrAgents.Funds
%    sp2 = sp2 + sum(sum(Funds.data(1,xxx).packages)); 
% end


if exist('stillOnSalePackages','var') ~= 0
    fprintf('\n Credit Securitization Market - Auction 2. Sold Packages: %d out of %d',sp,size(stillOnSalePackages,2))
    %fprintf('\n Credit Securitization Market - Auction 2. Available Packages: [%d, %d]',NrDebitPackages(1), NrDebitPackages(2));
else
    fprintf('\n Credit Securitization Market - Auction 2. Sold Packages: %d out of %d',sp,size(stillOnSalePackages,2))
    %fprintf('\n Credit Securitization Market - Auction 2. Available Packages: [%d, %d]',NrDebitPackages(1), NrDebitPackages(2));
end