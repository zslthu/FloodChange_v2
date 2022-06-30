function [ord_asc, ord_dsc, idx_len] = ORD_falling( idx_fall )
% generate two vectors to store the asending & descending order of falling
% limb
% % INPUT:
% idx_fall: logical value 1 & 0 to indecate whether data is in falling limb
% 
% 

%%
LEN = size( idx_fall, 1 );
ord_asc = zeros( LEN, 1 );
ord_dsc = zeros( LEN, 1 );
idx_len = zeros( LEN, 1 );

slice = rept_slices( idx_fall ); % value, bgn, end, len
Ns = size( slice, 1 );

for is = 1 : Ns
    if slice(is,1) == 1
        pos_bgn = slice(is,2);
        pos_end = slice(is,3);
        len = slice(is,4);
        asc = (1:len)';
        dsc = (len:-1:1)';
        ord_asc(pos_bgn:pos_end,1) = asc;
        ord_dsc(pos_bgn:pos_end,1) = dsc;
        idx_len(pos_bgn:pos_end,1) = len;
    end
end
%%