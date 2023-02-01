inputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shinmitsu_takeuchi\';
outputDirName = 'C:\Users\share\Documents\MATLAB\voice_data\sample\wav\shinmitsu_takeuchi\cut\';

% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_02';
% s_p = 117618;
% e_p = 4686130;
% temp = 0;
% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_05';
% s_p = 152666;
% e_p = 4681745;
% temp = 50;
% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_06';
% s_p = 191876;
% e_p = 4596835;
% temp = 100;
% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_08';
% s_p = 242801;
% e_p = 4475420;
% temp = 150;
% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_11';
% s_p = 109490;
% e_p = 4591959;
% temp = 200;
% inputName = 'no_shinmitsu_BPM140_48k_24bit_NE_13';
% s_p = 148475;
% e_p = 4818016;
% temp = 250;

% inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_05';
% s_p = 116236;
% e_p = 4624969;
% temp = 0;
% inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_07';
% s_p = 252803;
% e_p = 4937865;
% temp = 50;
% inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_08';
% s_p = 121238;
% e_p = 4610062;
% temp = 100;
% inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_11';
% s_p = 112456;
% e_p = 4666912;
% temp = 150;
% inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_14';
% s_p = 231831;
% e_p = 5059956;
% temp = 200;
inputName = 'cl_shinmitsu_BPM140_48k_24bit_NE_16';
s_p = 118263;
e_p = 4615286;
temp = 250;


[X,fs]= audioread([inputDirName inputName '.wav']);
nbit = audioinfo([inputDirName inputName '.wav']);
nbit = nbit.BitsPerSample;

% spl = getsplsig(X.*2^(nbits-1), fs, 10);
% figure
% plot(X);
% keyboard

% figure
% plot(abs(X(3122828:3149825)));
% mean(abs(X(3122828:3149825)))
% keyboard
thre_v = 0.01;
thre_v2 = 0.01;
thre_l = 400;
edge_l = 200;
speech_l = 100;

X_cut = cut_wav( X, fs, thre_v, thre_v2, thre_l, edge_l, speech_l,s_p,e_p);

keyboard

%âπê∫èëÇ´çûÇ›
for n= 1:length(X_cut),
%     outputName = [ 'YSB_' num2str(n+temp, '%04d')];
    outputName = [ 'YSB_C_' num2str(n+temp, '%04d')];
    audiowrite([outputDirName outputName '.wav'],X_cut{n}, fs, 'BitsPerSample',nbit)
end

