% AGG - iShares Core US Aggregate Bond ETF
% SPY - SPDR S&P 500 ETF Trust
% VGK - Vanguard European Stock Index Fund ETF
% VWO - Vanguard Emerging Markets Stock Index Fund ETF

addpath('DJIA_Prediction', 'SeroFAM', 'Indicators', 'Portfolio');
filename = {'AGG', 'SPY', 'VGK', 'VWO'};

testPercent = 0.2;

opt = {
    [2, 4, 2, 0.001068735, -0.000722583];
    [13, 46, 30, 0.001110505, -0.002115682];
    [5	45	36	0.005499194	-0.003570893];
    [2	3	43	2.06E-03	-0.002580471];
};
data = cell(4,2);
for i = 1:4
    d = fetchData(filename{i});

    [~, ~, ~, ~, inputTest,  predOutTest,  ~,  ~] = serofamPredict(d, testPercent, false, 1);
    data{i,1} = inputTest;
    data{i,2} = predOutTest;

    bnh = investBuyAndHold(inputTest, 1e6);
    sprintf("%s buy and hold result: %.3f", filename{i}, bnh)
end

out = tacticalBnH(data, opt);
sprintf("Tactical buy and hold result: %.3f", out(end))