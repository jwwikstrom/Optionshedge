% test

[data,txt] = xlsread('data.xlsx', 'USDSEK');
volsurfaces= flipud(xlsread('data.xlsx','PCA','C4:IF845'));
swe = xlsread('data.xlsx', 'Rates', 'B2:B5138')/100;
usd = xlsread('data.xlsx', 'Rates', 'C2:C5138')/100;
fxHistory = data(:,1);
dates = datenum(txt(end:-1:2,1));

t = 1/12;
nSamples = 200;
nDays = 252;
dt=1/252;
r = log(fxHistory(2:end-nDays)./fxHistory(1:end-1-nDays));

optionvec=optimset('MaxFunEvals',2000,'Display','iter','TolX',1e-12,'TolFun',1e-7,'Algorithm','interior-point');
% x = [ nu    beta0   beta1  beta2   alpha0   alpha1]
x0  = [ 0 ; 0.001 ; 0.90 ; 0.05 ;  0.1   ]; %Initial solution
lb  = [ 0 ; 0     ; 0    ; 0    ; -Inf   ];
ub  = [ 0 ; Inf   ; 1    ; 1    ;  Inf   ];
A   = [ 0     0       1      1       0     ];
b   = [1];

% Solve min  f(x)
%       s.t. Ax <= b
%            lb <= x <= ub
[xOpt,fval,exitflag,output,lambda,grad,hessian] = fmincon(@(x) likelihoodModGARCH(x,r,dt),x0,A,b,[],[],lb,ub,[],optionvec);

xOpt

%% test för fördelning

v=zeros(length(r)+1,1);
v(1)=(std(r))^2/dt;

for i = 1:length(r)  
     v(i+1)=xOpt(2)+xOpt(3)*v(i)+xOpt(4)*(1/dt)*(r(i)-xOpt(5)*dt).^2;     
end

xi = (r-xOpt(1)*dt)./sqrt(v(1:end-1)*(dt));
figure(4);
qqplot(xi);
title('QQ plot of GARCH(1,1) returns'); 

rs = (r-mean(r))/std(r);

figure(3);
qqplot(rs); 
title('QQ plot of standardized logarithmic returns'); 


%% Generering av scenarion



%[rScenarios, volScenarios,uScenarios] = genScenariosLatin(xOpt(1), v(end), t, nSamples, xOpt(2), xOpt(3), xOpt(4), xOpt(5), dt,xi, volsurfaces );


%% Prissättning av optioner samt portfölj 
% Har försökt få ut lite priser på optioner, men blir lite orimliga tal...
testDelta = 0.45;
testT = 5/252;
testVol = volsurfaces(1,10)/100;
rSWE = swe(end);
rUSD = usd(end);
s = data(end,1);
Data = reshape(volsurfaces(end,:),[17,14])/100;
%Ftest = forwardPrice(sTest,rSWE, rUSD, 0,testT);


maturityT = [5; 10; 15; 20; 30; 40; 60; 80; 100; 120; 180; 252; 378; 504]/252;
optionsDelta = [ 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 ]'/100; % ATM räknas alltid som CALL 
                   %-10% -15% -20% -25% -30% -35% -40% -45%
                   %252
                   %378
                   %504
TOption = [252 378 504]/252;
kPortfolio = zeros(floor(size(Data,1)/2),3);
optionPortfolio = ones(floor(size(Data,1)/2),3);
                %-10% -15% -20% -25% -30% -35% -40% -45% 50% 45% 40% 35% 30% 25% 20% 15% 10%
                %30; 
                %40 
                %60
                %80
                %100 
                %120 
                %180
THedge = [30 40 60 80 100 120 180]/252;
hedgePortfolio = zeros(size(Data,1), 7); 
kHedge = zeros(size(Data,1), 7); 
initPortfolioValue = 0;



for t =1:30
for i = 1:length(maturityT)
    F(i,1) = forwardPrice(s,rSWE,rUSD, 0, maturityT(i,1));    
end


%K for options
for i = 1:size(optionPortfolio,2)
    for j = 1:size(optionPortfolio,1)
            kPortfolio(j,i) =  strike(forwardPrice(s,rSWE,rUSD, 0, TOption(i)), Data(j,i), optionsDelta(j), maturityT(i));
            testd1(j,i)= d_1(F(i,1),kPortfolio(j,i),Data(j,i), maturityT(i));
            testd2(j,i) = d_2(testd1(j,i),Data(j,i),maturityT(i));
            initPortfolioValue = initPortfolioValue + put(kPortfolio(j,i), testd1(j,i), testd2(j,i), F(i,1),  rSWE, maturityT(i));
      
    end    
end
%K for hedge
for i = 1:size(hedgePortfolio,2)
    for j = 1:size(hedgePortfolio,1)
            kHedge(j,i) =  strike(forwardPrice(s,rSWE,rUSD, 0, THedge(i)), Data(j,i+4), optionsDelta(j), maturityT(i));
%             testd1(j,i)= d_1(F(i,1),kHedge(j,i),Data(j,i), maturityT(i));
%             testd2(j,i) = d_2(testd1(j,i),Data(j,i),maturityT(i));
%             initPortfolioValue = initPortfolioValue + put(kHedge(j,i), testd1(j,i), testd2(j,i), F(i,1),  rSWE, maturityT(i));
      
    end    
end

%kPortfolio = kPortfolio(1:8,1:end); % gör om kPortfolio till 8x3, var 24x3 innan!/abbas

kassa = -initPortfolioValue + 1;


[rScenarios, volScenarios, uScenarios] = genScenariosLatin(xOpt(1), v(end), t, nSamples, xOpt(2), xOpt(3), xOpt(4), xOpt(5), dt,xi, volsurfaces );



optionPrices = valuatePortfolio( optionPortfolio, uScenarios, TOption, kPortfolio , exp(rScenarios)*s, optionsDelta, s,rSWE,rUSD, maturityT);
hedgePrices = valuatePortfolio( hedgePortfolio, uScenarios, THedge, kHedge , exp(rScenarios)*s, optionsDelta, s,rSWE,rUSD, maturityT);


volla = reshape(volsurfaces(end-253+t,:),[17,14])/100;

bidPricePortfolio =  ;


for i = 1:size(hedgePortfolio,2)
    for j = 1:size(hedgePortfolio,1)
        
        pd1(j,i)= d_1(F(i,1),kPortfolio(j,i),volla(j,i+1), maturityT(i));
        pd2(j,i) = d_2(pd1(j,i),volla(j,i+1),maturityT(i));
        
        call(kHedge, pd1, pd2, F(i,1), rSWE, maturityT(i))
        put(kHedge, pd1, pd2, F(i,1), rSWE, maturityT(i))
        
    end
end
askPricePortfolio = bidPricePortfolio;
writeHedgeModel(nSamples, assets, alpha, dt, interestrate, transactionCost, kassa, optionPortfolio, hedgePortfolio, optionPrices, hedgePrices, bidPricePortfolio, askPricePortfolio, priceScenarioPortfolio) 
end
%%testköret
% for i = 1:size(Data,2)
%     
%     for j = 1:size(Data,1)
%         
%             testStrike(j,i) =  strikePut(Ftest(i), Data(j,i), optionsDelta(j), maturityT(i));
%             testd1(j,i)=d_1(Ftest(i,1),testStrike(j,i),Data(j,i), maturityT(i));
%             testd2(j,i) = d_2(testd1(j,i),Data(j,i),maturityT(i));
%             testPricePut(j,i) = put(testStrike(j,i), testd1(j,i), testd2(j,i), Ftest(i,1),  rSWE, maturityT(i));
% 
%             testStrike(j,i) =  strikeCall(Ftest(i), Data(j,i), optionsDelta(j), maturityT(i));
%             testd1(j,i)= d_1(Ftest(i,1),testStrike(j,i),Data(j,i), maturityT(i));
%             testd2(j,i) = d_2(testd1(j,i),Data(j,i),maturityT(i));
%             testPriceCall(j,i) = call(testStrike(j,i), testd1(j,i), testd2(j,i), Ftest(i,1),  rSWE, maturityT(i));
%     end
% end

% for i = 1 : size(testData,2)
%     for j = i:size(testData,1)
%         testd1(j,i)=d_1(Ftest(i,1),testStrike(j,i),testData(j,i), maturityT(i));
%         testd2(j,i) = d_2(testd1(j,i),testData(j,i),maturityT(i));
%         testPut(j,i) = put(testStrike(j,i), testd1(j,i), testd2(j,i), Ftest(j,1), rUSD, rSWE, maturityT(i));
%     end
% end

%testPut = put(testStrikePut, d_1, d_2, F, rUSD, rSWE, maturityT(i);

%% PCA

[evec, egd] = eig(cov(r));

%% Write to dat
%test
nSamples = 2;
assets = {'sca', 'seb'};
alpha = 1;
dt = 1;
interestRate = 0.01;
transactionCost = 0.01;
kassaIn = 100;
initHoldingPortfolio = [10,10];
initHoldingHedge = [1,2];
initPrice = [1,2];
priceScenarioHedge = [2,3;3,3];
bidPricePortfolio = [1,3];
askPricePortfolio = [1,3];
priceScenarioPortfolio = [3,1;3,3];
%slut test


writeHedgeModel(nSamples, assets, alpha, dt, interestRate, transactionCost, kassaIn, initHoldingPortfolio, initHoldingHedge, initPrice, priceScenarioHedge, bidPricePortfolio, askPricePortfolio, priceScenarioPortfolio);

%% Delta Hedge


% Delta_Put in our portfolio for each option
for i = 1:size(optionPortfolio,2)
    for j = 1:size(optionPortfolio,1)
        delta_Portfolio_put(j,i) = delta_put(d_1(F, kPortfolio(j,i), testVol, TOption(i)), rUSD, TOption(i)); 
        % Osäker på T eller TOption, testVol? Vill väl ha volatiltiet för
        % tidpunkt för resp option med avseende på underliggande
        % Får inf pga 0 i kportfolio, vill summera alla så vi får en skalär
        % för delta 
    end
end

delta_PortfolioPutValue = 0;

for i = 1:size(optionPortfolio,2)
    for j = 1:size(optionPortfolio,1)
        delta_PortfolioPutValue = delta_PortfolioPutValue + delta_Portfolio_put(j,i); % Måste ta hänsyn till vikt?
    end
end
        
% Call options to hedge, reach deltazero portfolio
















% if delta_PortfolioPutValue < 0
%     delta_PortfolioCallValue = -delta_PortfolioPutValue;
% end
% 
% if delta_PortfolioPutValue > 0
%     delta_PortfolioCallValue = -delta_PortfolioPutValue;
% end
%     
% Delta_hedge = delta_PortfolioPutValue + delta_PortfolioCallValue;







