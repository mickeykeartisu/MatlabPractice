classdef Plotter < handle
    %% プロパティ
    properties(SetAccess = private)
        row % 入力された画像の行数
        column % 入力された画像の列数

        spectralEnvelopeWithDB % 入力されたスペクトル包絡
        amplitudeSpectral   % 振幅スペクトル

        xLabel  % X軸のラベル
        yLabel  % Y軸のラベル
        titleLabel   % タイトル

        outputImageFilePath % アウトプット用のファイルパス(拡張子を含まない)
    end

    %% メソッド
    methods
        %% デフォルトコンストラクタ
        function object = Plotter(spectralEnvelopeWithDB, amplitudeSpectral, xLabel, yLabel, titleLabel, outputImageFilePath)
            object.spectralEnvelopeWithDB = spectralEnvelopeWithDB;
            object.amplitudeSpectral = amplitudeSpectral;
            object.xLabel = xLabel;
            object.yLabel = yLabel;
            object.titleLabel = titleLabel;
            object.outputImageFilePath = outputImageFilePath;

            % 内容をプロットする
            object.plotSignalAndSave();
        end

        %% セッター
        % 入力されたスペクトル包絡のセッター
        function set.spectralEnvelopeWithDB(object, inputSignal)
            if length(inputSignal) <= 0
                throw(MException("Setter:inputSpectralEnvelopeWithDB", "input spectral envelope with dB is less than 0."));
            end
            object.spectralEnvelopeWithDB = inputSignal;
        end

        % 入力された振幅スペクトルのセッター
        function set.amplitudeSpectral(object, amplitudeSpectral)
            if length(amplitudeSpectral) <= 0
                throw(MException("Setter:inputAmplitudeSpectral", "input amplitude spectral is less than 0."));
            end
            object.amplitudeSpectral = amplitudeSpectral;
        end

        % X軸のラベルのセッター
        function set.xLabel(object, xLabel)
            if xLabel == ""
                throw(MException("Setter:xLabel", "x label is empty."));
            end
            object.xLabel = xLabel;
        end

        % Y軸のラベルのセッター
        function set.yLabel(object, yLabel)
            if yLabel == ""
                throw(MException("Setter:yLabel", "y label is empty."));
            end
            object.yLabel = yLabel;
        end

        % タイトルのセッター
        function set.titleLabel(object, titleLabel)
            if titleLabel == ""
                throw(MException("Setter:titleLabel", "title label is empty."));
            end
            object.titleLabel = titleLabel;
        end

        % アウトプット用のファイルパスのセッター
        function set.outputImageFilePath(object, outputImageFilePath)
            if outputImageFilePath == ""
                throw(MException("Setter:outputImageFilePath", "output image fila path is empty."));
            end
            object.outputImageFilePath = outputImageFilePath;
        end

        %% ゲッター
        % 入力されたスペクトル包絡のゲッター
        function spectralEnvelopeWithDB = get.spectralEnvelopeWithDB(object)
            spectralEnvelopeWithDB = object.spectralEnvelopeWithDB;
        end

        % 入力された振幅スペクトルのゲッター
        function amplitudeSpectral = get.amplitudeSpectral(object)
            amplitudeSpectral = object.amplitudeSpectral;
        end

        % X軸のラベルのゲッター
        function xLabel = get.xLabel(object)
            xLabel = object.xLabel;
        end

        % Y軸のラベルのゲッター
        function yLabel = get.yLabel(object)
            yLabel = object.yLabel;
        end

        % タイトルのゲッター
        function titleLabel = get.titleLabel(object)
            titleLabel = object.titleLabel;
        end

        % アウトプット用の画像ファイルパスのゲッター
        function outputImageFilePath = get.outputImageFilePath(object)
            outputImageFilePath = object.outputImageFilePath;
        end

        %% 普通のメソッド
        function plotSignalAndSave(object)
            plot(1 : length(object.spectralEnvelopeWithDB), object.spectralEnvelopeWithDB, "r", 1 : length(object.amplitudeSpectral), object.amplitudeSpectral, "b", 'LineWidth', 1);
            xlabel(object.xLabel);
            ylabel(object.yLabel);
            title(object.titleLabel);
            axis([0 4000 -50 40]);
            grid on;

            print(object.outputImageFilePath, "-dpng");
        end
    end
end