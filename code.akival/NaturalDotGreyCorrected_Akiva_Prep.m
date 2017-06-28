%% NaturalDot_Prep
% vFPS = 60
[tAng, tDis] = getAngDis(d);

% % Random number initialization
rng shuffle

% d.tLen is the number of points
% sPnt is the start point. Don't get why it's randomized
sPnt = max([1 round(rand(1)*length(tAng)-d.tLen)]);
% halfHi1mm is the height/2 of the fly being
% simulated. 
% the term below gives the tan(theta) where theta measures
% the angle between the observer fly's eyes and the top of the observed
% fly in the video
% tOrd = height of female/distance to female
% how true is this?
tOrd = round(2*round(d.halfHi1mm./tDis));

% Starting points
t1 = sPnt;
t2 = sPnt+d.tLen-1;

newDotSize = convertSizeByMonitorAngle(...
   ... % Normalized heights
   tOrd(t1:t2),...
   ... % Stimulus Offset, x position. 
   ... %    Converted to radians and then to pixel units
   ... %    convertSizeByMonitorAngle deals only in pixel units
   d.scrDisPix*tan(tAng(t1:t2)*pi/180),...
   ... % Distance to the fly in pixel units
   d.scrDisPix);

d.dWid = uint16(newDotSize(:,1));
d.dHig = uint16(newDotSize(:,2));
d.color = single(ones(length(d.dWid),1)*1);

% Angular Offset
d.tAng = single(tAng(t1:t2));

% x position offset as before
d.hOff = int16(tan(double(d.tAng)*pi/180)*d.scrDisPix);
clear light*;
