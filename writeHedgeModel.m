function writeHedgeModel(nSamples, assets, alpha, dt, interestRate, transactionCost, kassaIn, initHoldingPortfolio, initHoldingHedge, initPrice, priceScenarioHedge, bidPricePortfolio, askPricePortfolio, priceScenarioPortfolio)

% This file builds the treestructure for a Stochastic Programming problem
% Input data:
% interestRate                       = interest rate for one time period
% assets                             = name of assets                                             
%  nSamples;			   # The number of scenarios
%  alpha;               # Constant for transactioncosts
%  dt;                  # Time step
%  interestRate;		   # The interest rate during the period
%  transactionCost;      #  
%  kassaIn;              # Money in the bank before time step
%  initHoldingPortfolio{Assets};	   # Initial position in assets
%  initHoldingHedge{Assets}
%  initCash;			   # Initial holding of cash
%  initPrice{Assets};           # Initial asset prices
%  priceScenarioHedge{1..nSamples, Assets}; 
%  bidPricePortfolio{Assets}; 
%  askPricePortfolio{Assets}; 
%  priceScenarioPortfolio{1..nSamples, Assets};
% probability 

nAssets = length(assets);
probability = 1/nSamples;

fid = fopen('amplProblem.dat','w');

fprintf(fid,'param interestRate := %e;\n', interestRate);
fprintf(fid,'param alpha := %e;\n', alpha);

fprintf(fid,'param nSamples := %e;\n', nSamples);
fprintf(fid,'param dt := %e;\n', dt);
fprintf(fid,'param transactionCost := %e;\n', transactionCost);
fprintf(fid,'param kassaIn := %e;\n', kassaIn);

fprintf(fid,'param probability := %e;\n', probability);

fprintf(fid,'set assets = ');
for i = 1:nAssets
  fprintf(fid,'%s ', char(assets(i)));
end
fprintf(fid,'; \n');

fprintf(fid,'param initHoldingPortfolio = ');
for i = 1:nAssets
  fprintf(fid,'%s %e ', char(assets(i)), initHoldingPortfolio(i));
end
fprintf(fid,'; \n');

fprintf(fid,'param initHoldingHedge = ');
for i = 1:nAssets
  fprintf(fid,'%s %e ', char(assets(i)), initHoldingHedge(i));
end
fprintf(fid,'; \n');

fprintf(fid,'param nSamples = %e;\n', nSamples);

fprintf(fid,'param initPrice = ');
for i = 1:nAssets
  fprintf(fid,'%s %d ', char(assets(i)), 1);
end
fprintf(fid,'; \n');

fprintf(fid,'param priceScenarioHedge : ');
for i = 1:nAssets
  fprintf(fid,'%s ', char(assets(i)));
end
fprintf(fid,':=\n');
for i = 1:nSamples
  fprintf(fid,'%d ', i);
  fprintf(fid,'%e ', priceScenarioHedge(i,:));
fprintf(fid,'\n');
end
fprintf(fid,'; \n');

fprintf(fid,'param priceScenarioPortfolio : ');
for i = 1:nAssets
  fprintf(fid,'%s ', char(assets(i)));
end
fprintf(fid,':=\n');
for i = 1:nSamples
  fprintf(fid,'%d ', i);
  fprintf(fid,'%e ', priceScenarioPortfolio(i,:));
fprintf(fid,'\n');
end
fprintf(fid,'; \n');

fprintf(fid,'param askPricePortfolio : ');
for i = 1:nAssets
  fprintf(fid,'%s ', char(assets(i)));
end
fprintf(fid,':=\n');
  fprintf(fid,'%d ', i);
  fprintf(fid,'%e ', askPricePortfolio);
fprintf(fid,'\n');

fprintf(fid,'; \n');

fprintf(fid,'param bidPricePortfolio : ');
for i = 1:nAssets
  fprintf(fid,'%s ', char(assets(i)));
end
fprintf(fid,':=\n');
  fprintf(fid,'%d ', i);
  fprintf(fid,'%e ', bidPricePortfolio);
fprintf(fid,'\n');

fprintf(fid,'; \n');



fclose(fid);
