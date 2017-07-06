function nprime = bounded(a,n, b)
  opts = [a, n, b];
  % One line conditional
  % options must be exclusive
  nprime = opts(max([1*(a > n), 2*(~((a>n)&(n>b))), 3*(n > b)]));
end
