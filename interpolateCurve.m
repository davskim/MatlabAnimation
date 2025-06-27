%Interpolates a curve so that it can have Nnew amount of points... All you
%need to do is pass in a david style function and how many points you want.
% Another chatGpt generation... I don't know how to make a clever
%interpolation function like this... I hope it'll work...
%goddamn... It worked... I'm impressed...
function [newfunc] = interpolateCurve(xy, Nnew)
    %xy = [x(:), y(:)];
    x = xy(:,1);
    y = xy(:,2);
    dxy = diff(xy);
    segment_lengths = sqrt(sum(dxy.^2,2));
    cumlen = [0; cumsum(segment_lengths)];
    totalLength = cumlen(end);
    tnew = linspace(0, totalLength, Nnew);
    xnew = interp1(cumlen, x(:), tnew)';
    ynew = interp1(cumlen, y(:), tnew)';
    newfunc = [xnew,ynew];
end