function slice = rept_slices( vec )
% given a column vector, return value and successive repeated times
% 
% slice: 4 columns value, bg,n end, and repeat times
% 
% vec = [1 1 1 2 3 1 1 1]';
% slice = [1 1 3 3; 2 4 4 1; 3 5 5 1; 1 6 8 3];

LEN = size( vec, 1 );
SLICE = zeros( LEN, 4 );

i = 1;
while i <= LEN
    if i == 1
        ns = 1; % number of slices
        flag = vec(i,1);
        len = 1;
        pos_bgn = 1;
    elseif i == LEN
        if vec(i,1) ~= vec(i-1,1)
            pos_end = i - 1;
            SLICE(ns,:) = [flag, pos_bgn, pos_end, len];
            ns = ns + 1;
            SLICE(ns,:) = [vec(LEN,1), LEN, LEN, 1];
        else
            pos_end = LEN;
            len = len + 1;
            SLICE(ns,:) = [flag, pos_bgn, pos_end, len];
        end
    elseif vec(i,1) ~= vec(i-1,1)
        pos_end = i - 1;
        SLICE(ns,:) = [flag, pos_bgn, pos_end, len];
        ns = ns + 1;
        len = 1;
        pos_bgn = i;
        flag = vec(i,1);

    else
        len = len + 1;
    end
    i = i + 1;
end
Nslice = ns;
slice = SLICE(1:Nslice,:);