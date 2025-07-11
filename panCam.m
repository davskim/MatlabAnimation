% I wonder if I can actually get the axis data from here..
% the panto variable should be a 2x2 double matrix... 
% should be simple enough right?
% TODO: output framestacks... Uh... If... if I can...
% All lines by default exist in the Zdimensiom as well... ChatGPT lied to
% me... Liar...
function framestack = panCam(ax,panto)
    frames = 100;
    c = 5;
    curX = xlim(ax.Parent);
    curY = ylim(ax.Parent);
    if length(panto) > 2
        curZ = ax.Parent.ZLim;
    end

    xdist = panto(1,:)-curX;
    ydist = panto(2,:)-curY;
    if length(panto) > 2
        zdist = panto(3,:) - curZ;
    end

    xframes = zeros(frames,2);
    yframes = zeros(frames,2);
    zframes = zeros(frames,2);
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1
        xlim(ax.Parent,curX + xdist*dist)
        xframes(i,:) = curX + xdist*dist;

        ylim(ax.Parent,curY + ydist*dist)
        yframes(i,:) = curY + ydist*dist;

        if length(panto) > 2
            zlim(ax.Parent,curZ + zdist*dist)
            zframes(i,:) = curZ + zdist*dist;
        end
        drawnow
    end

    if length(panto) > 2
        framestack = {xframes, yframes, zframes};
    else
        framestack = {xframes, yframes};
    end
end