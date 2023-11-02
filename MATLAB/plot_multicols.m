function legend_list=plot_multicols(Versuch, cols, plottitle, yaxis, varargin)
    plot_abstime=0;
    legend_list=varargin{1};
    if plot_abstime==1
        plot(Versuch.DateTime, Versuch{:, cols});
    else
        plot(Versuch.time_s, Versuch{:, cols});
    end
    % xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex','FontSize',12)
    ylabel(yaxis, 'Interpreter','latex', 'FontSize',12)
    ylimvec=[min(Versuch{:, cols},[],"all")*0.9, max(Versuch{:, cols},[],"all")*1.1];
    if ylimvec(1)==0
        ylimvec(1)=-1;
    end

    try
        ylim(ylimvec)
    catch
        ylim([-5 105])
    end
    
    if cols==73
        ylim([-5 105])
    end

    xlim([min(Versuch.time_s), max(Versuch.time_s)])
    legend_list={legend_list{:},Versuch.Properties.VariableNames{cols}};
    legend(Versuch.Properties.VariableNames{cols}, 'Interpreter', "latex")
end