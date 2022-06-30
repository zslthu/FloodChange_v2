function lbl_big = LBL_bigevent( idx_fall, qi, perc_big )
% label big event: Q of first recession day is larger than a certain of all
% flow percentile
% if it is a biger event, all the recession points of this event labled as 1
%     
%     
%     
%%
idx = logical( qi >= 0 );    % screen out mising data
Qcrit = prctile( qi(idx,1), perc_big );
%%
LEN = size(qi,1);

lbl_big = zeros(LEN,1);

slice = rept_slices( idx_fall ); % value, bgn, end, len
Ns = size( slice, 1 );

for is = 1 : Ns
    if slice(is,1) == 1
        pos_bgn = slice(is,2);
        if qi(pos_bgn,1) >= Qcrit
            pos_end = slice(is,3);
            lbl_big(pos_bgn:pos_end,1) = 1;
        end
    end
end
%%