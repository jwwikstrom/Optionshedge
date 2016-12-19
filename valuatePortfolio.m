function [ prices ] = pricesPortfolio( optionPortfolio, volSurface, TPortfolio, kPortfolio, r, optionsDelta, s, rSWE, rUSD, maturityT )


value = 0;

for i = 1:size(r,2)
    temp = reshape(volSurface(:,i),[17,14])./100;
    
    for j = 1:size(temp,2)
        for k = 1:size(temp,1)
            if optionsDelta(k)<0
                kSurface(k,j) = strike(forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), temp(k,j), optionsDelta(k), maturityT(j));
            else
                kSurface(k,j) = strike(forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), temp(k,j), optionsDelta(k), maturityT(j));
            end
        end
    end
    
    for j = 1:size(kPortfolio,2)
        for k = 1:size(kPortfolio,1)
            temp2 = interp2(optionsDelta, maturityT, kSurface', optionsDelta, TPortfolio(j));
            fDelta = interp1(temp2,optionsDelta,kPortfolio(k,j));
            vol = interp2(optionsDelta, maturityT, temp', fDelta, TPortfolio(j));
            if k<8
                d1 = d_1(forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), kPortfolio(k,j), vol , TPortfolio(j));
                prices(k,j,i) = put(kPortfolio(k,j), d1, d_2(d1, vol, TPortfolio(j)), forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), r(i), TPortfolio(j));
            else
                d1 = d_1(forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), kPortfolio(k,j), vol , TPortfolio(j));
                prices(k,j,i) = call(kPortfolio(k,j), d1, d_2(d1, vol, TPortfolio(j)), forwardPrice(s,rSWE,rUSD, 0, maturityT(j,1)), r(i), TPortfolio(j));
            end
            
        end
    end
    
    
    
end



end

