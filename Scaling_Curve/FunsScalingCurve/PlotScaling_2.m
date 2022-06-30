function PlotScaling_2(T1, P1, T_bin1, P_bin_s1,T_peak1, P_peak1,...
    T2, P2, T_bin2, P_bin_s2,T_peak2, P_peak2,cdata, Xname, Yname)

% % PERIOD-1
% % all data
plot(T1,P1,'.','color',[0.88 0.88 0.88]); hold on;
% % PERIOD-2
% % all data
plot(T2,P2,'.','color',[0.7 0.7 0.7]); hold on;

% % PERIOD-1
% % scaling curve
% plot(T_bin1,P_bin1,'.','MarkerSize',8,'Color',cdata); hold on;
hl1 = plot(T_bin1,P_bin_s1,'LineWidth',1,'Color',cdata); hold on;
% % peak point
plot(T_peak1, P_peak1,'*','color','g','LineWidth',1)

% % PERIOD-2
% % scaling curve
% plot(T_bin2,P_bin2,'.','MarkerSize',8,'Color',cdata); hold on;
hl2 = plot(T_bin2,P_bin_s2,'-.','LineWidth',1,'Color',cdata); hold on;
% % peak point
plot(T_peak2, P_peak2,'*','color','g','LineWidth',1)

% % format
P_Ymax = max(max(P1),max(P2));
P_Tmax = max(prctile(T1,99),prctile(T2,99));
P_Tmin = min(prctile(T1,0.1),prctile(T2,0.1));
axis([P_Tmin,P_Tmax,0, P_Ymax])

xlabel(Xname ,'fontsize',8)
ylabel(Yname ,'fontsize',8)

legend([hl1 hl2],{'historical period','future period'},'box', 'off','Location','northwest')
set(gca,'fontsize',8)

end
