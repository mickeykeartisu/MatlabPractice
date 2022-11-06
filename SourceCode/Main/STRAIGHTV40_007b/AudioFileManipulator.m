%% 音声ファイルを操作するクラス
classdef AudioFileManipulator < handle
    %% プロパティ
    properties(SetAccess = private)
        signal
        information
    end

    %% メソッド
    methods
        %% デフォルトコンストラクタ
        function object = AudioFileManipulator(inputFilePath)
            object.readProperties(inputFilePath);    % 音声データを読み込む
            object.displayProperties();
        end

        %% セッター
        % 音声信号のセッター
        function set.signal(object, signal)
            if length(signal) <= 0
                thorw(MException("Setter:signal", "signal length is smaller than 0"))
            end
            object.signal = signal;
        end

        % 音声の情報のセッター
        function set.information(object, information)
            object.information = information;
        end

        %% ゲッター
        % 音声信号のゲッター
        function signal = get.signal(object)
            signal = object.signal;
        end

        % 音声信号の情報を扱う構造体のゲッター
        function information = get.information(object)
            information = object.information;
        end

        %% その他のメソッド
        % 音声データを読み取るメソッド
        function readProperties(object, inputFilePath)
            [object.signal, waste] = audioread(inputFilePath);
            object.information = audioinfo(inputFilePath);
        end

        % 読み込んだ信号をその量子化ビット数に変換する
        function quantize(object)
            object.signal = object.signal .* (2 ^ (object.information.BitsPerSample - 1));
        end

        % プロパティを出力するメソッド
        function displayProperties(object)
            fprintf("-----------------------------------------------------------------------\n");
            fprintf("------------------ Audio File Manipulator Properties ------------------\n");
            fprintf("input file path : %s\n", object.information.Filename);
            fprintf("channel : %d [channel]\n", object.information.NumChannels);
            fprintf("sampling rate : %d [Hz]\n", object.information.SampleRate);
            fprintf("total sample : %d [sample]\n", object.information.TotalSamples);
            fprintf("bit per sample : %d [bit]\n", object.information.BitsPerSample);
            fprintf("signal shape : (%d, %d)\n", size(object.signal));
            fprintf("-----------------------------------------------------------------------\n\n");
        end
    end
end