%4モーラ単語リストの音声のサンプリング周波数を変換した音声を出力し、STRAIGHTスペクトログラムも求めて出力する%
clear all
inputDirName = 'C:\Users\share\Documents\shibata_original\voice_data\shibata\sf_22050Hz\';
outputDirName = '../voice_data/sample/';
s_num = 1;
e_num = 50;

fs = 16000;

for n = s_num:e_num,
    inputName_AN = ['AN' num2str(n, '%02d')];
    inputName_AC = ['AC' num2str(n, '%02d')];
    
    outputName_AN = ['AN' num2str(n, '%02d')];
    outputName_AC = ['AC' num2str(n, '%02d')];
%     outputName_AN = ['sample Normal' num2str(n)];
%     outputName_AC = ['sample Clear' num2str(n)];

    
    %通常音声
    [X_in,fs_in] = audioread([inputDirName inputName_AN '.wav']);
    X = sfconv(X_in,fs_in,fs);

    [f0raw, ap] = exstraightsource(X, fs);

    [n3sgram] = exstraightspec(X, f0raw, fs);

    save ([outputDirName 'mat/ATR_16kHz/' outputName_AN], 'X', 'fs', 'f0raw', 'ap','n3sgram');
    
    audiowrite([outputDirName 'wav/ATR_16kHz/' outputName_AN '.wav'],X, fs, 'BitsPerSample',24)
    
    %明瞭音声
    [X_in,fs_in] = audioread([inputDirName inputName_AC '.wav']);
    X = sfconv(X_in,fs_in,fs);
    
    [f0raw, ap] = exstraightsource(X, fs);

    [n3sgram] = exstraightspec(X, f0raw, fs);

    save ([outputDirName 'mat/ATR_16kHz/' outputName_AC], 'X', 'fs', 'f0raw', 'ap','n3sgram');
    
    audiowrite([outputDirName 'wav/ATR_16kHz/' outputName_AC '.wav'],X, fs, 'BitsPerSample',24)
    
    %ラベルtxt→matファイルに
%     label_AN = sploadlabel([inputDirName inputName_AN '_lab.txt'],'sec',1);
%     label_AC = sploadlabel([inputDirName inputName_AC '_lab.txt'],'sec',1);
%     
%     save ([outputDirName 'label/ATR_16kHz/' outputName_AN '_label'], 'label_AN');
%     save ([outputDirName 'label/ATR_16kHz/' outputName_AC '_label'], 'label_AC');
%     keyboard
end