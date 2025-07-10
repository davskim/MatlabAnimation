
function framestack = functween3(ax,startfunc,endfunc)
%This is a revamped version of functween that can output framestacks and
% also can work with the preplot function...
% TODO: make it so that I don't need a startfunction since that's annoying
    if iscell(ax) && sum(size(ax)) > 2 %checking if there are multiple axes...
        multi = true;
    else
        multi = false;
    end
    




    % Everything should be a cell now (including single tweens)
    if nargin == 2
        endfunc = startfunc;
        
        if ~multi %if it's not multiple plots, just draw the line as is...
            ax = {ax};
            endfunc = {endfunc};
            startfunc = {startfunc};
        end
        
        threeD = size(endfunc{1},2) > 2;

        for i = 1:length(ax)
            thisax = ax{i};
            thisstartax = startfunc{i};
            thisstartax(:,1) = thisax.XData;
            thisstartax(:,2) = thisax.YData;
            if threeD
                thisstartax(:,3) = thisax.ZData;
            end
            startfunc{i} = thisstartax;
        end
    else
        if ~multi %if it's not multiple plots, just draw the line as is...
            ax = {ax};
            endfunc = {endfunc};
        end
    end





    frames = 100;
    c = 5;  
    

    pdXCell = cell(1,length(endfunc));
    pdYCell = cell(1,length(endfunc));
    if threeD
    pdZCell = cell(1,length(endfunc));
    end
    
    allendfuncs = endfunc;
    allstartfuncs = startfunc;
    clear endfunc; % HORRIBLE thing to do, but I don't wanna change all my variables while upgrading this code
    clear startfunc;
    for j = 1:length(allendfuncs)
        endfunc = allendfuncs{j}; 
        startfunc = allstartfuncs{j};

        xdist = endfunc(:,1)-startfunc(:,1);
        ydist = endfunc(:,2)-startfunc(:,2);
        if threeD
        zdist = endfunc(:,3)-startfunc(:,3);
        end

        predestX = zeros(frames,length(startfunc)); %predetermining every point's movement
        predestY = zeros(frames,length(startfunc));
        if threeD
        predestZ = zeros(frames,length(startfunc));
        end
    
        for i = 1:frames
            if i ~= frames % This conditional is added to prevent Nan spaces...
                dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
                predestX(i,:) = startfunc(:,1)+dist*xdist;
                predestY(i,:) = startfunc(:,2)+dist*ydist;
                if threeD
                predestZ(i,:) = startfunc(:,3)+dist*zdist;
                end
            else
                predestX(i,:) = endfunc(:,1);
                predestY(i,:) = endfunc(:,2);
                if threeD
                predestZ(i,:) = endfunc(:,3);
                end
            end
        end

        framestack{j} = {predestX,predestY,predestZ};


    end


    allax = ax; % again... HORRIBLE practice, but I need this okay?
    clear ax;
    for i = 1:frames
        for j = 1:length(allax)
            ax = allax{j};
            subframestack = framestack{j};
            predestX = subframestack{1};
            predestY = subframestack{2};
            predestZ = subframestack{3};
            if threeD
            set(ax,'XData',predestX(i,:),'YData',predestY(i,:),'ZData',predestZ(i,:))
            else
            set(ax,'XData',predestX(i,:),'YData',predestY(i,:));
            end
        end
        drawnow
    end
    framestack = {predestX,predestY,predestZ};
end

