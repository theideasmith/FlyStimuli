% This abstracts the data loading and cleaning process
function [tAng, tDis] = getAngDis(d)

load('p1ang.mat');
load('p1dis.mat');
% Data is stored as integers, we need to preprocess it
tAng = double(P1Ang)*180/(pi*1e3); %[*180/pi][deg/rad] * [1/1e3][actual/stored ints]
tDis = double(P1Dis)/1e3; % [1/1e3][actual/stored ints]
vFPS = 60;
% Anglular Maximum
AngLim = 45;

% Some embarrasingly easy pruning
dIdx = tDis < 2.5 | abs(tAng) > AngLim; %this sets min distance to 2.5mm
tDis(dIdx) = [];
tAng(dIdx) = [];

% The indexes greater than the "maximum allowed angle"
% diff(x)(i) gives x_i - x_{i-1}. And initial conditions dx_1 = x_1.
jPnts = [find(abs(diff(tAng)) >= AngLim); length(tAng)];
% We start by deleting no indexes
dIdx = 0*tAng;
ePnt = 0;
% The last element of jPnts is length(tAng)
% I think that this is an initialization to find
% the indexes in tAng and tDisto delete
for i = 1:length(jPnts)-1
    %If the index is less than some number which I can't interpret
    % then it's fome
    % This is inefficient: we should make this faster. 
    if jPnts(i) <= ePnt; continue; end
    % or if the index is more than the total number of pAngs (not sure how
    % this would ever happen)
    
    % If the index at whcih AngLim is exceeded is at more than len(tAng) 
    % timepoints, it's fine
    if jPnts(i)+1e4 > length(tAng); continue; end

    % What lies ahead is a bit complicated if you dont pay attention
    % The angles from the current index of larger than angmax
    % until 1e4 ahead
    %    jpts_target_a = tAng(jPnts(i)+1:jPnts(i)+1e4)
    % the current angle
    %    jpts_target_b = tAng(jPnts(i)) 
    % deviation from the current angle: if we deviate this much from the
    % current angle which we know is not allowed
    %    compare_a = abs(jtarga-jtargb)
    % then take the first point of deviation which is measured relative to
    % jPnts+1 and put it back in absolute index coordinates
    
    ePnt = find( ...
      abs(tAng(...
            jPnts(i)+1 ...
            : ...
            jPnts(i)+1e4)-tAng(jPnts(i))) ...
          <...
          0.1*abs(tAng(jPnts(i))), ...
        1) ... 
        +jPnts(i)-1;
     
    % Then remove these jitter points. We really want to cut 
    % out bad angles. WHY? 
    dIdx(jPnts(i)+1:ePnt) = 1;
end
tAng(dIdx>0) = [];
tDis(dIdx>0) = [];


% Compute a moving standard deviation with 3 second resolution
% and choose those indexes with less than 2 standard deviation
dIdx = movingstd(tAng, round(3*vFPS))<2;
% Running max(x(t-dt:t+dt) with 3 second resolution (2*dt=3) 
% we are computing, to 3 second resolution, whether there are 
% points with std3 < 2
dIdx = runningExtreme(dIdx, round(3*vFPS)+1, 'max');
% remove all indices for which, to 3 second resolution, 
% the standard deviation of movement is less than 2. 
tAng(dIdx>0) = [];
tDis(dIdx>0) = [];

% now that we've pruned unwanted indices, resample the timeseries 
% 100*vFPS -> d.fps*100
% d is set in OpenLaserScreen.m. d.fps is the given fps of the screen
% refresh
tAng = resample(tAng, round(d.fps*100), round(vFPS*100));
tDis = resample(tDis, round(d.fps*100), round(vFPS*100));

% If we get out anything more than AngLim now cut it out. 
tDis(abs(tAng)>AngLim) = [];
tAng(abs(tAng)>AngLim) = [];

% Use a loess filter to smooth out the data
tAng = smooth(tAng, 0.00004, 'loess');
tDis = smooth(tDis, 0.00004, 'loess');

end