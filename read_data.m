% clear everything to start
close all; clear all;

% find all data folders in the directory
%data_dir = "L:/Wolfson Data/Microscopy Data Collection/Chelp Fluorescein +ve_ctrl/Positive Control Timelapse/";
data_dir = "";
folders = dir(join([data_dir "*001"], ""));

% User inputs: 
% check whether to run on all folders or not
p1 = 'Run on all folders? (y/n)';
run_all = 'y';%input(p1,'s');
p2 = 'Plot all folders? (y/n)';
plot_opt = 'y';%input(,'s');
p3 = 'Plot which colour? (1=r, 2=g, 3=b)';
rgb = 3;%input(p3,'s');
p4 = 'Apply threshold? (type percentage as decimal';
threshold  = 0.5;%input(p4,'s');
[N, ~] = size(folders);
switch run_all    
    case 'y'
    mean_intensity = {1:N};
    df = {1:N};
    well_posn = 1:N;
    pen_depth = {1:N};
    pct_change = {1:N};
    c_change = {1:N};

    n = 1;
    % loop through all folders
        for folder = folders'
            folder_name = join([data_dir folder.name], '');
            disp(folder.name)
            sprintf('\nfolder name is %s', folder_name);

            [mean_intensity{n}, df{n}] = load_data(folder_name, '/*.tif');
            well_posn(n) = 1;%get_well_posn(mean_intensity{n}, 'y');
            [pen_depth{n}, pct_change{n}, c_change{n}]  = get_pen_depth(mean_intensity{n}, well_posn(n), threshold);
            if plot_opt == 'y'
                plot_data(mean_intensity{n},data_dir, folder.name, 1, threshold, rgb, well_posn(n)); %plot_1
                plot_data(mean_intensity{n},data_dir, folder.name, 2, threshold, rgb, well_posn(n)); %plot_2
                close all;
            end
            % check to see whether to continue the loop
            if n < length(folders)
                prompt = sprintf('\nNext folder is ''%s'',\n Continue? (y/n)', folders(n+1).name);
                continue_opt = 'y';%input(prompt,'s');
                if continue_opt ~= 'y'
                    break
                end
            end
            n = n+1;
        end
        
    otherwise
    % get data from specific folder
        prompt = 'Type in folder name:';
        folder_name = input(prompt,'s');
        folder_name = join([data_dir folder_name], '');
        sprintf('folder name is %s', folder_name);

        [mean_intensity, df] = load_data(folder_name, '/*.tif');
end

% clear everything except mean_intensity and df
clearvars -except mean_intensity df well_posn pen_depth pct_change c_change