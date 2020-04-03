function [p_depth, pct_change, c_change] = get_pen_depth(data, wp, threshold)
    
    [L, N, RGB] = size(data);
    
    p_depth = ones(N,RGB);
    pct_change =  ones(N,RGB);
    c_change = ones(N,RGB);
    for c = 1:RGB
        for n = 1:N
            % get specific data
            y = data(:,n,c)';
            x = (1:L)*(10e-3/L);
            
            % remove well posn
            x = x(floor(wp*1.1):end);
            y = y(floor(wp*1.1):end);

            % consider only x greater than location of peak intensity
            [~, i] =  max(y);
            
            % normalise y to avoid thresholding errors
            y = (y(i:end) - min(y))/max(y);
            x = x(i:end);

            % get penetration depth
            % change to mean or max for debugging 
            i2 = mean(x(y < max(y)*threshold));
            %[i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
            
            p_depth(n,c) = i2;         
%             if size(i2,2) == 0
%                 p_depth(n,c) = x(end);    
%             else
%                 p_depth(n,c) = i2;
%             end
            pct_change(n,c) = p_depth(n,c)/10e-3;
            c_change(n,c) = trapz(y);
        end
    end
end
