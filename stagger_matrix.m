% This is a function that would stagger a matrix... it's for cascading...
% Cards on the table, I asked chatgpt to make this...
% Okay, not anymore... it's modded from chatgpt lol
function B = stagger_matrix(A)
    [N, M] = size(A);
    L = N + M - 1; % new length of staggered mat. I gotta change this if I'm gonna run this again...
    B = zeros(L, M);

    for col = 1:M
        idx = col;    % The diagonal position
        B(idx:N+idx-1, col) = A(:,col);
        if col ~= 1
            B(1:idx,col) = A(1,col);
        end
        if col ~= M
            B(idx+N:end,col) = A(end,col);
        end
    end
end
