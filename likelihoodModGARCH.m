function [f]=likelihoodModGARCH(x,r,dt)

nu     = x(1);
beta0  = x(2);
beta1  = x(3);
beta2  = x(4);
alpha = x(5);


v=zeros(length(r)+1,1);
v(1)=(std(r))^2/dt;

for i = 1:length(r)
    

        v(i+1)=beta0+beta1*v(i)+beta2*(1/dt)*(r(i)-alpha*dt).^2;     
 
 
end

f = sum (0.5*log(v(1:end-1))+0.5*((r-nu*dt).^2)./(v(1:end-1)*dt));