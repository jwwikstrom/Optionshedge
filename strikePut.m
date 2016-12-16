function K_put = strikePut( F, sigma, delta_put, T )

 K_put = F*exp((sigma^2/2)*T - norm(1 + delta_put)^(-1)*sigma*sqrt(T));
 
end

