%% Closedloop Prep
thisfilename = mfilename('fullpath');

if existsStimulusDataCache(thisfilename)
    loaded = loadStimulusData(thisfilename);
    d.tAng = loaded.tAng;
    d.tDis = loaded.tDis;
    d.vblT = loaded.vblT;
else
    % All the positional projection we do live
    % so this part is pretty bare
    [tAng, tDis] = getAngDis(d);
    [M, F, V, n] = absolutePositions(d, tAng, tDis);
    d.M = M;
    d.F = F;
    d.planeCenter = V;
    d.planeNormal = n;
    d.tAng = tAng;
    d.tDis = tDis;
    d.vblT = 0;
    cacheStimulusData(thisfilename, d);
end
