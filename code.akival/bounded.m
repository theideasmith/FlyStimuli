function nprime = bounded(a,n, b)
  if and(a <= n, n<=b)
    nprime = n;
  end

  if n < a
    nprime = a;
  end

  if n > b
    nprime  = b;
  end
end
