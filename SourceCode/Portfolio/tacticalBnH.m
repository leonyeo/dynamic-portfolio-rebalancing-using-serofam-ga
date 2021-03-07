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
    cash = mod(250000, (data{1,1}(1) * commission)) ...
           + mod(250000, (data{2,1}(1) * commission)) ...
           + mod(250000, (data{3,1}(1) * commission)) ...
           + mod(250000, (data{4,1}(1) * commission));
    stock = [
        floor(250000 / (data{1,1}(1) * commission)), ...
        floor(250000 / (data{2,1}(1) * commission)), ...
        floor(250000 / (data{3,1}(1) * commission)), ...
        floor(250000 / (data{4,1}(1) * commission))
        ];

    figure();
    subplot(2, 1 ,1); hold on;
    axis([0 900 0 400]);
    plot(data{1,1}, 'Color', '#E8F8F5');
    plot(data{2,1}, 'Color', '#EAF2F8');
    plot(data{3,1}, 'Color', '#F4ECF7');
    plot(data{4,1}, 'Color', '#FDEDEC');
    
    p = zeros(4, 1);
    p(1) = plot(0, data{1,1}(1), '.', 'Color', '#76D7C4');
    p(2) = plot(0, data{2,1}(1), '.', 'Color', '#7FB3D5');
    p(3) = plot(0, data{3,1}(1), '.', 'Color', '#BB8FCE');
    p(4) = plot(0, data{4,1}(1), '.', 'Color', '#F1948A');
    
    value = nan(length(data{1,1}) + 1);
    for i = 1:length(data{1,1})
        %% Plot
        value(i) = stock(1) * data{1,1}(i) + ...
                   stock(2) * data{2,1}(i) + ...
                   stock(3) * data{3,1}(i) + ...
                   stock(4) * data{4,1}(i) + ...
                   cash;
        if stock(1) > 0
            plot(i, data{1,1}(i), '.', 'Color', '#76D7C4');
        else
            plot(i, data{1,1}(i), '.', 'Color', '#E8F8F5');
        end
        if stock(2) > 0
            plot(i, data{2,1}(i), '.', 'Color', '#7FB3D5');
        else
            plot(i, data{2,1}(i), '.', 'Color', '#EAF2F8');
        end
        if stock(3) > 0
            plot(i, data{3,1}(i), '.', 'Color', '#BB8FCE');
        else
            plot(i, data{3,1}(i), '.', 'Color', '#F4ECF7');
        end
        if stock(4) > 0
            plot(i, data{4,1}(i), '.', 'Color', '#F1948A');
        else
            plot(i, data{4,1}(i), '.', 'Color', '#FDEDEC');
        end
        pause(.01);


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
    value(end) = stock(1) * data{1,1}(end) + ...
                 stock(2) * data{2,1}(end) + ...
                 stock(3) * data{3,1}(end) + ...
                 stock(4) * data{4,1}(end) + ...
                 cash;
    out = value;
    
    legend(p([1 2 3 4]), 'AGG', 'SPY', 'VGK', 'VWO');
    subplot(2, 1 ,2); hold on;
    plot(value);
    legend('Portfolio Value');
end