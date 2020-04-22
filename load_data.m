function df = load_data(folder_name, file_type)

    % find all files in dir that end with .jpg
    files = dir(join([folder_name, file_type], ''));

    % preload dataframe with all imagedata and mean_intensity 
    df = {};

    n = 1;
    reverseStr = '';
    
    fprintf('Percent done: ');
    
    for file = files'
        file_name = file.name;
        sprintf('file_name is %s', file_name);
        
        if isa(class(file_name(end-10)),'char') == 1
            idx = 10;
        else
            idx = 9;
        end
        
        t_idx = str2double(file_name(end-idx:end-9));
        ch_idx = str2double(file_name(end-5:end-4));
        path = join([folder_name, file_name], '/');
        
        exp_data = ExperimentData(path,file_name,ch_idx, t_idx);
        exp_data.setMeanIntensity();

        df{t_idx+1, ch_idx+1} = exp_data;

        percentDone = 100 * n / length(files);
        msg = sprintf('%3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        
        n = n+1;
    end
end

