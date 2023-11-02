resizeplot=2;

FolderName = strcat(pwd,'/Plots/');   % using my directory
ft='Times';
fsz=12;
% FolderName = pwd;
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  set(0, 'CurrentFigure', FigHandle);
  set(findall(gcf,'type','text'), 'FontSize', fsz, 'FontName', ft)
%   saveas(FigHandle, strcat(FigName, '.png'));
    if resizeplot==1
        width = 20; % Breite des Plots in cm
        height = 12;  % Hoehe des Plots in cm 
        set(gcf, 'Units', 'centimeters', 'Position', [0, 0, width, height], ...
        'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])
    elseif resizeplot==2
        width = 10; % Breite des Plots in cm
        height = 8;  % Hoehe des Plots in cm
        set(gcf, 'Units', 'centimeters', 'Position', [0, 0, width, height], ...
        'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7])
    end

    % PaperSize entspricht einer DIN A4 Seite
%     print('DSC_q_over_time','-dpng','-r600')
    % Erstellt ein png mit ausreichender Aufloesung
  fullpath=fullfile(FolderName,strcat(FigName, '.svg'));
  saveas(FigHandle, fullpath); % specify the full path
end