function [ output_args ] = prinComp( input_args )
%Reads .xlsx file of rates (?) and outputs the k compontents that describe
% 99 (?) percent of the variance
%   Detailed explanation goes here

volsurfaces= flipud(xlsread('data.xlsx','PCA','C4:IF845'));
temp = zeros(14,17,842);

% 14 maturities x 17 deltas x 842 dates
for k = 1:842
temp(:,:,k) = reshape(volsurfaces(k,:),[17,14])';    
end


% 14 maturities x 17 deltas x 841 returns
volDiff = log(temp(:,:,2:end)./temp(:,:,1:end-1));

% (14 mat x 17 delta) x 841 returns
for i = 1:841
    volDiff2D(:,i) = reshape(volDiff(:,:,i),[238,1]);
end



%% Create the eigen vectors

[eigVec, eigValD]=eig(cov(volDiff2D'));


%% Choose the k components that describe target range of variance

target = 0.95;
eigVal = flipud(diag(eigValD));
varExpl = 0;
k=0;
while varExpl < target 
    k=k+1;
    varExpl = varExpl + eigVal(k)/sum(eigVal);
end

pComp = eigVec(:,end-k+1:end);

B = reshape(pComp,[14,17,k]);

% for j = 1:length(volDiff2D)
%     for i = 1:k
%         F(j,i)=indexReturns(j,:)*B(:,i);
%     end
% end
% ctrl1 = cov(F);

end

