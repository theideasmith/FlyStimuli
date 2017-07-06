function results = getClosedLoopStruct(d)

d.fTims = zeros(d.tLen,1);
T = d.tLen;
results.stimdata = d;
results.Fems = zeros(T, 2);
results.Mals = zeros(T, 2);
results.FRadius = d.tDis(1);

end
