clear all

soundfile_folder = 'C:/work/matlab/folder_sound/';
save_folder = 'C:/work/matlab/prog_tsukuda/ana_baion/';
%save_fig_folder = 'C:/work/matlab/prog_tsukuda/ana_baion/';

band_par = 0.1;
Fs = 48000;
sidelobe = 80;
gain = 1;
%max number of analysis
baion_max = 6;

%frameSize[ms], frameShift[ms]
frame_ms = 30;
shift_ms = 10;

frame_len = (Fs/1000) * frame_ms;
shift_len = (Fs/1000) * shift_ms;

% k=1: normal, k=2: straight, k=3: gestopft
% l=1: lowB, l=2: midF, l=3: midB, l=4: highF

%open the file to write the f0
fileID = fopen([save_folder 'f0.txt'], 'w');

for k = 1: 3
    %update sound_type
    if (k == 1)
        sound_type = 'normal';
    elseif (k == 2)
            sound_type = 'straight';
    else
        sound_type ='gestopft';
    end
    for l = 1: 4
        
        takasa_no = l;
        
        [sig, ~] = audioread([soundfile_folder sound_type '-' num2str(takasa_no) '.wav']);
        
        frame_n = floor((length(sig)/(Fs/1000)-frame_ms) / shift_ms);

        %average of f0
        [f0_mean] = rms_f0(sig, Fs, sound_type, takasa_no);
        %write the f0_mean to the txt file
        fprintf(fileID, '%3.3f', f0_mean);
        if(l == 4)
            fprintf(fileID, '\n');
        else
            fprintf(fileID, ',');
        end
        
        %parameter of bandpass filter
        hp_cutoff = 0;
        lp_cutoff = 0;
        nyquist = Fs/2;
        trans = 10 / nyquist;
        rms_ii_baion = cell(baion_max, 1);
        fl = cell(baion_max,1);

        for ii = 1: 1: baion_max
           hp_cutoff = (1/nyquist*(f0_mean*ii)) - ((1/nyquist*(f0_mean*ii)) * band_par);
           lp_cutoff = (1/nyquist*(f0_mean*ii)) + ((1/nyquist*(f0_mean*ii)) * band_par);
           [filt] = bandpass(hp_cutoff, lp_cutoff, sidelobe, trans, gain);
%           fvtool(filt, 'Analysis', 'freq');
           
           %compensates for a delay to the midpoint of the impulse response
           if (ii == 1)
              [wav, ~, ~] = wavcut(sig, Fs, frame_ms, shift_ms, frame_n, filt);
              wav = (wav / max(abs(wav)))*0.5;
            end

           fl{ii} = filt;
           band = fftfilt(filt, wav);
           [rms_db] = rms_cmand(band, Fs, frame_ms, shift_ms);
           rms_ii_baion{ii} = rms_db;
        end        
        baion_rms_plot(shift_ms, rms_ii_baion, baion_max, ...
                       sound_type, takasa_no, save_folder);        
    end    
end
fclose(fileID);

%fvtool(fl{1},1,fl{2},1,fl{3},1,fl{4},1,fl{5},1,fl{6}, 'Analysis', 'freq');