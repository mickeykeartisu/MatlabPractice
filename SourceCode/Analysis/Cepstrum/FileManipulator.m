classdef FileManipulator < handle
    %% プロパティ
    properties(SetAccess = private)
        inputFilePath   % 開きたいデータのパス(.raw形式)
        outputFilePath  % 保存先のパス(.raw)
        samplingFrequency   % サンプリング周波数
        dataType    % 開きたい音声信号のデータ型
        originalSignal  % 開いた音声信号
    end

    %% メソッド
    methods
        %% コンストラクタ
        function object = FileManipulator(inputFilePath, outputFilePath, samplingFrequency, dataType)
            % それぞれのパラメータを読み取る
            object.inputFilePath = inputFilePath;
            object.outputFilePath = outputFilePath;
            object.samplingFrequency = samplingFrequency;
            object.dataType = dataType;

            % ファイルから信号を読み取る
            object.readSignal();

            % データを表示する
            object.displayProperties();
        end

        %% セッター
        % 開きたい音声信号のパスのセッター
        function set.inputFilePath(object, inputFilePath)
            if inputFilePath == ""
                throw(MException("Setter:inputFilePath", "input file path is empty."))
            end
            object.inputFilePath = inputFilePath;
        end

        % サンプリング周波数のセッター
        function set.samplingFrequency(object, samplingFrequency)
            if samplingFrequency <= 0
                throw(MException("Setter:samplingFrequency", "sampling frequency is smaller than 0."))
            end
            object.samplingFrequency = samplingFrequency;
        end

        % データタイプのセッター
        function set.dataType(object, dataType)
            if dataType == ""
                throw(MException("Setter:dataType", "data type is empty."))
            end
            object.dataType = dataType;
        end

        % 信号のセッター
        function set.originalSignal(object, originalSignal)
            object.originalSignal = originalSignal;
        end

        % 出力先のパスのセッター
        function set.outputFilePath(object, outputFilePath)
            if outputFilePath == ""
                throw(MException("Setter:outputFilePath", "output file path is empty."))
            end
            object.outputFilePath = outputFilePath;
        end

        %% ゲッター
        % 開きたい音声信号のパスのゲッター
        function inputFilePath = get.inputFilePath(object)
            inputFilePath = object.inputFilePath;
        end

        % サンプリング周波数のゲッター
        function samplingFrequency = get.samplingFrequency(object)
            samplingFrequency = object.samplingFrequency;
        end

        % 開きたい音声信号のデータ型のゲッター
        function dataType = get.dataType(object)
            dataType = object.dataType;
        end

        % 読み込んだ信号のゲッター
        function originalSignal = get.originalSignal(object)
            originalSignal = object.originalSignal;
        end

        % 出力先のファイルパスのゲッター
        function outputFilePath = get.outputFilePath(object)
            outputFilePath = object.outputFilePath;
        end

        %% 普通のメソッド
        % ファイルオブジェクトからファイルを読み込むメソッド
        function readSignal(object)
            openedFile = openFile(object.inputFilePath, "r");
            object.originalSignal = fread(openedFile, object.dataType);
            closeFile(openedFile);
        end

        % 合成された音声信号を保存するメソッド
        function writeSignal(object, signal)
            openedFile = openFile(object.outputFilePath, "w");
            fwrite(openedFile, signal, object.dataType);
            closeFile(openedFile);
        end

        % プロパティを表示するメソッド
        function displayProperties(object)
            fprintf("------------------------------------------------\n");
            fprintf("---------------- FileManipulator ---------------\n");
            fprintf("input file path : %s\n", object.inputFilePath);
            fprintf("output file path : %s\n", object.outputFilePath);
            fprintf("sampling frequency : %d [Hz]\n", object.samplingFrequency)
            fprintf("data type : %s\n", object.dataType);
            fprintf("original signal size : (%d, %d)\n", size(object.originalSignal));
            fprintf("------------------------------------------------\n\n");
        end
    end
end

% ファイルを開くメソッド
function openedFile = openFile(filePath, permission)
    % ファイルを開く
    [openedFile, errmsg] = fopen(filePath, permission);

    % 例外処理
    if openedFile < 0
        fprintf('openedFile : %d\n', openedFile);
        fprintf('errmsg : %s\n\n', errmsg);
    else
        fprintf('Could open file correctly\n');
    end
end

% ファイルオブジェクトを閉じるメソッド
function closeFile(openedFile)
    % ファイルオブジェクトを閉じる
    status = fclose(openedFile);

    % ファイルを閉じれた場合
    if status == 0
        fprintf("Could close file correctly\n\n");
    else
        fprintf("Could not close file correctly\n\n");
    end
end