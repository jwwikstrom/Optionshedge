function p = put(K, d_1, d_2, F, rd, T)

p = (K*norm(-d_2) - F*norm(-d_1))*exp(-rd*T);

end

