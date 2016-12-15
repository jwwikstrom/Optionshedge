problem OptionPricing;

set assets;			   # The set containing all assets

param nSamples;			   # The number of scenarios
param alpha;               # Constant for transactioncosts
param dt;                  # Time step
param interestRate;		   # The interest rate during the period
param transactionCost;      #  
param kassaIn;              # Money in the bank before time step

param initHoldingPortfolio{Assets};	   # Initial position in assets
param initHoldingHedge{Assets}


param initPrice{Assets};           # Initial asset prices

param priceScenarioHedge{1..nSamples, Assets}; 
param bidPricePortfolio{Assets}; 
param askPricePortfolio{Assets}; 
param priceScenarioPortfolio{1..nSamples, Assets};

param probability;         # Scenario probabilities

var xBuy{Assets};                       # Buy decisions
var xSell{Assets};                      # Sell decisions
var TC;                                 # Total transactioncosts
var W{nSamples};                        # Wealth for each scenario
var kassaUt;                            # Money in the bank after time step


minimize f: 1/(nSamples-1)*sum{i in nSamples}( (W[i] - 1/nSamples*sum{j in nSamples}(W[j]))*(W[i] - 1/nSamples*sum{j in nSamples}(W[j]))) + alpha*TC*TC;

subject to wealthConstrain {i in 1..nSamples}   : W[i+1] = kassaUt*exp(interestRate*dt) + (xBuy - xSell)*priceHedge[i] + initHoldingPortfolio*priceScenarioPortfolio[i] + initHoldingHedge*priceScenarioHedge[i];
subject to kassafloede : kassaUt = kassaIn*exp(interestRate*dt) - xBuy*askpriceportfolio + xSell*bidpriceportfolio;
subject to totalTranscost : TC = xBuy*(1/2*(bidPricePortfolio + askpriceportfolio)*transactioncost) + xSell*(1/2*(bidpriceportfolio + askpriceportfolio)*transactioncost);
    