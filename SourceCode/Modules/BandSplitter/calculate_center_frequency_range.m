function frequency_range = calculate_center_frequency_range(center_frequency)
    %% 1 / 3 : band range of center frequency
    %% URL : https://www.onosokki.co.jp/HP-WK/c_support/faq/fft_common/CF_10_1.html
    frequency_range = zeros(size(center_frequency, 2), 2);
    for center_frequency_index = 1 : size(center_frequency, 2)
        if center_frequency(center_frequency_index) == 20
            frequency_range(center_frequency_index, :) = [17.8, 22.5];
        elseif center_frequency(center_frequency_index) == 25
            frequency_range(center_frequency_index, :) = [22.3, 28.1];
        elseif center_frequency(center_frequency_index) == 31.5
            frequency_range(center_frequency_index, :) = [28.1, 35.4];
        elseif center_frequency(center_frequency_index) == 40
            frequency_range(center_frequency_index, :) = [35.6, 44.9];
        elseif center_frequency(center_frequency_index) == 50
            frequency_range(center_frequency_index, :) = [44.5, 56.1];
        elseif center_frequency(center_frequency_index) == 63
            frequency_range(center_frequency_index, :) = [56.1, 70.7];
        elseif center_frequency(center_frequency_index) == 80
            frequency_range(center_frequency_index, :) = [71.3, 89.8];
        elseif center_frequency(center_frequency_index) == 100
            frequency_range(center_frequency_index, :) = [89.1, 112.3];
        elseif center_frequency(center_frequency_index) == 125
            frequency_range(center_frequency_index, :) = [111.4, 140.3];
        elseif center_frequency(center_frequency_index) == 160
            frequency_range(center_frequency_index, :) = [142.5, 179.6];
        elseif center_frequency(center_frequency_index) == 200
            frequency_range(center_frequency_index, :) = [178.2, 224.5];
        elseif center_frequency(center_frequency_index) == 250
            frequency_range(center_frequency_index, :) = [222.7, 280.6];
        elseif center_frequency(center_frequency_index) == 315
            frequency_range(center_frequency_index, :) = [280.6, 353.6];
        elseif center_frequency(center_frequency_index) == 400
            frequency_range(center_frequency_index, :) = [356.3, 449.0];
        elseif center_frequency(center_frequency_index) == 500
            frequency_range(center_frequency_index, :) = [445.4, 561.3];
        elseif center_frequency(center_frequency_index) == 630
            frequency_range(center_frequency_index, :) = [561.2, 707.2];
        elseif center_frequency(center_frequency_index) == 800
            frequency_range(center_frequency_index, :) = [712.7, 898.0];
        elseif center_frequency(center_frequency_index) == 1000
            frequency_range(center_frequency_index, :) = [890.9, 1122.5];
        elseif center_frequency(center_frequency_index) == 1250
            frequency_range(center_frequency_index, :) = [1113.6, 1403.1];
        elseif center_frequency(center_frequency_index) == 1600
            frequency_range(center_frequency_index, :) = [1425.4, 1796.0];
        elseif center_frequency(center_frequency_index) == 2000
            frequency_range(center_frequency_index, :) = [1781.7, 2245.0];
        elseif center_frequency(center_frequency_index) == 2500
            frequency_range(center_frequency_index, :) = [2227.2, 2806.3];
        elseif center_frequency(center_frequency_index) == 3150
            frequency_range(center_frequency_index, :) = [2806.2, 3535.9];
        elseif center_frequency(center_frequency_index) == 4000
            frequency_range(center_frequency_index, :) = [3563.5, 4490.0];
        elseif center_frequency(center_frequency_index) == 5000
            frequency_range(center_frequency_index, :) = [4454.3, 5612.5];
        elseif center_frequency(center_frequency_index) == 6300
            frequency_range(center_frequency_index, :) = [5612.5, 7071.8];
        elseif center_frequency(center_frequency_index) == 8000
            frequency_range(center_frequency_index, :) = [7126.9, 8980.0];
        elseif center_frequency(center_frequency_index) == 10000
            frequency_range(center_frequency_index, :) = [8908.7, 11225.0];
        elseif center_frequency(center_frequency_index) == 12500
            frequency_range(center_frequency_index, :) = [11135.9, 14031.3];
        elseif center_frequency(center_frequency_index) == 16000
            frequency_range(center_frequency_index, :) = [14253.9, 17960.0];
        elseif center_frequency(center_frequency_index) == 20000
            frequency_range(center_frequency_index, :) = [17817.4, 22450.0];
        else
            frequency_range(center_frequency_index, :) = [NaN, NaN];
        end
    end
end