function [well_posn, well] = get_well_posn(data, threshold)
[~, N, ~] = size(data);
well = ones(1,N);
    for n = 1:N
        y = data(:,n,2)';
        if threshold == 'y'
            y = y - mean(y(floor(length(y)/2) : end));
        end
        dy = diff(y);

        % get well
        [~, i1] = max(dy(1:500));
        well(n) = i1;
    end
    well_posn = mean(well);
end
