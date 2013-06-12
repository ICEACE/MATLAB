Firms.price = Firms.Markup.*Firms.ProductionUnitCosts;
Firms.price(isnan(Firms.price)) = 0;
