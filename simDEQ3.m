% Something that can solve systems of differential equations. The only
% thing that is a little wack is that you need funcs to be a cell of
% function handles... You need to know how to make anonymous functions in
% matlab like...
%
%     func1 = @(s) (s(1)^2)/5;
%     func2 = @(s) s(2)^2-1;
%     func3 = @(s) 1/s(3);
%
% And then shove these bad boys into a cell... Then of course, you can't
% solve a differential equation without an initial vector, so... 
% xinit should be that... 
% time is just how long you want the function to run for, and frames is how
% many frames you want, so you shouldn't have to calculate a time step size
% as it does it for you...
function x = simDEQ3(funcs, xinit,time,frames)     
    dt = time / frames;
    x = zeros(length(funcs),frames);
    x(:,1) = xinit;
    for i = 1:frames-1
        for j = 1:length(funcs)
            thisfunc = funcs{j};
            deriv = thisfunc(x(:,i));
            x(j,i+1) = x(j,i) + (dt*deriv);
        end
    end
end