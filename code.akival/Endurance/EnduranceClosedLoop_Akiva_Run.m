%% Endurance ClosedLoop Run

disp(['Running']);

d.fTims = zeros(d.tLen,1);

T = d.tLen;
disp(T);
K = length(d.stimDatas)
disp('Beginning plotting')
disp([num2str(T)])

% 3hrs worth of fly song
% 144[frame/s]*60[s/min]*60[min/hr]*3[hr]
targetFrames = 144*60*60*3;
totframe = 0;
t = 0;

while totframe <= targetFrames;
  totframe = totframe + 1;
  t = t+1;
  t = mod(totframe, targetFrames)+1;

  % This does all the heavy lifting for us
  bbox = ClosedLoopKit(results, t);
  Screen('FillPoly', d.win, [0 0 0],bbox);
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
