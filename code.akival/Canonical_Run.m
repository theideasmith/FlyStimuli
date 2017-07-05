function Canonical_Run(d)

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

T = d.tLen;
disp(T);
K = length(d.stimDatas);

% The number of points
for t = 1:T
  %% Plotting each individual shape
  disp(['Frame ', num2str(i)]);
  for j=1:K
    stimj = d.stimDatas(j);
    bboxtj =  stimj.bbox(t,:,:);
    bboxtj = squeeze(bboxtj);
    colortj = stimj.colors(t,:);
    Screen('FillPoly', d.win, colortj,bboxtj,1);

  Screen('DrawingFinished', d.win);
  end

  %% Flipping buffer to the screen
  [d.vblT] = Screen('Flip', d.win, d.vblT+0.5*d.ifi);
%    imageArray = Screen('GetImage', d.win, d.Rect);
%    imwrite(imageArray, ['tmpimg' num2str(i) '.png'])
   
  d.frmCnt = i;
  d.fTims(i,1) = d.vblT;

end
% close(vComp);
save EndPlayback i;

end

