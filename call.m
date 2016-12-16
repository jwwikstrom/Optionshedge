function c = call(K, d_1, d_2, F, r, t, T)

c = (F*norm(d_1) - K*norm(-d_2))exp(-r*T);

end

