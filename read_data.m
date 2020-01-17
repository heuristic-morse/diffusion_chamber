% clear everything to start
close all; clear all;

% find all data folders in the directory
data_dir = "D:\Wolfson Data\Microscopy Data Collection\Chelp Fluorescein +ve_ctrl\Positive Control Timelapse";
folders = dir(join([data_dir "\*001"]));

% User inputs: 
% check whether to run on all folders or not
p1 = 'Run on all folders? (y/n)';
run_all = 'y';%input(p1,'s');
p2 = 'Plot all folders? (y/n)';
plot_opt = 'n';%input(,'s');
p3 = 'Plot which colour? (1=r, 2=g, 3=b)';
rgb = 3;%input(p3,'s');
p4 = 'Apply threshold? (y/n)';
threshold  = 'y';%input(p4,'s');

switch run_all    
    case 'y'
    mean_intensity = {};
    df = {};
    n = 1;
    % loop through all folders
        for folder = folders'
            folder_name = join([data_dir folder.name], '\');
            disp(folder.name)
            sprintf('folder name is %s', folder_name);

            [mean_intensity{n}, df{n}] = load_data(folder_name, '*.tif');
            if plot_opt == 'y'
                plot_data(mean_intensity{n},folder_name, 1, threshold, rgb); %plot_1
                plot_data(mean_intensity{n},folder_name, 2, threshold, rgb); %plot_2
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
        folder_name = join([data_dir folder_name], '\');
        sprintf('folder name is %s', folder_name);

        [mean_intensity, df] = load_data(folder_name, '*.tif');
end

% clear everything except mean_intensity and df
clearvars -except mean_intensity df