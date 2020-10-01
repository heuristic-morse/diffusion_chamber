% clear everything to start
close all; clear all;

% find all data folders in the directory
%data_dir = "L:/Wolfson Data/Microscopy Data Collection/TripleChip - Fluorescein/Chip 2/";
data_dir = "data_1_10_2020/";
folders = dir(join([data_dir "*001"], ""));
folders = dir(data_dir);

% User inputs: 
% check whether to run on all folders or not
p1 = 'Run on all folders? (y/n)';
run_all = 'y';%input(p1,'s');
p2 = 'Plot all folders? (y/n)';
plot_opt = 'n';%input(,'s');
p3 = 'Plot which colour? (1=r, 2=g, 3=b)';
rgb = 2;%input(p3,'s');
p4 = 'Apply threshold? (type percentage as decimal';
threshold  = 0.2;%input(p4,'s');
load_prompt = 'y';

if load_prompt == 'y'
    prompt = '\nAre you sure you want to load all data? (y/n)';
    load_prompt = input(prompt,'s');
end
        
[N, ~] = size(folders);
switch run_all    
    case 'y'
    df = {1:N};
    pct_change = {1:N};
    c_change = {1:N};

    n = 1;
    % loop through all folders
        for folder = folders'
            folder_name = join([data_dir folder.name], '');
            disp(folder.name)
            sprintf('\nfolder name is %s', folder_name);

            df{n} = load_data(folder_name, '/*.tif', load_prompt);
            
            get_well_posn(df{n}, 'y', 0);
            get_pen_depth(df{n}, threshold, 'intcp');
            
            if plot_opt == 'y'
                plot_data(df, 1, rgb); %plot_1
                plot_data(df, 2, rgb); %plot_2
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

        [mean_intensity, label] = load_data(folder_name, '/*.tif');
end
% clear everything except df
clearvars -except df

save('chip1.mat','df')
