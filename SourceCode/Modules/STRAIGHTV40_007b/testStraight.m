clear variables;
clear clc;

inputFilePath = "vaiueo2d.wav";
audioFileManipulator = AudioFileManipulator( ...
    inputFilePath ...
);

for index = 0.4 : 0.2 : 2.0
    %% パラメータを設定
    synthesizeParamters.pconv = index;    % 基本周波数利得
    synthesizeParamters.fconv = index;    % 周波数軸変換利得
    synthesizeParamters.sconv = 1.0;    % 時間軸変換利得
    outputFilePath = "vaiued2d_straight_pconv" + num2str(synthesizeParamters.pconv) + "_fconv" + num2str(synthesizeParamters.fconv) + ".wav";
    
    % 音声ファイルの量子化ビット数を16[bit]に変換する
    audioFileManipulator.quantize();
    
    % 基本周波数と非周期性パラメータを抽出する
    [basicFrequency, aperiodicityParameter] = exstraightsource(audioFileManipulator.signal, audioFileManipulator.information.SampleRate);
    fprintf("basic frequency size : (%d, %d)\n", size(basicFrequency));
    fprintf("aperiodicity parameter size : (%d, %d)\n", size(aperiodicityParameter));
    
    % スペクトログラムを取得する
    spectrogram = exstraightspec(audioFileManipulator.signal, basicFrequency, audioFileManipulator.information.SampleRate);
    
    % 音声合成を行う
    synthesizedSignal = exstraightsynth(basicFrequency, spectrogram, aperiodicityParameter, audioFileManipulator.information.SampleRate, synthesizeParamters);
    
    % スペクトログラムを表示して再生する
    dispsgram(spectrogram, audioFileManipulator.information.SampleRate);
    soundsc(synthesizedSignal, audioFileManipulator.information.SampleRate);
    
    % 生成した変数を保存する
    save("vaiueo2d", "basicFrequency", "aperiodicityParameter", "spectrogram");
    synthesizedSignal = synthesizedSignal ./ (2 ^ (audioFileManipulator.information.BitsPerSample - 1));
    audioFileManipulator.saveWaveFile(outputFilePath, synthesizedSignal);
end