function  a = filtercoef(Qobs, Snow)
% to calculate the recession constant of baseflow separation
% reference: Cheng, L., Zhang, L., & Brutsaert, W. (2016). Automated selection of pure base flows 
% from regular daily streamflow data: objective algorithm. Journal of Hydrologic Engineering, 21(11), 06016008.

%% set global parameter for the automation
xbgn = 3;   % points to be eliminated at the beginning
xend = 1;   % points to be eliminated at the end

xxbgn = 2;  % extra pts

RLmn = 7;   % minum length
prc_env = 5;    % percentage for lower envelope
prc_big = 95;   % percentage for bigger event

th_qualobs = max(1.0E-3,quantile(Qobs,0.001)); 
%%
% estimate time series -----------------------------------
[rr, qi] = BN_series_f1(Qobs);
% idx recession limb ----------------------------
idx_rec = IDX_recession( rr );
% get recession order ------------------------------------
[ord_asc, ord_dsc, idx_len] = ORD_falling( idx_rec );
% index monotonic recession points -----------------------
idx_mr = IDX_monorec( rr );
% idx quality observation --------------------------------
%     th_qualobs = 0.0001;
idx_qual = logical( min([rr,qi], [], 2) >= th_qualobs );

% eliminating beginning points ---------------------------
lbl_big = LBL_bigevent( idx_rec, qi, prc_big );
nxbgn = max( [idx_rec*xbgn,lbl_big*(xbgn+xxbgn)], [], 2);
idx_xbgn = logical( ord_asc > nxbgn );

% elimination acorrding to length and ending --------------
idx_xend = logical( ord_dsc > xend );
idx_xlen = logical( idx_len >= RLmn );

% snow and/or freezing free period --------------
idx_nsnw = logical(Snow(2:end) ==0);
idx = logical( (idx_rec+idx_xlen+idx_xbgn+idx_xend+idx_mr+idx_nsnw+idx_qual) == 7 );

BNrr = rr( idx, 1 );
Qi   = qi( idx, 1 );
%         T_BN77 = tinfo(idx,:);

% estimate BNa
a = 1-est_a( BNrr, Qi, prc_env );
a = min(max(0.8, a),0.99);
end