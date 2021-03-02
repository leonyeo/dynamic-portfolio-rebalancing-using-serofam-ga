% AGG - iShares Core US Aggregate Bond ETF
% SPY - SPDR S&P 500 ETF Trust
% VGK - Vanguard European Stock Index Fund ETF
% VWO - Vanguard Emerging Markets Stock Index Fund ETF

addpath('DJIA_Prediction', 'SeroFAM', 'Indicators', 'Portfolio');
filename = {'AGG', 'SPY', 'VGK', 'VWO'};

testPercent = 0.2;

opt = cell(4,1);
data = cell(4,2);
for i = 1:4
    data = fetchData(filename{i});

    [~, ~, ~, ~, inputTest,  predOutTest,  ~,  ~] = serofamPredict(data, testPercent, false, 1);
    data{i,1} = inputTest;
    data{i,2} = predOutTest;

    bnh = investBuyAndHold(inputTest, 1e6);
    sprintf("%s buy and hold result: %.3f", filename{i}, bnh)
end