close all;
clearvars -except df mean_intensity
% rgb choice:
rgb = 3;
% folder choice (order by name in parent dir)
folder = 2;
% get a long figure window (to max size of image)
figure('Renderer', 'painters', 'Position', [500 500 1600 500])

for n = 1:16    
    % plotting image
    subplot(3,1,1)
    channel = df{1,folder}{3*(n- 1) + rgb,1};
    channel_name = df{1,folder}{3*(n- 1)+ rgb,2};
    if rgb == 1
        threshold = 200;
    else
        threshold = 70;
    end
    imshow(channel, [0 threshold]);
    % plotting average intensity
    subplot(3,1,2);
    plot(mean_intensity{1,folder}(:,n,rgb));
    hold on;
    plot(mean_intensity{1,folder}(:,n,rgb) + std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
    plot(mean_intensity{1,folder}(:,n,rgb) - std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
    hold off;
    % set the ylimits
    ylim([0, threshold])
    title(channel_name);

end