% I'm gonna make an improved version of my linedraw function. Basically, I
% want to upgrade it so that we can animate an entire cell of lines at
% once... I'll make it optional to have everything actually plot. That'll
% be a boolean value that I'll set... If it's set to zero, it'll just
% output a cell of animation "layers" that I'll have a separate animate
% function for... I think that animate function could end up being a heart
% of my code...

% TODO: GET RID OF SAVEANI

function frameSeq = LineDraw(ax,endfunc,func,autoscale)
    if iscell(ax) && sum(size(ax)) > 2 %checking if there are multiple axes...
        multi = true;
    else
        multi = false;
    end
    if ~multi %if it's not multiple plots, just draw the line as is...
        frameSeq = LineDrawOld(ax,endfunc);
        return
    end
    if nargin == 2
        func = @InvCarv;
        autoscale = false;
        saveani = false;
    elseif nargin == 3
        if ~isfloat(func)
            autoscale = false;
            saveani = false;
        else
            autoscale = false;
            saveani = func;
            func = @InvCarv;
        end
    elseif nargin == 4
        saveani = autoscale;
        autoscale = false;
    end
    
    %checking for autoscaling
    if autoscale
        for i = 1:length(endfunc)
            % TODO... I stopped because diffeqs can become infinite, so
            % whoopty do...
        end
    end

    frames = 100;
    c = 5; 
    
    % I have to loop through every axis in the ax cell...
    xFramCell = {};
    yFramCell = {};
    assert(iscell(endfunc))
    assert(iscell(ax))
    assert(length(endfunc) == length(ax))
    pdXCell = cell(1,length(endfunc));
    pdYCell = cell(1,length(endfunc));
    for j = 1:length(ax)
        %predetermining every point's movement
        thisendfunc = endfunc{1,j};
        xvec = thisendfunc(:,1)';
        yvec = thisendfunc(:,2)';
        predestX = repmat(xvec,frames,1);
        predestY = repmat(yvec,frames,1);
       
        predestX = func(predestX,frames);
        predestY = func(predestY,frames);

        pdXCell{1,j} = predestX;
        pdYCell{1,j} = predestY;
        frameSeq{1,j} = {predestX predestY};
    end

    % Okay, now that we looped through and got all the frame stacks, now we
    % can plot all the axes... one at a time...
    hold on;
    for i = 1:frames
        for j = 1:length(ax)
            predestX = pdXCell{1,j};
            predestY = pdYCell{1,j};
            set(ax{1,j},'XData',predestX(i,:),'YData',predestY(i,:))
        end
        drawnow
    end
end