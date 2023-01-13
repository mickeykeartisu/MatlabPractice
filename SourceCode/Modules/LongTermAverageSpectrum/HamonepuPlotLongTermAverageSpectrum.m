%% initialize environments
clc;
clear variables;

%% plot all long term average spectrum
band_list = [
    "めどれみ", ...
    "シャンディタウン", ...
    "ビート・ビート・ビート", ...
    "太陽の破片", ...
    "すばる", ...
    "ささめき", ...
    "ジュリアナイト", ...
    "しっくすなっつ", ...
    "チョコミン党", ...
    "ラボラトリア", ...
    "ジュークボックス", ...
    "バリバリ" ...
];

for band_list_index = 1 : length(band_list)
    %% load dynamic feature World mat file
    long_term_average_spectrum_path = "D:/アカペラ/はもねぷ 2022 冬 音源/mat_files/long_term_average_spectrum/" + band_list(band_list_index) + ".mat";
    spectrogram = load(long_term_average_spectrum_path);
    spectrogram = spectrogram.spectrogram;
    disp(long_term_average_spectrum_path);
    
    %% plot long term average spectrum
    fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
    x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
    window = figure;
    window.WindowState = "maximized";
    grid on;
    hold on;
    ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
    plot(x, ltas_decibel);
    font_size = 18;
    title("Long Term Average Spectrum " + band_list(band_list_index),"FontSize", font_size);
    xlim([0 19000]);
    ylim([-60 10]);
    xlabel("frequency [Hz]", "FontSize", font_size);
    ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
    long_term_average_spectrum_png_path = "D:/アカペラ/はもねぷ 2022 冬 音源/plot_files/long_term_average_spectrum/" + band_list(band_list_index) + ".png";
    saveas(gcf, long_term_average_spectrum_png_path);
    delete(gcf);
end

window = figure;
window.WindowState = "maximized";
grid on;
hold on;
band_list_long_term_average_spectrum_mean = zeros(length(band_list), 1);
for band_list_index = 1 : length(band_list)
    %% load dynamic feature World mat file
    long_term_average_spectrum_path = "D:/アカペラ/はもねぷ 2022 冬 音源/mat_files/long_term_average_spectrum/" + band_list(band_list_index) + ".mat";
    spectrogram = load(long_term_average_spectrum_path);
    spectrogram = spectrogram.spectrogram;
    disp(long_term_average_spectrum_path);
    band_list_long_term_average_spectrum_mean(band_list_index) = sum(spectrogram.long_term_average_spectrum) / length(spectrogram.long_term_average_spectrum);
    
    %% plot long term average spectrum
    % fftl = (length(spectrogram.long_term_average_spectrum)-1)*2;
    % x = ((0:fftl/2)*spectrogram.sample_rate/fftl)';
    % ltas_decibel = 10 * log10(spectrogram.long_term_average_spectrum);
    % plot(x, ltas_decibel, "DisplayName", band_list(band_list_index));
end
plot(10 * log10(band_list_long_term_average_spectrum_mean), "ro");
xticks(1 : 1 : length(band_list));
font_size = 18;
title("Long Term Average Spectrum comparison all bands","FontSize", font_size);
xlabel("バンドの出演番号", "FontSize", font_size);
ylabel("long term average spectrum Magnitude [dB]", "FontSize", font_size);
long_term_average_spectrum_png_path = "D:/アカペラ/はもねぷ 2022 冬 音源/plot_files/long_term_average_spectrum/all.png";
saveas(gcf, long_term_average_spectrum_png_path);
delete(gcf);