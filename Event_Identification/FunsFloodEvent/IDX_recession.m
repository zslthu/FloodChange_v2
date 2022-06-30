function idx_rec = IDX_recession( rr )
% according to the -dQ/dt series (incld. -9999 as missing data), to generate
% a label column vector for recession series
% lbl_rec = 1: = recession point
% 
% % missing data handelling
% missing points & following recession were labeled as non recession points
% % beinning recesion handling
% the beginning recession events is elimnated;
% % input
% rr = -dQ/dt series
% 
% % output
% lbl_rec: binary conding 
% 
% 
% Notes:
% comparing with simple using -dQ/dt>0 to select recession data, missing pieces
% are elimnated, recession episodes at the beginning and folloing missing pieces
% are both eliminated

%%
LEN = size( rr, 1 );    % length of the data
NoData = -9999; % missing data flag in -dQ/dt series

idx_tmp = zeros( LEN, 1 );

idx = logical( rr > 0 );
idx_tmp(idx,1) = 1;
idx = logical( rr == NoData );
idx_tmp(idx,1) = -1;

slice = rept_slices( idx_tmp ); % value, bgn, end, len
Ns = size( slice, 1 );

%% handling the beginning recession
if slice(1,1) == 1  % begin with a recession event
    pos_bgn = slice(1,2);
    pos_end = slice(1,3);
    idx_tmp(pos_bgn:pos_end,1) = 0;
end
%% handling missing piece(s)
if min(slice(:,1),1) == -1  % missing pieces exist !!!
    for is = 1 : Ns-1
        if slice(is,1)==-1 && slice(is+1,1)==1
            pos_bgn = slice(1,2);
            pos_end = slice(1,3);
            idx_tmp(pos_bgn:pos_end,1) = 0;
        end
    end
end
%%
idx_rec = logical( idx_tmp == 1 );  % eliminating missing data

%%



