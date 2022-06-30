function [runoffEvent, rainfallEvent, rc_diff] = IdentifySEPoint(hy, TP, Tr, filter, end_thres)
% Identify the Start and End Points of Runoff Event

[~, baseflow] = separatebaseflow(hy, filter);
hy = [hy(:,1:2) baseflow(:,2) hy(:,3)]; % 3rd column: baseflow value  % 4rd column: rainfall

TP(:,4) = baseflow(TP(:,1),2);

lhy = size(hy,1)/365;
[~, MaxR1day_Timing] = max(reshape(hy(:,2), 365, lhy));
MaxR1day_Timing = MaxR1day_Timing';     % timing of the peak value
MaxR1day_Timing(:,2) = MaxR1day_Timing + (0:365:lhy*365-1)';   % timing of the peak value

end_thres_0 = 0.1;
% % Initialize the variables
runoffEvent = cell(lhy,1);
rainfallEvent = cell(lhy,1);
lenEvent = ones(lhy,1)*nan;
rc = ones(lhy,1)*nan;

im = 0;  rc_res = [];
for iy = 1:lhy
    loc_peak = MaxR1day_Timing(iy,2); % location of peak flow
    loc_peak_tp = find(TP(:,1) == loc_peak);
    if ~isempty(loc_peak_tp)

        flow_peak = TP(loc_peak_tp,3);  % value of peak flow
        baseflow_peak = TP(loc_peak_tp,4); % value of baseflow at peak flow

        % % Step 2a:
        % % location for search start point
        loc_start_s = TP(:,2) == 0 & TP(:,1) < loc_peak ; %  valley abd before the peak
        TP_start_s = TP(loc_start_s,:);  % TP for search
        i = 1;
        mark_start = 1;
        while i < size(TP_start_s,1)
            mark_start = 1;
            flow_start = TP_start_s(end+1-i,3);
            loc_start = TP_start_s(end+1-i,1);
            baseflow_start = TP_start_s(end+1-i,4);
            if flow_start <= baseflow_start  % < baseflow
                mark_start = 0;
                break;
            else
                i = i+1;
            end
        end
        if mark_start  % not find the start point
            loc_start = TP_start_s(1, 1);
            flow_start = TP_start_s(1, 3);
        end
        loc_start_tp = find(TP(:,1) == loc_start);

        % % Step 2b:
        % % location for search end point
        loc_end_s = TP(:,2) == 0 & TP(:,1) > loc_peak ; %  valley abd after the peak
        TP_end_s = TP(loc_end_s,:); % TP for search
        i = 1;
        if size(TP_end_s,1)==1
            loc_end = TP(1,1);
        else
            while i < size(TP_end_s,1)
                loc_end = TP_end_s(i,1);
                flow_end = TP_end_s(i,3);
                baseflow_end = TP_end_s(i,4); % the point < baseflow defined as end point
                if (flow_end <= baseflow_end) || ...
                        (flow_end-baseflow_end) <= (flow_peak - baseflow_peak) * end_thres_0 ||...
                        (flow_end-flow_start) <= (flow_peak - flow_start) * end_thres_0
                    break;
                else
                    i = i+1;
                end
            end
        end

        % % Step 2c:
        % % refine the start point: check if there is end point in the starting line
        TP_start_res = TP(loc_start_tp:loc_peak_tp-1,:);  % TP for search
        flow_start_res = TP_start_res(1,3); % start value

        i = 1;
        mark_res =0; % mark if find the refined point
        while i < size(TP_start_res,1)
            flow_end_res = TP_start_res(end+1-i,3);
            baseflow_end_res = TP_start_res(end+1-i,4);
            [flow_peak_res,loc_peak_res] = max(TP_start_res(1:end+1-i,3));
            baseflow_peak_res = max(TP_start_res(1:end+1-i,4));

            if flow_end_res <= flow_peak_res * end_thres ||...
                    ((flow_end_res-baseflow_end_res) <= (flow_peak_res-baseflow_peak_res) * end_thres) ||...
                    (flow_end_res-flow_start_res) <= (flow_peak_res- flow_start_res) * end_thres
                mark_res = 1;
                break;
            else
                i = i+2;
            end
        end

        if mark_res
            im = im + 1;
            loc_start_res = loc_start; % start of former event
            loc_peak_res = TP_start_res(loc_peak_res,1);  % peak of former event
            rain_start_res = max(loc_start_res-Tr+1,1);

            rc_res(im) = sum(hy(loc_start_res:loc_peak_res, 2))/...
                sum(hy(rain_start_res:loc_peak_res, 4)); 

            loc_start = TP_start_res(end+1-i,1); % replace start point as the point after the find peak point

        end

        rain_start = max(loc_start-Tr+1,1);
        rc(iy) = sum(hy(loc_start:loc_peak, 2)) / sum(hy(rain_start:loc_peak, 4)); % runoff coefficient

        runoffEvent(iy) = {hy(loc_start:loc_end, 1:3)};
        rainfallEvent(iy) = {hy(rain_start:loc_end, [1 4])};

        lenEvent(iy) = length(loc_start:loc_peak);

    end
end
% % difference in the runoff coefficient
rc_diff = std(rc,'omitnan')/mean(rc,'omitnan');

