function [outclosedloopdata, bbox] = ClosedLoopKit(inclosedloopdata, t)
  d = inclosedloopdata.stimdata;
  tDis = d.tDis;
  tAng = d.tAng;

  [ddt_MRadius, ddt_MTheta] = getMaleVelocity();
  ddt_MRadius = -2*d.mm2pix;
  FTheta = tAng(t);
  noise = 0;
  rate = 1;
  dt = 1/144;
  minRadius = min(tDis);
  maxRadius = max(tDis);

  %--------( Running the control system )------
  inclosedloopdata.FRadius = bounded(...
    minRadius, ...
    inclosedloopdata.FRadius + dt*rate*ddt_MRadius + noise, ...
    maxRadius);
  %--------------------------------------------

  disp(inclosedloopdata.FRadius );

  inclosedloopdata.Fems(t, 1) = inclosedloopdata.FRadius;
  inclosedloopdata.Fems(t, 2) = FTheta;

  inclosedloopdata.Mals(t, 1) = inclosedloopdata.FRadius;
  inclosedloopdata.Mals(t, 2) = FTheta;

  [M, F, V, n] = absolutePositions(d, FTheta, inclosedloopdata.FRadius);
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
  outclosedloopdata = inclosedloopdata;
end
