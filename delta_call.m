function [ output_args ] = delta_call(rUSD, d_1, T)


delta_call = exp(-rUSD*T)*norm(d_1);

end

