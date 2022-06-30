function [T_bin,P_bin,P_bin_s,T_peak, P_peak] = CalScaling(P,T)

% %  initialization
T_peak = nan;
P_peak = nan;
P_bin_s = nan;

% % scaling curve
T = T(P~=0);
P = P(P~=0);

T_range = min(T):0.5:max(T);
len = length(T_range)-1;
T_bin = ones(len,1)*nan;
P_bin = ones(len,1)*nan;

ethres = 99;
for it = 1: len
    loc = find( T > T_range(it) & T <= T_range(it+1) );
    len_mark = length(loc);
    if len_mark > 20
        P_loc = P(loc);
        T_loc = T(loc);
        P_bin(it) = prctile(P_loc, ethres);
        T_bin(it) = mean(T_loc);
    end
end
T_bin(isnan(T_bin)) = [];
P_bin(isnan(P_bin)) = [];
LenF = length(P_bin);

% % peak point
fs = 0.2;
ls = 2;
if LenF>=10
    P_bin_s = smooth(P_bin,fs,'loess');
    % % peak temperature
    [P_peak,loc_maxP] = max(P_bin_s);
    if loc_maxP >= ls && loc_maxP <= (LenF - ls)
        T_peak = T_bin(loc_maxP);
    end
end