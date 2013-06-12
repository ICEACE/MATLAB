% In the current version borrowing requests are fullfilled if the CAR of the bank is met and
% lending banks are chosen randomly

%Create a temporary structure for Debtors (Firms and CstrFirms)
Debtors.BorrowingNeeds = [Firms.BorrowingNeeds,CstrFirms.BorrowingNeeds];
Debtors.DebtsArray = [Firms.DebtsArray,CstrFirms.DebtsArray];
Debtors.Liquidity = [Firms.Liquidity,CstrFirms.Liquidity];
Debtors.TotalDebts = [Firms.TotalDebts,CstrFirms.TotalDebts];
Debtors.id = [1:NrAgents.Firms,1:NrAgents.CstrFirms];
Debtors.class = [ones(1,NrAgents.Firms),2*ones(1,NrAgents.CstrFirms)];

for t=randperm(numel(Debtors.BorrowingNeeds))
    loan = 0;
        if (Debtors.BorrowingNeeds(t)>0)
            %idLendingBank = unidrnd(NrAgents.Banks);
            idLendingBank = Debtors.DebtsArray{1,t}.BanksId(end);
            if UseSecuritization == 1
                %ADDED IN ORDER TO CONSIDER THE CREDIT SECURITIZATION:
                sumOfSecuredCredits = calculateSecuredCredits(idLendingBank, Banks, Funds, NrAgents.Funds,NrDebitPackages,Households,NrAgents.Households);
            end
            if (Banks.Equity(idLendingBank)/(Banks.TotalAssets(idLendingBank)+Debtors.BorrowingNeeds(t)) > PriceIndices.CAR)
                loan = Debtors.BorrowingNeeds(t);
            else
                idx_banks = 1:NrAgents.Banks;
                idx_newbank = find(idx_banks ~= idLendingBank); 
                idLendingBank = randperm(length(idx_newbank)); 
                for b = 1:length(idLendingBank)
                    if UseSecuritization == 1
                        %ADDED IN ORDER TO CONSIDER THE CREDIT SECURITIZATION:
                        sumOfSecuredCredits = calculateSecuredCredits(idLendingBank(b), Banks, Funds, NrAgents.Funds,NrDebitPackages,Households,NrAgents.Households);
                    end
                    if Banks.Equity(idLendingBank(b))/(Banks.TotalAssets(idLendingBank(b))+Debtors.BorrowingNeeds(t)) > PriceIndices.CAR
                        loan = Debtors.BorrowingNeeds(t);
                        idLendingBank = idLendingBank(b);
                    end
                    if loan > 0
                        break
                    end
                end
            end
            clear b
        end
        
        if loan > 0
            % update firm's balance sheet
            Debtors.Liquidity(t) = Debtors.Liquidity(t) + loan;
            Debtors.DebtsArray{1,t}.Amount = [Debtors.DebtsArray{1,t}.Amount, loan];
            Debtors.DebtsArray{1,t}.InterestRate = [Debtors.DebtsArray{1,t}.InterestRate, PriceIndices.InterestRate];
            Debtors.DebtsArray{1,t}.MaturityDay = [Debtors.DebtsArray{1,t}.MaturityDay, d + TimeConstants.LoanDuration];
            Debtors.DebtsArray{1,t}.BanksId = [Debtors.DebtsArray{1,t}.BanksId, idLendingBank];
            Debtors.TotalDebts(t) = Debtors.TotalDebts(t) + loan;
        
            Debtors.BorrowingNeeds(t) = 0;
            
            % update bank's balance sheet
            if Debtors.class(t) == 1
                Banks.Liquidity(idLendingBank) = Banks.Liquidity(idLendingBank) - loan;
                Banks.LoansArray{1,idLendingBank}.Amount = ...
                    [Banks.LoansArray{1,idLendingBank}.Amount, loan];
                Banks.LoansArray{1,idLendingBank}.InterestRate = ...
                    [Banks.LoansArray{1,idLendingBank}.InterestRate, PriceIndices.InterestRate];
                Banks.LoansArray{1,idLendingBank}.MaturityDay = ...
                    [Banks.LoansArray{1,idLendingBank}.MaturityDay, d + TimeConstants.LoanDuration];
                Banks.LoansArray{1,idLendingBank}.FirmsId = ...
                    [Banks.LoansArray{1,idLendingBank}.FirmsId, Debtors.id(t)];
                Banks.TotalLoans(idLendingBank) = Banks.TotalLoans(idLendingBank) + loan;
            elseif Debtors.class(t) == 2
                Banks.Liquidity(idLendingBank) = Banks.Liquidity(idLendingBank) - loan;
                Banks.LoansArrayCstrF{1,idLendingBank}.Amount = ...
                    [Banks.LoansArrayCstrF{1,idLendingBank}.Amount, loan];
                Banks.LoansArrayCstrF{1,idLendingBank}.InterestRate = ...
                    [Banks.LoansArrayCstrF{1,idLendingBank}.InterestRate, PriceIndices.InterestRate];
                Banks.LoansArrayCstrF{1,idLendingBank}.MaturityDay = ...
                    [Banks.LoansArrayCstrF{1,idLendingBank}.MaturityDay, d + TimeConstants.LoanDuration];
                Banks.LoansArrayCstrF{1,idLendingBank}.CstrFirmsId = ...
                    [Banks.LoansArrayCstrF{1,idLendingBank}.CstrFirmsId, Debtors.id(t)];
                Banks.TotalLoans(idLendingBank) = Banks.TotalLoans(idLendingBank) + loan;
                
            end
            clear loan idLendingBank
        end
end

for f = 1:NrAgents.Firms
    Firms.DebtsArray(f) = Debtors.DebtsArray(f);
    Firms.Liquidity(f) = Debtors.Liquidity(f);
    Firms.TotalDebts(f) = Debtors.TotalDebts(f);
end
for c = 1:NrAgents.CstrFirms
    CstrFirms.DebtsArray(c) = Debtors.DebtsArray(c+f);
    CstrFirms.Liquidity(c) = Debtors.Liquidity(c+f);
    CstrFirms.TotalDebts(c) = Debtors.TotalDebts(c+f);
end

clear Debtors c f t
