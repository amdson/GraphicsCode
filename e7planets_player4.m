function [move] = e7planets_player4(map)
    r = map.player.location(end, 1);
    c = map.player.location(end, 2);
    distance_grid = get_distance_grid(map.grid, r, c);
    distances = zeros(numel(map.scraps), 1);
    min = Inf;
    min_index = 0;
    for i = 1:numel(distances)
        r2 = map.scraps(i).location(1);
        c2 = map.scraps(i).location(2);
        dist = distance_grid(r2, c2);
        if(dist < min)
            min = dist;
            min_index = i;
        end
    end
    r_scrap = map.scraps(min_index).location(1);
    c_scrap = map.scraps(min_index).location(2);
    move = backtrace(distance_grid, r_scrap, c_scrap);
end
function [direction] = backtracje(dg, sx, sy)
    x = sx;
    y = sy;
    dist = dg(x, y);
    [m, n] = size(dg);
    count = 0;
    while(dist > 0)
        count = count + 1;
        buffer = zeros(4, 2);
        buffer(1, :) = [mod(x, m)+1, y];
        buffer(2, :) = [x, mod(y, n)+1];
        buffer(3, :) = [mod(x-2, m)+1, y];
        buffer(4, :) = [x, mod(y-2, n)+1];
        for i = 1:4
            ax = buffer(i, 1);
            ay = buffer(i, 2);
            if(dg(ax, ay) < dist)
                dist = dg(ax, ay);
                if(dist < 1)
                    if(x == mod(ax, m)+1)
                        direction = 'D';
                    elseif(x == mod(ax-2, m)+1)
                        direction  = 'U';
                    elseif(y == mod(ay, n)+1)
                        direction = 'R';
                    else
                        direction = 'L';
                    end
                    break;
                end
                x = ax;
                y = ay;
            end
        end
        if(count > 150)
            direction = 'U';
            break;
        end
    end
end
function [distance_grid] = get_distance_grid(grid, px, py)
    [m, n] = size(grid);
    distance_grid = inf(m, n);
    covered = zeros(m, n);
    distance_grid(px, py) = 0;
    covered(px, py) = 1;
    shell = zeros(2*m+2*n, 2);
    shell(1, :) = [px, py];
    shell_length = 1;
    count = 0;
    while(shell_length > 0)
        count = count + 1;
        shell_copy = shell;
        shell(1, :) = 0;
        shell(2, :) = 0;
        b = shell_length;
        shell_length = 0;
        for i = 1:b
            xa = shell_copy(i, 1);
            ya = shell_copy(i, 2);
            spread(xa, ya)
        end
        if(count > 150)
            break;
        end
    end
    
    function spread(px, py)
        buffer = zeros(4, 2);
        %movetime = grid(px, py)+1;
        movetime = 1;
        dist = distance_grid(px, py);
        surr_vals = movetime+dist; 
        buffer(1, :) = [mod(px, m)+1, py];
        buffer(2, :) = [px, mod(py, n)+1];
        buffer(3, :) = [mod(px-2, m)+1, py];
        buffer(4, :) = [px, mod(py-2, n)+1];
        for i = 1:4
            x = buffer(i, 1);
            y = buffer(i, 2);
            if(grid(x, y) == Inf)
                continue;
            end
            if(distance_grid(x, y) > (surr_vals+grid(x, y)))
                distance_grid(x, y) = surr_vals+grid(x, y);
            end
            if(covered(x, y) == 0)
                covered(x, y) = 1;
                shell_length = shell_length+1;
                shell(shell_length, 1) = x;
                shell(shell_length, 2) = y;
            end
        end
    end
end