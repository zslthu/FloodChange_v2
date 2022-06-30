function [rr, qi] = BN_series_f1(Qobs) 
%% this subroutine used to calculated Brutsaert & Nieber 77 time series
% method: -dQ/dt = Q_{i-1}-Q_{i}
%         Q = (Q_{i-1}+Q_{i})/2
% this one differs from the other using observed Q directly;

% INPUT: Q = observed runoff time series, a column vector;
% OUTPUT: tinfo = time info, first day was eliminated
%         rr = -dQ/dt, recession rate
%         qi = Qi
%         

% NOTE: (1) this subroutine does NOT consider the missing data, thus make
% sure that input runoff series are complete and missing data labeled -9999;
%       (2) this subroutine do nothing more rather than just estimate the
%       value series;
%       (3) return series lengther is one shorther than the orginal one;
%       (4) missing data and affected mising data were labeled as -9999;
%
% First created on 1/7/2013
% updated on 5/7/2013: for handling time 
%

LEN = size( Qobs, 1 ) - 1;

% rr = zeros( LEN, 1 );
% qi = zeros( LEN, 1 );
% tinfo = zeros( LEN, 3 ); % Yr, mo, day

rr = Qobs(1:LEN,1) - Qobs(2:(LEN+1), 1);
% rr = -1.0 * diff(Qobs,1,1);
qi = (Qobs(1:LEN,1) + Qobs(2:(LEN+1), 1) )/2.0;

% if isempty( Tinfo_obs )
%     tinfo = [];
% else
%     tinfo = Tinfo_obs(2:(LEN+1),:); % 1st day eliminated !!!!!
% end

% handling of missing data -----------------------------
idx = logical( Qobs < 0 );    % missing value in observed flow -9999 has been converted
if sum( idx, 1 ) > 0
    idx = logical( (idx(1:LEN,1)+idx(2:(LEN+1),1)) > 0 );
    rr(idx,:) = -9999;
    qi(idx,:) = -9999;
end
%%