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
end

% I need to start off with tweening between two functions of the same
% length. 
% Each function needs a column of x and y 
function functween(ax,startfunc,endfunc)
    frames = 100;
    c = 15;
    

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
