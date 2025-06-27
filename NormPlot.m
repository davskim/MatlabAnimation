% Pretty useful function honestly... It really is just for plotting
% abstract plots that have weird ass x and y limits... It makes it a bit
% easier to animate things right out the box from real data...
% Basically, I want a function that takes in any given plot, normalizes it
% to be compatible to the 6x6 grid that I have... 
% Also, let's just have this make an explicit amount of samples as well
% just for convenience
function anifriend = NormPlot(func,samps)
    funx = linspace(-3,3,samps);
    func = double(func);
    normfunc = zscore(func);
    
    redfunc = interp1(linspace(-3,3,length(func))',normfunc,funx);
    anifriend = [funx(:),redfunc(:)];
end