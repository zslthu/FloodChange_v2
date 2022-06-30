function [sf, bf] = separatebaseflow(hy, fc)
%Separate streamflow into baseflow and stormflow.
%   streamflow (hy) into baselfow and stormflow using digital filter method.
%   fc = filter coefficient

n = size(hy, 1);
TV = hy(:, 1); % time vector (time frame)
hy = hy(:, 2); % orginal hydrograph
bf = nan(n, 1); % baseflow
bf_p = hy; % baseflow from the previous pass, initial is the streamflow
pass = 4;

for j = 1:pass
    % set forward and backward pass
    if mod(j, 2) == 1
        sidx = 1; eidx = n;
        incr = 1;
    else
        sidx = n; eidx = 1;
        incr = -1;
    end
    % set the inital value for baseflow
    bf(sidx) = bf_p(sidx);

    for i = (sidx + incr):incr:eidx
        tmp = fc*bf(i-incr) + (1-fc)*(bf_p(i)+bf_p(i-incr))/2;
        bf(i) = min([tmp, bf_p(i)]);
    end

    bf_p = bf;

end

sf = hy - bf; % stormflow
sf = [TV, sf];
bf = [TV, bf];

end

