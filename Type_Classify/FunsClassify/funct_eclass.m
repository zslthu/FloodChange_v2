function res = funct_eclass(x,EF_All)
%% threshold
Thres = x;

%% event classifity
ne = size(EF_All,1);% number of events
res = ones(ne,1)*nan;  
parfor ie = 1:ne
    EF = EF_All(ie,:);
    res(ie) = EventClass(EF, Thres);
end





