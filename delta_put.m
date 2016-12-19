function delta_put = delta_put(d1, rUSD, T)

delta_put = exp(-rUSD*T)*(norm(d1)-1);

end

