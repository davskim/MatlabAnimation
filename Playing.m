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
    functween3(ax,[x,3*y],[x,y])
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
figure;
x = [(1:300) / 100]';
y = sin(5*x);
ax = plot(x,y,'o');
xlim([0,3])
ylim([-3,3])

while 1
    Cascadefunctween(ax,[x,y],[x,3*y]);
    Cascadefunctween(ax,[x,3*y],[x,y]);
    panCam(ax,[0,3;0,9]);
    Cascadefunctween(ax,[x,3*x]);
    panCam(ax,[0,3;-3,3])
    Cascadefunctween(ax,[x,y]);
end

%% Okay, now how about we augment the Cascade functween to have multiple plots?
% how in the hell do I do this? Multithreading? Nah... Probably not. I
% don't want it to get that complicated... I'll start with something
% simple... I'll pass in two ax objects in a cell... I'll pass in the same
% thing with the startfunc and endfunc variables... a 2x1 cell that have
% two columns each...
figure;
x = [(1:300) / 100]';
y = sin(5*x);
ax = plot(x,y,'o');
hold on;
ax2 = plot(x,sin(10*x),'o');
xlim([0,3])
ylim([-3,3])

MultiCascade({ax,ax2},{[x,1.5*y],[x,3*y]});

%% HOLY SHIT that worked. Let's see if this works with everything...
figure;
x = [(1:300) / 100]';
y = sin(5*x);
ax = plot(x,y,'o');
hold on;
ax2 = plot(x,sin(10*x),'o');
ax3 = plot(x,x*1.2,'o');
xlim([0,3])
ylim([-3,3])

axcell = {ax,ax2,ax3};
while 1
    MultiCascade(axcell,{[x,2*sin(12*x)],[x,3*sin(x)],[x,1.5*sin(4*x)]})
    panCam(ax,[-3,3;-3,3])
    MultiCascade(axcell,{[cos(linspace(0,2*pi,300)')*2,sin(linspace(0,2*pi,300)')*2], ...
        [cos(linspace(0,2*pi,300)')*.5,sin(linspace(0,2*pi,300)')*.5], ...
        [cos(linspace(0,2*pi,300)'),sin(linspace(0,2*pi,300)')]})
    panCam(ax,[0,3;-3,3])
end

%% Transforming contiguous SVGs
figure;
x = [(1:300) / 100]';
y = sin(5*x);
ax = plot(x,y,'o');
hold on;
ax2 = plot(x,sin(10*x),'o');
ax3 = plot(x,x*1.2,'o');
xlim([0,3])
ylim([-3,3])
svg = loadsvg('test.svg',.99,0);
svg = interpolateCurve(svg{1,1},length(x));
% Let's normalize to a -3,3 grid... Wait... I can just zscore conveniently
% LMFAOOOOO THAT WORKED HOLY SHIT
svg = zscore(svg,0,1)


axcell = {ax,ax2,ax3};
while 1
    MultiCascade(axcell,{[x,2*sin(12*x)],[x,3*sin(x)],[x,1.5*sin(4*x)]})
    panCam(ax,[-3,3;-3,3])
    MultiCascade(axcell,{[cos(linspace(0,2*pi,300)')*2,sin(linspace(0,2*pi,300)')*2], ...
        [cos(linspace(0,2*pi,300)')*.5,sin(linspace(0,2*pi,300)')*.5], ...
        [cos(linspace(0,2*pi,300)'),sin(linspace(0,2*pi,300)')]})
    MultiCascade(axcell,{svg,1.5*svg,2*svg})
    panCam(ax,[0,3;-3,3])
    MultiCascade(axcell,{[x,2*sin(12*x)],[x,3*sin(x)],[x,1.5*sin(4*x)]})
end

%% Testing with previous functions
figure;
x = linspace(-3,3,300);
y = sin(5*x);
ax = plot(x,y,'o');
xlim([-3,3])
ylim([-3,3])
svg = loadsvg('test.svg',.99,0);
svg = interpolateCurve(svg{1,1},length(x));
svg = zscore(svg,0,1)

while 1
    functween(ax,svg)
    pause(1)
    Cascadefunctween(ax,[x(:),y(:)])
    pause(1)
end

%% Okay, now I want to see how it works with a multiple part SVG
% Oh weird... It can only import illustrator brush strokes... It can't do
% penstrokes...
face = readSVG('multipart.svg',1000);
face = zscore(face,0,1);
x = linspace(-3,3,1000)';

figure;
ax = plot(x,sin(5*x),'o');
xlim([-3,3])
ylim([-3,3])
while 1 
    functween(ax,[x(:),sin(5*x)]);
    pause(1)
    functween(ax,face);
    pause(1)
end

%% I wanna make something with this now...
% Shall we try... I don't know... Splitting a ephys signal into different
% parts? Something spikesortingy? I originally wanted to use this to
% explain PCA, but... Hmmm... I think I need to get better functionality to
% actually get something as beautiful as I think 3b1b's videos are...

filepath = 'D:\15minNZ\sim_binary.dat';
bin = bz_LoadBinary(filepath,'frequency',20000,'nChannels',32);

figure; 
chans = [3,4,5,6];
for i = 1:4
    subplot(4,1,i);
    plot(bin(10000:15000,chans(i)));
    axis tight;
    ylim([-1500,1500])
end

%% Making some cool stuff...
subdat = bin(10000:15000,3:6);
thisguy = NormPlot(subdat(:,1),2000);

ax = canvas(thisguy,[],[-6,6],'-')
while 1
    LineDraw(ax,NormPlot(subdat(:,2),2000));
    pause(1)
    functween(ax,NormPlot(subdat(:,3),2000));
    pause(1)
    functween(ax,NormPlot(subdat(:,4),2000));
    pause(1)
    functween(ax,NormPlot(subdat(:,1),2000));
    pause(1)
end

%% Let's try using spmd and parallel computing...
%parpool(2)

%% This might get a bit chaotic and indeterminant...
% Wait. I'm not sure if this works... I might not be able to use this after
% all... Ah well...


% ax = canvas(thisguy,'-')
% while 1
% spmd
%     functween(ax,NormPlot(subdat(:,2),2000));
%     pause(1)
%     functween(ax,NormPlot(subdat(:,3),2000));
%     pause(1)
%     functween(ax,NormPlot(subdat(:,4),2000));
%     pause(1)
%     functween(ax,NormPlot(subdat(:,1),2000));
%     pause(1)
% end
%     panCam(ax,[-4,4;-6,6])
%     panCam(ax,[-3,3;-5,5])
% end

%% I really need to try to integrate doing multiple things at once...
% For instance, I need to be able to continuously transform objects WHILE
% having something that is animating on a different layer... This sounds
% really REALLY tough...
%
% OH WAIT! What if i weaved the PREDETERMINED PATHS of each object???

%% As a quick aside, maybe I should actually use it to develop my own intuition...
% Let's visualize a linear transformation
x = (rand(1,50) -.5 ) * 2.5;
y = (rand(1,50) -.5 ) * 2.5;
ax = canvas([x(:),y(:)],'o')

while 1
    xlim(ax.Parent,[-3,3])
    ylim(ax.Parent,[-3,3])
    set(ax,'XData',x,'YData',y)
    pause(.5)
    panCam(ax,[-6,6;-6,6])
    pause(1)
    functween3(ax,[x(:),y(:)],([3,2;1,2]*[x(:),y(:)]')')
    pause(1)

end

%% Okay, this is pretty nice visualization, but I would also like a line to
% be drawn along the eigenvectors... I guess I'd have to animate lines,
% huh? That... Hmmm... I hope that isn't too hard... Should I just go
% through and modify transparencies? Or should I append data? Eh... Let's
% go transparencies... Oh... Matlab doesn't support that right now. Bummer.

x = linspace(-2.5,2.5,3000);
ax = canvas([x(:),x(:)],'-');

while 1
    LineDraw(ax,[x(:),sin(5*x(:))]);
    pause(1)
    Cascadefunctween(ax,ones(length(x),2)*x(1))
    LineDraw(ax,[x(:),x(:)]);
    pause(1)
    functween(ax,ones(length(x),2)*x(1))
    pause(1)
    %LineDraw(ax,NormPlot(subdat(:,2),1000))
    %LineDraw(ax,x')
end


%% Can this do bars?
% Yes it can holy shit...
x = 1:5;
y = 5 * (rand(1,5));
ax = bar(x,y)
ylim([0,6])
xlim([0,6])

while 1
    y = 5*rand(1,5);
    functween(ax,[x(:),y(:)])
    pause(.25)
end
% while 1
%     y = 5*rand(1,5);
%     LineDraw(ax,[x(:),y(:)]);
%     pause(.25)
% end

%% Okay, a bit of a jump
% I wanna be able to draw out phase portraits because I'm in a small
% diffeqs phase at the moment... I wanna start out with a system of linear
% differential equations that is derived from a single homogeneous second
% order linear differential equation... I'm PRETTY SURE that means that
% it'll take the form of 
%   [x' ]  = [0 1] * [x']
%   [x'']    [a b]   [x ] 
% I don't know how I should do this... Should I simulate? Or should I solve
% analytically and plot? Let's try both...

% I also just realized I never tried to control 2 graphs independently on
% one single plot yet... Nuts...

[pointsx,pointsy] = ndgrid(linspace(-5,5,10),linspace(-5,5,10));

x_0 = 3;
x1_0 = 2;
xinit = [x_0;x1_0];
system = [0,1;-1,-2];
allpath = {};
for j = 1:size(pointsx,2)
    for i = 1:size(pointsx,1)
        xinit = [pointsx(i,j),pointsy(i,j)];
        x = simDEQ(system,xinit,1,3000)';
        allpath{i,j} = x;
    end
end

% calculating eigens
[evec,evals] = eig(system);

ax = canvas(x,[-10,10],[-10,10],'-');
hold on;
ex = linspace(-10,10,100);
plot(ex,ex*(evec(2,1) / evec(1,1)),'LineWidth',2) %rise over run...
plot(ex,ex*(evec(2,2) / evec(1,2)),'LineWidth',2)
for i = 1:size(pointsx,1)
    for j = 1:size(pointsy,1)
        curx = allpath{i,j};
        ax = plot(curx(:,1),curx(:,1));
        LineDraw(ax,curx)
    end
end


%% I want to have all of them move at once...

[pointsx,pointsy] = ndgrid(linspace(-5,5,10),linspace(-5,5,10));

x_0 = 3;
x1_0 = 2;
xinit = [x_0;x1_0];
system = [0,1;-4,-3];
allpath = {};
for j = 1:size(pointsx,2)
    for i = 1:size(pointsx,1)
        xinit = [pointsx(i,j),pointsy(i,j)];
        x = simDEQ(system,xinit,3,3000)';
        allpath{i,j} = x;
    end
end

% calculating eigens
[evec,evals] = eig(system);

figure;
ax = blank(x,'-',[-10,10],[-10,10]);
hold on;
ex = linspace(-10,10,100);
plot(ex,ex*(evec(2,1) / evec(1,1)),'LineWidth',2) %rise over run...
plot(ex,ex*(evec(2,2) / evec(1,2)),'LineWidth',2)
axs = {};
for i = 1:size(pointsx,1)
    for j = 1:size(pointsy,1)
        curx = allpath{i,j};
        axs{i,j} = blank(curx,'-');
    end
end
xlim([-6,6])
ylim([-6,6])

axs = reshape(axs,1,[]);
allpath = reshape(allpath,1,[]);
while 1
LineDraw(axs,allpath,@InvCarv,1);
end
%gifwritefromFS('PhasePortraitLinearSystem.gif',axs,LineDraw2(axs,allpath,@InvCarv,1));

%% Redoing this except with only looking at the projection onto x
    [pointsx,pointsy] = ndgrid(linspace(-5,5,10),linspace(-5,5,10));

    x_0 = 3;
    x1_0 = 2;
    xinit = [x_0;x1_0];
    %system = [0,1;-4,-1];
    allpath = {};
    for j = 1:size(pointsx,2)
        for i = 1:size(pointsx,1)
            xinit = [pointsx(i,j),pointsy(i,j)];
            x = simDEQ(system,xinit,3,3000)';
            allpath{i,j} = x;
        end
    end
    
    figure;
    axs = {};
    ax = blank(x,'-',[-10,10],[-10,10]);
    hold on;
    for i = 1:size(pointsx,1)
        for j = 1:size(pointsy,1)
            curx = allpath{i,j};
            axs{i,j} = blank(curx,'-');
        end
    end
    
    allpath = reshape(allpath,1,[]);
    pathproj = {};
    t = linspace(0,3,3000);
    for i = 1:length(allpath)
        thispath = allpath{1,i};
        pathproj{1,i} = [t(:),thispath(:,1)];
    end
    xlim([0,3])
    ylim([-6,6])
    
    axs = reshape(axs,1,[]);
    LineDraw(axs,pathproj,@InvCarv)
    %gifwritefromFS('linearPhasePortrait.gif',axs,LineDraw2(axs,pathproj,@LinCarv));

 %% Redoing this except with a nonlinear...
    [pointsx,pointsy] = ndgrid(linspace(-5,5,10),linspace(-5,5,10));
    x_0 = 3;
    x1_0 = 2;
    xinit = [x_0;x1_0];
    func1 = @(s) -1*s^2+1;
    func2 = @(s) s^2-s-1;
    allpath = {};
    for j = 1:size(pointsx,2)
        for i = 1:size(pointsx,1)
            xinit = [pointsx(i,j),pointsy(i,j)];
            x = simDEQ2(func1,func2,xinit,3,3000)'; % should spit out a xy function...
            allpath{i,j} = x;
        end
    end
    
    figure;
    axs = {};
    hold on;
    for i = 1:size(pointsx,1)
        for j = 1:size(pointsy,1)
            curx = allpath{i,j};
            axs{i,j} = blank(curx,'-');
        end
    end
    allpath = reshape(allpath,1,[]);
    axs = reshape(axs,1,[]);
    xlim([-10,10])
    ylim([-10,10])
    
    
    while 1
        LineDraw(axs,allpath,@LinCarv);
    end

    %% Cool... I wanna do hodgekin huxley...
    % Okay, I guess while I was at it, I made the blank canvas function
    % like a million times better lol...
    %
    % axs = Preplot(allpath,'-');
    % LineDraw2(axs,allpath)
    %
    % Anyways
    figure
    [pointsx,pointsy,pointsz] = ndgrid(linspace(-5,5,10),linspace(-5,5,10),linspace(-5,5,10));
    func1 = @(s) (s(1)^2)/5;
    func2 = @(s) s(2)^2-1;
    func3 = @(s) 1/s(3);
    allpath = {};
    for j = 1:size(pointsx,2)
        for i = 1:size(pointsx,1)
            xinit = [pointsx(i,j),pointsy(i,j),pointsz(i,j)];
            x = simDEQ3({func1,func2,func3},xinit,3,3000)'; % should spit out a xy function...
            allpath{i,j} = x;
        end
    end
    
    allpath = reshape(allpath,1,[]);
    axs = Preplot(allpath,'-',[-5,20],[-5,20]);
    lol = LineDraw(axs,allpath,@LinCarv);

   % gifwritefromFS('test2.gif',axs,lol);

    %% Plotting ACGs
    load('C:\Users\davskim\Downloads\Halfdanacg.mat');
    
    samples = [];
    for i = 1:length(acgs)
        samples(i) = ~isempty(acgs{i});
    end
    samples = logical(samples);
    samples = acgs(samples);

    len = length(samples{1,1}.binCenters);
    %ax = Preplot(1:len,'-',[min(samples{1,1}.binCenters),max(samples{1,1}.binCenters)],[0,100]);
    ax = bar(zeros(1,len))
    xlim([min(samples{1,1}.binCenters),max(samples{1,1}.binCenters)])
    ylim([1,300])
    framestacks = {};
    for i = 1:10
        framestacks{i,1} = functween(ax,[samples{i,1}.binCenters(:), samples{i,1}.currentacg(:)]);
        pause(1);
    end

    %% testing functween2
    ax = Preplot(1:10, '-',[0,10],[-2,2]);
    x = (1:1000) / 100;
    y = sin(x *10);
    lol = functween(ax,[x(:),x(:)],[x(:),y(:)]);
    
    x(1:5) = [];
    y(1:5) = [];
    functween(ax,[x(:),.5 *y(:)])
    
    %gifwritefromFS('functweentest.gif',{ax},{lol});


    %% Back to the SVGs
    % Let's test out SVGReadNew
    % Huh... I wonder what those weird breaks are... Perhaps it's because
    % we're tweening between Nans?

    face = SVGReadNew('multipart.svg',1000,0),1;
    boxes = SVGReadNew('davidtest1.svg',1000,0),1;
   % plot(face(:,1),face(:,2))
    
    
    ax = Preplot(face,'-')
    xlim([0,200])
    ylim([0,200])
    
    LineDraw(ax,face);
    while(1)
        functween(ax,face,boxes / 3);
        pause(1)
        Cascadefunctween(ax,face);
        pause(1)
        LineDraw(ax,face);
        pause(1)
    end

%% Trying out inherent normalization
% This... This is good... Wow...
face = SVGReadNew('multipart.svg',2000,1);
boxes = SVGReadNew('davidtest1.svg',2000,1);
hotdog = SVGReadNew('hotdog1.svg',2000,1);
sandwich = SVGReadNew('sandwich.svg',2000,1);
taco = SVGReadNew('taco.svg',2000,1);
poptart = SVGReadNew('poptart.svg',2000,1);
uncrust = SVGReadNew('uncrustables1.svg',2000,1);
ax = Preplot(face,'-',[-4,4],[-4,4]);

hold on;
LineDraw(ax,face);
text(0,-3,0,"Is it a sandwich?","FontSize",20,'HorizontalAlignment','center')
while(1)
    functween(ax,hotdog);
    pause(1)
    functween(ax,sandwich);
    pause(1)
    functween(ax,taco);
    pause(1)
    functween(ax,poptart); 
    pause(1)
    functween(ax,uncrust);
    pause(1)
end

%% Hm... For some reason this didn't work...
linny = SVGReadNew('syrup-01.svg',2000,1);
ax = Preplot(linny,'-');
LineDraw(ax,linny)

%% Gotta try to go to the third dimension
figure;
linequestionmark = plot(eigline(1,:),eigline(2,:),eigline(3,:),'o');
grid(true)
xlim([-3 3])
ylim([-3 3])
zlim([-3 3])

%%
% Let's do some PCA stuff... I want to have a 3D cluster, and then convert
% that bad boy into eigenvector projections on the correlation matrix
data = readmatrix('3D_Data_with_Clusters.csv');

% Norming and making correlation matrix
normdata = zscore(data,0,1);
cormat = normdata' * normdata;
cormat = cormat / (length(data)-1);

[evecs evals] = eig(cormat);

% Creating new coordinate system based on the eigenbasis
% Projecting on each eigenvector
eigendata = zeros(size(data));
for i = 1:size(evals,1)
    for j = 1:size(data,1)
        eigendata(j,i) = dot(evecs(:,i),data(j,:));
    end
end
    
elines = {};
line = (-4:.1:4);
eline = [];
for i = 1:length(evecs)
    for j = 1:length(line)
        eline(j,:) = line(j) * evecs(:,i);
    end
    elines{i} = eline;
end

cardax = {};
cardax{1} = [linspace(-3,3,length(eline)); zeros(1,length(eline)); zeros(1,length(eline))]';
cardax{2} = [zeros(1,length(eline)); linspace(-3,3,length(eline)); zeros(1,length(eline))]';
cardax{3} = [zeros(1,length(eline)); zeros(1,length(eline)); linspace(-3,3,length(eline))]';

figure;
lin = Preplot3(data,'o',[-5,10],[-5,10],[-5,10]);
grid(true)

LineDraw3(lin,data);
normdat = zscore(data,0,1);
functween3(lin,normdat);
panCam(lin,[-3,3;-3,3;-3,3]);

elins = Preplot3(elines,'-');
LineDraw3(elins,elines);

rotate(lin,[45,45]);
rotate(lin,[0,45]);
rotate(lin,[45,45]);
panCam(lin,[-6,6;-6,6;-6,24])
functween3(elins,cardax);
functween3(lin,eigendata)








% Something to solve diffeqs
% This specifically only solves systems of diffeqs in R2... I'm kinda
% certain that it CAN in theory do solutions in Rn, but obviously you can't
% visualize beyond three dimensions anyway...
% And even more specifically, only linear systems lmfao...
% I need something for nonlinear systems...
% Ah fuck... I want to make another one but for generalized functions, but
% adding in a function handle is wack... I also don't wanna make it all the
% fuck the way at the bottom of the script...
% Anonymous functions were apparently the answer, but cmon... Nobody
% actually knows how to use that shit...
function x = simDEQ(system,xinit,time,frames)     
    dt = time / frames;
    x = zeros(2,frames);
    x(:,1) = xinit;
    for i = 1:frames-1
        deriv = system * x(:,i);
        x(:,i+1) = x(:,i) + (dt*deriv);
    end
end

% Can only do 2 dims right now... Whoops... Second order nonlinear diffeqs
% are possible now though...
% FINE I'll generalize it...
function x = simDEQ2(func1,func2,xinit,time,frames)     
    dt = time / frames;
    x = zeros(2,frames);
    x(:,1) = xinit;
    for i = 1:frames-1
        deriv1 = func1(x(1,i));
        deriv2 = func2(x(2,i));
        x(1,i+1) = x(1,i) + (dt*deriv1);
        x(2,i+1) = x(2,i) + (dt*deriv2);
    end
end
