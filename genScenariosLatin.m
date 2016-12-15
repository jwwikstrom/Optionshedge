
function [r,vol, ut1] = genScenariosLatin(nu1, vol, t, nSamples, beta0, beta1, beta2, alpha, dt, r)

%


nDays = t/dt;
%vol = vol*ones(nDays,nSamples);
%rDaily = zeros(nDays,nSamples);
%rScen = zeros(1,nSamples);


[B, nu2, u, Xt]  = prinComp();
temp = [r(end-length(Xt)+1:end)'; Xt]';
C = cov(temp);
L = chol(C,'lower');

xi1 = L*lhsnorm(zeros(length(L),1), eye(length(L)), nSamples)';
xi2 = lhsnorm(zeros(1,1), eye(1), nSamples)';

u = repmat(u,1,nSamples);

ut1 = u.*exp(B*xi1(2:end,:)*sqrt(t) + sqrt(nu2)*xi2*sqrt(t));


r = nu1*t + sqrt(vol).*xi1(1,:)*sqrt(t); % Ber�kna avkastning
vol = beta0 + beta1*vol + beta2/t*(r - alpha*t).^2; %utifr�n avkastning f� en ny vol:



% for i = 1:nSamples
%    rScen(i) = sum(rDaily(:,i)); 
% end





