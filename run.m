% test

[data,txt] = xlsread('data.xlsx', 'USDSEK');
fxHistory = data(end:-1:1,1);
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


%% Generering av scenarion


scenarios = genScenariosLatin(xOpt(1), v(end), t, nSamples, xOpt(2), xOpt(3), xOpt(4), xOpt(5), dt );

%% PCA

[evec, egd] = eig(cov(r));
