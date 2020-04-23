function df = load_data(folder_name, file_type)

    % find all files in dir that end with .jpg
    files = dir(join([folder_name, file_type], ''));

    % preload dataframe for all imagedata 
    df(1:16, 1:3) = ExperimentData(1,1,1,1);

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
        label = split(file_name, '0');
        exp_data = ExperimentData(path,label(1),ch_idx, t_idx);
        exp_data.setMeanIntensity();
        exp_data.loadData();

        df(t_idx+1, ch_idx+1) = exp_data;

        percentDone = 100 * n / length(files);
        msg = sprintf('%3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        
        n = n+1;
    end
end

