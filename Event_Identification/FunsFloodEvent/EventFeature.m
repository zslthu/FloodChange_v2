function [EF] = EventFeature(runoffEvent, triggers, Tr)

Tac = 10;

% % mean feature
Mean_rain = mean(triggers(:,1));  % mean rainfall
% Mean_sm = mean(triggers(:,2));  % mean snowmelt
Mean_sw = mean(triggers(:,3));  % mean soil water

% % x day average
triggers_3day(:,1) = AverXday(triggers(:,1),3);
triggers_3day(:,2) = AverXday(triggers(:,2),3);

lhy = length(runoffEvent);
EF = ones(lhy,8)*nan;
for iy = 1:lhy
    hydata = cell2mat(runoffEvent(iy));
    if size(hydata,1)>3
        tm_start = hydata(1,1);
        [~,loc_peak] = max(hydata(:,2));
        tm_peak = tm_start + loc_peak - 1;
        tm_start = max(tm_start-Tr, 1);  % account for the response time

        EventPD = tm_start : tm_peak; % period  start -- peak
        Tac = min(Tac, loc_peak); % antecdent day
        EventPA = max(tm_start-Tac, 1) : tm_start; % period  10 days antecdent  -- peak

        % % during the event - mean
        Emean_rain = mean(triggers(EventPD, 1));  %1- rainfall 
        Emean_sm = mean(triggers(EventPD, 2));  % 2- snowmelt

        % % during the event - max
        Emax_rain = max(triggers_3day(EventPD, 1));   % 1 - rainfall 
        Emax_sm = max(triggers_3day(EventPD, 2));    % 2 - snowmelt
        
        % % 10 days antecdent - mean
        AEmean_rain = mean(triggers(EventPA, 1));  % 4 - rainfall 
        AEmean_sw = mean(triggers(EventPA, 3));  % 3- soil water

        % % index - P
        I_pd = Emean_rain / Mean_rain;
        I_pdmax3 = Emax_rain / Mean_rain;           
        I_pa = AEmean_rain / Mean_rain;            
        I_pa_pd = AEmean_rain / Emean_rain;

        % % index - SM
        I_sm = Emean_sm / Mean_rain;                 
        I_sm_pd = Emean_sm / Emean_rain;            
        I_smmax3_pd = Emax_sm / Emean_rain;            

        % % index - SW
        I_sw = AEmean_sw / Mean_sw;            

        EF(iy,:) = [I_pd; I_pdmax3; I_pa; I_pa_pd; I_sw; I_sm; I_sm_pd; I_smmax3_pd];
    end
end

% 
% 
% 
% EventP = DateSandPeak(1):DateSandPeak(2); % start -- peak
% EventPA = max(1,DateSandPeak(1)-20):DateSandPeak(1); % 20 days antecdent
% EventPAll = max(1,DateSandPeak(1)-20):DateSandPeak(2); % 20 days antecdent -- peak
% 
% DurationPeak = DateSandPeak(2)-DateSandPeak(1)+1;
% 
% Imean = mean(CPre);
% %% pre *3
% r_id = mean(CPre(EventP))/Imean;
% % I1max_mean = max(CPre(EventP))/Imean;
% % I1max_max = max(CPre(EventP))/max(CPre);
% 
% % r_id3 = max(CPre_3SUM(EventP))/mean(CPre_3SUM);
% % r_id3_mean = max(CPre_3SUM(EventP))/3/Imean;
% 
% r_id3 = ( max(CPre_3SUM(EventP))/3 )/Imean;
% r_maxid3 = max(CPre_3SUM(EventP))/mean(CPre_3SUM);
% %% anticident pre/sw *4
% % r_ia = mean(CPre(EventPA)-CDis(EventPA)/2)/Imean;
% r_ia = mean(CPre(EventPA))/Imean;
% r_ia_id = r_ia/r_id;
% 
% r_asw = mean(CSW(EventPA))/mean(CSW);
% r_asw_dsw = mean(CSW(EventPA))/mean(CSW(EventP));
% 
% %% snowmelt *4
% r_sm = mean(CSnowmelt(EventPAll))/Imean;  % 
% r_sm_id = mean(CSnowmelt(EventPAll))/mean(CPre(EventPAll));
% 
% r_sm3 = max(CSnowmelt_3SUM(EventPAll)/3)/Imean;
% r_sm3_id3 = max(CSnowmelt_3SUM(EventPAll))/max(CPre_3SUM(EventPAll));
% 
% % %                  1      2      3       4      5     6       7      8       9      10       11     12
% FeatureAll = [DurationPeak r_id r_maxid3 r_id3 r_ia r_ia_id r_asw r_asw_dsw r_sm r_sm_id r_sm3_id3 r_sm3];
% % Check = length(FeatureAll);
% 
% %% event classifty
% thres_r_sm = 0.1;
% 
% thres_r_sm_id = 1.0;
% thres_r_sm3_id3 = 1.0;
% 
% thres2_r_id = 1.0;
% %%%%
% thres1_r_id = 3.0;
% thres_r_maxid3 = 10;
% 
% thres_r_ia = 0.5;
% thres_r_ia_id = 0.5;
% 
% thres_r_asw = 1.0;
% if r_sm >= thres_r_sm
%     if r_sm_id >= thres_r_sm_id || r_sm3_id3 >= thres_r_sm3_id3
%         EventClass = 1; % SMF
%     elseif r_id >= thres2_r_id
%         EventClass = 2; % RoSF
%         % 要求减半
%     elseif r_sm_id >= thres_r_sm_id/2  || r_sm3_id3 >= thres_r_sm3_id3/2
%         EventClass = 1; % SMF
%     elseif r_id >= thres2_r_id/2
%         EventClass = 2; % RoSF
%         % 要求减半
%     elseif r_sm_id/thres_r_sm_id >  r_id/thres2_r_id
%         EventClass = 1; 
%     else
%         EventClass = 2; 
%     end
% end
% if r_sm < thres_r_sm
%     if r_id >= thres1_r_id || r_maxid3 >= thres_r_maxid3
%         EventClass = 4; % IRF
%     elseif r_ia >= thres_r_ia && (r_ia_id >= thres_r_ia_id || r_asw >= thres_r_asw)
%         EventClass = 5; % ESF
%         % 要求减半
%     elseif r_id >= thres1_r_id/2 || r_maxid3 >= thres_r_maxid3/2
%         EventClass = 4; % IRF
%     elseif r_ia >= thres_r_ia/2 && (r_ia_id >= thres_r_ia_id/2 || r_asw >= thres_r_asw/2)
%         EventClass = 5; % ESF
%          % 要求减半
%     else    %r_id/thres1_r_id  r_ia/thres_r_ia
%         EventClass = 6; % 未分类
%     end
% end
% 
%