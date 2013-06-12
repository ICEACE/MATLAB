
% for fist market only ----------------------------------------

display(NrDebitPackages);


if exist ('FirstMarket','var') > 0
FirstMarket=2;
else
    
TotNrDebitPackages=zeros(NrAgents.Banks,1);
Banks.MortgageProperty= zeros(NrAgents.Banks, NrAgents.Households);
for t=1: NrAgents.Banks
  BanksHouseholds=[];
  BanksHouseholds=Banks.MortgageArray{1,t}.HouseholdsId;
  for f=1:NrAgents.Households
    if BanksHouseholds(f)> 0
        
        Banks.MortgageProperty(t,f)=1;
        
    end
      
      
  end

end
FirstMarket=1;
end

display(FirstMarket);

display(TotNrDebitPackages);
%---------------------------------------------------------------------


NrDebitPackages=zeros(NrAgents.Banks,1);


for t=1:NrAgents.Banks  %each bank evaluates its debt and creates packages
    
    %evaluation of the funds risk propensity
    fundsRiskProp=zeros(NrAgents.Funds,1);
    
    for f=1:NrAgents.Funds
        fundsRiskProp(f,1)= Funds.data(f).riskPropensity; 
        
    end
    
    averageRiskFundsProp= mean(fundsRiskProp);
    
    
    %evaluation of mortgages risk levels
    
    MortgagesRisk= zeros(NrAgents.Households,1);
    
    
        BanksHouseholds=[];
        BanksHouseholds=Banks.MortgageArray{1,t}.HouseholdsId;
    
    for y=1:NrAgents.Households
        

        s= BanksHouseholds(y);
        if s>0     
        
        MortgagesRisk(y)= Banks.MortgageProperty(t,y)*(Households.TotalMortgage(y))*(2-((Households.Equity(y))/(Households.TotalAssets(y))));
        
        end 
            
    end
    
    % the packages are created considering the average funds risk propensity
    % (we consider three different categories)
    
    NrDebitPackages(t)= 0;
    avgRisk=0;
    varRisk=0;
    
    avgRisk= mean(MortgagesRisk(MortgagesRisk~=0));
    varRisk= sqrt(var(MortgagesRisk(MortgagesRisk ~= 0)));
    
    
    if averageRiskFundsProp > ((NrRiskPropensityLevels+1)/2)+ (NrRiskPropensityLevels-(NrRiskPropensityLevels+1)/2)/2 % high propensity (average)
        
          target= avgRisk+varRisk;
          package1=zeros(NrAgents.Households,1);
          package2=zeros(NrAgents.Households,1);
          NrPackage1=0;
          NrPackage2=0;
            
          for y=1:NrAgents.Households
            
           if MortgagesRisk(y) ~= 0
              
            if MortgagesRisk(y)> target
                PercentMortgage1 = 0.15  + (0.40-0.15)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0;
                
                
            else
                
                PercentMortgage1 = 0.60  + (0.90-0.60)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0; 
                
                
                
            end
            
            if (mean(package1(package1 ~= 0))>= target && NrPackage1> 5)|| NrPackage1> 18 
                
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package1;
                package1=zeros(NrAgents.Households,1);
                NrPackage1=0;
                
                
            end
            
            
           if (mean(package2 (package2 ~= 0))>= target && NrPackage2> 5 ) || NrPackage2> 18
               
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
                package2=zeros(NrAgents.Households,1);
                NrPackage2=0;
                
                
            end
            

            
           
           end
           
           
            if y== NrAgents.Households && NrPackage1 ~=  0
               
              NrDebitPackages(t)= (NrDebitPackages(t))+1; 
              Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package1;
            
                 
           end
           
           
           if y== NrAgents.Households && NrPackage2  ~=  0
               
              NrDebitPackages(t)= (NrDebitPackages(t))+1;
              Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
              
           
           end
           
           
           
          end
            
        
        
        
        
    else
        
         if averageRiskFundsProp < (NrRiskPropensityLevels+1)/2 - (NrRiskPropensityLevels-(NrRiskPropensityLevels+1)/2)/2 % low propensity
            
          target= avgRisk-varRisk;
          package1=zeros(NrAgents.Households,1);
          package2=zeros(NrAgents.Households,1);
          NrPackage1=0;
          NrPackage2=0;
            
          for y=1:NrAgents.Households
              
              
           if MortgagesRisk(y) ~= 0   
                
            if MortgagesRisk(y)> target
                PercentMortgage1 = 0.15  + (0.40-0.15)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0;
                
                
            else
                
                PercentMortgage1 = 0.70  + (0.95-0.70)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0; 
                
                
                
            end
            
            if  (mean(package1(package1~=0))<= target && NrPackage1 > 5) || NrPackage1 > 18 
                
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package1;
                package1=zeros(NrAgents.Households,1);
                NrPackage1=0;
                
                
            end
            
            
           if (mean(package2(package2 ~= 0))<= target && NrPackage2> 5) || NrPackage2 > 18
               
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
                package2=zeros(NrAgents.Households,1);
                NrPackage2=0;
                
                
            end
            

           
           end
           
           if y== NrAgents.Households && NrPackage1 ~=  0
               
              NrDebitPackages(t)= (NrDebitPackages(t))+1; 
              Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package1;

                 
           end
           
           
           if y== NrAgents.Households && NrPackage2  ~=  0
           
              NrDebitPackages(t)= (NrDebitPackages(t))+1;
              Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
             
              
           end
           
           
           
            
          end
             
             
             
            
            
         else % medium propensity
             
             
          target= avgRisk;
          package1=zeros(NrAgents.Households,1);
          package2=zeros(NrAgents.Households,1);
          NrPackage1=0;
          NrPackage2=0;
            
          for y=1:NrAgents.Households
              
           if MortgagesRisk(y) ~= 0
                
            if MortgagesRisk(y)> target
                PercentMortgage1 = 0.25  + (0.40-0.25)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0;
                
                
            else
                
                PercentMortgage1 = 0.25  + (0.40-0.25)*rand();
                PercentMortgage1=(round((10^4).*PercentMortgage1)./10^4);
                PercentMortgage2= 1 - PercentMortgage1;
                package1(y)= (round((10^4).*(PercentMortgage1 * Banks.MortgageProperty(t,y)))./10^4);
                package2(y)= (round((10^4).*(PercentMortgage2 * Banks.MortgageProperty(t,y)))./10^4);
                NrPackage1= NrPackage1 +1;
                NrPackage2= NrPackage2 +1;
                PercentMortgage1=0;
                PercentMortgage2=0; 
                
                
                
            end
            
            if (mean(package1(package1 ~=0))>= target-varRisk && mean(package1)<= target+varRisk && NrPackage1> 5) || NrPackage1 > 18
                
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package1;
                package1=zeros(NrAgents.Households,1);
                NrPackage1=0;
                
                
            end
            
            
           if (mean(package2(package2 ~= 0))>= target- varRisk && mean(package2)<= target+ varRisk  && NrPackage2> 5) || NrPackage2 > 18
               
                NrDebitPackages(t)= (NrDebitPackages(t))+1;
                Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
                package2=zeros(NrAgents.Households,1);
                NrPackage2=0;
                
                
            end
            

  
            
           end
          
           
           if y== NrAgents.Households && NrPackage1 ~=  0
               
              NrDebitPackages(t)= (NrDebitPackages(t))+1;
              Banks.Packages(t,NrDebitPackages(t)+TotNrDebitPackages(t)).composition= package1;

                 
           end
           
           
           if y== NrAgents.Households && NrPackage2  ~=  0
               
              NrDebitPackages(t)= (NrDebitPackages(t))+1;
              Banks.Packages(t,NrDebitPackages(t)+ TotNrDebitPackages(t)).composition= package2;
              
           
           end
           
           
             
          end  
             
             
         end
    
    
    end
    
    
end


% TotNrDebitPackages updating
TotNrDebitPackages = TotNrDebitPackages + NrDebitPackages;


%new structure for NrDebitPackages

NrDebitPackages_newstruct=[];
NrPack=0;
p=1;
for u=1:NrAgents.Banks
   NrPack= NrDebitPackages(u);
   for q=1:NrPack
       
       NrDebitPackages_newstruct(p)= u;
       p=p+1;
       
   end
    
NrPack=0;
    
    
end


display(NrDebitPackages);
display(TotNrDebitPackages);



MortgageProperty_correction






