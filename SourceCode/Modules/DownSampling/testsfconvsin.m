ifs = 96000;
ofs = 11025;
freq = 200;
dur = 0.1;

t = 0:1/ifs:dur;

sig = sin(2.0 * pi * freq * t);

[osig, ofs2, filt] = sfconv(sig, ifs, ofs);

ot = (0:length(osig)-1) / ofs;

plot(t, sig, 'b-', ot, osig, 'r:');
