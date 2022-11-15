function w = mykaiser(n, beta)

w = zeros(n, 1);

an1 = 1.0 / (n - 1.0);
for ii = 1:n ,
  t = (2 * (ii - 1) - n + 1) * an1;
  wval = myai0(beta * sqrt(1.0 - (t .^ 2)));
  w(ii, 1) = wval / myai0(beta);
end

return;

function s = myai0(x)
ds = 1;
d = 2;
s = ds;
ds = (x .^ 2) / 4.0;
while ds >= (0.2e-8 * s) ,
  d = d + 2;
  s = s + ds;
  ds = ds * (x .^ 2) / (d .^ 2);
end

return;
