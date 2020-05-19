ch = 'chip1.mat';
plt_opt = 'n';

load(ch);
c = 2;
color = {'red', 'green', 'blue'};
for i = 1:12
    % print out of which chip and experiment number for debugging
    fprintf('%s - %s (Run %g)\n',ch,color{c}, i);
    
    % get data from experiment data chip file
    tmp = df{i}(:,c);
    
    % select range of x values (x2=8500 seems end of channel)
    x1 = 1;%500;
    x2 = 8500;
    x = x1:x2;
    
    % number of time points
    t = 1:16;

    % initialise plot window to watch fitting
    if plt_opt =='y'
        h = figure('units','normalized','outerposition',[0.5 0.5 0.6 0.6]);
    end
    
    for ti = 1:16

        % moving window average (window size of 1000)
        tmpY = movmean(tmp(ti).MeanIntensity,1000);

        % normalise all data by subtracting min and dividing by max of Y1
        if ti == 1
            minX = min(tmpY(x1:x2));
            maxX = max(tmpY(x1:x2) - minX);
        end

        % normalise and select only relevant range
        tmpY = (tmpY - minX)/maxX;
        y = tmpY(x1:x2);
        
        % Choice of fitting equation and subsequnt fitting
%        % Case 1
%        % Diffusion from a well - includes additional fitting parameter
%        (wellLength)
        [xData, yData] = prepareCurveData( x, y);
        fitresult = fittype(sprintf('0.5*(erf((x+wellLength)./(2*sqrt(D*%d))) - erf((x-wellLength)./(2*sqrt(D*%d))))',[ti*108000, ti*108000]),...
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
        D(ti, i) = fitresult.D;

        if plt_opt == 'y'
            % Plot data
            plot(x, y(ti,:), 'k');
            hold on
            % Plot fit 
            plot(xData, fitresult(x), '--r' );
            
            % Line showing fitted welllength
            xline(fitresult.wellLength);
    
            title(sprintf('%s - %s (Run %g): Time %d*30mins',ch,color{c}, i, ti))
            xlabel('x');
            ylabel('Normalised Concentration (a.u.)');
            ax = gca;
            ax.FontSize = 18;

            pause(0.3);
        end
    end
end
%% Create box plot of diffusion
h = figure('units','normalized','outerposition',[0.5 0.5 0.6 0.6]);
boxplot(D)
xlabel('Experiment');
ylabel('D (um^2/s)');
ax = gca;
ax.FontSize = 18;
            
