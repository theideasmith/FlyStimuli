function projection = planarProjection(p1, p2, r0, n)
    dp = (p2-p1);
    t = repmat(((r0-p1)*n')./(dp * n'), 1, 3);
    projection = p1 + t.*dp;    
end