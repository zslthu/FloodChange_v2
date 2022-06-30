function [SR] = SimilarityTest(classlabel,data)
% similarity test for clustering 
% Internal validity indices when true labels are unknown
% from: Kaijun WANG, sunice9@yahoo.com, Oct. 2006, March 2007

Rd = 'correlation'; %'euclidean';  

% Calinski-Harabasz(CH)
% tic;
Re = strcmp(Rd, 'euclidean');
CH = valid_internal_deviation(data,classlabel, Re);
% toc;
% output
SR = 1/CH; % -----the higher the better


