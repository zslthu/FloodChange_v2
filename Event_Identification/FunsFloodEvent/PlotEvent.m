function PlotEvent(runoffEvent, rainEvent)

lhy = length(runoffEvent);
ncolumn = 6;
nline = fix(lhy/ncolumn)+1;
for iy = 1:lhy
    hydata = cell2mat(runoffEvent(iy));
    raindata = cell2mat(rainEvent(iy));
    if ~isempty(hydata) && ~isempty(raindata)

        hy_tm = hydata(:,1) - (fix(hydata(1,1)/365))*365;
        hy_streamflow = hydata(:,2);
        hy_baseflow = hydata(:,3);

        pre_tm = raindata(:,1) - (fix(raindata(1,1)/365))*365;
        pre_data = raindata(:,2);

        subplot(nline,ncolumn,iy),
        colororder([0.9 0 0; 0 0.89 0.93])

        yyaxis left
        plot(hy_tm,hy_streamflow,'r',hy_tm,hy_baseflow,'r');
        ylim([0 max(hy_streamflow)*1.5])
        ylabel('flow(mm d^-^1)')
        
        yyaxis right
        bar(pre_tm,pre_data,'FaceColor',[0 0.89 0.93],'EdgeColor',"none");
        set(gca,'ydir','reverse')
        ylim([0 max(pre_data)*1.8])
        ylabel('rainfall(mm d^-^1)')
    end
end