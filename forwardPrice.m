%function [ output_args ] = forwardRates( input_args )

function F = forwardPrice(S,r,rf,t,T)
F = S*exp((r-rf)*(T-t));
end 





% 
% %   Detailed explanation goes here
% 
% %% Data
% swe = xlsread('data.xlsx', 'Rates', 'B2:B5138')/100;
% usd = xlsread('data.xlsx', 'Rates', 'C2:C5138')/100;
% usdsekPrice = xlsread('data.xlsx', 'USDSEK', 'B2:B5138');
% 
% %% Forward Pris
% T = [7; 14; 21; 30; 42; 60; 90; 120; 150; 180; 270; 365; 540; 720];
% t = []
% for i = 1:length(T)
%     for t = 1:length(swe)-T
%         F(t) = (usdsekPrice(t)*exp((swe(t+T) - usd(t+T))*(T-t)/252))';
%     end
% end
% 
% %--------------------------------------------------------------------------
% T_2W = 14;
% for t = 1:length(swe)-T_2W
%   F_2W(t) = (usdsekPrice(t+T_2W)*exp((swe(t+T_2W) - usd(t+T_2W))*(T_2W-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_3W = 21;
% for t = 1:length(swe)-T_3W
%    F_3W(t) = (usdsekPrice(t+T_3W)*exp((swe(t+T_3W) - usd(t+T_3W))*(T_3W-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_1M = 30
% for t = 1:length(swe)-T_1M
%    F_1M(t) = (usdsekPrice(t+T_1M)*exp((swe(t+T_1M) - usd(t+T_1M))*(T_1M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_6W = 42
% for t = 1:length(swe)-T_6W
%      F_6W(t) = (usdsekPrice(t+T_6W)*exp((swe(t+T_6W) - usd(t+T_6W))*(T_6W-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_2M = 60
% for t = 1:length(swe)-T_2M
%      F_2M(t) = (usdsekPrice(t+T_2M)*exp((swe(t+T_2M) - usd(t+T_2M))*(T_2M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_3M = 90
% for t = 1:length(swe)-T_3M
%      F_3M(t) = (usdsekPrice(t+T_3M)*exp((swe(t+T_3M) - usd(t+T_3M))*(T_3M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_4M = 120
% for t = 1:length(swe)-T_4M
%      F_4M(t) = (usdsekPrice(t+T_4M)*exp((swe(t+T_4M) - usd(t+T_4M))*(T_4M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_5M = 150
% for t = 1:length(swe)-T_5M
%      F_5M(t) = (usdsekPrice(t+T_5M)*exp((swe(t+T_5M) - usd(t+T_5M))*(T_5M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_6M = 180
% for t = 1:length(swe)-T_6M
%      F_6M(t) = (usdsekPrice(t+T_6M)*exp((swe(t+T_6M) - usd(t+T_6M))*(T_6M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_9M = 270
% for t = 1:length(swe)-T_9M
%      F_9M(t) = (usdsekPrice(t+T_9M)*exp((swe(t+T_9M) - usd(t+T_9M))*(T_9M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_12M = 365
% for t = 1:length(swe)-T_12M
%      F_12M(t) =( usdsekPrice(t+T_12M)*exp((swe(t+T_12M) - usd(t+T_12M))*(T_12M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_18M = 540
% for t = 1:length(swe)-T_18M
%      F_18M(t) =( usdsekPrice(t+T_18M)*exp((swe(t+T_18M) - usd(t+T_18M))*(T_18M-t)/252))';
% end
% %--------------------------------------------------------------------------
% T_24M = 720
% for t = 1:length(swe)-T_24M
%      F_24M(t) = (usdsekPrice(t+T_24M)*exp((swe(t+T_24M) - usd(t+T_24M))*(T_24M-t)/252))';
% end
% 
% %% Call & Put
% F = [F_1W(1,1:4414); F_2W(1,1:4414); F_3W(1,1:4414); F_1M(1,1:4414); F_6W(1,1:4414);
%     F_2M(1,1:4414); F_3M(1,1:4414); F_4M(1,1:4414); F_5M(1,1:4414); F_6M(1,1:4414);
%     F_9M(1,1:4414); F_12M(1,1:4414); F_18M(1,1:4414); F_24M(1,1:4414)];
% F = F';
% sigma=1;
% for i = 1:size(F,1)
%     for j = 1:size(F,2)
%     d_1(i,j) = (log(F(i,j))+((sigma^2)/2)*(T-t))/(sigma*sqrt(T-t));
%     d_2(i,j) = d_1(i,j) - (sigma*sqrt(T-t));
%     end 
% end
% 
% 
% %Call
% for t = 1:length(swe)
%     for i = 1:length(F)
%         c(t) = (F(i) * norm(-d_1(i)) - K*norm(-d_2(i)))exp(-(swe(t+T_1W))*(T_1W-t));
%     end
% end
% 
% %Put
% for t = 1:length(swe)
%     for i = 1:length(F)
%         p(t) = (K*norm(-d_2(i)) - F(i)*norm(-d_1(i))*exp(-(swe(t+T_1W))*(T_1W-t)));
%     end
% end
% %--------------------------------------------------------------------------
