function df = get_pen_depth(df, threshold, fcn_name)
    
    
[N_tp, N_ch] = size(df);
    for t_idx = 1:N_tp
        for ch_idx = 1:N_ch
            pd_data = [];
            expdata = df{t_idx,ch_idx};
            
            % get specific data
%           y = data(:,n,c)';
            y = expdata.MeanIntensity;           
            L = length(y);
            wp = expdata.WellPosn;
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
            % change to mean or min for debugging, 
            
            i2 = feval(fcn_name,x(y < max(y)*threshold));
            %[i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
            
            if size(i2,2) == 0
                pd_data(1) = x(end);    
            else
                pd_data(1)= i2;
            end
            
           pd_data(2) = pd_data(1)/10e-3;
           pd_data(3) = trapz(y);
           
           expdata.setPenData(pd_data, fcn_name);
        end
    end
end
