clc; clear;

fullpath = mfilename('fullpath');
[path,name]=fileparts(fullpath);
addpath([path,'/FunsScalingCurve'])

% % load data
load([path,'/Example_data.mat'])

% % calculate scaling curves
[T_P_bin1,P_bin1,P_bin_s1,T_peak_P1, P_peak1] = CalScaling(P1,T1);
[T_P_bin2,P_bin2,P_bin_s2,T_peak_P2, P_peak2] = CalScaling(P2,T2);

[T_Q_bin1,Q_bin1,Q_bin_s1,T_peak_Q1, Q_peak1] = CalScaling(Q1,T1);
[T_Q_bin2,Q_bin2,Q_bin_s2,T_peak_Q2, Q_peak2] = CalScaling(Q2,T2);

% % Figure
cdata_P = [0 0 0.9];
cdata_Q = [0.9 0 0];
Xname = 'Daily {\itT} (\circC)';
Yname_P = 'Daily {\itP} (mm/d)';
Yname_Q = 'Daily {\itQ} (mm/d)';

subplot(2,2,1),
PlotScaling(T1, P1, T_P_bin1, P_bin1, P_bin_s1, T_peak_P1, P_peak1, cdata_P,Xname, Yname_P);
text(0,1.08,'a','units','normalized','FontSize',12,'FontWeight','bold')

subplot(2,2,2),
PlotScaling_2(T1, P1, T_P_bin1, P_bin_s1,T_peak_P1, P_peak1,...
    T2, P2, T_P_bin2, P_bin_s2,T_peak_P2, P_peak2,cdata_P, Xname, Yname_P)
text(0,1.08,'b','units','normalized','FontSize',12,'FontWeight','bold')

subplot(2,2,3),
PlotScaling(T1, Q1, T_Q_bin1, Q_bin1, Q_bin_s1, T_peak_Q1, Q_peak1, cdata_Q,Xname, Yname_Q);
text(0,1.08,'c','units','normalized','FontSize',12,'FontWeight','bold')

subplot(2,2,4),
PlotScaling_2(T1, Q1, T_Q_bin1, Q_bin_s1,T_peak_Q1, Q_peak1,...
    T2, Q2, T_Q_bin2, Q_bin_s2,T_peak_Q2, Q_peak2,cdata_Q, Xname, Yname_Q)
text(0,1.08,'d','units','normalized','FontSize',12,'FontWeight','bold')
