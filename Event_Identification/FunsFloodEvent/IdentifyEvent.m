function [runoffEvent, rainfallEvent, Tr] = IdentifyEvent(streamflow, rainfall, snowfall, snowmelt)
%  Extract Runoff Events from Stormflow Series

% % response time rainfall & snowmelt
max_window = 30;
rainfallplus = rainfall+snowmelt;
Tr = Matfun_Tr_DMCA(rainfallplus, streamflow, max_window);

% % baseflow separation filter
filter = filtercoef(streamflow, snowfall); % the recession constant

% % Idenfity Turning Points (TP)
streamflow = smoothcurve(streamflow, 1);   % smooth runoff series
Tinfo = (1:length(streamflow))';
hy = [Tinfo streamflow rainfallplus]; % 3rd column: rainfall
lhy = size(hy,1)/365;

% Identify local max and min (peak and valley)
TP = findTP(hy(:, 2)); % 1st column: index; 2nd column: label (valley = 0, peak = 1)
TP(:, 3) = hy(TP(:, 1), 2); % 3rd column: discharge value
% % the first element in 'hy' array is considered a 'valley point' no matter what,
if TP(1, 2) == 1 && hy(1, 2) < mean(hy(:, 2))/10
    TP = [[1, 0, hy(1, 2)]; TP];
end
% % the last element in 'hy' array is considered a 'valley point' no matter what,
if TP(end, 2) == 1 && hy(end, 2) < mean(hy(:, 2))/10
    TP = [TP; [size(hy, 1), 0, hy(end, 2)]];
end
% % Remove incomplete event(s) at the beginning and at the end
while TP(1, 2) == 1, TP(1, :) = []; end
% while TP(end, 2) == 1, TP(end, :) = []; end
% % Get difference between peak and valley
TP(:, 4) = [diff(TP(:, 3)); 0];
% % Delete point with difference=0
if TP(1, 4) == 0, TP(1, :) = []; end
dele_loc = find(TP(1:end-1,4)==0);
dele_loc_v = TP(dele_loc-1,2) + TP(dele_loc+1,2);
dele_loc_add = dele_loc(dele_loc_v~=1) + 1;
TP([dele_loc;dele_loc_add],:) = [];

% % Identify the Start and End Points of Runoff Event
end_thres_range = 0.05:0.01:0.25;
% the best end_thres to refine multiple-peaks
is = 0;
rc_diff = ones(length(end_thres_range),1)*nan;
% hg_diff = ones(length(end_thres_range),1)*nan;
for end_thres_i = end_thres_range
    is = is+1;
    [~, ~,rc_diff(is)] = IdentifySEPoint(hy, TP, Tr, filter, end_thres_i);
end
[~,sort_rc_diff] = sort(rc_diff,'ascend');
loc_is = sort_rc_diff;
% [~,sort_len_std] = sort(hg_diff,'ascend');
% loc_is = []; i = 1;
% while isempty(loc_is)
%     loc_is = intersect(sort_rc_diff(1:i),hg_diff(1:i));
%     i = i+1;
% end
end_thres = end_thres_range(loc_is(1));

[runoffEvent, rainfallEvent, ~] = IdentifySEPoint(hy, TP, Tr, filter, end_thres);
% PlotEvent(runoffEvent, rainEvent)
minslp = 0.1;
for iy = 1:lhy
    runoffEvent_temp = cell2mat(runoffEvent(iy));
    if ~isempty(runoffEvent_temp)
        rainfallEvent_temp = cell2mat(rainfallEvent(iy));
        loc_tp_start = find(TP(:,1) == runoffEvent_temp(1,1));
        loc_tp_end = find(TP(:,1) == runoffEvent_temp(end,1));
        TP_temp = TP(loc_tp_start:loc_tp_end,:);
        [~, loc_tp_max] = max( TP_temp(:,3));
        if loc_tp_max/2 > 2 
            flow_start = runoffEvent_temp(1,2);
            flow_range = range(runoffEvent_temp(:,2));
            i = 0;
            while  (i < loc_tp_max/2) && (TP_temp((i+1)*2,3) - flow_start) / flow_range  < minslp
                i = i+1;
            end
            if i
                loc_start = find(runoffEvent_temp(:,1) == TP_temp(i*2+1,1));
                runoffEvent_temp(1:loc_start-1,:) = [];
                rainfallEvent_temp(1:loc_start-1,:) = [];
                runoffEvent(iy) = {runoffEvent_temp};
                rainfallEvent(iy) = {rainfallEvent_temp};
            end
        end
    end
end
% PlotEvent(runoffEvent, rainfallEvent)