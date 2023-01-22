%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
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

band_dynamic_feature_mean_list = zeros(length(band_list), 1);
for band_list_index = 1 : length(band_list)
    %% load dynamic feature World mat file
    dynamic_feature_path = "D:/アカペラ/はもねぷ 2022 冬 音源/mat_files/dynamic_feature/" + band_list(band_list_index) + ".mat";
    dynamic_feature = load(dynamic_feature_path);
    band_dynamic_feature_mean_list(band_list_index) = sum(dynamic_feature.dynamic_feature) / length(dynamic_feature.dynamic_feature);
    disp(dynamic_feature_path);

    %% plot dynamic feature World
    window = figure;
    window.WindowState = "maximized";
    time_axis = dynamic_feature.spectrogram.aperiodicity_structure.temporal_positions;
    plot(time_axis, dynamic_feature.dynamic_feature);
    ylim([0 2]);
    title_string = "Band " + band_list(band_list_index) + " Dynamic Feature ";
    font_size = 14;
    title(title_string, 'fontsize', font_size);
    set(gca, 'YMinorGrid', 'on', 'fontsize', font_size);
    ylabel('D_\Delta(t) [dB]', 'fontsize', font_size);
    xlabel('Time [s]', 'fontsize', font_size);
    grid on;
    dynamic_feature_png_path = "D:/アカペラ/はもねぷ 2022 冬 音源/plot_files/dynamic_feature/" + band_list(band_list_index);
    print(dynamic_feature_png_path, "-dpng");
    delete(gcf);
end

plot(band_dynamic_feature_mean_list, "ro");
grid on;
xticks(1 : 1 : 12);
title("それぞれのバンドにおける明瞭性");
xlabel("バンドの出演番号");
ylabel("明瞭性特徴量 [dB/ms]");