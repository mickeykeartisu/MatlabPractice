classdef CepstrumVocoder < handle
    %% プロパティ
    properties(SetAccess = private)
        originalSignal  % 入力された全体の信号
        samplingFrequency   % サンプリング周波数 [Hz]
        FFTPoint    % FFTする際の次元数
        frameLength % フレームの長さ [ポイント数]
        frameShift  % シフト長 [ポイント数]

        basicFrequencies    % 基本周波数の配列
        synthesizedSignal   % 合成された音声信号
    end

    %% メソッド
    methods
        %% デフォルトコンストラクタ
        function object = CepstrumVocoder(originalSignal, samplingFrequency, frameLength, frameShift, FFTPoint)
            object.originalSignal = originalSignal; % 入力された信号
            object.samplingFrequency = samplingFrequency;   % サンプリング周波数 [Hz]
            object.frameLength = frameLength;   % インスタンス生成時は[ms]で入力後自動で計算する
            object.frameShift = frameShift; % インスタンス生成時は[ms]で入力後自動で計算する
            object.FFTPoint = FFTPoint;

            % フレーム長さとシフト長さの単位を変換
            object.transformUnit();

            % それぞれのバッファを予め確保
            object.setBuffers();

            % プロパティを表示する
            object.displayProperties();
        end

        %% セッター
        % 読み込んだのセッター
        function set.originalSignal(object, originalSignal)
            if length(originalSignal) <= 1
                throw(MException("Setter:originalSignal", "original signal shape is smaller then 0."));
            end
            object.originalSignal = originalSignal;
        end

        % サンプリング周波数のセッター
        function set.samplingFrequency(object, samplingFrequency)
            if samplingFrequency <= 0
                throw(MException("Setter:samplingFrequency", "sampling frequency is smaller than 0."));
            end
            object.samplingFrequency = samplingFrequency;
        end

        % フレーム長のセッター
        function set.frameLength(object, frameLength)
            if frameLength < 1
                throw(MException("Setter:frameLength", "frame length is smaller than 1."));
            end
            object.frameLength = frameLength;
        end

        % フレームのシフト長のセッター
        function set.frameShift(object, frameShift)
            if frameShift < 1
                throw(MException("Setter:frameShift", "frame shift is smaller than 1."));
            end
            object.frameShift = frameShift;
        end

        % 基本周波数の配列のセッター
        function set.basicFrequencies(object, basicFrequencies)
            object.basicFrequencies = basicFrequencies;
        end

        % 合成された音声信号のセッター
        function set.synthesizedSignal(object, synthesizedSignal)
            object.synthesizedSignal = synthesizedSignal;
        end

        % FFTの際の次元数のセッター
        function set.FFTPoint(object, FFTPoint)
            if FFTPoint <= 1
                throw(MException("Setter:FFTPoint", "FFT Point is smaller than 2."));
            end
            object.FFTPoint = FFTPoint;
        end

        %% ゲッター
        % 開きたい音声信号のゲッター
        function originalSignal = get.originalSignal(object)
            originalSignal = object.originalSignal;
        end

        % サンプリング周波数のゲッター
        function samplingFrequency = get.samplingFrequency(object)
            samplingFrequency = object.samplingFrequency;
        end

        % フレーム長さのゲッター
        function frameLength = get.frameLength(object)
            frameLength = object.frameLength;
        end

        % フレームシフト長のゲッター
        function frameShift = get.frameShift(object)
            frameShift = object.frameShift;
        end

        % 基本周波数の配列のゲッター
        function basicFrequencies = get.basicFrequencies(object)
            basicFrequencies = object.basicFrequencies;
        end

        % 合成された音声信号のゲッター
        function synthesizedSignal = get.synthesizedSignal(object)
            synthesizedSignal = object.synthesizedSignal;
        end

        % FFTの際の次元数のゲッター
        function FFTPoint = get.FFTPoint(object)
            FFTPoint = object.FFTPoint;
        end

        %% 通常のメソッド
        % フレーム長とフレームシフト長さの単位を変換するメソッド
        function transformUnit(object)
            object.frameLength = floor(object.frameLength * object.samplingFrequency / 1000);
            object.frameShift = floor(object.frameShift * object.samplingFrequency / 1000);
        end

        % それぞれのパラメータのバッファを確保するメソッド
        function setBuffers(object)
            object.basicFrequencies = zeros([floor((length(object.originalSignal) - object.frameLength) / object.frameShift), 1]);
            object.synthesizedSignal = zeros([length(object.originalSignal) + object.FFTPoint, 1]);
        end

        % それぞれの基本周波数を計算する
        function calculateBasicFrequenciesAndSynthesize(object, maxCepstrumDimension, threshold, repeatNumber, basicPeriodGain)
            for frameIndex = 1 : length(object.basicFrequencies)
                cepstrum = Cepstrum( ...
                    object.originalSignal(object.frameShift * (frameIndex - 1) + 1 : object.frameShift * (frameIndex - 1) + 1 + object.frameLength), ...
                    object.samplingFrequency, ...
                    object.FFTPoint, ...
                    maxCepstrumDimension, ...
                    threshold, ...
                    repeatNumber, ...
                    basicPeriodGain ...
                );

                if rem(frameIndex, 10) == 0
                    fprintf("frame : %d / %d\n", frameIndex, length(object.basicFrequencies));
                    cepstrum.displayProperties();
                end

                object.basicFrequencies(frameIndex) = cepstrum.basicFrequency;

                if cepstrum.basicFrequency == 0
                    uv_period = 10 * object.samplingFrequency / 1000;
                    uv_resp = randn(1, uv_period);
                    uv_resp = uv_resp ./ sqrt(uv_period);
                    object.synthesizedSignal(object.frameShift * (frameIndex - 1) + 1 : object.frameShift * (frameIndex - 1) + object.FFTPoint) ...
                    = object.synthesizedSignal(object.frameShift * (frameIndex - 1) + 1 : object.frameShift * (frameIndex - 1) + object.FFTPoint) ...
                    + conv(cepstrum.impulseResponseOfCepstrum, uv_resp, 'same');
                else
                    object.synthesizedSignal(object.frameShift * (frameIndex - 1) + 1 : object.frameShift * (frameIndex - 1) + object.FFTPoint) ...
                    = object.synthesizedSignal(object.frameShift * (frameIndex - 1) + 1 : object.frameShift * (frameIndex - 1) + object.FFTPoint) ...
                    + cepstrum.impulseResponseOfCepstrum;
                end
            end
        end

        % パラメータを表示するメソッド
        function displayProperties(object)
            fprintf("------------------------------------------------\n");
            fprintf("---------------- CepstrumVocoder ---------------\n");
            fprintf("original signal shape : (%d, %d)\n", size(object.originalSignal));
            fprintf("frame length : %d [ポイント]\n", object.frameLength);
            fprintf("shift length : %d [ポイント]\n", object.frameShift);
            fprintf("basic frequencies shape : (%d, %d)\n", size(object.basicFrequencies));
            fprintf("FFT Point : %d\n", object.FFTPoint);
            fprintf("synthesized signal shape : (%d, %d)\n", size(object.synthesizedSignal));
            fprintf("------------------------------------------------\n\n");
        end
    end
end