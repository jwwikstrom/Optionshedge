function K_put = strikePut( F, sigma, delta_put, T )


if delta_put>0
   delta_put = delta_put - 1; 
end
 K_put = F*exp(((sigma^2)/2)*T - norminv(1 + delta_put)*sigma*sqrt(T));
 
end

