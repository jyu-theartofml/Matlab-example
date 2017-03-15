function portfolio
ticker = { 'veiex' 'vbiix' 'vgpmx' 'vgsix' 'visgx' 'vbmfx' 'vitsx'};
c=yahoo;

for i =1:length(ticker)
    price.(ticker{i})=fetch(c, ticker(i), 'Adj Close', '6/1/2014', '3/1/2015', 'm');
    temp= price.(ticker {i});
    ClosePrice(:,i)= temp(:,2);
end
% use price2ret to convert prices to monthly return
ClosePrice=flipud(ClosePrice);
returns=price2ret(ClosePrice);

p=Portfolio('Name','Vanguard');
p=p.setAssetList(ticker);
%determine mean and covariance
p=p.estimateAssetMoments(returns);
p=p.setDefaultConstraints;
m=p.AssetMean; c=p.AssetCovar;
%intial portfolio as baseline
pwgt0=[0.0538; 0.1326; 0.014;0.1329;0.1286;0.0573;0.4808];
vanguard_return= [0.0914; 0.0572; -0.1512; 0.2244; 0.0503; 0.0490; 0.1406];% these are from vanguard database
%rate_of_return=sum(pwgt0.*vanguard_return)
p=setInitPort(p, pwgt0);

%estimate portfolio risk and return
[prsk0, pret0] = estimatePortMoments(p, p.InitPort)
current_annual_return0=(1+pret0)^12-1 %based on matlab cal
[pwgt, pbuy, psell]=estimateFrontier(p,10);
display(pwgt);

%find efficient frontier
[prisk, preturns]= p.plotFrontier(10);
display(preturns);
%display(prisk);
hold on

plot(prisk, preturns, 'ored');
    
%hold off
display(pbuy);
display(psell);

%determin the risk and return for the efficient frontier portfolios
[prisk1, pret1]= estimatePortMoments(p, pwgt);
plot(prisk1,pret1, '+blue')

%Maximize Sharpe's Ratio
r0=0.03;
p = Portfolio('RiskFreeRate', r0);
p = setAssetMoments(p, m, c); %takes portfolio mean and covariance
p = setDefaultConstraints(p);
pwgt2 = estimateMaxSharpeRatio(p);
display(pwgt2);

xlswrite('buy and sell.xlsx', pwgt,1)
xlswrite('buy and sell.xlsx', pbuy,2)
xlswrite('buy and sell.xlsx', psell,3)