function fs=getfsfrommenu(hh)
%       fs=getfsfrommenu(hh)
%	fs	: sampling frequency (Hz)
%	hh	: handle

fsv=[48000 44100 32000 24000 22050 20000 ...
16000 12500 12000 11050 10000 8000];

id=get(hh,'Value');
fs=fsv(max(1,min(length(fsv),id)));
