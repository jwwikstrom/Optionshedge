function K_call = strikeCall( F, sigma, delta_call, T )

 K_call = F*exp((sigma^2/2)*T - norminv(delta_call)*sigma*sqrt(T));

end

