function [r, sigma2] = genScenariosLatin(nu, sigma, dt, nSamples, beta0, beta1, beta2, alpha)

%

xi = lhsnorm(zeros(31,1), eye(31), nSamples)';

% r = zeros(
% sigma2 =
for i=1:31
    r(i,:) = nu*dt + sigma.*xi(i,:)*sqrt(dt);
    sigma2(i,:) = beta0 + beta1*sigma^2 + beta2/dt*(r(i,:) - alpha*dt).^2;
end





