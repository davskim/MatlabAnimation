data = doublesvg(:,1);

figure;
plot(data)
smoothed = movmean(data,3);
hold on;
plot(smoothed)

%%
data = doublesvg(:,1);
samps = size(doublesvg,1);
smoothedX = movmean(data,3);
interpedX = interp1(1:samps,smoothedX,linspace(0,samps,1000));

smoothedY = movmean(doublesvg(:,2),3);
interpedY = interp1(1:samps,smoothedY,linspace(0,samps,1000));

%% Here's the plan... I'm going to read in an SVG, detect the contiguous 
% bodies, and break down a explicit amount of samples to interpolate. I'll
% then interpolate WITHIN those bodies...

% wait actually, you don't need to do this so long as you read in the svg
% finely enough... Also the lower the value is the higher the resolution is
% lol...

parts = loadsvg('multipart.svg',.01,0);
doublesvg = [];
for i = 1:length(parts)
    doublesvg = [doublesvg; parts{1,i}];
end
M = length(doublesvg(:,1));
xi = linspace(1, M, 1000);
x_downsampled = interp1(1:M, doublesvg(:,1), xi);
M = length(doublesvg(:,2));
xi = linspace(1, M, 1000);
y_downsampled = interp1(1:M, doublesvg(:,2), xi);

figure
plot(x_downsampled,y_downsampled,'o')