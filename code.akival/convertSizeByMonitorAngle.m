% NOTE: June 21 Akiva Lipshitz
% I think this takes pixel coordinates and performs the proper reshaping
% we could also do the more advanced perspective transform as opposed to
% just making the thing wider. 

% Since stimsize is in units of pixels, monitorDistance is also in units of
% pixels. The mapping is 531.264/1920 [mm/pixel]
function [newStimSize] = convertSizeByMonitorAngle(stimSize, stimOffset, monitorDistance)
% Let 
% 
% v be a viewpoint vector, the point of observation. 
% q be an arbitrary point in space. 
% r = v-q, slope of line from v to q
% l = \hat{r}*t+v where t is a scalar \in R
% n be a normal vector to a plane
% w be an arbitrary point lying on the plane
% 
% An arbitrary plane is given by 
%   (l - w).n = 0                    (1) 
% 
% Substituting in l=r*t+v:
%         (r*t + v-w).n = 0          (2)
%     t*(r.n) + (v-w).n = 0
%               t*(r.n) = (w-v).n
%                        (w-v).n
%                   t = ----------
%                         (r.n)  

   % Distance from fly to stimulus in pixel units
   rdist = sqrt(stimOffset.^2 + monitorDistance.^2);
   
   % vStim = [h1mm/tDis] * [rDist/scrDis]
   cosTheta = monitorDistance/rdist;
   vStim = 100.*rdist/monitorDistance .* stimSize;

   hStim1 = tand(atan2d(stimSize/2,monitorDistance) + atan2d(stimOffset, monitorDistance))*monitorDistance - stimOffset;
   hStim2 = tand(atan2d(stimSize/2,monitorDistance) - atan2d(stimOffset, monitorDistance))*monitorDistance + stimOffset;
   %                Width       Height
   newStimSize = [hStim1+hStim2,vStim];

%    vAng_optimal = 2*atan2d(stimSize/2,monitorDistance);
%    vAng_actual = 2*(atan2d(stimSize/2,rdist));g
   

%    atan2d(stimNew,rdist) = atan2d(stimOld,monitorDistance) => stimNew/rdist = stimOld/monitorDistance => stimNew = rdist/monitorDist * stimOld
   
%    hAng = (atan2d(stimOffset + stimSize/2,monitorDistance) - atan2d(stimOffset,monitorDistance)) + ...
%                             (atan2d(stimOffset,monitorDistance) - atan2d(stimOffset - stimSize/2,monitorDistance));
   
%    atan2d(stimOff + stimNew,monitorDist) - atan2d(stimOffset, monitorDist) = atan2d(stimOld,monitorDist) =>
%    atan2d(stimOff + stimNew,monitorDist) = atan2d(stimOld,monitorDist) + atan2d(stimOffset, monitorDist) =>
%    stimNew1 = tand(atan2d(stimOld,monitorDist) + atan2d(stimOffset, monitorDist))*monitorDist - stimOff
%    stimNew2 = tand(atan2d(stimOld,monitorDist) - atan2d(stimOffset, monitorDist))*monitorDist + stimOff (I think)
end