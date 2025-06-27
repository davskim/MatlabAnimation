%Tweens a point from a start to an endpoint
% TODO: I need to output framestacks
function pointtween(ax,startpoint,endpoint)
    frames = 100;
    c = 15;
    xdist = endpoint(1)-startpoint(1);
    ydist = endpoint(2)-startpoint(2);
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
        
        set(ax,'XData',startpoint(1)+dist*xdist,'YData',startpoint(2)+dist*ydist)
        drawnow
    end
end