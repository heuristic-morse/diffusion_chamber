rgb = ['r', 'g', 'b'];
%% Compare mean intensity across runs (highlighting difference for first three) 
% 
% fig_gif = figure('Renderer', 'painters', 'units','normalized','outerposition',[0 0 1 1]);
% axis tight manual % this ensures that getframe() returns a consistent size
% filename = 'testAnimated.gif';
figure
for m = 0:2
%     if m == 0
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     end
    for n = 1:4
        for t= 1:12
            subplot(4,3, 4*m + n)
            data = movmean(df{4*m + n}(t,3).MeanIntensity, 1000);% - df{4*m + n}(1,3).MeanIntensity,1000);
            [~, i] = min(diff(data));
            plot(df{4*m + n}(t,3).MeanIntensity, '--','LineWidth', 0.5);
            hold on;
            plot(data, 'b','LineWidth', 1.5);
            xline(i, '--k');
            plot(i,data(i), 'Or', 'MarkerSize', 10);
            j = find(data == min(data(i:end)), 1);
            xline(j, '--r') 
            
            hold off;
            title(sprintf('Run %g', 4*m + n))

            xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
            ylim([0 2.5e4])
            pause();
% 
%             % Capture the plot as an image 
%             frame = getframe(fig_gif); 
%             im = frame2im(frame); 
%             [imind,cm] = rgb2ind(im,256); 
%             % Write to the GIF File 
%             imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end
    end
end

%% Compare mean intensity across runs (highlighting difference for first three) 
% 
fig_gif = figure('Renderer', 'painters', 'units','normalized','outerposition',[0 0 1 1]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'newPenDepth.gif';
for m = 0:2
%     if m == 0
%         % Capture the plot as an image 
%         frame = getframe(fig_gif); 
%         im = frame2im(frame); 
%         [imind,cm] = rgb2ind(im,256); 
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     end
    ch = 2;
    for n = 1:4
        subplot(4,3, 4*m + n)
        for t= 1:12
            data = movmean(df{4*m + n}(t,ch).MeanIntensity, 1000);% - df{4*m + n}(1,3).MeanIntensity,1000);
            data_t0 = movmean(df{4*m + n}(1,ch).MeanIntensity, 1000);% - df{4*m + n}(1,3).MeanIntensity,1000);
            x = 1:length(data);
            h = max(data)*0.2;
            if t == 1
                [~, i] = min(diff(data));
%                h = data(i);
                j = i;
            else        
                x = x(i:end);
                j = min(x(data(i:end) < h*1.05 & data(i:end) > h*0.95));
            end
%            plot(df{4*m + n}(t,ch).MeanIntensity - df{4*m + n}(1,ch).MeanIntensity, '--','LineWidth', 0.5);
            plot(df{4*m + n}(t,ch).MeanIntensity, '--','LineWidth', 0.5);
            hold on;
            plot(data, rgb(ch),'LineWidth', 1.5);
            plot(data_t0, 'k','LineWidth', 1.5);
            
            xline(i, '--k');
            yline(h, '--k');
            plot(i,h, 'Xr', 'MarkerSize', 10);

% %             j = find(min(data < min(data(i:end)), 1);
%             disp(j)
%             xline(j, '--r') 
            
            hold off;
            title(sprintf('Run %g', 4*m + n))

%             xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
            ylim([0 1.5e4])
            pause();
%             % Capture the plot as an image 
%             frame = getframe(fig_gif); 
%             im = frame2im(frame); 
%             [imind,cm] = rgb2ind(im,256); 
%             % Write to the GIF File 
%             imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end
    end
end

%% Compare difference between t0 and mean intensity across runs 
% 
fig_gif = figure('Renderer', 'painters', 'units','normalized','outerposition',[0 0 1 1]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'newPenDepth.gif';
for m = 0:2
%     if m == 0
%         % Capture the plot as an image 
%         frame = getframe(fig_gif); 
%         im = frame2im(frame); 
%         [imind,cm] = rgb2ind(im,256); 
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     end
    ch = 3;
    for n = 1:4
        subplot(4,3, 4*m + n)
        for t= 1:12
            data = movmean(df{4*m + n}(t,ch).MeanIntensity, 1000);% - df{4*m + n}(1,3).MeanIntensity,1000);
            data_t0 = movmean(df{4*m + n}(1,ch).MeanIntensity, 1000);% - df{4*m + n}(1,3).MeanIntensity,1000);
            x = 1:length(data);
            t_diff= data - data_t0;
            if t == 2
                [~, i] = min(diff(t_diff));
                h = t_diff(i);
                j = i;
            else        
                h = abs(t_diff(i)/2);
                x = x(i:end);
                j = max(x(data(i:end) < h*1.05 & data(i:end) > h*0.95));
            end
%            plot(df{4*m + n}(t,ch).MeanIntensity - df{4*m + n}(1,ch).MeanIntensity, '--','LineWidth', 0.5);
            plot(df{4*m + n}(t,ch).MeanIntensity, '--','LineWidth', 0.5);
            hold on;
            
            plot(data, rgb(ch),'LineWidth', 1.5);
%             plot(data_t0, 'k','LineWidth', 1.5);
            
%             xline(i, '--k');
%             yline(h, '--k');
%             plot(i,h, 'Xr', 'MarkerSize', 10);
            
%             [~, j] = min(t_diff(i*1.10:end));

%              xline(x(j), '--r') 
            
            hold off;
            title(sprintf('Run %g', 4*m + n))

%             xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
             ylim([0 1.5e4])
            pause(0.1);
%             % Capture the plot as an image 
%             frame = getframe(fig_gif); 
%             im = frame2im(frame); 
%             [imind,cm] = rgb2ind(im,256); 
%             % Write to the GIF File 
%             imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end
    end
end

%% Compare derivative of moving window averaged and showing inflection point

h = figure;
for m = 0:2
    for n = 1:4
        for t= 1:12
            subplot(4,3, 4*m + n)
            data = movmean(df{4*m + n}(t, 2).MeanIntensity,1000);
            plot(diff(data), 'g','LineWidth', 1.5);
            [~, i] = min(diff(data));
            hold on;
            yline(0, 'k')
            xline(i, '--k')
    
            hold off;
            title(sprintf('Run %g', 4*m + n))
            pause(0.1)
        end
    end
end


%% Compare ...

h = figure;
for m = 0:2
    for n = 1:4
        for t= 1:12
            subplot(4,3, 4*m + n)
            data = movmean(df{4*m + n}(t,3).MeanIntensity,1000);
            plot(diff(data), 'r','LineWidth', 1.5);
            [~, i] = min(diff(data));
            hold on;
            yline(0, 'k')
            xline(i, '--k')
    
            hold off;
            title(sprintf('Run %g', 4*m + n))
            pause(0.1)
        end
    end
end


%% Compare mean intensity across runs (showing penetration depth) 
h = figure;
for m = 0:2
    for n = 1:4
    subplot(4,3, 4*m + n)
    for c = 1:3
        y = df{4*m + n}(end,c).MeanIntensity;
        y = movmean(y, 1000);

        y = (y - min(y))/max(y- min(y));
     
        plot(y, rgb(c));
        hold on
    end
    title(sprintf('Run %g', 4*m + n))
    
    xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
    pause();
    end
end


%% Compare mean intensity across runs (highlighting difference for first three) 

figure

for m = 0:2
    for n = 1:4
%    subplot(4,3, 4*m + n)
    
%     plot(df{4*m + n}(end,1).MeanIntensity, 'r');
%     plot(df{4*m + n}(end,2).MeanIntensity, 'g');
    if 4*m + n < 4
        plot(df{4*m + n}(end,3).MeanIntensity, 'k', 'LineWidth', 2);
        xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2, 'LineStyle', '--');
    else
        plot(df{4*m + n}(end,3).MeanIntensity, 'b');
        xline(df{4*m + n}(end,3).PcntPenDepth*10000, 'k','LineWidth', 2);
    end
    hold on
    title(sprintf('Run 1 - %g', 4*m + n))
    end
end


%% Calculate mean intensity after removing cutoff
% Shows that doesn't make much difference

figure

for n = 1:3
    subplot(2,3,n)
    a = tmpdata{n}.Data;
    cutpoint = find(a(:,1) > mean(a(:,1)));
    
    plot(mean(a(cutpoint(1):end,:)), 'r')    
    hold on;
    plot(tmpdata{n}.MeanIntensity, 'k');
    
    subplot(2,3,4)
    plot(mean(a(cutpoint(1):end,:)), 'r')    
    hold on
    plot(df{6}(end,3).MeanIntensity, 'b', 'LineWidth', 2);

    subplot(2,3,5)
    plot(tmpdata{n}.MeanIntensity, 'k');
    hold on
    plot(df{6}(end,3).MeanIntensity, 'b', 'LineWidth', 2);
end

%% Demonstrates method for removing cutoff by calculating where mean begins

figure

for n = 1:3
    subplot(1,3,n)
    a = tmpdata{n}.Data;
    plot(a(:,1))
    
    hold on;
    yline(mean(a(:,1)), '--')
    yline(std(double(a(:,1))), '.r')
    cutpoint = find(a(:,1) > mean(a(:,1)));
    title(sprintf('cut from %g', cutpoint(1)));
end