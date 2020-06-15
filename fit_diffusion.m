D=  [];
run_label = {};
idx = 1;

outliers = zeros(12,3);

outliers(2,1) = 1;
outliers([2,3,6],2) = 1;
outliers([2,3],3) = 1;

check_run = zeros(12,3);
check_run(5,1) = 1;
% check_run([1, 4, 7, 10],1) = 1;
% check_run([1, 4, 7, 10],2) = 1;
% check_run([1, 4, 7, 10],3) = 1;

plt_opt = 'y';
anim_opt = 'n';

for ch = 1:3
channel = sprintf('chip%d.mat', ch);

load(channel);
c = 2;
color = {'red', 'green', 'blue'};
    for i = 5

        chip_data = split(df{i}(1,1).Label,'_');
        chip_label{idx} = chip_data{1};
        run_label{idx} = chip_data{2};
        tmp  = split(chip_data{2}, ' ');
        exp_label{idx} = tmp{1};

        if outliers(i, ch) == 1
            continue
        end

        % print out of which chip and experiment number for debugging
        fprintf('%s - %s (Run %g)\n',channel,color{c}, i);

        % get data from experiment data chip file
        tmp = df{i}(:,c);

        % select range of x values (x2=8500 seems end of channel)
        x1 = 1;% requires well to fit diffusion
        x2 = 8500;
        x = x1:x2;

        % number of time points
        t = 16;

        for ti = 1:t 

            % moving window average (window size of 1000)
            tmpY = movmean(tmp(ti).MeanIntensity,1000);
            tmpY = tmpY(x1:x2);

            % normalise all data by subtracting min and dividing by max of Y1
            if ti == 1
                minX = min(tmpY(x1:x2));
                maxX = max(tmpY(x1:x2) - minX);
            end

            % normalise and select only relevant range
            y = (tmpY - minX)/maxX;

            % moving window average (window size of 1000)
            tmpY = movmean(tmp(ti).MeanIntensity,1000);
            tmpY = tmpY(x1:x2);

            tmpY = (tmpY - min(tmpY))/max(tmpY - min(tmpY));
            
            % Choice of fitting equation and subsequnt fitting
    %        % Case 1
    %        % Diffusion from a well - includes additional fitting parameter
    %        (wellLength)
            [xData, yData] = prepareCurveData( x, y);
            fitresult = fittype(sprintf('0.5*(erf((x+wellLength)./(2*sqrt(D*%d))) - erf((x-wellLength)./(6*sqrt(D*%d))))',[ti*108000, ti*108000]),...
                     'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';

            % Fit parameter ranges for [D wellLength])
            opts.Lower = [0 0];
            opts.StartPoint = [5 2000];
            opts.Upper = [30 4000];

    %        % Case 2 
    %        % Constant Source Diffusion - requires constant max at x=0

    %         fitresult = fittype(sprintf('(1/sqrt(2*D*%d))*abs(exp(-(x*x)./(4*D*%d)))',[ti*108000, ti*108000]),...
    %              'independent', 'x', 'dependent', 'y' );
    %         opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    %         opts.Display = 'Off';
    %         opts.Lower = 0;
    %         opts.StartPoint = 5;
    %         opts.Upper = 30;

    %        % Case 3
    %        % Instantaneous Source Diffusion - ignores additional contribution
    %        % from well
    %          fitresult = fittype(sprintf('erfc(x/(2*sqrt(D*%d)))',ti*108000),...
    %              'independent', 'x', 'dependent', 'y' );
    %         opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    %         opts.Display = 'Off';
    %         opts.Lower = 0;
    %         opts.StartPoint = 5;
    %         opts.Upper = 30;

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, fitresult, opts );

            % Save diffusion 
            D(ti, idx) = fitresult.D;
            % Save gof statistics
            gof_r2(ti,idx) = gof.adjrsquare;
            gof_rmse(ti,idx) = gof.rmse;
            % Save end amount
            endpoints(ti,idx) = tmpY(end);
            if anim_opt == 'y'
                % Capture the plot as an image 
                frame = getframe(fig_gif); 
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256); 
                % Write to the GIF File 
                if n == 1 
                  imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
                else 
                  imwrite(imind,cm,filename,'gif','WriteMode','append'); 
                end 
            end
            
            
            if plt_opt == 'y' && check_run(i, ch) == 1
                h = figure('units','normalized','outerposition',[0.2 0.2 0.6 0.6]);

                subplot(2,1,1)

                % Plot data
                plot(x, y, 'k');
                hold on
                % Plot fit 
                plot(xData, fitresult(xData), '--r');                

                % Line showing fitted welllength
                xline(fitresult.wellLength);

                xlabel('x');
                ylabel('Normalised Concentration (a.u.)');
                title(sprintf('%s - %s (Run %g): Time %dmins',channel,color{c}, i, ti*30))
                ax = gca;
                ax.FontSize = 16;
                ylim([0 1]);
                
                subplot(2,1,2)
                plot(fitresult,xData, yData,'fit','residuals')
                title(sprintf('Residuals (gof: R^2 = %g, RMSE = %g)', gof.adjrsquare, gof.rmse));
                ax = gca;
                ax.FontSize = 16;

                pause();
%                 close(h);
            end

        end
        
        if check_run(i, ch) == 1
            h = figure('units','normalized','outerposition',[0.2 0.2 0.6 0.6]);
            plot(D(:,idx), 'o--') 
            title(sprintf('%s - %s (Run %s): fitted diffusion over time',channel,color{c}, run_label{idx}))
            xlabel('Time (30mins)');
            ylabel('D (um^2/s)');
            ax = gca;
            ax.FontSize = 18;
            pause()
            close(h);
        end
        idx = idx + 1;
    end
end
%% Create box plot of diffusion per run
h = figure('units','normalized','outerposition',[0.2 0.2 0.6 0.6]);
boxplot(D(1:end,:), run_label)
xlabel('Experiment');
ylabel('D (um^2/s)');
ax = gca;
ax.FontSize = 18;
title(sprintf('%s - %s',channel,color{c}))

%% Create box plot of diffusion per gel
h2 = figure('units','normalized','outerposition',[0.2 0.2 0.6 0.6]);
boxplot(D(3:end,:), exp_label)
xlabel('Experiment');
ylabel('D (um^2/s)');
ax = gca;
ax.FontSize = 18;
title(sprintf('%s - %s',channel,color{c}))

%% goodness of fit 

figure
bar(sum(gof_r2>0.9))
set(gca,'XTick', 1:30,'XTickLabel', exp_label)
ylabel('# of tpoints w R^2 > 0.9')
xlabel('experiment label')
set(gca,'XTick', 1:30,'XTickLabel', run_label)
set(gcf,'color','w');
ax = gca;
ax.FontSize = 18;
title(sprintf('number of fits w R^2 > 0.9 - %s',color{c}))


%% goodness of fit corrected boxplot

boxplot(D(:,(sum(gof_r2>0.95) > 10)),  run_label(sum(gof_r2>0.95) > 10))
xlabel('Experiment');
ylabel('D (um^2/s)');
ax = gca;
ax.FontSize = 18;
title(sprintf('all channels - %s',color{c}))

%% goodness of fit corrected boxplot

boxplot(D(:,(sum(gof_r2>0.9) > 11)),  exp_label(sum(gof_r2>0.9) > 11))
xlabel('Experiment');
ylabel('D (um^2/s)');
ax = gca;
ax.FontSize = 18;
title(sprintf('all channels & all experiments - %s',color{c}))