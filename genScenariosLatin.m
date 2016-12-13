function [r] = genScenariosLatin(nu, vol, t, nSamples, beta0, beta1, beta2, alpha, dt)

%

nDays = t/dt;
xi = lhsnorm(zeros(nDays,1), eye(nDays), nSamples)';
vol = vol*ones(nDays,nSamples);
rDaily = zeros(nDays,nSamples);
r = zeros(1,nSamples);

for i = 1:nDays
    rDaily(i,:) = nu*dt + sqrt(vol(i,:)).*xi(i,:)*sqrt(dt); % Beräkna avkastning
    vol(i+1,:) = beta0 + beta1*vol(i,:) + beta2/dt*(rDaily(i,:) - alpha*dt).^2; %utifrån avkastning få en ny vol:
end

for i = 1:nSamples
   r(i) = sum(rDaily(:,i)); 
end





