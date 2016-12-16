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



[rScenarios, volScenarios,uScenarios] = genScenariosLatin(xOpt(1), v(end), t, nSamples, xOpt(2), xOpt(3), xOpt(4), xOpt(5), dt,r, volsurfaces );


%% Prissättning av optioner samt portfölj 
% Har försökt få ut lite priser på optioner, men blir lite orimliga tal...
testDelta = 0.45;
testT = 5/252;
testVol = volsurfaces(1,10)/100;
rSWE = swe(end);
rUSD = usd(end);
sTest = data(end,2);
%Ftest = forwardPrice(sTest,rSWE, rUSD, 0,testT);
%testStrikeCall = strikeCall(Ftest, testVol, testDelta, testT);

maturityT = [5; 10; 15; 20; 30; 40; 60; 80; 100; 120; 180; 252; 378; 504]/252;
optionsDelta = [ -10 -15 -20 -25 -30 -35 -40 -45 50 45 40 35 30 25 20 15 10]'/100; % ATM räknas alltid som CALL 
testData = reshape(volsurfaces(end,:),[17,14])/100;

for i = 1:length(maturityT)
Ftest(i,1) = forwardPrice(sTest,rSWE,rUSD, 0, maturityT(i,1));    
end


for i = 1:size(testData,2)    
    
    for j = 1:size(testData,1)
       if optionsDelta(j) <0 
       testStrikePut(j,i) =  strikePut(Ftest(i), testData(j,i), optionsDelta(j), maturityT(i));
       else
       testStrikeCall(j,i) =  strikeCall(Ftest(i), testData(j,i), optionsDelta(j), maturityT(i));
       end 
    end
end


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

