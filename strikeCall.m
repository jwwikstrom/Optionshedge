function K_call = strikeCall( F, sigma, delta_call, T )

 K_call = F*exp((sigma^2/2)*T - norm(delta_call)^(-1)*sigma*sqrt(T));

end

