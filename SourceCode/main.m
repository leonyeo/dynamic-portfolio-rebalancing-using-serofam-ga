addpath('DJIA_Prediction', 'SeroFAM', 'Indicators', 'Portfolio');

data = {'^DJI', '^FTSE', '^GSPC', '^HSI', '^IXIC', '^N225', '^STI'};
output = cell(length(data), 1);

for i = 1:length(data)
    %output{i} = optimMACDH(data{i});
    output{i} = BAH(data{i});
end


function output = BAH(filename)
    testPercent = 0.2;
    data = fetchData(filename);

    [~, ~, ~, ~, ...
    inputTest,  ~,  ~,  ~] = ...
        serofamPredict(data, testPercent, false, 1);

    output = investBuyAndHold(inputTest, 300000);
end