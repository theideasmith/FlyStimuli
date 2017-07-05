%% NaturalDot_Prep
% vFPS = 60
% The data cleaning process is done as an abstraction
thisfilename = mfilename('fullpath');

if existsStimulusDataCache(thisfilename)
    d.stimDatas = loadStimulusData(thisfilename);
else 
    [tAng, tDis] = getAngDis(d);
    [P_M, P_F, V, n] = absolutePositions(d, tAng, tDis);

    % This is why the geometrical algorithm is so cool
    bBoxPixOffs = d.mm2pix;

    P_F_edges = [
      % The female's center
      P_F; 
      % Make sure the edges are in the right order
      % we can do this for arbitrary shapes
      P_F + repmat([-bBoxPixOffs 0. 0.], T,1);
      P_F + repmat([bBoxPixOffs 0. 0.], T, 1);
      P_F + repmat([0. 0. bBoxPixOffs], T, 1);
      P_F + repmat([0. 0. -bBoxPixOffs], T, 1);
    ];

    % It's very easy to compute projections
    [corrected] = dotCorrectedPositionalData(P_M, P_F_edges, V, n);

    % Pixels are integers
    corrected = int16(corrected(:,:,[1 3]));
    colors = zeros(T,3);
    
    stimDatas(1).colors = colors;
    stimDatas(1).centers = corrected(:,1,:);
    stimDatas(1).bbox(1) =  corrected(:,2:5,:);    
    d.stimDatas = stimDatas;    
    
    % Saving to disk so that we dont need to recalculate 
    % every single time
    cacheStimulusData(thisfilename, stimDatas);

end 

d.tAng(1) = tAng;
d.vblT = 0;
clear light;

