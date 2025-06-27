% As the name implies, this is old, but I need this because this is
% basically the heart of LineDraw (formerly LineDraw2).
% TODO: Change the logic of LineDraw so that I no longer need this...
% Line plot that draws a line lol...
% I wonder though... Should I interpolate so that I can use this generally?
% Nah, I should staircase it... I'll pass in the line function very
% explicitly and expect it to preserve the number of datapoints... Perhaps
% I'll make an augmentation of this in the future to only require 2 points
% and it'll draw a line between the two points that you pass in...
function frameSeq = LineDrawOld(ax,startfunc,endfunc)
    if nargin == 2 %Default usage. Basically requires no previous funcion
        endfunc = startfunc;
        startfunc(:,1) = ax.XData;
        startfunc(:,2) = ax.YData;
    end
    frames = 100;
    c = 5; 
    
    %predetermining every point's movement
    xvec = endfunc(:,1)';
    yvec = endfunc(:,2)';
    predestX = repmat(xvec,frames,1);
    predestY = repmat(yvec,frames,1);
    
    logvec = linspace(0,1,length(endfunc));
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); % Should go 0-1
        predestX(i,logvec > dist) = NaN;
        predestY(i,logvec > dist) = NaN;
    end

    for i = 1:size(predestX,1)
        set(ax,'XData',predestX(i,:),'YData',predestY(i,:))
        drawnow
    end
    frameSeq = {predestX,predestY};
end