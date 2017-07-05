function [P_M, P_F, V, n] = absolutePositions(d, tAng, tDis)

% Obtains the necessary variables for computing 
% projections of female onto plane
% The following variable names are explained
% in the paper "Deriving Projections on Planes"
% in my notes directory in Dropbox
T = uint64(length(tAng));

% Converting from mm to pixels
R = tDis*d.mm2pix;
D = d.scrDisPix;
scrCntrX = 1920/2;
scrCntrY = D;
scrCntrZ = 1080/2;

% These initial position are important 
% if we dont want to run an affine transformation
% on P_F later on
P_M  = repmat(double([scrCntrX, 0, scrCntrZ]), T, 1);
P_akiva = repmat(double([0, 8*scrCntrY scrCntrZ]),scrCntrZ, T,1);
V    = repmat(double([scrCntrX scrCntrY scrCntrZ]),T,1);
jhat = double([0 1 0]);
P_F =  P_M+[R.*sind(tAng), R.*cosd(abs(tAng)), 0*tAng];       
n = jhat;

end


