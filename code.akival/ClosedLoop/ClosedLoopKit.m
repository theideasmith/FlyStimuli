function bbox = ClosedLoopKit(closedloopdata, t)
  d = closedloopdata.stimdata;
  tDis = d.tDis;
  tAng = d.tAng;

 
  [ddt_MRadius, ddt_MTheta] = getMaleVelocity();

  FTheta = tAng(t);
  noise = 0;
  rate = 1;
  dt = 1;
  minRadius = min(tDis);
  maxRadius = max(tDis);

  %--------( Running the control system )------
  closedloopdata.FRadius = bounded(...
    minRadius, ...
    closedloopdata.FRadius + dt*rate*ddt_MTheta/closedloopdata.FRadius + noise, ...
    maxRadius);
  %--------------------------------------------


  closedloopdata.Fems(t, 1) = closedloopdata.FRadius;
  closedloopdata.Fems(t, 2) = FTheta;

  [M, F, V, n] = absolutePositions(d, FTheta, closedloopdata.FRadius);
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

  bbox =  squeeze(F_edges_corrected(1,2:5,[1 3]));

end
