fig = figure;

xdat = 1:200;
ydat = sin(xdat/20);

plot(xdat,ydat);


%%
fig = figure;
ax = plot(1,1,'o');
xlim([0,2])
ylim([0,2])

set(ax,'XData',1.5,'YData',1)

%%
fig = figure;
ax = plot(1,1,'o');
xlim([0,2])
ylim([0,2])

for i = 1:100
    set(ax,'XData',1+(i/100),'YData',1+(i/100))
    drawnow
end

%% Make the point move logistically 

fig = figure;
ax = plot(1,1,'o');
xlim([0,3])
ylim([0,3])

frames = 100;
for i = 1:frames
    dist = 1 / (1 + 2^(20*(-2*(i/frames) + .35)));
    set(ax,'XData',1+dist,'YData',1+dist)
    drawnow
end


%% Make the point move asymptotically 

fig = figure;
ax = plot(1,1,'o');
xlim([0,3])
ylim([0,3])

frames = 100;
c = 15;
for i = 1:frames
    dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
    set(ax,'XData',1+dist,'YData',1+dist)
    drawnow
end


%% Using a function
figure;
ax = plot(1,1,'o');
xlim([0,3])
ylim([0,3])

pointtween(ax,[.4,.2],[2,2.9])



%% Trying to tween functions now... This will be kinda hard...

figure;
x = [(1:300) / 100]';
y = sin(5*x);

ax = plot(x,y,'o');

xlim([0,3])
ylim([-3,3])

while 1
    functween(ax,[x,y],[x,3*y])
    functween(ax,[x,3*y],[x,y])
    functween(ax,[x,y],[x,sin(10*x)])
    functween(ax,[x,sin(10*x)],[x,1.5*sin(12*x)])
    functween(ax,[x,1.5*sin(12*x)],[x,y])
    functween(ax,[x,y],[cos(linspace(0,2*pi,300)')+1.5,sin(linspace(0,2*pi,300)')*2])
    functween(ax,[cos(linspace(0,2*pi,300)')+1.5,sin(linspace(0,2*pi,300)')*2],[x,y])
end

%% let's try to pan the axis now...
figure;
x = [(1:300) / 100]';
y = sin(5*x);

ax = plot(x,y,'o');

xlim([0,3])
ylim([-3,3])

while 1
    panCam(ax,[-1,4;-4,4])
    panCam(ax,[-1,1;-3,3])
    panCam(ax,[-5,5;-5,5])
    panCam(ax,[0,3;-3,3])
end

%% Let's combine
figure;
x = [(1:300) / 100]';
y = sin(5*x);

ax = plot(x,y,'o');

xlim([0,3])
ylim([-3,3])

while 1
    panCam(ax,[-1,4;-4,4])
    functween(ax,[x,y],[x,3*y])
    panCam(ax,[-1,1;-3,3])
    panCam(ax,[0,5;-5,5])
    functween(ax,[x,3*y],[5*x,2*y])
    functween(ax,[5*x,2*y],[cos(linspace(0,2*pi,300)')+1.5,sin(linspace(0,2*pi,300)')*2])
    panCam(ax,[0,3;-3,3])
    functween(ax,[cos(linspace(0,2*pi,300)')+1.5,sin(linspace(0,2*pi,300)')*2],[x,y])
end

%% I want to create a differnt kind of tween
% instead of having all of the points move at once, I want them all to move
% one at a time... This will be hard though because.. they need to be
% staggered in movement... I can't just fully animate one point at a
% time...

figure;
x = [(1:300) / 100]';
y = sin(5*x);
ax = plot(x,y,'o');
xlim([0,3])
ylim([-3,3])

while 1
    Sandfunctween(ax,[x,y],[x,3*y])
end

%% Okay, this techincally works, but it's god awfully slow...
% Oh! What about predetermining the path of every tween FIRST! And then
% staggering them? After that, we can just loop through the new data and
% animate!


function Cascadefunctween(ax,startfunc,endfunc)
    frames = 100;
    c = 5;
    

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    ax.XData = startfunc(:,1);
    ax.YData = startfunc(:,2);
    for j = 1:size(startfunc,1)
        for i = 1:frames
            dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1

            logicVec = zeros(size(startfunc,1),1);
            logicVec(j) = 1;
            set(ax,'XData',startfunc(:,1)+dist*xdist.*logicVec,'YData',startfunc(:,2)+dist*ydist.*logicVec)
            drawnow
        end
        startfunc(:,1) = ax.XData';
        startfunc(:,2) = ax.YData';
    end
end


% I need to start off with tweening between two functions of the same
% length. 
% Each function needs a column of x and y 
function Sandfunctween(ax,startfunc,endfunc)
    frames = 100;
    c = 5;
    

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    ax.XData = startfunc(:,1);
    ax.YData = startfunc(:,2);
    for j = 1:size(startfunc,1)
        for i = 1:frames
            dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1

            logicVec = zeros(size(startfunc,1),1);
            logicVec(j) = 1;
            set(ax,'XData',startfunc(:,1)+dist*xdist.*logicVec,'YData',startfunc(:,2)+dist*ydist.*logicVec)
            drawnow
        end
        startfunc(:,1) = ax.XData';
        startfunc(:,2) = ax.YData';
    end
end


% I wonder if I can actually get the axis data from here..
% the panto variable should be a 2x2 double matrix... 
% should be simple enough right?
function panCam(ax,panto)
    frames = 100;
    c = 5;
    curX = xlim(ax.Parent);
    curY = ylim(ax.Parent);
    xdist = panto(1,:)-curX;
    ydist = panto(2,:)-curY;
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1
        xlim(ax.Parent,curX + xdist*dist)
        ylim(ax.Parent,curY + ydist*dist)
        drawnow
    end
end


% I need to start off with tweening between two functions of the same
% length. 
% Each function needs a column of x and y 
function functween(ax,startfunc,endfunc)
    frames = 100;
    c = 5;
    

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
        
        set(ax,'XData',startfunc(:,1)+dist*xdist,'YData',startfunc(:,2)+dist*ydist)
        drawnow
    end
end

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
