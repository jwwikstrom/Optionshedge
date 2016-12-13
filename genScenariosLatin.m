function [r, sigma2] = genScenariosLatin(nu, sigma, dt, nSamples, beta0, beta1, beta2, alpha)
function [r] = genScenariosLatin(nu, vol, t, nSamples, beta0, beta1, beta2, alpha, dt)

%

xi = lhsnorm(zeros(31,1), eye(31), nSamples)';
nDays = t/dt;
xi = lhsnorm(zeros(nDays,1), eye(nDays), nSamples)';
vol = vol*ones(nDays,nSamples);
rDaily = zeros(nDays,nSamples);
r = zeros(1,nSamples);

% r = zeros(
% sigma2 =
for i=1:31
    r(i,:) = nu*dt + sigma.*xi(i,:)*sqrt(dt);
    sigma2(i,:) = beta0 + beta1*sigma^2 + beta2/dt*(r(i,:) - alpha*dt).^2;
for i = 1:nDays
    rDaily(i,:) = nu*dt + sqrt(vol(i,:)).*xi(i,:)*sqrt(dt); % Ber�kna avkastning
    vol(i+1,:) = beta0 + beta1*vol(i,:) + beta2/dt*(rDaily(i,:) - alpha*dt).^2; %utifr�n avkastning f� en ny vol:
end
for i = 1:nSamples
   r(i) = sum(rDaily(:,i)); 
end





