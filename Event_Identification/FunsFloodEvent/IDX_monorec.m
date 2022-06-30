function idx_mr = IDX_monorec( rr )
% identify the monotonic recession points as 1 as in WB method
% two kind of non-monotonic points should be removed:
% Type I: of which -dQ/dt is two GT time of previous one; (rr(i,1)/rr(i-1,1)) >= 2  
% Type II: of whick the following -dQ/dt is larger; (rr(i,1)/rr(i+1,1)) <= 1
%
% INPUT: 
% rr: -dQ/dt series, missing data as -9999
% 
% NOTE: this index should be use with idx_len, idx_asc or idx_dsc because
% these indecs has eliminated beginning, 
%
% 
% First created: 8/7/2013
% Author: hydroleicheng@gmail.com
% Updated:

%%
TH1 = 2.0;
TH2 = 1.0;

LEN = size( rr, 1 );
idx_mr = zeros(LEN,1);

idx_r = logical( rr > 0 );

for i = 1 : LEN
    if i == 1
        if idx_r(i,1) == 1
            idx_mr(i,1) = 1;
        end
    elseif i == LEN
        if idx_r(i,1) == 1
            idx_mr(i,1) = 1;
        end
    else
        if idx_r(i,1)
            if idx_r(i-1,1) && idx_r(i+1,1) % with in recession
                if ((rr(i,1)/rr(i-1,1))<TH1) && ((rr(i,1)/rr(i+1,1))>TH2)
                    idx_mr(i,1) = 1;
                end
            elseif ~idx_r(i-1,1) && idx_r(i+1,1) % beginning
                if (rr(i,1)/rr(i+1,1)) > TH2 % NOT type II
                    idx_mr(i,1) = 1;
                end
            elseif idx_r(i-1,1) && ~idx_r(i+1,1) % end
                if (rr(i,1)/rr(i-1,1)) < TH1 % NOT type I
                    idx_mr(i,1) = 1;
                end
            end
        end
    end
end
%%