chips  = {'chip1','chip2','chip3'};
for c = 1:length(chips)
    chip = chips{c};
    load(sprintf('%s.mat', chip));

    %% plot all data at end timepoint
    rgb = ['r', 'g', 'b'];

    h = figure('units','normalized','outerposition',[0 0 1 1]);
    for m = 0:2
        for n = 1:4
        subplot(4,3, 4*m + n)
        for c = 1:3
            y = df{4*m + n}(end,c).MeanIntensity;

            y = (y - min(y))/max(y- min(y));
            avg_y = movmean(y, 1000);     
            plot(y, rgb(c));
            hold on
            plot(avg_y, rgb(c), 'LineStyle', '--', 'LineWidth', 1);
        end
        chip_data = split(df{4*m + n}(1,1).Label,'_');
        title(sprintf('%s - %s (Run %g)',chip_data{1},chip_data{2}, 4*m + n))
    %     xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
        ax = gca;
        ax.FontSize = 18;
        end
    end
    [ax1,h1]=suplabel('Distance (a.u)');
    [ax2,h2]=suplabel('Intensity (a.u)', 'y');
    set(h1,'FontSize',20)
    set(h2,'FontSize',20)

    tightfig()            
    saveas(h,sprintf('%s_comp_all_data.png',chip))
    % print(h,'-dtiff', sprintf('%s_comp_all_data.tiff',chip))
    close;

    %% plot color with threshold at end timepoint
    rgb = ['r', 'g', 'b'];
    for c = 2:3
        thresholds = [0.1, 0.2, 0.3, 0.5];
        h = figure('units','normalized','outerposition',[0 0 1 1]);
        for m = 0:2
            for n = 1:4
            subplot(4,3, 4*m + n)
            y = df{4*m + n}(end,c).MeanIntensity;

            y = movmean(y, 1000);     
            y = (y - min(y))/max(y- min(y));

            plot(y, rgb(c), 'LineStyle', '--', 'LineWidth', 1);
            hold on
            chip_data = split(df{4*m + n}(1,1).Label,'_');
            title(sprintf('%s (Run %g)',chip_data{2}, 4*m + n))
            for t = 1:length(thresholds)
                get_pen_depth(df{4*m + n}, thresholds(t), 'mean');
                xline(df{4*m + n}(end,c).PcntPenDepth*100, '--k','LineWidth', 2);
                yline(thresholds(t), ':k','LineWidth', 1);
                hold on
            end
            ax = gca;
            ax.FontSize = 14;
            end
        end
        if c == 3
            color = 'blue';
        elseif c==2
            color = 'green';
        end
        [ax1,h1]=suplabel('Distance (a.u)');
        [ax2,h2]=suplabel('Intensity (a.u)', 'y');
        [ax4,h3]=suplabel(sprintf('%s - (%s, thresholds = 50%%, 30%%, 20%%, 10%%)',chip_data{1}, color)  ,'t');
        set(h1,'FontSize',20)
        set(h2,'FontSize',20)
        set(h3,'FontSize',20)
        tightfig()            
        saveas(h,sprintf('%s_comp_%s_threshold_data.png',chip,color))
        close;
    end

    %% Calculate percentage change over all experiments

    % get data for bar charts
    c_opt = [2 3];
    for t = 1:length(thresholds)

        exp_results = [];
        for n = 1:length(df)
            get_pen_depth(df{n}, thresholds(t), 'mean');
            [N_exp, N_ch] = size(df{n});
            tmp = cell2mat(getPropArray(df{n},'PcntPenDepth'));
            exp_results(n,:) = tmp(end,:);
            exp_label{:, n} = join(['Run', string(n)]);% + "CH"+ string(getPropArray(df{1}, 'ChannelNum'));    
            chip_data = split(df{n}(1,1).Label,'_');
            chip_label{n} = chip_data{1};
            run_label{n} = chip_data{2};
        end
        %get colours for bar charts
        base = repmat([0 0 0], length(c_opt),1);
        for n = 1:length(c_opt)
            base(n, c_opt(n)) = 1;    
        end

        %plot colours for all experiments
        h = figure('Renderer', 'painters');
        ax = gca;
        hb = bar(exp_results(:, c_opt));
        %hb.FaceColor = 'flat';
        ax.XTickLabel = run_label;
        set(gcf,'color','w');    
        for n = 1:length(c_opt)  
            hb(n).FaceColor = rgb(c_opt(n));
        end
        ax.FontSize = 14;
        xticks([1:length(exp_results(:, c_opt))])
        xtickangle(45)
        yticks([0 20 40 60 80 100]);
        ylabel('Penetration Depth of Dye/Particle (%)');
        title_str = sprintf('%s (threshold=%d%%)',chip_label{1}, thresholds(t)*100);
        title(title_str, 'FontSize', 24)
        tightfig()            
        saveas(h,sprintf('%s_penetration_th_%g.png',chip,t))
        close;

        %% Getting triplicate data
        %number of independent exps (ie gels)
        n_gels = length(exp_results)/3;
        trp_mean = []; trp_std = [];trp_labels = {};
        for n = 1:n_gels
            triplicates = 3*n-2:3*n;
            c_m = mean(exp_results(triplicates,c_opt));
            c_std = std(exp_results(triplicates,c_opt));
            trp_mean = horzcat(trp_mean, c_m);
            trp_std = horzcat(trp_std, c_std);
            chip_data = split(run_label{3*n-2}, ' ');
            trp_labels{2*n -1} = string(chip_data(1));
            trp_labels{2*n} = string(chip_data(1));
        end

        %plot colours for trip experiments
        h = figure('units','normalized','outerposition',[0.5 0.5 0.6 0.6]);
        ax = gca;
        hb = bar(trp_mean);
        hb.FaceColor = 'flat';
        hold on
        errorbar(1:length(trp_mean), trp_mean,trp_std, 'or', 'MarkerSize', 8, 'LineWidth', 1);
        set(gca,'XTick', 1:7,'XTickLabel', trp_labels)
        set(gcf,'color','w');    
        hb.CData(:,:) = repmat(base, length(trp_mean)/length(c_opt),1);

        ax.FontSize = 14;
        xticks([1:length(exp_results)])
        xtickangle(45)
        yticks([0 20 40 60 80 100]);
        ytickformat('percentage');
        ylabel('Mean Penetration Depth (%)');
        title_str = sprintf('Triplicate avg for %s (threshold=%d%%)',chip_label{1}, thresholds(t)*100);
        title(title_str, 'FontSize', 24)
        tightfig() 
        saveas(h,sprintf('%s_penetration_th_%g_trp_avg.png',chip,t))
        close();
    end
end
%% Comparison of data
for c = 2:3
    if c == 3
        color = 'blue';
        c_min = 0;
    elseif c==2
        color = 'green';
        c_min = 80;
    end

    for t = 1:length(thresholds)
        h = figure('units','normalized','outerposition',[0.5 0.5 0.6 0.6]);
        idx = 1;
        for ch = 1:length(chips)
            chip = chips{ch};
            load(sprintf('%s.mat', chip));
            for n = 1:length(df)
                get_pen_depth(df{n}, thresholds(t), 'mean');
                tmp = cell2mat(getPropArray(df{n},'PcntPenDepth'));
                exp_results(idx) = tmp(end,c);
                chip_data = split(df{n}(1,1).Label,'_');
                run_label = chip_data{2};
                chip_data = split(run_label, ' ');
                exp_label(idx) = chip_data(1);
                idx = idx +1;
            end
        end

         boxplot(exp_results,exp_label)
        title_str = sprintf('Boxplot for all penetration data (threshold=%d%%, color=%s)',thresholds(t)*100, color);
        title(title_str);
        ylim([c_min,100])
        xlabel('Chip data');
        ytickformat('percentage');
        ylabel('Penetration Depth (%)')
        ax=gca;
        ax.FontSize = 18;
        saveas(h,sprintf('boxplot_th_%g (%s).png',t, color))
        close();
    end
end