
for b=1:NrAgents.Banks

for y=1:NrAgents.Households
    
    
    if Banks.MortgageProperty(b,y)< 0.0001
        
       Banks.MortgageProperty(b,y)=0; 
        
        
    end
    
    
    
end



end