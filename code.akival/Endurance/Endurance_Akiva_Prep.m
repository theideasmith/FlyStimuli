%% Endurance 

thisfilename = mfilename('fullpath');

if existsStimulusDataCache(thisfilename)
    loaded = loadStimulusData(thisfilename);
    d.tAng = loaded.tAng;
    d.tDis = loaded.tDis;
    d.vblT = loaded.vblT;
    d.stimDatas = loaded.stimDatas;
else
    [tAng, tDis] = getAngDis(d);
    [P_M, P_F, V, n] = absolutePositions(d, tAng, tDis);
    [T D] = size(tAng);
    % This is why the geometrical algorithm is so cool
    bBoxPixOffs = 0.5*d.mm2pix;

    P_F_edges = zeros(5, T,3);

    W = [-bBoxPixOffs 0. 0.];
    E = [bBoxPixOffs 0. 0.];
    N = [0. 0. bBoxPixOffs];
    S = [0. 0. -bBoxPixOffs];

    P_F_edges(1,:,:) = P_F;
    P_F_edges(2,:,:) = P_F + repmat(N+W, T,1);
    P_F_edges(3,:,:) = P_F + repmat(N+E, T, 1);
    P_F_edges(4,:,:) = P_F + repmat(S+E, T, 1);
    P_F_edges(5,:,:) =  P_F + repmat(S+W, T, 1);

    % It's very easy to compute projections
    [corrected] = dotCorrectedPositionalData(P_M, P_F_edges, V, n);

    % Pixels are integers
    corrected = int16(corrected(:,:,[1 3]));
    colors = zeros(T,3);

    stimDatas(1).colors = colors;
    stimDatas(1).centers = corrected(:,1,:);
    stimDatas(1).bbox =  corrected(:,2:5,:);
    d.stimDatas = stimDatas;
    d.tAng = tAng;
    d.tDis = tDis;
    d.vblT = 0;

    % Saving to disk so that we dont need to recalculate
    % every single time
    cacheStimulusData(thisfilename, d);
end

clear light;
