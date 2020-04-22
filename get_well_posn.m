function df = get_well_posn(df, threshold, run)

[N_tp, N_ch] = size(df);
    for t_idx = 1:N_tp
        for ch_idx = 1:N_ch
            expdata = df(t_idx,ch_idx);

            if run == 0
               expdata.setWellPosn(1);        
            else
                y = expdata.MeanIntensity;
                if threshold == 'y'
                    y = y - mean(y(floor(length(y)/2) : end));
                end
                dy = diff(y);

                % get well posn
                [~, well] = max(dy(1:500));
                expdata.setWellPosn(mean(well));        
            end        
        end
    end

end
