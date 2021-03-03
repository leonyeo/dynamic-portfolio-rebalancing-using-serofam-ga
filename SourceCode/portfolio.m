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
% for i = 1:4
%     d = fetchData(filename{i});
% 
%     [~, ~, ~, ~, inputTest,  predOutTest,  ~,  ~] = serofamPredict(d, testPercent, false, 1);
%     data{i,1} = inputTest;
%     data{i,2} = predOutTest;
% 
%     bnh = investBuyAndHold(inputTest, 1e6);
%     sprintf("%s buy and hold result: %.3f", filename{i}, bnh)
% end

out = tacticalBnH(data, opt);
sprintf("Tactical buy and hold result: %.3f", out)

function out = tacticalBnH(data, opt)
    [~, fMACDH, ~] = getfMACDH(data{1,1}, data{1,2}, opt{1}(1), opt{1}(2), opt{1}(3), 1);
    aggSignal = getBuySell(fMACDH, opt{1}(4), opt{1}(5));

    [~, fMACDH, ~] = getfMACDH(data{2,1}, data{2,2}, opt{2}(1), opt{2}(2), opt{2}(3), 1);
    spySignal = getBuySell(fMACDH, opt{2}(4), opt{2}(5));

    [~, fMACDH, ~] = getfMACDH(data{3,1}, data{3,2}, opt{3}(1), opt{3}(2), opt{3}(3), 1);
    vgkSignal = getBuySell(fMACDH, opt{3}(4), opt{3}(5));

    [~, fMACDH, ~] = getfMACDH(data{4,1}, data{4,2}, opt{4}(1), opt{4}(2), opt{4}(3), 1);
    vwoSignal = getBuySell(fMACDH, opt{4}(4), opt{4}(5));

    commission = 1.001;
    cash = 1e6 - mod(250000, (data{1,1}(1) * commission)) ...
               - mod(250000, (data{2,1}(1) * commission)) ...
               - mod(250000, (data{3,1}(1) * commission)) ...
               - mod(250000, (data{4,1}(1) * commission));
    stock = [
        floor(250000 / (data{1,1}(1) * commission)), ...
        floor(250000 / (data{2,1}(1) * commission)), ...
        floor(250000 / (data{3,1}(1) * commission)), ...
        floor(250000 / (data{4,1}(1) * commission))
        ];
    for i = 1:length(data{1,1})
        if ~isempty(vwoSignal) && i == -vwoSignal(1) % Sell high risk and buy medium risk
            cash = cash + stock(4) * data{4,1}(i);
            stock(4) = 0;
            stock(3) = stock(3) + floor(cash / (data{3,1}(i) * commission));
            cash = mod(cash, (data{3,1}(i) * commission));
            vwoSignal = vwoSignal(2:end);
        end
        if ~isempty(vgkSignal) && i == -vgkSignal(1) % Sell medium risk and buy low risk
            cash = cash + stock(3) * data{3,1}(i);
            stock(3) = 0;
            stock(2) = stock(2) + floor(cash / (data{2,1}(i) * commission));
            cash = mod(cash, (data{2,1}(i) * commission));
            vgkSignal = vgkSignal(2:end);
        end
        if ~isempty(spySignal) && i == -spySignal(1) % Sell low risk and buy lowest risk
            cash = cash + stock(2) * data{2,1}(i);
            stock(2) = 0;
            stock(1) = stock(1) + floor(cash / (data{1,1}(i) * commission));
            cash = mod(cash, (data{1,1}(i) * commission));
            spySignal = spySignal(2:end);
        end

        if ~isempty(spySignal) && i == spySignal(1) % Sell lowest risk and buy low risk
            cash = cash + stock(1) * data{1,1}(i);
            stock(1) = 0;
            stock(2) = stock(2) + floor(cash / (data{2,1}(i) * commission));
            cash = mod(cash, (data{2,1}(i) * commission));
            spySignal = spySignal(2:end);
        end
        if ~isempty(vgkSignal) && i == vgkSignal(1) % Sell low risk and buy medium risk
            cash = cash + stock(2) * data{2,1}(i);
            stock(2) = 0;
            stock(3) = stock(3) + floor(cash / (data{3,1}(i) * commission));
            cash = mod(cash, (data{3,1}(i) * commission));
            vgkSignal = vgkSignal(2:end);
        end
        if ~isempty(vwoSignal) && i == vwoSignal(1) % Sell high risk and buy medium risk
            cash = cash + stock(3) * data{3,1}(i);
            stock(3) = 0;
            stock(4) = stock(4) + floor(cash / (data{4,1}(i) * commission));
            cash = mod(cash, (data{4,1}(i) * commission));
            vwoSignal = vwoSignal(2:end);
        end
    end
    cash = stock(1) * data{1,1}(end) + ...
           stock(2) * data{2,1}(end) + ...
           stock(3) * data{3,1}(end) + ...
           stock(4) * data{4,1}(end) + ...
           cash;
    out = cash;
end