function K_call = strike( F, sigma, delta_call, T )

if delta_call<0
   delta_call = 1 + delta_call; 
end

 K_call = F*exp((sigma^2/2)*T - norminv(delta_call)*sigma*sqrt(T));

end

