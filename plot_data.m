function [] = plot_data(df, opt, c_opt)

% get a long figure window (to max size of image)
h1 = figure('Renderer', 'painters');%, 'Position', [500 500 1600 500]);
[N_timepoints, N_channels] = size(df);
rgb = ['r', 'g','b'];

switch opt
    case 1
        % rgb choice:
        for ch_idx = 1:N_channels
            figure(h1)
            p_depths = 1:N_timepoints;
            for t_idx = 1:N_timepoints    
                expdata = df{t_idx,ch_idx};
                
            % plotting image
                subplot(N_channels,1,ch_idx)
                y = expdata.MeanIntensity;     
                pd = expdata.PenDepth;
                wp = expdata.WellPosn;

                x = 1:length(y);

                xx = x;
                yy = y;

                % use only from well posn
                x = x(floor(wp*1.1):end);
                y = y(floor(wp*1.1):end);

                y0 = zeros(size(y));        
                z = zeros(size(x));        
                S = surface([x;x],[y0;y],[z;z],...
                            'facecol','no',...
                            'linew',0.1,...
                            'edgealpha',.01,...
                            'edgecolor',rgb(ch_idx));

                hold on
                yL = get(gca,'YLim');
                xL = length(xx);
                plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
                line([wp wp],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k')
                line(xL.*[pd pd],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
                p_depths(t_idx) = pd;
                
%           pause(0.2)
            end
            figure(2)
            semilogy(1:N_timepoints, xL*p_depths(:,ch_idx), '--o', 'LineWidth', 1.5, 'Color', rgb(ch_idx));
            xlabel('time (30mins)')
            ylabel('x')
        %    ylim([p_depth(1, 1)-1e3, p_depth(end, c)+1e3])
            hold on
        end
        %save_fig        
        newname=join(['figures/' char(expdata.Label) '_plot_1a.png'], ''); 
        saveas(h1,newname)
        h2 = figure(2);
        newname=join(['figures/' char(expdata.Label) '_plot_1b.png'], '');
        saveas(h2,newname)
    case 2
        p_depths = 1:N_timepoints;
        for t_idx = 1:N_timepoints   
            expdata = df{t_idx,c_opt};

            pd = expdata.PenDepth;
            y = expdata.MeanIntensity;     
            wp = expdata.WellPosn;
            
            x = 1:length(y);
            total_length = length(y);
            xx = x;
            yy = y;
            
            % use only from well posn
            x = x(floor(wp*1.1):end);
            y = y(floor(wp*1.1):end);

            dy = diff(y);

            % plotting image
            subplot(3,1,1);
            plot(x, y,'LineWidth', 1, 'Color', rgb(c_opt));
            hold on
            plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
            yL = get(gca,'YLim');
            xL = length(xx);
            line([wp wp],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k')
            line(xL.*[pd pd],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');

            subplot(3,1,2);
            plot(dy, 'Color', rgb(c_opt));

            p_depths(t_idx) = pd;
            %ylim([-A, A])
            %pause(0.1)
        end

        subplot(N_channels,1,3);
        plot(1:N_timepoints, p_depths, '--o', 'LineWidth', 1.5,  'Color', rgb(c_opt));
        xlabel('time (30mins)')
        ylabel('x')
        %ylim([p_depth(1), p_depth(end) + 1])
        title(sprintf('Penetration depth is %g%%', 100*p_depths(end)/total_length))
        %save_fig
        newname=join(['figures/' char(expdata.Label) '_plot_1b.png'], '');
        saveas(gcf,newname)
end

