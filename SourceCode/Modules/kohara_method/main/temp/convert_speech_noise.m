%4モーラ単語リストの音声のサンプリング周波数を変換した音声を出力し、STRAIGHTスペクトログラムも求めて出力する%
clear all
% inputDirName = 'C:\Users\share\Documents\shibata_original\voice_data\';
inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\sample\JNAS\';
inputVOLName = char( ...
    'VOL1\DAT\', ...
    'VOL2\DAT\',...
    'VOL3\DAT\');

inputDirName3 = char( ...
    'CAN0001\','CAN0002\','CAN1001\','CAN1002\', ...
    'ECL0001\','ECL0002\','ECL1003\','ECL1004\','ECL1007\','ECL1008\', ...
    'MIT0001\','MIT0002\','MIT1001\','MIT1002\', ...
    'NEC0001\','NEC0002\','NEC1001\','NEC1002\', ...
    'TSU0001\','TSU0003\','TSU1001\','TSU1002\', ...  
    'ECL0005\','ECL0006\', ...
    'ETL0001\','ETL0004\','ETL1001\','ETL1002\', ...
    'KDD1001\','KDD1002\','KDD1003\','KDD1004\', ...
    'MAC0001\','MAC0002\','MAC1001\','MAC1002\', ...
    'MAT0001\','MAT0002\','MAT1001\','MAT1002\', ...
    'SHA0001\','SHA0002\','SHA1001\','SHA1002\', ... 
    'FUJ0001\','FUJ0002\','FUJ1001\','FUJ1002\', ...
    'HIT0001\','HIT0002\','HIT1001\','HIT1002\', ...
    'RIC0001\','RIC0002\','RIC1001\','RIC1002\', ...
    'SON0001\','SON0002\','SON1001\','SON1002\', ...
    'TOS0001\','TOS0002\','TOS1001\','TOS1002\');

inputDirName_ATRtype = 'A\';

% inputDirName2{1} = 'shibata\';
% inputDirName2{2} = 'kitaoka\';
% inputDirName2{3} = 'kawakami\';
% inputDirName3 = 'sf_22050Hz\';

outputDirName = '../voice_data/sample/';
s_num = 1;
e_num = 5;

fs = 16000;

for m =1:size(inputDirName3,1),
    if 1 <= m && m <= 22,
        inputDirName2 = inputVOLName(1,:);
    elseif 23 <= m && m <= 44,
        inputDirName2 = inputVOLName(2,:);
    elseif 45 <= m && m <= 64,
        inputDirName2 = inputVOLName(3,:);
    end
%     keyboard
    for n = s_num:e_num,
        inputName = ['A' num2str(n, '%02d')];

        outputName = ['SN_ATR' num2str(n, '%02d') '_' num2str(m, '%02d')];

        %通常音声
        [X_in,fs_in] = audioread([inputDirName inputDirName2 inputDirName3(m,:) inputDirName_ATRtype inputName '.wav']);
        if fs ~= fs_in,
            X_in = sfconv(X_in,fs_in,fs);
        end
%         [f0raw, ap] = exstraightsource(X, fs);
% 
%         [n3sgram] = exstraightspec(X, f0raw, fs);
% 
%         save ([outputDirName 'mat/ATR_16kHz/' outputName_AN], 'X', 'fs', 'f0raw', 'ap','n3sgram');

        audiowrite([outputDirName 'wav/speech_noise/' outputName '.wav'],X_in, fs, 'BitsPerSample',24)

        %明瞭音声
%         [X_in,fs_in] = audioread([inputDirName inputName_AC '.wav']);
%         X = sfconv(X_in,fs_in,fs);
% 
%         [f0raw, ap] = exstraightsource(X, fs);
% 
%         [n3sgram] = exstraightspec(X, f0raw, fs);
% 
%         save ([outputDirName 'mat/ATR_16kHz/' outputName_AC], 'X', 'fs', 'f0raw', 'ap','n3sgram');
% 
%         audiowrite([outputDirName 'wav/ATR_16kHz/' outputName_AC '.wav'],X, fs, 'BitsPerSample',24)

        %ラベルtxt→matファイルに
    %     label_AN = sploadlabel([inputDirName inputName_AN '_lab.txt'],'sec',1);
    %     label_AC = sploadlabel([inputDirName inputName_AC '_lab.txt'],'sec',1);
    %     
    %     save ([outputDirName 'label/ATR_16kHz/' outputName_AN '_label'], 'label_AN');
    %     save ([outputDirName 'label/ATR_16kHz/' outputName_AC '_label'], 'label_AC');
    %     keyboard
    end
end

% for m =1:3,
%     for n = s_num:e_num,
%         inputName_AN = ['AN' num2str(n, '%02d')];
% %         inputName_AC = ['AC' num2str(n, '%02d')];
% 
%         outputName_AN = ['AN' num2str(n, '%02d')];
% %         outputName_AC = ['AC' num2str(n, '%02d')];
%     %     outputName_AN = ['sample Normal' num2str(n)];
%     %     outputName_AC = ['sample Clear' num2str(n)];
% 
% 
%         %通常音声
%         [X_in,fs_in] = audioread([inputDirName inputDirName2{m} inputDirName3 inputName_AN '.wav']);
%         X = sfconv(X_in,fs_in,fs);
% 
% %         [f0raw, ap] = exstraightsource(X, fs);
% % 
% %         [n3sgram] = exstraightspec(X, f0raw, fs);
% % 
% %         save ([outputDirName 'mat/ATR_16kHz/' outputName_AN], 'X', 'fs', 'f0raw', 'ap','n3sgram');
% 
%         audiowrite([outputDirName 'wav/speech_noise/' outputName_AN '_' num2str(m) '.wav'],X, fs, 'BitsPerSample',24)
% 
%         %明瞭音声
% %         [X_in,fs_in] = audioread([inputDirName inputName_AC '.wav']);
% %         X = sfconv(X_in,fs_in,fs);
% % 
% %         [f0raw, ap] = exstraightsource(X, fs);
% % 
% %         [n3sgram] = exstraightspec(X, f0raw, fs);
% % 
% %         save ([outputDirName 'mat/ATR_16kHz/' outputName_AC], 'X', 'fs', 'f0raw', 'ap','n3sgram');
% % 
% %         audiowrite([outputDirName 'wav/ATR_16kHz/' outputName_AC '.wav'],X, fs, 'BitsPerSample',24)
% 
%         %ラベルtxt→matファイルに
%     %     label_AN = sploadlabel([inputDirName inputName_AN '_lab.txt'],'sec',1);
%     %     label_AC = sploadlabel([inputDirName inputName_AC '_lab.txt'],'sec',1);
%     %     
%     %     save ([outputDirName 'label/ATR_16kHz/' outputName_AN '_label'], 'label_AN');
%     %     save ([outputDirName 'label/ATR_16kHz/' outputName_AC '_label'], 'label_AC');
%     %     keyboard
%     end
% end