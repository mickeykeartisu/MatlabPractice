%% initialize environments
clc;
clear variables;

phoneme_counter_path = "D:/名城大学/研究室/研究/Sources/MatFiles/4モーラ単語リスト/Set1/phoneme_dictionary/phoneme_dictionary.mat";
phoneme_counter = load(phoneme_counter_path);
phoneme_counter = phoneme_counter.phoneme_counter;

phoneme_keys_list = keys(phoneme_counter);

for phoneme_key_index = 1 : length(phoneme_keys_list)
    fprintf("%s : %d,\t", phoneme_keys_list(phoneme_key_index), int32(phoneme_counter(phoneme_keys_list(phoneme_key_index)) / 4));
    if mod(phoneme_key_index, 9) == 0
        fprintf("\n");
    end
end