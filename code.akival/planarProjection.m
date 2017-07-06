function projection = planarProjection(p1, p2, r0, n)
    [T,D] = size(p1);
    dp = (p2-p1);
    t = repmat(((r0-p1)*n')./(dp * n'), 1, D);
    projection = p1 + t.*dp;    
end