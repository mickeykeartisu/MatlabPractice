classdef Analysis < handle
    %% プロパティ
    properties(SetAccess = private)
        originalSignalPath  % 開きたいデータのパス
        samplingFrequency   % サンプリング周波数
        dataType    % 開きたい音声信号のデータ型
        originalSignal  % 開いた音声信号

        startPoint  % 抽出を始めたい点
        continueTime    % 抽出時間
        windowSize  % ハミング窓の大きさ
        extractedSignal % 特定の範囲を抽出した音声信号

        hammingWindow  % ハミング窓
        multipledSignal % 窓関数を乗じた音声信号

        FFTPoint    % FFTの際の次元数
        linearAmplitudedSpectral  % 振幅スペクトル(真数)

        maxCepstrumPoint   % ケプストラムから抽出する次元の最大値
        threshold   % 有性か無性かを判定する閾値

        cepstrum    % ケプストラム
        peakPointOfCepstrum % ケプストラムのピークポイント
        maxValueOfCepstrum    % ケプストラムのピークポイントの最大値

        basicPeriod % 基本周期
        basicFrequency  % 基本周波数

        lowQuefrency    % ケプストラムの低次元成分(低ケフレンシー)
        linearAmplitudedSpectralEnvelope    % 真数の振幅スペクトル包絡
        impulseResponseOfCepstrum   % ケプストラムのインパルス応答

        repeatNumber    % 重畳加算する回数
        peakPointOfCepstrumGain % 基本周期のゲイン
        synthesizedSignal   % ケプストラムのインパルス応答から重畳加算された音声信号

        synthesizedFilePath % 合成された音声信号を保存先のパス
    end

    %% メソッド
    methods
        % コンストラクタ
        function object = Analysis(originalSignalPath, samplingFrequency, dataType, startPoint, continueTime, FFTPoint, maxCepstrumPoint, threshold, repeatNumber, peakPointOfCepstrumGain, synthesizedFilePath)
            % Matlabの環境を初期化する
            object.clearEnviornments();
            
            % 音声信号を読み込むのに必要はパラメータをセット
            object.originalSignalPath = originalSignalPath;
            object.samplingFrequency = samplingFrequency;
            object.dataType = dataType;

            % 音声信号を読み取る
            object.setOriginalSignal();

            % 音声信号の範囲を決定するのに必要なパラメータをセット
            object.startPoint = startPoint;
            object.continueTime = continueTime;

            % 窓のサイズと窓を生成する
            object.setWindowSize();
            object.setHammingWindow();
            
            % 音声信号を抽出して窓を乗じる
            object.setExtractedSignal();
            object.setMultipledSignal();

            % FFTを行う為のパラメータをセットして振幅スペクトルを計算する
            object.FFTPoint = FFTPoint;
            object.setLinearAmplitudedSpectral();

            % ケプストラムの低次元の最大値と閾値を設定してケプストラムを計算する
            object.setCepstrum();
            object.maxCepstrumPoint = maxCepstrumPoint;
            object.threshold = threshold;

            % ケプストラムの頂点を計算して基本周波数と基本周期を計算する
            object.setPeakPointAndMaxValueOfCepstrum();
            object.setBasicPeriod();
            object.setBasicFrequency();

            % 低ケフレンシーを計算して振幅スペクトル包絡を計算する
            object.setLowQuefrency();
            object.setLinearAmplitudedSpectralEnvelope();

            % ケプストラムのインパルス応答を計算する
            object.setImpulseResponseOfCepstrum();

            % ケプストラムのインパルス応答から重畳加算する
            object.repeatNumber = repeatNumber;
            object.peakPointOfCepstrumGain = peakPointOfCepstrumGain;
            object.setSynthesizedSignal();

            % 合成された音声信号を保存する為のパスを設定してデータを保存する
            object.synthesizedFilePath = synthesizedFilePath;
            object.saveSynthesizedSignal();
        end

        %% セッター
        % 開きたい音声信号のパスのセッター
        function set.originalSignalPath(object, originalSignalPath)
            object.originalSignalPath = originalSignalPath;
        end

        % サンプリング周波数のセッター
        function set.samplingFrequency(object, samplingFrequency)
            object.samplingFrequency = samplingFrequency;
        end

        % 開きたい音声信号のデータ型のセッター
        function set.dataType(object, dataType)
            object.dataType = dataType;
        end

        % 信号の中の抽出したい点のセッター
        function set.startPoint(object, startPoint)
            object.startPoint = startPoint;
        end

        % 抽出時間のセッター
        function set.continueTime(object, continueTime)
            object.continueTime = continueTime;
        end

        % FFTの際の次元数のセッター
        function set.FFTPoint(object, FFTPoint)
            object.FFTPoint = FFTPoint;
        end

        % ケプストラムの抽出する最大の次元数のセッター
        function set.maxCepstrumPoint(object, maxCepstrumPoint)
            object.maxCepstrumPoint = maxCepstrumPoint;
        end
 
        % 有声か無声かを判定する為の閾値
        function set.threshold(object, threshold)
            object.threshold = threshold;
        end

        % ケプストラムのピークポイントのセッター
        function set.peakPointOfCepstrum(object, peakPointOfCepstrum)
            object.peakPointOfCepstrum = peakPointOfCepstrum;
        end

        % ケプストラムの最大値のセッター
        function set.maxValueOfCepstrum(object, maxValueOfCepstrum)
            object.maxValueOfCepstrum = maxValueOfCepstrum;
        end

        % 重畳加算する回数のセッター
        function set.repeatNumber(object, repeatNumber)
            object.repeatNumber = repeatNumber;
        end

        % 基本周期の間隔のゲインのセッター
        function set.peakPointOfCepstrumGain(object, peakPointOfCepstrumGain)
            object.peakPointOfCepstrumGain = peakPointOfCepstrumGain;
        end

        % 合成された音声信号の保存先のパス
        function set.synthesizedFilePath(object, synthesizedFilePath)
            object.synthesizedFilePath = synthesizedFilePath;
        end

        %% 引数が無くても自動的に設定出来るセッター
        % 開きたい音声信号のセッター
        function setOriginalSignal(object)
            openedFile = openFile(object.originalSignalPath, "r");
            object.originalSignal = object.readSignal(openedFile);
            closeFile(openedFile);
        end

        % 窓のサイズのセッター
        function setWindowSize(object)
            object.windowSize = floor(object.samplingFrequency * object.continueTime);
        end

        % 窓のセッター
        function setHammingWindow(object)
            object.hammingWindow = 0.54 - 0.46 * cos(2 * (0 : object.windowSize - 1)' * pi / (object.windowSize - 1));
        end

        % 特定の範囲を抽出した音声信号のセッター
        function setExtractedSignal(object)
            object.extractedSignal = object.originalSignal(object.startPoint : object.startPoint + object.windowSize - 1);
        end

        % 窓関数を乗じた後の音声信号のセッター
        function setMultipledSignal(object)
            object.multipledSignal = object.extractedSignal .* object.hammingWindow;
        end

        % 真数振幅スペクトルのセッター
        function setLinearAmplitudedSpectral(object)
            % フーリエ変換を行う
            fastFourierTransformedSignal = fft(object.multipledSignal, object.FFTPoint);
            % 振幅スペクトルを計算する
            object.linearAmplitudedSpectral = sqrt(abs(real(fastFourierTransformedSignal) .^ 2 + imag(fastFourierTransformedSignal) .^ 2));
        end

        % ケプストラムのセッター
        function setCepstrum(object)
            % 自然対数に変換する
            naturalLogarithmAmplitutedSpectral = log(object.linearAmplitudedSpectral);
            % 逆フーリエ変換を行う
            inverseFastFourierTransformedSignal = ifft(naturalLogarithmAmplitutedSpectral);
            % 実部を取得する
            object.cepstrum = real(inverseFastFourierTransformedSignal);   % get real part
        end

        % ケプストラムのピークポイントと最大値のセッター
        function setPeakPointAndMaxValueOfCepstrum(object)
            [object.maxValueOfCepstrum, object.peakPointOfCepstrum] = max(object.cepstrum(object.maxCepstrumPoint : object.FFTPoint / 2));
            object.peakPointOfCepstrum = object.peakPointOfCepstrum + object.maxCepstrumPoint - 1;
            object.checkVoicedSpeechOrNot();
        end

        % 基本周期のセッター
        function setBasicPeriod(object)
            object.basicPeriod = object.peakPointOfCepstrum / object.samplingFrequency;
        end

        % 基本周波数のセッター
        function setBasicFrequency(object)
            object.basicFrequency = 1 / object.basicPeriod;
        end

        % 低ケフレンシーのセッター
        function setLowQuefrency(object)
            object.lowQuefrency = object.cepstrum;    % low quefrency
            object.lowQuefrency(object.maxCepstrumPoint + 1 : object.FFTPoint - object.maxCepstrumPoint) = 0;
        end

        % 真数振幅スペクトル包絡のセッター(ケプストラムから算出)
        function setLinearAmplitudedSpectralEnvelope(object)
            spectralEnvelope = fft(object.lowQuefrency, object.FFTPoint);
            amplitutedSpectralEnvelope = sqrt(abs(real(spectralEnvelope) .^ 2 + imag(spectralEnvelope) .^ 2));
            object.linearAmplitudedSpectralEnvelope = exp(amplitutedSpectralEnvelope);
        end

        % ケプストラムのインパルス応答のセッター
        function setImpulseResponseOfCepstrum(object)
            realPartOfLinearAmplitutedSpectralEnvelope = real(object.linearAmplitudedSpectralEnvelope);
            inverseFourierTransformedSignal = ifft(realPartOfLinearAmplitutedSpectralEnvelope, object.FFTPoint);
            realPartOfInverseFourierTransformedSignal = real(inverseFourierTransformedSignal);
            object.impulseResponseOfCepstrum = fftshift(realPartOfInverseFourierTransformedSignal);
        end

        % ケプストラムのインパルス応答を用いた重畳加算のセッター
        function setSynthesizedSignal(object)
            % 重畳加算用のバッファを確保する
            object.synthesizedSignal = zeros([object.peakPointOfCepstrum * object.peakPointOfCepstrumGain * object.repeatNumber + object.FFTPoint, 1]);

            % 重畳加算する
            for index = 0 : object.repeatNumber
                object.synthesizedSignal(object.peakPointOfCepstrum * object.peakPointOfCepstrumGain * index + 1 : object.peakPointOfCepstrum * object.peakPointOfCepstrumGain * index + object.FFTPoint) = object.synthesizedSignal(object.peakPointOfCepstrum * object.peakPointOfCepstrumGain * index + 1 : object.peakPointOfCepstrum * object.peakPointOfCepstrumGain * index + object.FFTPoint) + object.impulseResponseOfCepstrum(1 : object.FFTPoint);
            end
        end

        %% ゲッター
        % 開きたい音声信号のパスのゲッター
        function originalSignalPath = get.originalSignalPath(object)
            originalSignalPath = object.originalSignalPath;
        end

        % サンプリング周波数のゲッター
        function samplingFrequency = get.samplingFrequency(object)
            samplingFrequency = object.samplingFrequency;
        end

        % 開きたい音声信号のデータ型のゲッター
        function dataType = get.dataType(object)
            dataType = object.dataType;
        end

        % 信号の中の抽出したい点のゲッター
        function startPoint = get.startPoint(object)
            startPoint = object.startPoint;
        end

        % 抽出時間のゲッター
        function continueTime = get.continueTime(object)
            continueTime = object.continueTime;
        end

        % 開きたい音声信号のゲッター
        function originalSignal = get.originalSignal(object)
            originalSignal = object.originalSignal;
        end

        % 窓のサイズのゲッター
        function windowSize = get.windowSize(object)
            windowSize = object.windowSize;
        end

        % 窓のゲッター
        function hammingWindow = get.hammingWindow(object)
            hammingWindow = object.hammingWindow;
        end

        % 特定の範囲を抽出した音声信号のゲッター
        function extractedSignal = get.extractedSignal(object)
            extractedSignal = object.extractedSignal;
        end

        % 窓関数を乗じられた音声信号のゲッター
        function multipledSignal = get.multipledSignal(object)
            multipledSignal = object.multipledSignal;
        end

        % FFTの際の次元数のゲッター
        function FFTPoint = get.FFTPoint(object)
            FFTPoint = object.FFTPoint;
        end

        % 真数振幅スペクトルのゲッター
        function linearAmplitudedSpectral = get.linearAmplitudedSpectral(object)
            linearAmplitudedSpectral = object.linearAmplitudedSpectral;
        end

        % ケプストラムのゲッター
        function cepstrum = get.cepstrum(object)
            cepstrum = object.cepstrum;
        end

        % ケプストラムの抽出する最大の次元数のゲッター
        function maxCepstrumPoint = get.maxCepstrumPoint(object)
            maxCepstrumPoint = object.maxCepstrumPoint;
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

        % 低ケフレンシーのゲッター
        function lowQuefrency = get.lowQuefrency(object)
            lowQuefrency = object.lowQuefrency;
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

        % 基本周期の間隔のゲインのセッター
        function peakPointOfCepstrumGain = get.peakPointOfCepstrumGain(object)
            peakPointOfCepstrumGain = object.peakPointOfCepstrumGain;
        end

        % 合成された音声信号の保存先のパス
        function synthesizedFilePath = get.synthesizedFilePath(object)
            synthesizedFilePath = object.synthesizedFilePath;
        end

        %% その他諸々のメソッド
        % ファイルを開くメソッド
        function openedFile = openFile(filePath, permission)
            % ファイルを開く
            [openedFile, errmsg] = fopen(filePath, permission);

            % 例外処理
            if openedFile < 0
                disp('openedFile : ', openedFile);
                disp('errmsg : ', errmsg);
            else
                disp('Could open file correctly');
            end
        end

        % ファイルオブジェクトからファイルを読み込むメソッド
        function signal = readSignal(object, openedFile)
            signal = fread(openedFile, object.dataType);
        end

        % ファイルオブジェクトを閉じるメソッド
        function closeFile(openedFile)
            % ファイルオブジェクトを閉じる
            status = fclose(openedFile);

            % error exception
            if status == 0
                disp('Could close file correctly')
            else
                disp('Can not close file correctly')
            end
        end

        % 入力された信号が有声か無声か判定するメソッド
        function checkVoicedSpeechOrNot(object)
            if object.maxValueOfCepstrum < object.threshold
                object.peakPointOfCepstrum = 0;
            end
        end

        % 合成された音声信号をファイルに書き込むメソッド
        function writeSignal(object, openedFile)
            fwrite(openedFile, object.synthesizedSignal, object.dataType);
        end

        % 合成された音声信号を保存するメソッド
        function saveSynthesizedSignal(object)
            openedFile = openFile(object.synthesizedFilePath, "w");
            object.writeSignal(openedFile);
            closeFile(openedFile);
        end

        % 環境を一度リセットするmethod
        function clearEnviornments(object)
            clear variables;  % clear viriables
            clc % clear comand window
        end
    end
end