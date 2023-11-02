%% For Written Thesis
figure('Name', 'Q_cool_comparison_1');
b=bar([Results.Q_H2O_x1_o(:,5), Results.Q_H2O_x1(:,5), Results.Q_cool_2(:, 5)]);
legend('$E_{t,H_2O}(x=1)$, BF102 ohne Korrekturfaktor', '$E_{t,H_2O}(x=1)$','$E_{t,CW}$', 'interpreter', 'latex', 'location', 'northwest')
xlabel('Versuch')
ylabel('$E_t \mathrm{[kWh]}$', 'interpreter', 'latex')

for i=1:length(b)
    % b(i).BarWidth=.6;
    xtips{i} = b(i).XEndPoints;
    ytips{i} = b(i).YEndPoints;
    labelsdata{i} = string(round(b(i).YData, 2));
    text(xtips{i},ytips{i},labelsdata{i},'HorizontalAlignment','center',...
    'VerticalAlignment','bottom', 'FontName', 'Cambria Math')
end

ylim([0 6])
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 20, 6], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])

%% For Presentation
figure('Name', 'Q_cool_comparison_2');
b=bar([Results.Q_H2O_x1(:,5), Results.Q_cool_2(:, 5)]);
legend('Entladene thermische Energie', 'Thermische Energie in Kühlwasser', 'location', 'northwest')
xlabel('Versuch')
ylabel('$E_t \mathrm{[kWh]}$', 'interpreter', 'latex')

for i=1:length(b)
    % b(i).BarWidth=.6;
    xtips{i} = b(i).XEndPoints;
    ytips{i} = b(i).YEndPoints;
    labelsdata{i} = string(round(b(i).YData, 2));
    text(xtips{i},ytips{i},labelsdata{i},'HorizontalAlignment','center',...
    'VerticalAlignment','bottom', 'FontName', 'Cambria Math')
end

ylim([0 6])
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 20, 6], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])