%% NaturalDot_Prep
thisfilename = mfilename('fullpath');

if existsStimulusDataCache(thisfilename)
    d.stimDatas = loadStimulusData(thisfilename);
else 
    d = getConstants();
    % vFPS = 60
    % The data cleaning process is done as an abstraction
    [tAng, tDis] = getAngDis(d);
    [P_M, P_F, V, n] = absolutePositions(d, tAng, tDis);

    % This is why the geometrical algorithm is so cool
    bBoxPixOffs = d.mm2pix;

    [T D] =  size(P_F);
      % The female's center
      P_F_edges = zeros(5,T,D);
     P_F_edges(1,:,:) = P_F;
     P_F_edges(2,:,:) = P_F + repmat([-bBoxPixOffs 0. 0.], T,1);
     P_F_edges(3,:,:) = P_F + repmat([bBoxPixOffs 0. 0.], T, 1);
     P_F_edges(4,:,:) = P_F + repmat([0. 0. bBoxPixOffs], T, 1);
     P_F_edges(5,:,:) = P_F + repmat([0. 0. -bBoxPixOffs], T, 1);


    % It's very easy to compute projections
    corrected = dotCorrectedPositionalData(P_M, P_F_edges, V, n);

    % Pixels are integers
    corrected = int16(corrected(:,:,[1 3]));

    % Important stimulus stuff
    stimDatas(1).colors = zeros(T, 3);
    stimDatas(1).centers = corrected(:,1,:);
    stimDatas(1).bbox = corrected(:,2:5,:);
    d.stimDatas = stimDatas;    
    cacheStimulusData(thisfilename, stimDatas);
end 
d.vblT = 0;
clear light;

