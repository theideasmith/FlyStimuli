disp(['Running']);
%% MovingDot_Run

d.fTims = zeros(d.tLen,1);
% vComp = VideoWriter(['Test'], 'MPEG-4');
% vComp.FrameRate = 60;
% vComp.Quality = 50;
% open(vComp);
disp(['TLEN IS:']);
disp(d.tLen);

% A generalized drawing scheme:
%   d.stimdatas
% is a struct-array.
% each index in the struct array is a struct
% with the following fields
%  .colors: (T [0,255]) or (T [r g b a]) matrix
%  .bbox: (T nVertices [x y]) matrix
%  .centers: (T [x y]) matrix
% Because of the coordinate transform that needs to happen,
% if you want to draw a circle or any other shape you need to
% make it a polygon beforehand.
% To run any stimulus we just perform a lookup for each
% key at time t
% Make sure all matrices are (T ** [x y]). Otherwise it wont
% work properly

% INTELLIGENCE:
% CIRCLES: If stimDatas contains only one point then
%   assume we are drawing circle with radius specified
%   by the distance between that single point and the centers
% ELLIPSES: If stimDatas only has two points then read them
%   as the foci of an ellipse centered at the given center points

T = d.tLen;
disp(T);
K = length(d.stimDatas)
disp('Beginning plotting')
disp([num2str(T)])

% 3hrs worth of fly song
%144[frame/s]*60[s/min]*60[min/hr]*3[hr]
totframe = 0;
t = 0;
targetFrames = 144*60*60*3;

while totframe <= targetFrames;
  totframe = totframe + 1;
  disp([num2str(totframe), num2str(targetFrames)]);
  t = t+1;
  % Add 1 because matlab indexes by 1
  t = mod(t, targetFrames)+1;

  %% Plotting each individual shape
%   disp(['Frame ', num2str(t)]);
  for j=1:K
    stim = d.stimDatas(j);
    [T, nEdges, D] = size(stim.bbox);
    switch nEdges
        case {1,2}
          center = stim.centers(t,:);
          radius = stim.bbox(t, 1,:);
          x = center(1);
          y = center(2);
          R = radius;
          rect = [x-R, y+R, x+R, y-R];
          Screen('FillOval', d.win,rect);
        otherwise
          bboxtj =  stim.bbox(t,:,:);
          bboxtj = double(squeeze(bboxtj));
          colortj = stim.colors(t,:);
          Screen('FillPoly', d.win, colortj,bboxtj);
    end
  end

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
