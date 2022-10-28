%path('../STRAIGHTV40_005b', path);

[x, fs, nbits] = wavread('vaiueo2d.wav');
x = x .* 32768; 
[f0raw, ap] = exstraightsource(x, fs);
[n3sgram] = exstraightspec(x, f0raw, fs);

stfObject = createSTFObject(fs, 1.0, f0raw, 1.0, ap, 1.0, n3sgram ./ 32768);
writeSTFFile('vaiueo2d.stf', stfObject);
[stfObjectRead, machineFormat] = readSTFFile('vaiueo2d.stf');
