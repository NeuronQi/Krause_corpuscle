function s = ethoSingle(folder,filename, stim, stimDuration, baseline, after, plotBehavior, colorChoice, transparency, saveOption)

% This function is to create ethogram for the behaviors using the
% exported file from BORIS software
% Input:
% folder and filename are for the name of csv file exported from BORIS; 
% stim refers to the type of stimuli, including "opto", "vibration",
% "brush";
% stimDuration, baseline and after referes to the duration of stimulation,
% baseline and to time to plot after stimulation, all in seconds.
% plotBehavior refers to the type of behaviors to plot
%
% Output:
% s is a structure containing the information extracted.
% Created by Lijun Qi

arguments
    folder char
    filename char
    stim char
    stimDuration double
    baseline double
    after double
    plotBehavior string = ["erection", "flip", "cup"];
    colorChoice string = ["red", "cyan", "yellow", "black"];
    transparency double = [0.6, 0.8, 1, 0.1];
    saveOption string = "save"
end

timeWindow = 30; % in seconds, only response within 30 seconds after start of the stimulation is counted

T_original = readtable(fullfile(folder, filename),'VariableNamingRule','preserve');
% T = renamevars(T, "x1028_ARA16",string(filename(1:end-4)));
firstColumn = T_original(:,1);
tempi = find(~isnan(table2array(firstColumn(:, vartype("numeric")))));
% find the first row that has number in the first column
if ~isempty(tempi)
    T = T_original(tempi(1):end,[1,6, 9]);
else
    T = T_original(10:end,[1, 6, 9]);
end
T.Properties.VariableNames(1) = "Time";
T.Properties.VariableNames(2) = "Behavior";
T.Properties.VariableNames(3) = "Status";

if isa(T.Time,'cell') || isa(T.Time,'char')
    T.Time = str2double(T.Time);
end

a = ismember(T.Behavior,stim);
if sum(a) == 0
    disp(['there is no ', stim, ' for ', filename]);
else
    switch stim
        case 'retract'
            stimStart = T.Time(a);
            % stimEnd = T.Time(a);

        case {'opto', 'vibration', 'brush'}
            if mod(sum(a),2) == 1
                error('missing stop of the stimulation')
            end

            temp = T.Time(a);
            stimStartTemp = temp(1:2:end);
            stimStartDiff = diff(stimStartTemp);
            realStart = find(stimStartDiff>20); % 20 seconds is usually the duration of stimuli
            if isempty(realStart)
                stimStart = stimStartTemp(1);
            else
                stimStart = stimStartTemp([1; realStart+1 ]); % only keep the start of the real session;
                % as certain initial quantification had many small pulse in one stimulation session
                % stimEnd = temp(2:2:end);
            end
        otherwise
            error('Please check the stimulation method')
    end

    % subfolder = fullfile(folder,[filename(1:end-4),'_ethogram']);
    % if ~exist(subfolder, 'dir')
    %     mkdir(subfolder);
    % end
    structName = fullfile(folder, [filename(1:end-4), '_sum.mat']);
    % if isfile(structName)
    %     load(structName, "s");
    %     % load(structName);
    % end
    % plotBehavior = ["erection", "flip", "cup"];
    % colorChoice = ["red", "cyan", "yellow"];
    % transparency = [0.6, 0.8, 1];
    for i_session = 1:numel(stimStart)
        plotStart = stimStart(i_session) - baseline;
        plotEnd = stimStart(i_session) + stimDuration + after;
        plotIndex = T.Time>plotStart & T.Time<plotEnd;
        plotTime = T.Time(plotIndex);

        field = [stim, '_', num2str(i_session)];
        s.(field).baseline = baseline;
        s.(field).after = after;
        s.(field).behavior = plotBehavior;
        s.(field).color = colorChoice;
        s.(field).transparency = transparency;

        f = figure('units','inch',"Position", [1, 2, 15, 1]);
        % set(gcf,'Visible','on')
        set(gcf, 'Color', 'white')
        %     set(gca, 'OuterPosition', [0,0,1,1])
        ax = gca;
        ax.Position = [0.005 0.01 0.99 0.98]; % 0.1300 0.1100 0.7750 0.8150
        for i = 1:numel(plotBehavior)
            s.(field).(strcat(plotBehavior(i),"_time")) = [];
            s.(field).(strcat(plotBehavior(i),"_duration")) = [];
            time = plotTime(T.Behavior(plotIndex) == plotBehavior(i));
            s.(field).(strcat(plotBehavior(i),"_time")) = time;
            try
                s.(field).(strcat(plotBehavior(i),"_duration")) = time(2:2:end) - time(1:2:end);
            catch
                disp(time)
            end
            ethopatch(time, colorChoice(i), transparency(i), [plotStart, plotEnd], 0.5)
            % time is for plotting purposes, while timeReal is for
            % quantification, only response within the responseWindow will
            % be counted
            responseWindow = stimStart(i_session) + timeWindow;
            timeReal = time(time>stimStart(i_session) & time<responseWindow);
            s.(field).(strcat(plotBehavior(i),"_timeReal")) = timeReal;
            if isempty(timeReal)
                s.(field).(strcat(plotBehavior(i),"_start")) = [];
            else
                s.(field).(strcat(plotBehavior(i),"_start")) = timeReal(1)-stimStart(i_session);
            end
        end
        hold on
        fill([stimStart(i_session), stimStart(i_session), stimStart(i_session)+ stimDuration, stimStart(i_session)+ stimDuration], [0, 1, 1, 0],...
            colorChoice(4), 'faceAlpha',transparency(4),'EdgeColor','none')
        axis off
        xlim([plotStart, plotEnd]);
        save(structName,"s");
        switch saveOption
            case "save"
                saveas(f,fullfile(folder,[filename(1:end-4),'_', stim,'_', num2str(i_session),'.jpg']));
            case "saveSubFolder"
                subfolder = fullfile(folder,[filename(1:end-4),'_ethogram']);
                if ~exist(subfolder, 'dir')
                    mkdir(subfolder);
                end
                saveas(f,fullfile(subfolder,[stim,'_', num2str(i_session),'.jpg']));
            otherwise
                warning('the valid save options are "save" and "saveSubFolder"');
        end
    end
end
end
