function prop_df = getPropArray(df, prop)
% Temp function to convert object propert data to array
[N_tp, N_ch] = size(df);
prop_df = {};
    for t_idx = 1:N_tp
        for ch_idx = 1:N_ch
            prop_df{t_idx,ch_idx} = df(t_idx,ch_idx).(prop);
        end
    end
end