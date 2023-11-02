close all

annotations_ypos=[0.86, 0.65, 0.43, 0.22];
annotations_string={'(a)';'(b)';'(c)';'(d)'};
subplot_length=.7;
subplot_position=.09;
legend_position=.89;

fig=figure('Name','Averaged_Results');
greyvalue=ones(1,3)*.7;


for i=1:4
    subplot(4,1,i); hold on
    yyaxis right
    plot(Results.time_s{i}, Results.Q_dot_H2O_x1{i})
    for ii=1:length(Results.window_end{i})
        plot([Results.time_s{i}(Results.window_start{i}(ii)+plus_buffer), Results.time_s{i}(Results.window_end{i}(ii)-minus_buffer)],...
            [Results.average_power(i, ii), Results.average_power(i, ii)], 'LineStyle','-', 'LineWidth',2)
    end
    ylabel('$\dot{Q}_{H_2O} [\mathrm{kW}]$', 'interpreter', 'latex')

    yyaxis left
    plot(Results.time_s{i}, Results.speed{i}, 'LineWidth',1)
    ylabel('$n [\mathrm{min}^{-1}]$', 'interpreter', 'latex')
    annotation('textbox', [0.04, annotations_ypos(i), 0, 0], 'string', annotations_string{i}, 'interpreter', 'latex')
    % annotation('textbox', [0.08, annotations_ypos(i)-0.08, 0.1, 0.05], 'string',...
    %     annotations_string{i}, 'interpreter', 'latex', 'Rotation',90, 'EdgeColor', 'none')
    legend('MA101', '$\dot{Q}_{H_2O}(x=1)$', 'interpreter', 'latex', 'location', 'northeastoutside')
end


xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex')
width = 20; % Breite des Plots in cm
height = 16;  % Hoehe des Plots in cm 
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, width, height], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])

fig=figure('Name','T_PCM');
for i=1:4
    subplot(4,1,i); hold on
    yyaxis right
    plot(Results.time_s{i}, Results.Q_dot_H2O_x1{i})
    for ii=1:length(Results.window_end{i})
        xregion(Results.time_s{i}(Results.window_start{i}(ii)),Results.time_s{i}(Results.window_end{i}(ii)), 'FaceAlpha',0.2)
    end
    ylabel('$\dot{Q}_{H_2O} [\mathrm{kW}]$', 'interpreter', 'latex')

    yyaxis left
    plot(Results.time_s{i}, Results.T_1_PCM{i}, 'LineWidth',1)
    plot(Results.time_s{i}, Results.T_2_PCM{i}, 'LineWidth',1)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex')
    annotation('textbox', [0.02, annotations_ypos(i), 0, 0], 'string', annotations_string{i}, 'interpreter', 'latex')
    % annotation('textbox', [0.08, annotations_ypos(i)-0.08, 0.1, 0.05], 'string',...
    %     annotations_string{i}, 'interpreter', 'latex', 'Rotation',90, 'EdgeColor', 'none')
    ylim([20 300])
legend('$T_{1,PCM}$', '$T_{2,PCM}$', '$\dot{Q}_{H_2O}(x=1)$', 'interpreter', 'latex', 'location', 'northeastoutside')
end



xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex')
width = 20; % Breite des Plots in cm
height = 16;  % Hoehe des Plots in cm 
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, width, height], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])
