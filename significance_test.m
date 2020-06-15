%% Comparison of data
thresholds = [0.05 0.1, 0.2, 0.3, 0.4, 0.5];
chips  = {'chip1','chip2','chip3'};
outliers = zeros(12,3);
outliers(2,1) = 1;
outliers([2,3,6],2) = 1;
outliers([2,3],3) = 1;

for c = 2:3
    if c == 3
        color = 'blue';
        c_min = 0;
    elseif c==2
        color = 'green';
        c_min = 0;
    end
    exp_results = [];
    exp_label = {};
    list = [{1}, {2}];
    for i = 1:2 % cycles through comparisons between C/M, +/-, and combinations of all 4
        for t = 1:length(thresholds)
            idx = 1;
            for ch = 1:length(chips)
                chip = chips{ch};
                load(sprintf('%s.mat', chip));
                for n = 1:length(df)
                    % only calculte boxplot using non-outlier results
                    if outliers(n,ch) ~= 1
                        get_pen_depth(df{n}, thresholds(t), 'intcp');
                        tmp = cell2mat(getPropArray(df{n},'PcntPenDepth'))*100;
                        exp_results(idx) = tmp(end,c);

                        chip_data = split(df{n}(1,1).Label,'_');
                        run_label = chip_data{2};
                        chip_data = split(run_label, ' ');
                        exp_label(idx) = {chip_data{1}(list{i})};
                        idx = idx +1;                    
                    end
                end
            end
            gel = unique(exp_label);

            [A,sortIdx] = sort(exp_label);
            B = exp_results(sortIdx);
            tmp = [A;num2cell(B)];
            disp(sprintf("\n%s/%s, %s, %s\n", tmp{1,1}, tmp{1,end}, thresholds(t), color));
    %           check signifigance  :: 
            x = cell2mat(tmp(2, (contains(tmp(1,:),tmp(1,1)))));
            y = cell2mat(tmp(2, (contains(tmp(1,:),tmp(1,end)))));
            disp(length(x));
            disp(length(y));
            [h,p] = ttest2(x,y);
            
            if h == 1
                disp(sprintf('Statistical signifance:\n threshold=%s, %s (%s/%s) \n h = %d, p = %s',thresholds(t), color, tmp{1,1}, tmp{1,end}, h, p)); 
            end

        end
    end
end

3e-2 < 1e-2
%%