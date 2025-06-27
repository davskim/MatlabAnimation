% needs a path and points you want to read it as...
% This is basically the interpolation function and loadsvg function (not my code)
% So you might need to include the path if you don't have it already...
function xy = readSVG(path,points)
    parts = loadsvg(path,.01,0);
    doublesvg = [];
    for i = 1:length(parts)
        doublesvg = [doublesvg; -1*parts{1,i}];
    end
    M = length(doublesvg(:,1));
    xi = linspace(1, M, points);
    x_downsampled = interp1(1:M, doublesvg(:,1), xi);
    M = length(doublesvg(:,2));
    xi = linspace(1, M, points);
    y_downsampled = interp1(1:M, doublesvg(:,2), xi);

    xy = [x_downsampled(:),y_downsampled(:)];
end