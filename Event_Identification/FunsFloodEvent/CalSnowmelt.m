function [Snowfall, Snowmelt] = CalSnowmelt(P, Ta)
%  CALSNOWMELT reference: Berghuijs et al. (2016) and Stein et al. (2019)

Snowfall = ones(length(Ta), 1)*0;
S_snow = ones(length(Ta), 1)*0;
Snowmelt = ones(length(Ta), 1)*0;

fdd = 2; %% a melt factor unit:mm day–1 K–1 (Berghuijs et al., 2019, 2016)
Tthr = 1;

if Ta(1) < Tthr
    S_snow (1) = P(1);
    Snowfall (1) = P(1);
else
    S_snow (1) = 0;
    Snowmelt(1) = 0;
    Snowfall (1) = 0;
end
for t = 2:length(Ta)
    if Ta(t) < Tthr
        S_snow(t) = P(t) + S_snow(t-1);
        Snowfall (t) = P(t);
        Snowmelt(t) = 0;
    else
        Snowmelt(t) = min( fdd * (Ta(t) - Tthr), S_snow(t-1));
        S_snow(t) = max(S_snow(t-1) - Snowmelt(t), 0);
        Snowfall (t) = 0;
    end
end
end