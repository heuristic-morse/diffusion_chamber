function df = get_pen_depth(df, threshold, fcn_name)
    
[N_tp, N_ch] = size(df);
%TODO: Check influence of removing T0 from all data. 
x1 = 1500;
x2 = 8500;
L = x2 - x1;

x = 1:L;
for c_idx = 2:N_ch
    for t_idx = 1:N_tp
        pd_data = [];
        expdata = df(t_idx,c_idx);
        y = expdata.MeanIntensity;
        % get specific data
        wp = expdata.WellPosn;

%         % remove well posn <- do this explicitly through x1,x2 
%          x = x(wp:end);
%          y = y(wp:end);
        
        switch fcn_name
            case 'intcp'   
                % normalise y to avoid thresholding errors
                y = y(x1:x2);
                y = movmean(y, 1000);
                y = (y - min(y))/max(y- min(y));

                % get penetration depth
                % change to mean or min for debugging, 
                intcpt = repmat(threshold,1,length(y));
                yd = [intcpt;y];
                
                ydn = diff(yd, [], 1);              % Subtract line from curve to create zero-crossings
                px = circshift(ydn, [0 1]).*ydn;  % Use circshift to detect them
                pxi = find(px < 0);                 % Their indices

                for k1 = 2:length(pxi)              % Use interp1(Y,X,0) to get line intercepts as Xzx
                    p(k1) = interp1([ydn(pxi(k1)-1) ydn(pxi(k1))], [x(1,pxi(k1)-1) x(1,pxi(k1))], 0);
                end
                if size(p,1) == 2
                    pd_data(1) = x(end);    
                else
                    pd_data(1)= p(2);
                end

        case 'diff'
                %calculates penetration depth as maximum decrease from
                %initial peak
                
                %first calculates moving average (where window size = 1000) 
                avg_y = movmean(y, 1000);
                if t_idx == 1
                    % calculates the minimum of the first derivative
                    [~, i] = min(feval(fcn_name,avg_y ));
                    h = avg_y (i);
                    pd_data(1) = i;
                else        
                    i2 = min(x(avg_y(i:end) < h*1.05 & avg_y(i:end) > h*0.95));
                    if size(i2,2) == 0
                        pd_data(1) = x(end);    
                    else
                        pd_data(1) = i2;
                    end
                end
        end       
        pd_data(2) = pd_data(1)/L;
%        pd_data(3) = trapz(y);

       expdata.setPenData(pd_data, fcn_name);
    end
end
