%% NaturalDotSquare

thisfilename = mfilename('fullpath');

if existsStimulusDataCache(thisfilename)
    loaded = loadStimulusData(thisfilename);
    d.tAng = loaded.tAng;
    d.tDis = loaded.tDis;
    d.vblT = loaded.vblT;
    d.stimDatas = loaded.stimDatas;

else
    [tAng, tDis] = getAngDis(d);

    % Because we optimized for an arbitrary number of stimuli
    % objects,
    % writing the binocular code is absolutely piece of cake
    [colorsleft, centersleft, bboxleft] = getData(tAng-30, tDis);
    [colorsright, centersright, bboxright] = getData(tAng+30, tDis);
    stimDatas(1).colors  = colorsleft;
    stimDatas(1).centers = centersleft;
    stimDatas(1).bbox    =  bboxleft;

    stimDatas(2).colors  = colorsright;
    stimDatas(2).centers = centersright
    stimDatas(2).bbox    =  bboxright;

    d.stimDatas = stimDatas;
    d.tAng = tAng;
    d.tDis = tDis;
    d.vblT = 0;

    % Saving to disk so that we dont need to recalculate
    % every single time
    cacheStimulusData(thisfilename, d);
end

clear light;

function [colors, centers, bbox] = getData(tAng, tDis)
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

  % Psychtoolbox takes doubles as pixel
  % positions, not integers as would be expected
  % for a sensibly designed piece of software
  corrected = double(corrected(:,:,[1 3]));
  colors = zeros(T,3);

  %% IMPORTANT!!!!!!!!!!!!!!!!!!!!
  %% Blocking out the binocular region
  colors(abs(tAng) < 30) = 1;
  centers = corrected(:,1,:);
  bbox    =  corrected(:,2:5,:);
end
