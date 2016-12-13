%data = flipud(xlsread('lab5.xlsx','rawdata','B3:Z752'));
%funds = flipud(xlsread('lab5.xlsx','Blad2', 'B3:B752'));
faktorData = data;

fundReturns = log(funds(2:length(funds))./funds(1:length(funds)-1));


%% Create the eigen vectors
indexReturns = log(faktorData(2:length(faktorData),:)./faktorData(1:length(faktorData)-1,:));

[eigVec, eigValD]=eig(cov(indexReturns));


%% Choose the k components that describe target range of variance

target = 0.99;
eigVal = flipud(diag(eigValD));
varExpl = 0;
k=0;
while varExpl < target 
    k=k+1;
    varExpl = varExpl + eigVal(k)/sum(eigVal);
end

pComp = eigVec(:,1:k);

B = pComp;

for j = 1:length(indexReturns)
    for i = 1:k
        F(j,i)=indexReturns(j,:)*B(:,i);
    end
end
ctrl1 = cov(F);
