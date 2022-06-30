function PlotScaling(T, P, T_bin, P_bin, P_bin_s,T_peak, P_peak, cdata, Xname, Yname)

% % all data
plot(T,P,'.','color',[0.88 0.88 0.88]); hold on;
% % scaling curve
plot(T_bin,P_bin,'.','MarkerSize',8,'Color',cdata); hold on;
plot(T_bin,P_bin_s,'LineWidth',1,'Color',cdata); hold on;
% % peak point
plot(T_peak, P_peak,'*','color','g','LineWidth',1)

% % format
P_Ymax = max(P);
P_Tmax = prctile(T,99);
P_Tmin = prctile(T,0.1);
axis([P_Tmin,P_Tmax,0, P_Ymax])

xlabel(Xname ,'fontsize',8)
ylabel(Yname ,'fontsize',8)
set(gca,'fontsize',8)

end
