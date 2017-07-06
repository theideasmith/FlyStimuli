%% Closedloop Run
d.fTims = zeros(d.tLen,1);
T = d.tLen;

results = getClosedLoopStruct(d);

for t = 1:T
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
% Write results to a file. Must figure out to where. 
