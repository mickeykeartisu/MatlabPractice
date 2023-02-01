%%CSVì«Ç›éÊÇËÉeÉXÉg
Dirname = 'C:\Users\share\Documents\Subjective evaluation tools\Subjective_evaluation_data\output\';

foldername = 'ñæóƒê´å¸è„ï]âø' ;
% foldername = 'ñæóƒê´å¸è„ï]âøÅiÉmÉCÉYÇ†ÇËÅj/70dB-67dB' ;

inputDirname = [Dirname foldername '/'];
outputDirname = [Dirname foldername '/'];
filename = 'all_confusion_'; 

% file_type_list{1} = 'normalization';
% file_type_list{2} = '3dB_16band_hanning0Hz_normalization';
% file_type_list{3} = '3dB_16band_hanning500Hz_normalization';
% file_type_list{4} = 'PeakHz16_lin_3';

if strcmp(foldername,'ñæóƒê´å¸è„ï]âø') == 1,
    file_type_list = char( ...
    'normalization30dB', ...
    '6dB_16band_hanning500Hz_Gainlimit9dB_normalization30dB',...
    'PeakHz16_lin_6'); 
end

if strcmp(foldername,'ñæóƒê´å¸è„ï]âøÅiÉmÉCÉYÇ†ÇËÅj/70dB-67dB') == 1,
    file_type_list = char( ...
        'add_noise_speech70dB_noise67dB', ...
        'PeakHz16_lin_6_add_noise_speech70dB_noise67dB',...
        '6dB_16band_hanning500Hz_Gainlimit9dB_add_noise_speech70dB_noise67dB'); 
end

% keyboard
% file_type_list = char( ...
%     'normalization', ...
%     '3dB_16band_hanning0Hz_normalization',...
%     '3dB_16band_hanning500Hz_normalization',...
%     'PeakHz16_lin_3'); 
% size(file_type_list,1)
% keyboard

masatsu_list = {'f', 's','S','h','hj'};
hasatsu_list = {'dz','ts','d3','tS'};
haretsu_list = {'b', 'p', 'd','t', 'g', 'k', 'kj'};
hanboin_list = {'w','r','j','rj'};
bion_list = {'m','n','nj','N'};

% masatsu_list = {'f', 's','S','h'};
% hasatsu_list = {'dz','ts','d3','tS'};
% haretsu_list = {'b', 'p', 'd','t', 'g', 'k'};
% hanboin_list = {'w','r','j'};
% bion_list = {'m','n','N'};

phoneme = {'m','p','b','t','d','s','ts','dz','r','n','S','tS','d3','k','g','h','hj','f','mj','pj','bj','kj','gj','rj','nj','w','j','N','Q','.','a','i','u','e','o'};
phoneme_correct = cell(1,size(file_type_list,1));
masatsu_correct = cell(1,size(file_type_list,1));
hasatsu_correct = cell(1,size(file_type_list,1));
haretsu_correct = cell(1,size(file_type_list,1));
hanboin_correct = cell(1,size(file_type_list,1));
bion_correct = cell(1,size(file_type_list,1));

masatsu_correct_rate = zeros(1,size(file_type_list,1));
hasatsu_correct_rate = zeros(1,size(file_type_list,1));
haretsu_correct_rate = zeros(1,size(file_type_list,1));
hanboin_correct_rate = zeros(1,size(file_type_list,1));
bion_correct_rate = zeros(1,size(file_type_list,1));

% masatsu_correct = zeros(1,size(file_type_list,1));
% hasatsu_correct = zeros(1,size(file_type_list,1));
% haretsu_correct = zeros(1,size(file_type_list,1));
% hanboin_correct = zeros(1,size(file_type_list,1));
% bion_correct = zeros(1,size(file_type_list,1));

count = 0;
for i = 1:size(file_type_list,1);
%     readname = [filename file_type_list{i} '_mean_normalized.csv'];
    readname = [inputDirname filename deblank(file_type_list(i,:)) '_mean.csv'];
%     keyboard
    M = csvread(readname,1,1);
    
%     keyboard
    
    for ii = 1:size(M,1)-1,
        s.phoneme = phoneme{ii};
        s.n_correct = M(ii,ii);
        s.n_answer = M(ii,end);
        phoneme_correct{i}(ii) = s;
%         keyboard
    end
%     
    %ñÄéCâπ
    masatsu_correct{i}.n_correct = 0;
    masatsu_correct{i}.n_answer = 0;
    for m = 1:length(masatsu_list),
        for ii = 1:length(phoneme_correct{i}),
            if strcmp(phoneme_correct{i}(ii).phoneme,masatsu_list{m}) == 1,
                masatsu_correct{i}.n_correct = masatsu_correct{i}.n_correct + phoneme_correct{i}(ii).n_correct;
                masatsu_correct{i}.n_answer = masatsu_correct{i}.n_answer + phoneme_correct{i}(ii).n_answer;
%                 masatsu_correct{i} = masatsu_correct(i) + phoneme_correct{i}(ii).rate;
%                 count = count + 1;
            end
        end
    end
    masatsu_correct{i}.correct_rate = masatsu_correct{i}.n_correct / masatsu_correct{i}.n_answer * 100;
%     count = 0;
%     keyboard    

    %îjéC
    hasatsu_correct{i}.n_correct = 0;
    hasatsu_correct{i}.n_answer = 0;
    for m = 1:length(hasatsu_list),
        for ii = 1:length(phoneme_correct{i}),
            if strcmp(phoneme_correct{i}(ii).phoneme,hasatsu_list{m}) == 1,
                hasatsu_correct{i}.n_correct = hasatsu_correct{i}.n_correct + phoneme_correct{i}(ii).n_correct;
                hasatsu_correct{i}.n_answer = hasatsu_correct{i}.n_answer + phoneme_correct{i}(ii).n_answer;
%                 hasatsu_correct(i) = hasatsu_correct(i) + phoneme_correct{i}(ii).rate;
%                 count = count + 1;
            end
        end
    end
    hasatsu_correct{i}.correct_rate = hasatsu_correct{i}.n_correct / hasatsu_correct{i}.n_answer * 100;
%     hasatsu_correct(i) = hasatsu_correct(i) / count;
%     count = 0;
    
    %îjóÙ
    haretsu_correct{i}.n_correct = 0;
    haretsu_correct{i}.n_answer = 0;
    for m = 1:length(haretsu_list),
        for ii = 1:length(phoneme_correct{i}),
            if strcmp(phoneme_correct{i}(ii).phoneme,haretsu_list{m}) == 1,
                haretsu_correct{i}.n_correct = haretsu_correct{i}.n_correct + phoneme_correct{i}(ii).n_correct;
                haretsu_correct{i}.n_answer = haretsu_correct{i}.n_answer + phoneme_correct{i}(ii).n_answer;
%                 haretsu_correct(i) = haretsu_correct(i) + phoneme_correct{i}(ii).rate;
%                 count = count + 1;
            end
        end
    end
    haretsu_correct{i}.correct_rate = haretsu_correct{i}.n_correct / haretsu_correct{i}.n_answer * 100;
%     haretsu_correct(i) = haretsu_correct(i) / count;
%     count = 0;
    
    %îºïÍâπ
    hanboin_correct{i}.n_correct = 0;
    hanboin_correct{i}.n_answer = 0;
    for m = 1:length(hanboin_list),
        for ii = 1:length(phoneme_correct{i}),
            if strcmp(phoneme_correct{i}(ii).phoneme,hanboin_list{m}) == 1,
                hanboin_correct{i}.n_correct = hanboin_correct{i}.n_correct + phoneme_correct{i}(ii).n_correct;
                hanboin_correct{i}.n_answer = hanboin_correct{i}.n_answer + phoneme_correct{i}(ii).n_answer;
%                 hanboin_correct(i) = hanboin_correct(i) + phoneme_correct{i}(ii).rate;
%                 count = count + 1;
            end
        end
    end
    hanboin_correct{i}.correct_rate = hanboin_correct{i}.n_correct / hanboin_correct{i}.n_answer * 100;
%     hanboin_correct(i) = hanboin_correct(i) / count;
%     count = 0;
    
    %ï@âπ
    bion_correct{i}.n_correct = 0;
    bion_correct{i}.n_answer = 0;
    for m = 1:length(bion_list),
        for ii = 1:length(phoneme_correct{i}),
            if strcmp(phoneme_correct{i}(ii).phoneme,bion_list{m}) == 1,
                bion_correct{i}.n_correct = bion_correct{i}.n_correct + phoneme_correct{i}(ii).n_correct;
                bion_correct{i}.n_answer = bion_correct{i}.n_answer + phoneme_correct{i}(ii).n_answer;
%                 bion_correct(i) = bion_correct(i) + phoneme_correct{i}(ii).rate;
%                 count = count + 1;
            end
        end
    end
    bion_correct{i}.correct_rate = bion_correct{i}.n_correct / bion_correct{i}.n_answer * 100;
%     bion_correct(i) = bion_correct(i) / count;
%     count = 0;

    masatsu_correct_rate(i) = masatsu_correct{i}.correct_rate;
    hasatsu_correct_rate(i)  = hasatsu_correct{i}.correct_rate;
    haretsu_correct_rate(i)  = haretsu_correct{i}.correct_rate;
    hanboin_correct_rate(i)  = hanboin_correct{i}.correct_rate;
    bion_correct_rate(i)  = bion_correct{i}.correct_rate;
end

correct_list_file = [outputDirname 'correct_rate_of_Manner_of_articulation.csv'];
fid = fopen(correct_list_file, 'w');
fprintf(fid, ['Manner of articulation ,masatsu, hasatsu, haretsu, hanboin, bion\n']);
for i = 1:size(file_type_list,1); 
        fprintf(fid, '%s, %d, %d, %d, %d, %d\n', ...
      deblank(file_type_list(i,:)), ...
      masatsu_correct_rate(i), ...
      hasatsu_correct_rate(i), ...
      haretsu_correct_rate(i), ...
      hanboin_correct_rate(i), ...
      bion_correct_rate(i) );
end
fclose(fid);
% phoneme_correct

% masatsu_correct_rate = [masatsu_correct{1}.correct_rate, masatsu_correct{2}.correct_rate, masatsu_correct{3}.correct_rate, masatsu_correct{4}.correct_rate];
% hasatsu_correct_rate = [hasatsu_correct{1}.correct_rate, hasatsu_correct{2}.correct_rate, hasatsu_correct{3}.correct_rate, hasatsu_correct{4}.correct_rate];
% haretsu_correct_rate = [haretsu_correct{1}.correct_rate, haretsu_correct{2}.correct_rate, haretsu_correct{3}.correct_rate, haretsu_correct{4}.correct_rate];
% hanboin_correct_rate = [hanboin_correct{1}.correct_rate, hanboin_correct{2}.correct_rate, hanboin_correct{3}.correct_rate, hanboin_correct{4}.correct_rate];
% bion_correct_rate = [bion_correct{1}.correct_rate, bion_correct{2}.correct_rate, bion_correct{3}.correct_rate, bion_correct{4}.correct_rate];


% correct_csv = [masatsu_correct_rate;hasatsu_correct_rate;haretsu_correct_rate;hanboin_correct_rate;bion_correct_rate];

% csvwrite('correct_rate of Manner_of_articulation.csv',correct_csv)
% type correct_rate of Manner_of_articulation.csv