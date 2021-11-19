close all;
clear all;

DATA_DIR = '../sim/OdomTune/logs4/';
FILE_NAME_LOG = 'eve-uart_odom.csv';

exps.data = {};
exps.dt = 1/100.0;
exps.f = 1/exps.dt;
exps.filter_cut_off = 5.0;
exps.ackeramParams = struct('LENGHT_AXIS', 1.453909315677834, ...
 'FW_ENC_RES', 0.00107421875, ...
 'FW_ENC_RES_SCALE_LEFT', 0.9915777500843911, ...
 'FW_ENC_RES_SCALE_RIGHT', 1.0297179411627437, ...
 'FW_ENC_OFFSET', 488.39678629407706, ...
 'RW_ENC_RES_M_TIC', 0.008089774630338619, ...
 'TIME_FACTOR', 43121.1);

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Time", "stamp_rossecs", "stamp_rosnsecs", "timestamp_stm", "throttle", "steering_angle", "wheel_angle", "hall_L_data", "hall_R_data", "state_machine"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Butteworth filter
[b,a] = butter(5, exps.filter_cut_off / exps.f);

listing = dir(DATA_DIR);
for i=1:length(listing)
    if listing(i).isdir && ~isempty(regexp(listing(i).name, '^\d{2}_', 'once'))
        tmp = regexp(listing(i).name, '_', 'split');
        
        exps.data{end+1} = readtable(strcat(listing(i).folder, '/', listing(i).name, '/', FILE_NAME_LOG), opts);
        exps.data{end}.throttle = exps.data{end}.state_machine * (str2double(tmp{1})/100.0);
        %
        
        % Change column name Time to SimTime
        exps.data{end}.Properties.VariableNames{1}=['SimTime'];

        % Add time
        exps.data{end} = addvars(exps.data{end}, ...
            [0 : exps.dt : length(exps.data{end}.SimTime) * exps.dt-exps.dt]' , ... 
            'NewVariableNames', 'Time');

        % Commpute distance fromm hall sensors
        exps.data{end} = addvars(exps.data{end}, ...
            exps.ackeramParams.RW_ENC_RES_M_TIC * ...
            ( exps.data{end}.hall_L_data + exps.data{end}.hall_R_data) / 2.0, ... 
            'NewVariableNames', 'Distance');

        % Commputeer raw velocity
        exps.data{end} = addvars(exps.data{end}, ...
            [0.0; diff( exps.data{end}.Distance ) / exps.dt], ... 
            'NewVariableNames', 'velRaw');

        exps.data{end} = addvars(exps.data{end}, ...
            filter(b, a, exps.data{end}.velRaw), ...
            'NewVariableNames', 'vel');
    end
end

% Test 
figure;
j=1;
for i=round(linspace(1, length(exps.data), 9))
    subplot(3, 3, j);
    hold on;grid;
    plot(exps.data{i}.Time, exps.data{i}.velRaw);
    plot(exps.data{i}.Time, exps.data{i}.vel, 'r');
    xlabel('Time');ylabel('Velocity');title(i);
    legend('velRaw', 'vel');
    hold off;
    j=j+1;
end;

save('exps.mat', 'exps');
clear opts i tmp listing a b