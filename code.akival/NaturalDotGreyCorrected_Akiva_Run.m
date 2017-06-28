%% MovingDot_Run
ScreenRefresh
d.fTims = zeros(d.tLen,1);
% halfHiPix = round(d.halfHi1mm./(double(d.fDis)/1e3));
% Compute the difference of the half height of the fly and its actual height. 
% I think this is to make animating things a little bit easier
modH(:,1) =  (double(d.dWid)./2) -d.halfHi1mm;
modH(:,2) =  (double(d.dHig)./2)  -d.halfHi1mm;
% vComp = VideoWriter(['Test'], 'MPEG-4');
% vComp.FrameRate = 60;
% vComp.Quality = 50;
% open(vComp);

if ~isfield(d, 'vOff'); d.vOff = d.hOff*0; end

% The number of points
for i = 1:d.tLen
   % Some initialization stuff
   Screen('FillRect', d.win, d.white)
   Screen('FillRect', d.win, d.syncCol(i), d.syncPos);
   
   % Grows the initial rect of the fly to the initialization rect of the fly
   tRect = GrowRect(d.r1mm,modH(i,1),modH(i,2));
   % Places the rect at its initial position
   tRect =double(OffsetRect(tRect,d.hOff(i,1),d.vOff(i,1)));
   
   % colors the rect gray, hene (NaturalDot...GREY...Corrected....)
   % Now the rect is visible
   Screen('FillRect', d.win, d.gray, tRect);
   
    % The main animation loop
    % Start with the second (probably for some bit of NaN safety?) index
    % and then go to through height offsets.
    % TODO: How do we control the speed of the animation? Is it just the 
    % standard framerate of the screen, such that our data needs to be resampled
    % at that frequency, or is there some setting that can be flipped. I guess whenn
    % it is so easy to resample in MATLAB, doing so is not a big deal.
   for dot = 2:size(d.hOff,2)
      % I suppose the software somehow knows we are using the same tRect each time
      % Maybe it remembers the position of the rectangle?
      tRect = GrowRect(d.r1mm,modH(i,1),modH(i,2));
      tRect = double(OffsetRect(tRect,d.hOff(i,dot),d.vOff(i,dot)));
      Screen('FillRect', d.win, d.gray, tRect);
   end

   Screen('DrawingFinished', d.win);

   % Some file handling logic. If the file already exists we dont 
   % want to save the video.  
   if exist('EndPlayback.mat', 'file');
      break;
   end

   [d.vblT] = Screen('Flip', d.win, d.vblT+0.5*d.ifi);
   %     imageArray = Screen('GetImage', d.win, d.Rect);
   d.frmCnt = i;
   d.fTims(i,1) = d.vblT;
   % Writing video is immensely expensive
   % and MATLAB asyncio sucks. Like most things
   % about MATLAB.
   %     writeVideo(vComp,uint8(imageArray));
   %     if i > 1; disp(d.fTims(i)-d.fTims(i-1)); end
end
% close(vComp);
save EndPlayback i;
ScreenRefresh
