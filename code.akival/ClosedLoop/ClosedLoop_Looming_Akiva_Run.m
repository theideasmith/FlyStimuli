d.fTims = zeros(d.tLen,1);
T = d.tLen;
K = length(d.stimDatas);

% We would like to save this data into a struct
results.stimdata = d;
results.Fems = zeros(T, 2);
results.Mals = zeros(T, 2);

FRadius = d.tDis(1);
function nprime = bounded(a,n, b)
  opts = [a, n, b]
  % One line conditional
  % options must be exclusive
  nprime = opts(max([1*(a > n), 2*(~((a>n)&(n>b))), 3*(n > b)]))
end

FRadius = d.tDis(1);

for t = 1:T
  [ddt_MTheta, ddt_MRadius] = getMaleVelocity();

  FTheta = d.tAng(t);
  
  noise = 0;
  rate = 1;
  dt = 1;
  minRadius = min(tDis);
  maxRadius = max(tDis);
  FRadius = bounded(minRadius, ...
    MRadius + dt*rate*ddt_FTheta/FRadius + noise, ...
    maxRadius);

  results.Fems(t, 1) = FRadius;
  results.Fems(t, 2) = FTheta;

  [M, F, V, n] = absolutePositions(d, FTheta, FRadius);

  % This is why the geometrical algorithm is so cool
  bBoxPixOffs = 0.5*d.mm2pix;

  F_edges = zeros(5,1,3);

  W = [-bBoxPixOffs 0. 0.];
  E = [bBoxPixOffs 0. 0.];
  N = [0. 0. bBoxPixOffs];
  S = [0. 0. -bBoxPixOffs];

  F_edges(1,:,:) = F;
  F_edges(2,:,:) = F + N+W;
  F_edges(3,:,:) = F + N+E;
  F_edges(4,:,:) = F + S+E;
  F_edges(5,:,:) = F + S+W;

  [F_edges_corrected] = dotCorrectedPositionalData(M, F_edges, V, n);
  bbox =  squeeze(F_edges_corrected(1,2:5,:));

  Screen('FillPoly', d.win, [0 0 0],bbox);

  Screen('DrawingFinished', d.win);

  %% Flipping buffer to the screen
  [d.vblT] = Screen('Flip', d.win, d.vblT+0.5*d.ifi);

  if isfield(d, 'toSave')
    if d.toSave == true
      imageArray = Screen('GetImage', d.win, d.Rect);
      imwrite(imageArray, ['tmpimg' num2str(t) '.png'])
    end
  end
  d.frmCnt = t;
  d.fTims(t,1) = d.vblT;
end

close(vComp);
save EndPlayback i;

end
