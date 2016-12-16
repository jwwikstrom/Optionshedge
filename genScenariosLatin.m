

function [rTot,vol,u] = genScenariosLatin(nu1, vol, t, nSamples, beta0, beta1, beta2, alpha, dt, r, volsurfaces)

%
%= flipud(xlsread('data.xlsx','PCA','C4:IF845'));

nDays = t/dt;
%vol = vol*ones(nDays,nSamples);
%rDaily = zeros(nDays,nSamples);
%rScen = zeros(1,nSamples);


[B, nu2, u, Xt, V]  = prinComp(volsurfaces);
temp = [r(end-length(Xt)+1:end)'; Xt]';
C = cov(temp);
L = chol(C,'lower');
B = fliplr(B);


u = repmat(u,1,nSamples);
rTot = 0;
for i = 1:nDays;
    xi1 = L*lhsnorm(zeros(length(L),1), eye(length(L)), nSamples)';
    xi2 = lhsnorm(zeros(1,1), eye(1), nSamples)';

    u = u.*exp(sqrt(V)*B*xi1(2:end,:)*sqrt(dt) + sqrt(V)*sqrt(nu2)*xi2*sqrt(dt));
    r = nu1*dt + sqrt(vol).*xi1(1,:)*sqrt(dt); % Ber�kna avkastning
    vol = beta0 + beta1*vol + beta2/dt*(r - alpha*t).^2; %utifr�n avkastning f� en ny vol:
    rTot = rTot + r;
%     for j = 1:200
     temp = reshape(u(:,1),[17,14])';
   surf(temp);
%     end
end




% for i = 1:nSamples
%    rScen(i) = sum(rDaily(:,i)); 
% end





