function c = call(K, d_1, d_2, F, rd, T)

c = (F*norm(d_1) - K*norm(-d_2))*exp(-rd*T);

end

