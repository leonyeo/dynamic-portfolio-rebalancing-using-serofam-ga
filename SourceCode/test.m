figure;
subplot(2,2,1);hold on;
plot(inputTest);
ylabel('Closing'); xlabel('Datapoint#');
legend({'Actual'});
grid on;
title('Actual prices');

subplot(2,2,2);hold on;
plot(movmean(inputTest, [12,12], 'Endpoints', 'fill'));
ylabel('Closing'); xlabel('Datapoint#');
grid on;
title('Moving Average across 26 days');
for i = 1:size(peakTrough)
    if peakTrough(i) == 1 && peakTrough(i-1) == -1
        xline(i);
    elseif peakTrough(i) == -1 && peakTrough(i-1) == 1
        xline(i);
    end
end

subplot(2,2,3);hold on;
plot(macdhSignal);
plot(fMACDHSignal);
ylabel('Signal'); xlabel('Datapoint#');
legend({'MACDH', 'fMACDH'});
grid on;
title('MACDH vs fMACDH Buy/Sell signals');

subplot(2,2,4);hold on;
plot(rsiSignal);
plot(fRSISignal);
ylabel('Signal'); xlabel('Datapoint#');
legend({'RSI', 'fRSI'});
grid on;
title('RSI vs fRSI Buy/Sell signals');