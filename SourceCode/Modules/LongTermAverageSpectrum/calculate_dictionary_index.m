function [index] = calculate_dictionary_index(dictionary, key)
    index = 1;
    key_list = keys(dictionary);
    for key_index = 1 : length(key_list)
        if key_list(key_index) == key
            index = key_index;
            break;
        end
    end
end