%Households_housingmarket

NumTransactions = 0;
BankMortgageBlocked = 0;
HouseholdMortgageRejected = 0;

FireSale_Idx = find(Households.HousingFireSale == 1);
Households.HousingPrices = zeros(1,NrAgents.Households);
Households.HousingPrices(HousingSell_Idx) = REmarket.HousingPrice(end)*...
    (1+REmarket.const_theta*rand(1,numel(HousingSell_Idx)));

if ~isempty(FireSale_Idx) == 1
   Households.HousingPrices(FireSale_Idx) = ...
       REmarket.HousingPrice(end).*(1-REmarket.FireSalePriceReduction.*rand(1,length(FireSale_Idx)));
end
%10.9.2012 - Lines 17-22 are new
%Set Construction firm prices
CstrFirmsNrForSale = 0;
CstrFirms_Idx = find(CstrFirms.Inventories ~= 0);
for c = CstrFirms_Idx
   CstrFirms.HousingPrices{1,c} = REmarket.HousingPrice(end).*(1+REmarket.CstrFirmsPriceInterval.*rand(1,CstrFirms.Inventories(c)));
   CstrFirms.MinPrice(c) = min(CstrFirms.HousingPrices{1,c});
   CstrFirmsNrForSale = CstrFirmsNrForSale + numel(CstrFirms.HousingPrices{1,c});
   %muna að setja MinPrice = Inf ef inventories = 0
end

%Buyer only sees a portion of housing for sale
NumForSaleSeen = round(REmarket.const_q*(numel(HousingSell_Idx)+CstrFirmsNrForSale));
%Randomize buyer queue 
IdxHouseholds_buy = randperm(numel(HousingBuy_Idx));
Sellers.prices = Households.HousingPrices(HousingSell_Idx);
Sellers.class = ones(1,numel(HousingSell_Idx));
Sellers.id = HousingSell_Idx;
for c = CstrFirms_Idx
    Sellers.prices = [Sellers.prices,CstrFirms.HousingPrices{1,c}];
    Sellers.class = [Sellers.class,2*ones(1,numel(CstrFirms.HousingPrices{1,c}))];
    Sellers.id = [Sellers.id,c*ones(1,numel(CstrFirms.HousingPrices{1,c}))];
end

Sellers_Idx = 1:numel(Sellers.id);

%Buyers take turns on the market, looking for the lowest price
% fprintf('\n #buyers: %d #sellers: %d #fire sales: %d old price: %f',...
%     numel(HousingBuy_Idx),numel(Sellers_Idx),numel(FireSale_Idx),REmarket.HousingPrice(month_no-1))
% 
for h=1:numel(HousingBuy_Idx)
    %Buyer only sees a portion of housing for sale
    idx_buyer = HousingBuy_Idx(IdxHouseholds_buy(h));
    
    NumForSaleSeen = min(NumForSaleSeen,numel(Sellers_Idx));
    if NumForSaleSeen == 0
        break
    end
    PricesSeen = Sellers.prices(Sellers_Idx);
    %Buyer selects the lowest price seen
    [minPrice,idxtmp] = min(PricesSeen);
    idx_seller = Sellers_Idx(idxtmp);
    %Buyers EQ ratio and Consumption budget constraints
    BorrowingNeed = max(0,minPrice - Households.Liquidity(idx_buyer));
    
    if UseSecuritization == 1 
        %THE FOLLOWING PIECE OF CODE HAS BEEN ADDED IN ORDER TO ALLOW THE 
        %HOUSEHOLD TO DISINVEST SOME CAPITAL FROM A FUND IN ORDER TO REDUCE THE
        %AMOUNT OF MORTGAGE THAT HE/SHE HAS TO REQUEST.
        if BorrowingNeed > 0
            disinvestedMoney = 0;
            %we have to verify in which fund the household invested in:
            f = find(Households.fundsInvestments(:,idx_buyer));
            %we have to update the information related to:
            %1) Households.fundInvestments;
            %2) Households.Liquidity;
            %3) Funds.Capital;
            %4) Funds.availableCash;

            if sum(f) > 0
                moneyToTransfer = max(0, min([Households.fundsInvestments(f,idx_buyer) , BorrowingNeed, Funds.data(1,f).availableCash]));
                Households.fundsInvestments(f,idx_buyer) = Households.fundsInvestments(f,idx_buyer) - moneyToTransfer;
                Households.Liquidity = Households.Liquidity + moneyToTransfer;
                Funds.data(1,f).capital(idx_buyer) = Funds.data(1,f).capital(idx_buyer) - moneyToTransfer;
                Funds.data(1,f).availableCash = Funds.data(1,f).availableCash - moneyToTransfer; 
                disinvestedMoney = moneyToTransfer;
            end 
        end
    end
    
    Buyer_EQratio = Households.Equity(idx_buyer)/...
        (Households.TotalAssets(idx_buyer)+BorrowingNeed);
    Buyer_DeltaH = (BorrowingNeed/PriceIndices.AnnuityFactor);
    Buyer_BudgetConstraint = (Households.H(idx_buyer)+Buyer_DeltaH)/(Households.C(idx_buyer));
    
    if Buyer_EQratio > REmarket.EQratio && Buyer_BudgetConstraint < REmarket.BudgetConstraint
        %Check banks capital adequancy ratio requirements
        idLendingBank = Households.MortgageArray{1,idx_buyer}.PrimeBankId;
        
        if (Banks.Equity(idLendingBank)/(Banks.TotalAssets(idLendingBank)+BorrowingNeed) > PriceIndices.CAR)
        %Update Buyers housing amount and balance sheet
            Households.HousingAmount(idx_buyer) = Households.HousingAmount(idx_buyer) + 1;
            Households.MortgageArray{1,idx_buyer}.Amount = ...
                Households.MortgageArray{1,idx_buyer}.Amount + BorrowingNeed;
            Households.TotalMortgage(idx_buyer) = ...
                Households.TotalMortgage(idx_buyer) + BorrowingNeed;

            Households.Liquidity(idx_buyer) = Households.Liquidity(idx_buyer) - minPrice + BorrowingNeed;
            
            %update banks mortgages for buyer
            Banks.Liquidity(idLendingBank) = Banks.Liquidity(idLendingBank) - BorrowingNeed;
            Banks.MortgageArray{1,idLendingBank}.Amount = ...
                Banks.MortgageArray{1,idLendingBank}.Amount + BorrowingNeed;
            Banks.MortgageArray{1,idLendingBank}.HouseholdsId = ...
                [Banks.MortgageArray{1,idLendingBank}.HouseholdsId, idx_buyer];
            Banks.TotalMortgage(idLendingBank) = Banks.TotalMortgage(idLendingBank) + BorrowingNeed;
            
            %Must discriminate between HH and CstrF w.r.t. updating Sellers
            %balance sheets and other information
            if Sellers.class(idx_seller) == 1
            %Seller pays back mortgage to bank
            idLendingBankSeller = Households.MortgageArray{1,Sellers.id(idx_seller)}.PrimeBankId(end);
            %Update Sellers housing amount and balance sheet
            Households.HousingAmount(Sellers.id(idx_seller)) = Households.HousingAmount(Sellers.id(idx_seller)) - 1;
            MortgageValueSeller = Households.MortgageArray{1,Sellers.id(idx_seller)}.Amount(end);
            Households.MortgageArray{1,Sellers.id(idx_seller)}.Amount(end) = max(0,MortgageValueSeller-minPrice);
            Households.TotalMortgage(Sellers.id(idx_seller)) = Households.TotalMortgage(Sellers.id(idx_seller)) - min(MortgageValueSeller,minPrice);
            Households.Liquidity(Sellers.id(idx_seller)) = Households.Liquidity(Sellers.id(idx_seller)) + max(0,minPrice-MortgageValueSeller);

            %update banks mortgages for seller            
            Banks.Liquidity(idLendingBankSeller) = Banks.Liquidity(idLendingBankSeller) + min(MortgageValueSeller,minPrice);
            Banks.MortgageArray{1,idLendingBankSeller}.Amount = ...
                [Banks.MortgageArray{1,idLendingBankSeller}.Amount, -min(MortgageValueSeller,minPrice)];
            Banks.MortgageArray{1,idLendingBankSeller}.InterestRate = ...
                [Banks.MortgageArray{1,idLendingBankSeller}.InterestRate, PriceIndices.MortgageRate];
            Banks.MortgageArray{1,idLendingBankSeller}.MaturityDay = ...
                [Banks.MortgageArray{1,idLendingBankSeller}.MaturityDay, 0];
            Banks.MortgageArray{1,idLendingBankSeller}.HouseholdsId = ...
                [Banks.MortgageArray{1,idLendingBankSeller}.HouseholdsId, Sellers.id(idx_seller)];
            Banks.TotalMortgage(idLendingBankSeller) = Banks.TotalMortgage(idLendingBankSeller) - min(MortgageValueSeller,minPrice);
            Households.TimeOnMarket(Sellers.id(idx_seller)) = 0;
            
            NumTransactions = NumTransactions + 1;
            PriceTransaction(NumTransactions) = minPrice;
            Sellers_Idx = Sellers_Idx(Sellers_Idx ~= idx_seller);
            
            elseif Sellers.class(idx_seller) == 2
            CstrFirms.Revenues(Sellers.id(idx_seller)) = CstrFirms.Revenues(Sellers.id(idx_seller)) + minPrice;
            CstrFirms.Inventories(Sellers.id(idx_seller)) = CstrFirms.Inventories(Sellers.id(idx_seller)) - 1;
            NumTransactions = NumTransactions + 1;
            PriceTransaction(NumTransactions) = minPrice;
            Sellers_Idx = Sellers_Idx(Sellers_Idx ~= idx_seller);
            end
        else     
            BankMortgageBlocked = BankMortgageBlocked + 1;
        end
        
    else
        HouseholdMortgageRejected = HouseholdMortgageRejected + 1;
    end

    if isempty(Sellers_Idx) == 1
        break
    end
end
REmarket.Transactions = NumTransactions;
if NumTransactions == 0
    REmarket.HousingPrice(month_no) =  REmarket.HousingPrice(month_no-1)*0.995;
else
    REmarket.HousingPrice(month_no) = mean(PriceTransaction);
end

%fprintf(' new price: %f', REmarket.HousingPrice(month_no))

Households.HousingFireSale = zeros(1,NrAgents.Households);
clear PriceTransaction Sellers Sellers_Idx idx_seller HousingSell_Idx CstrFirms_Idx
