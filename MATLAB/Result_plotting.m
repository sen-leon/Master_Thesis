set(0, 'DefaultLineLineWidth', 1.15);
figure('Name', sprintf("Experiment_Nr_%d", id_versuch)); hold on;
set(gcf, 'Position', get(0, 'Screensize'));

set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 20, 12], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])

subplot_length=.6;
subplot_height=.17;
subplot_position=.1;
legend_position=.77;
sub(1)=subplot(4,1,1);
annotation('textbox', [0, 0.86, 0, 0], 'string', '(a)', 'Interpreter','latex')

i=1; %Steam/Feedwater Temperature cols
yyaxis left
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, {}); hold on
ylim([0 150])

i=5; %flowrate cols
yyaxis right
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);
% plot(Versuch.time_s, m_dot_PCM/15);
legend_list={"Speisewassertemperatur", "Dampftemperatur", "Massenfluss Wasser ein", "Massenfluss Dampf aus"};

leg(1)=legend(legend_list);
ylim([0 110])


legend_list={};
sub(2)=subplot(4,1,2);
annotation('textbox', [0, 0.65, 0, 0], 'string', '(b)', 'interpreter','latex')
i=4; %cooling water cols
yyaxis left
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);
ylim([20 45])

i=6; %pressure cols
yyaxis right
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);


legend_list={"Kühlwasser Rücklauf", "Kühlwasser Tank", "Dampfdruck"};
leg(2)=legend(legend_list);
% s2.Position(3)=subplot_length;
% l2.Position(1)=legend_position;
ylim([0 5])

legend_list={};
sub(3)=subplot(4,1,3);
annotation('textbox', [0, 0.43, 0, 0], 'string', '(c)', 'interpreter','latex')
i=8; %Valve
% yyaxis left
% % legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);
% ylim([0 100])

i=9; %Fill level
% yyaxis right
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);hold on

if id_versuch==5
    plot(Versuch.time_s, x*100, 'Color','r','LineStyle','-')
    ylim([0 105])
    ylabel('$x$ [\%]; FL [\%]', 'Interpreter', 'latex')

    leg(3)=legend(legend_list{:}, '$x$=BQ101');
else
    legend_list={"Füllstand PCM-Becken"};
    leg(3)=legend(legend_list{:});
end
ylim([0 105])

sub(4)=subplot(4,1,4); hold on
annotation('textbox', [0, 0.22, 0, 0], 'string', '(d)', 'interpreter','latex')
legend_list={};
i=7; %RPM
yyaxis left
legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);
ylim([0 25])

yyaxis right

plot(Versuch.time_s, Q_dot_H2O_x1, 'DisplayName','$\dot{Q}_{H_2O,x=1}$', 'color','k','LineStyle','-')
plot(Versuch.time_s, Q_dot_cool, 'DisplayName','$\dot{Q}_{CW}$')

% if id_versuch==4
%     plot(Versuch.time_s, Q_dot_H2O, 'DisplayName','$\dot{Q}_{H_2O,x=BQ101}$', 'Color','r', 'LineStyle','-')
% end

xlim([min(Versuch.time_s), max(Versuch.time_s)])
ylabel('$\dot{Q}$ [kW]', 'interpreter','latex')

% ylim([min(Q_dot_H2O_x1)*1.05, max(Q_dot_H2O_x1)*1.05])
ylim([0 65])

% legend_list = {legend_list{:},'$\dot{Q}_{H_2O,x=1}$','$\dot{Q}_{CW}$'};
xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex','FontSize',12)
%legend_list = {'$\dot{Q}_{H_2O,p}$','$\dot{Q}_{H_2O,x=1}$','$\dot{Q}_{H_2O,t}$'};
% leg(4)=legend(legend_list, 'Interpreter',"latex");

legend_list={"Drehzahl", "Entladeleistung", "Kühlleistung"};


leg(4)=legend();
leg(4)=legend(legend_list);
set(gca,'Box','on');
leg(4).AutoUpdate='off';



for k=1:4
    sub(k).Position(1)=subplot_position;
    sub(k).Position(3)=subplot_length;
    sub(k).Position(4)=subplot_height;
    leg(k).Position(1)=legend_position;
end

linkaxes(sub, 'x')
% SaveFigures

hold on
for ii=1:num_windows(id_versuch)
    xregion(Versuch.time_s(window_start(ii)), Versuch.time_s(window_end(ii)), 'FaceAlpha', .15)
end


% figure; hold on
% plot(Q_dot_H2O)
% plot(Q_dot_H2O_x1)
% plot(Q_test)
% plot(n_test)
% 
% for ii=1:num_windows(id_versuch)
%     xline(window_start(ii), 'r');
%     xline(window_end(ii));
% end


%% Plot für Präsentation
presentation_plot=0;
if presentation_plot==1
    figure('Name','Timeplot_Präsentation')
    
    legend_list={};
    i=7; %RPM
    yyaxis left
    legend_list=plot_multicols(Versuch, parameters.cols{i}, "",  parameters.yaxis_ger{i}, legend_list);
    ylim([0 25])
    
    yyaxis right
    
    plot(Versuch.time_s, Q_dot_H2O_x1, 'DisplayName','$\dot{Q}_{H_2O}$', 'color','k','LineStyle','-', 'LineWidth', 2); hold on
    plot(Versuch.time_s, Q_dot_cool, 'DisplayName','$\dot{Q}_{CW}$', 'LineStyle','-')
    
    
    xlim([min(Versuch.time_s), max(Versuch.time_s)])
    ylabel('$\dot{Q}$ [kW]', 'interpreter','latex')
    
    ylim([0 65])
    xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex','FontSize',12)
    
    legend_list={'Drehzahl $n$', 'Entladeleistung $\dot{Q}_{H_2O}$', 'K\"{u}hlleistung $\dot{Q}_{CW}$'};
    legend(legend_list)
end