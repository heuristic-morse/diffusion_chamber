function [mean_intensity, df] = load_data(folder_name, file_type)

    % find all files in dir that end with .jpg
    files = dir(join([folder_name, file_type], ''));

    % preload dataframe with all imagedata and mean_intensity 
    df = {};
    mean_intensity = [];

    n = 1;
    reverseStr = '';
    
    fprintf('Percent done: ');

    for file = files'
        file_name = file.name;
        sprintf('file_name is %s', file_name);
        channel = imread(join([folder_name, file_name],'/'));
        t_idx = str2double(file_name(end-10:end-9));
        ch_idx = str2double(file_name(end-5:end-4));

        df{n, 1} = channel;
        df{n, 2} = file_name;
        mean_intensity(:,t_idx + 1, ch_idx + 1) = mean(channel)'; 
        
    
        percentDone = 100 * n / length(files);
        msg = sprintf('%3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        
        n = n+1;
    end
end

