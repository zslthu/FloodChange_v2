function f_min = funct_class(x,EF_All)
% % threshold
Thres = x;

% % event classifity
ne = size(EF_All,1);% number of events
EClass = ones(ne,1)*nan;  
parfor ie = 1:ne
    EF = EF_All(ie,:);
    EClass(ie) = EventClass(EF, Thres);
end

% % similarity test
f_min =  SimilarityTest(EClass,EF_All);




