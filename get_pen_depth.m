function [p_depth] = get_pen_depth(data, wp, threshold)
    
    [~, N, RGB] = size(data);
    p_depth = ones(N,RGB);
    
    for c = 1:RGB
        for n = 1:N
            % get specific data
            y = data(:,n,c)';
            x = 1:length(y);
            
            % remove well posn
            x = x(floor(wp*1.1):end);
            y = y(floor(wp*1.1):end);

            % get penetration depth
            [i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
            
            if size(i2,2) == 0
                p_depth(n,c) = x(end);    
            else
                p_depth(n,c) = i2;
            end
        end
    end
end
