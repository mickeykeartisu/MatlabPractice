classdef Cepstrum < handle
    %% プロパティ
    properties(SetAccess = public)
        extractedSignal  % 解析を行いたい信号
        samplingFrequency   % サンプリング周波数 [Hz]
        hammingWindowLength  % ハミング窓の大きさ

        FFTPoint    % FFTの際の次元数
        linearAmplitudeSpectral  % 振幅スペクトル(真数)

        cepstrum    % ケプストラム
        peakPointOfCepstrum % ケプストラムのピークポイント
        maxValueOfCepstrum    % ケプストラムのピークポイントの最大値
        maxCepstrumDimension   % ケプストラムから抽出する次元の最大値
        threshold   % 有性か無性かを判定する閾値

        basicPeriod % 基本周期 [ポイント数]
        basicFrequency  % 基本周波数 [Hz]

        linearAmplitudedSpectralEnvelope    % 真数の振幅スペクトル包絡
        impulseResponseOfCepstrum   % ケプストラムのインパルス応答

        repeatNumber    % 重畳加算する回数
        basicPeriodGain % 基本周期のゲイン
        synthesizedSignal   % ケプストラムのインパルス応答から重畳加算された音声信号
    end

    %% メソッド
    methods
        % コンストラクタ
        function object = Cepstrum(extractedSignal, samplingFrequency, FFTPoint, maxCepstrumDimension, threshold, repeatNumber, basicPeriodGain)
            % パラメータを読み込む
            object.extractedSignal = extractedSignal; % 入力された信号
            object.samplingFrequency = samplingFrequency;   % 信号のサンプリング周波数 [Hz]
            object.FFTPoint = FFTPoint; % FFTの際の次元数
            object.maxCepstrumDimension = maxCepstrumDimension; % ケプストラムの低次元の最大次元数
            object.threshold = threshold;   % 有声か無声かを判定する為の閾値
            object.repeatNumber = repeatNumber; % 重畳加算回数
            object.basicPeriodGain = basicPeriodGain;   % 声の高さの利得

            % 窓のサイズを読み込み窓を乗じた信号を生成する
            object.hammingWindowLength = length(extractedSignal);
            object.multipleHammingWindow();

            % FFTを行う為のパラメータをセットして振幅スペクトルを計算する
            object.calculateLinearAmplitudeSpectral();

            % ケプストラムの低次元の最大値と閾値を設定してケプストラムを計算する
            object.calculateCepstrum();

            % ケプストラムの頂点を計算して基本周波数と基本周期を計算する
            object.calculatePeakPointAndMaxValueOfCepstrum();
            object.calculateBasicPeriodAndBasicFrequency();

            % 低ケフレンシーを計算して振幅スペクトル包絡を計算する
            object.extractLowQuefrency();
            object.calculateLinearAmplitudeSpectralEnvelope();

            % ケプストラムのインパルス応答を計算する
            object.calculatempulseResponseOfCepstrum();

            % ケプストラムのインパルス応答から重畳加算する
            object.synthesizeSignal();
        end

        %% セッター
        % 読み込んだのセッター
        function set.extractedSignal(object, originalSignal)
            if length(originalSignal) <= 1
                throw(MException("Setter:originalSignal", "original signal shape is smaller then 0."));
            end
            object.extractedSignal = originalSignal;
        end

        % サンプリング周波数のセッター
        function set.samplingFrequency(object, samplingFrequency)
            if samplingFrequency <= 0
                throw(MException("Setter:samplingFrequency", "sampling frequency is smaller than 0."));
            end
            object.samplingFrequency = samplingFrequency;
        end

        % ハミング窓の長さのセッター
        function set.hammingWindowLength(object, hammingWindowLength)
            if hammingWindowLength <= 1
                throw(MException("Setter:hammingWindowLength", "hamming window length is smaller than 0."));
            end
            object.hammingWindowLength = hammingWindowLength;
        end

        % FFTの際の次元数のセッター
        function set.FFTPoint(object, FFTPoint)
            if FFTPoint <= 1
                throw(MException("Setter:FFTPoint", "FFT Point is smaller than 2."));
            end
            object.FFTPoint = FFTPoint;
        end

        % ケプストラムの抽出する最大の次元数のセッター
        function set.maxCepstrumDimension(object, maxCepstrumDimension)
            if maxCepstrumDimension < 0
                throw(MException("Setter:maxCepstrumDimension", "max cepstrum dimension is smaller than 0."));
            end
            object.maxCepstrumDimension = maxCepstrumDimension;
        end
 
        % 有声か無声かを判定する為の閾値
        function set.threshold(object, threshold)
            if threshold < 0
                throw(MException("Setter:threshold", "threshold is smaller than 0."));
            end
            object.threshold = threshold;
        end

        % ケプストラムのピークポイントのセッター
        function set.peakPointOfCepstrum(object, peakPointOfCepstrum)
            if peakPointOfCepstrum < 0
                throw(MException("Setter:peakPointOfCepstrum", "peak point of cepstrum is smaller than 0."));
            end
            object.peakPointOfCepstrum = peakPointOfCepstrum;
        end

        % ケプストラムの最大値のセッター
        function set.maxValueOfCepstrum(object, maxValueOfCepstrum)
            if maxValueOfCepstrum < 0
                throw(MException("Setter:maxValueOfCepstrum", "max value of cepstrum is smaller than 0."));
            end
            object.maxValueOfCepstrum = maxValueOfCepstrum;
        end

        % 重畳加算する回数のセッター
        function set.repeatNumber(object, repeatNumber)
            if repeatNumber < 1
                throw(MException("Setter:repeatNumber", "repeat number is smaller than 1."));
            end
            object.repeatNumber = repeatNumber;
        end

        % 基本周期の間隔のゲインのセッター
        function set.basicPeriodGain(object, basicPeriodGain)
            if basicPeriodGain <= 0
                throw(MException("Setter:basicPeriod", "basic period gain is smaller than 0."));
            end
            object.basicPeriodGain = basicPeriodGain;
        end

        %% ゲッター
        % 開きたい音声信号のゲッター
        function originalSignal = get.extractedSignal(object)
            originalSignal = object.extractedSignal;
        end

        % サンプリング周波数のゲッター
        function samplingFrequency = get.samplingFrequency(object)
            samplingFrequency = object.samplingFrequency;
        end

        % 窓のサイズのゲッター
        function hammingWindowLength = get.hammingWindowLength(object)
            hammingWindowLength = object.hammingWindowLength;
        end

        % FFTの際の次元数のゲッター
        function FFTPoint = get.FFTPoint(object)
            FFTPoint = object.FFTPoint;
        end

        % 真数振幅スペクトルのゲッター
        function linearAmplitudedSpectral = get.linearAmplitudeSpectral(object)
            linearAmplitudedSpectral = object.linearAmplitudeSpectral;
        end

        % ケプストラムのゲッター
        function cepstrum = get.cepstrum(object)
            cepstrum = object.cepstrum;
        end

        % ケプストラムの抽出する最大の次元数のゲッター
        function maxCepstrumPoint = get.maxCepstrumDimension(object)
            maxCepstrumPoint = object.maxCepstrumDimension;
        end

        % ケプストラムのピークポイントのゲッター
        function peakpointOfCepstrum = get.peakPointOfCepstrum(object)
            peakpointOfCepstrum = object.peakPointOfCepstrum;
        end

        % ケプストラムの最大値のゲッター
        function maxValueofCepstrum = get.maxValueOfCepstrum(object)
            maxValueofCepstrum = object.maxValueOfCepstrum;
        end

        % 有声か無声かを判定する為の閾値のゲッター
        function threshold = get.threshold(object)
            threshold = object.threshold;
        end

        % 基本周期のゲッター
        function basicPeriod = get.basicPeriod(object)
            basicPeriod = object.basicPeriod;
        end

        % 基本周波数のゲッター
        function basicFrequency = get.basicFrequency(object)
            basicFrequency = object.basicFrequency;
        end

        % 真数振幅スペクトル包絡のゲッター
        function linearAmplitudedSpectralEnvelope = get.linearAmplitudedSpectralEnvelope(object)
            linearAmplitudedSpectralEnvelope = object.linearAmplitudedSpectralEnvelope;
        end

        % ケプストラムのインパルス応答のゲッター
        function impulseResponseOfCepstrum = get.impulseResponseOfCepstrum(object)
            impulseResponseOfCepstrum = object.impulseResponseOfCepstrum;
        end

        % 重畳加算する回数のゲッター
        function repeatNumber = get.repeatNumber(object)
            repeatNumber = object.repeatNumber;
        end

        % 重畳加算した信号のゲッター
        function synthesizedSignal = get.synthesizedSignal(object)
            synthesizedSignal = object.synthesizedSignal;
        end

        % 基本周期の間隔のゲインのゲッター
        function peakPointOfCepstrumGain = get.basicPeriodGain(object)
            peakPointOfCepstrumGain = object.basicPeriodGain;
        end

        %% その他諸々のメソッド
        % 窓関数をかけ合わせた信号を計算するメソッド
        function multipleHammingWindow(object)
            object.extractedSignal = object.extractedSignal .* (0.54 - 0.46 * cos(2 * (0 : object.hammingWindowLength - 1)' * pi / (object.hammingWindowLength - 1)));
        end

        % 低ケフレンシー成分を抽出するメソッド
        function extractLowQuefrency(object)
            object.cepstrum(object.maxCepstrumDimension + 1 : object.FFTPoint - object.maxCepstrumDimension) = 0;
        end

        % 真数の振幅スペクトルを計算するメソッド
        function calculateLinearAmplitudeSpectral(object)
            fastFourierTransformedSignal = fft(object.extractedSignal, object.FFTPoint);
            object.linearAmplitudeSpectral = sqrt(abs(real(fastFourierTransformedSignal) .^ 2 + imag(fastFourierTransformedSignal) .^ 2));
        end

        % ケプストラムを計算するメソッド
        function calculateCepstrum(object)
            naturalLogarithmAmplitutedSpectral = log(object.linearAmplitudeSpectral);
            inverseFastFourierTransformedSignal = ifft(naturalLogarithmAmplitutedSpectral);
            object.cepstrum = real(inverseFastFourierTransformedSignal);
        end

        % ケプストラムのピークポイントと最大値を計算するメソッド
        function calculatePeakPointAndMaxValueOfCepstrum(object)
            [object.maxValueOfCepstrum, object.peakPointOfCepstrum] = max(object.cepstrum(object.maxCepstrumDimension : object.FFTPoint / 2));
            object.peakPointOfCepstrum = object.peakPointOfCepstrum + object.maxCepstrumDimension - 1;
        end

        % 基本周波数[Hz]と基本周期[s]を設定するメソッド
        function calculateBasicPeriodAndBasicFrequency(object)
            object.basicPeriod = object.peakPointOfCepstrum / object.samplingFrequency;
            object.basicFrequency = 1 / object.basicPeriod;
            object.checkVoicedSpeechOrNot();
        end

        % 真数振幅スペクトル包絡を計算するメソッド
        function calculateLinearAmplitudeSpectralEnvelope(object)
            spectralEnvelope = fft(object.cepstrum, object.FFTPoint);
            amplitutedSpectralEnvelope = sqrt(abs(real(spectralEnvelope) .^ 2 + imag(spectralEnvelope) .^ 2));
            object.linearAmplitudedSpectralEnvelope = exp(amplitutedSpectralEnvelope);
        end

        % ケプストラムのインパルス応答を計算するメソッド
        function calculatempulseResponseOfCepstrum(object)
            realPartOfLinearAmplitutedSpectralEnvelope = real(object.linearAmplitudedSpectralEnvelope);
            inverseFourierTransformedSignal = ifft(realPartOfLinearAmplitutedSpectralEnvelope, object.FFTPoint);
            realPartOfInverseFourierTransformedSignal = real(inverseFourierTransformedSignal);
            object.impulseResponseOfCepstrum = fftshift(realPartOfInverseFourierTransformedSignal);
        end

        % ケプストラムのインパルス応答を用いた重畳加算を行うメソッド
        function synthesizeSignal(object)
            % 重畳加算用のバッファを確保する
            object.synthesizedSignal = zeros([floor(object.peakPointOfCepstrum * object.basicPeriodGain * object.repeatNumber + object.FFTPoint), 1]);

            % 重畳加算する
            for index = 0 : object.repeatNumber
                object.synthesizedSignal(floor(object.peakPointOfCepstrum * object.basicPeriodGain * index + 1) : floor(object.peakPointOfCepstrum * object.basicPeriodGain * index + object.FFTPoint)) ...
                = object.synthesizedSignal(floor(object.peakPointOfCepstrum * object.basicPeriodGain * index + 1) : floor(object.peakPointOfCepstrum * object.basicPeriodGain * index + object.FFTPoint)) ...
                + object.impulseResponseOfCepstrum(1 : object.FFTPoint);
            end
        end

        % 入力された信号が有声か無声か判定するメソッド
        function checkVoicedSpeechOrNot(object)
            if object.maxValueOfCepstrum < object.threshold
                object.basicFrequency = 0;
                object.basicPeriod = 0;
            end
        end

        % ケプストラム分析に利用されたパラメータを表示するメソッド
        function displayProperties(object)
            fprintf("------------------------------------------------\n");
            fprintf("------------------- Cepstrum -------------------\n");
            fprintf("sampling frequency : %d [Hz]\n", object.samplingFrequency);    % サンプリング周波数
            fprintf("original signal shape : (%d, %d)\n", size(object.extractedSignal)); % 開いた音声信号
            fprintf("hamming window length : %d\n", object.hammingWindowLength);   % ハミング窓の大きさ
    
            fprintf("FFT Point : %d\n", object.FFTPoint);   % FFTの際の次元数
            fprintf("linear amplituded spectral shape : (%d, %d)\n", size(object.linearAmplitudeSpectral));    % 振幅スペクトル(真数)
            fprintf("max cepstrum dimension : %d\n", object.maxCepstrumDimension);  % ケプストラムから抽出する次元の最大値
            fprintf("threshold : %f\n", object.threshold);  % 有性か無性かを判定する閾値
    
            fprintf("cepstrum shape : (%d, %d)\n", size(object.cepstrum));  % ケプストラム
            fprintf("peak point of cepstrum : %d\n", object.peakPointOfCepstrum);   % ケプストラムのピークポイント
            fprintf("max value of cepstrum : %f\n", object.maxValueOfCepstrum); % ケプストラムのピークポイントの最大値
    
            fprintf("basic period : %f\n", object.basicPeriod); % 基本周期 [ポイント数]
            fprintf("basic frequency : %f\n", object.basicFrequency);   % 基本周波数 [Hz]
    
            fprintf("linear amplituded spectral envelope shape : (%d, %d)\n", size(object.linearAmplitudedSpectralEnvelope));   % 真数の振幅スペクトル包絡
            fprintf("impulse response of cepstrum shape : (%d, %d)\n", size(object.impulseResponseOfCepstrum)); % ケプストラムのインパルス応答
    
            fprintf("repeat number : %d\n", object.repeatNumber);   % 重畳加算する回数
            fprintf("peak point of cepstrum gain : %f\n", object.basicPeriodGain);  % 基本周期のゲイン
            fprintf("synthesized signal shape : (%d, %d)\n", size(object.synthesizedSignal));   % ケプストラムのインパルス応答から重畳加算された音声信号
            fprintf("------------------------------------------------\n\n");
        end
    end
end