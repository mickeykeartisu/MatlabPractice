%% initialize environments
clc;
clear variables;

%% plot all 4 mora word list audio files
mask_list = ["noMask", "withMask"];
spectrogram_list = ["TandemStraight", "World"];
for mask_index = 1 : length(mask_list)
    for spectrogram_index = 1 : length(spectrogram_list)
        for file_index = 1 : 50
            %% load dynamic feature World mat file
            dynamic_feature_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index) + ".mat";
            dynamic_feature = load(dynamic_feature_path);
        
            %% plot dynamic feature World
            window = figure;
            window.WindowState = "maximized";
            if spectrogram_list(spectrogram_index) == "TandemStraight"
                time_axis = dynamic_feature.spectrogram.aperiodicity_structure.temporalPositions;
                plot(time_axis, dynamic_feature.dynamic_feature, "LineWidth", 3);
            elseif spectrogram_list(spectrogram_index) == "World"
                time_axis = dynamic_feature.spectrogram.aperiodicity_structure.temporal_positions;
                plot(time_axis, dynamic_feature.dynamic_feature, "LineWidth", 3);
            end
            xlim([1.65 2.65]);
            ylim([0.1 1.2]);
            spplotlabel(dynamic_feature.spectrogram.label, 'sec', "r-");
            title_string = "Set1\_" + mask_list(mask_index) + "\_word " + int2str(file_index) + " Dynamic Feature " + spectrogram_list(spectrogram_index);
            font_size = 24;
            title(title_string, 'fontsize', font_size);
            set(gca, 'YMinorGrid', 'on', 'fontsize', font_size);
            ylabel('D_\Delta(t) [dB/ms]', 'fontsize', font_size);
            xlabel('Time [s]', 'fontsize', font_size);
            grid on;
            set(gca, "FontSize", font_size);
            dynamic_feature_png_path = "D:/名城大学/研究室/研究/Outputs/4モーラ単語リスト/Set1/" + mask_list(mask_index) + "/DynamicFeature/" + spectrogram_list(spectrogram_index) + "/word " + int2str(file_index);
            print(dynamic_feature_png_path, "-dpng");
            delete(gcf);
        end
    end
end