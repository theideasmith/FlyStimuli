function results = polynoms(xs, ys, orders)
    results = cell(length(orders), 1);
    for i=1:length(orders)
        o = orders(i);
        p = polyfit(xs, ys, o)
        mse = computeMSE(xs, ys, p)
        results_i = struct(...
            "mse", mse, ...
            "p", p, ...
            "order", o);
        results{i} = results_i
    end
    
end 