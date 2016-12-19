function  vega  = vegaCalc( rUSD, mat, F, K, sigma )
%VEGACALC Summary of this function goes here
%   Detailed explanation goes here
vega = S*exp(-rUSD*norminv(d_1(F, K, sigma, mat))*sqrt(mat));
end

