function [ output_args ] = calculationPhoneme( phoneme_list, ATR_allDcep )
%

phoneme = dec_phonemeValueCell(phoneme_v_list);
phoneme_nv = dec_phonemeValueCell(phoneme_nv_list);
phoneme_c = dec_phonemeValueCell(phoneme_c_list);
phoneme_etc = dec_phonemeValueCell(phoneme_etc_list);
for ii =  1:length(ATR_allDcep),
    if strcmp(ATR_allDcep(ii).phoneme,phoneme_list) == 1,
        phoneme{i}.sum = phoneme{i}.sum + ATR_allDcep(ii).dcep;
        phoneme{i}.num = phoneme{i}.num + 1;
    end
end

end

