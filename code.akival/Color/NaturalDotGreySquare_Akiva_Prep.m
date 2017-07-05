%% NaturalDot_Prep
% vFPS = 60
% The data cleaning process is done as an abstraction
[tAng, tDis] = getAngDis(d);
[dWid, dHig, hOff, tAng, color, polygonPoints] = dotCorrectedPositionalData(d, tAng, tDis);
% Dot height and width
d.dWid = dWid;
d.dHig = dHig;
d.hOff = hOff;
% Auxiliary Variables
d.color = color;
d.tAng = tAng;
d.vblT = 0;
d.bbox = polygonPoints
clear light;