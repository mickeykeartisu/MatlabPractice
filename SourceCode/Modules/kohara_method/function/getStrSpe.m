function [n3sgram,  f0raw, ap] = getStrSpe( x, fs )
%GETSTRSPE この関数の概要をここに記述
%   詳細説明をここに記述
[f0raw, ap] = exstraightsource(x, fs);

[n3sgram] = exstraightspec(x, f0raw, fs);

end

