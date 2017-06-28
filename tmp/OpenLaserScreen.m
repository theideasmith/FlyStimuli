function [d] =  OpenLaserScreen(funcName)
%% init ball reader
try
   disp('opening ball reader')
   try
      fclose(instrfindall);
   end
   mr = MouseReader('COM3');
   disp('   done.')
catch
   disp('   failed!')
end
%% init visual display
clear d;
InitializeMatlabOpenGL();
[~, sysName] = system('hostname');
if strcmp(strtrim(sysName), 'PipLaptop'); d.sNum=1; else d.sNum=1; end
d.sNum=2;
disp('Detecting Available Screens ...');
Screen('Screens');
disp(['Using Screen Number ' num2str(d.sNum) ' for video']);
d.clut = Screen('LoadCLUT', d.sNum);
disp('Opening Screen Interface ...');
Screen('Preference', 'SkipSyncTests', 1);
[d.win, d.Rect] = Screen('OpenWindow', d.sNum, 0);
if any(d.Rect - [0 0 1920 1080]); error('Screen Size is Incorrect'); end

if exist('EndPlayback', 'file')
   delete('EndPlayback.mat');
end

disp('Screen Interface Ready!');
d.fps=Screen('FrameRate',d.win); %Frames per second
if d.fps ~=144
   warning('FRAME RATE IS NOT 144Hz');
end
d.ifi=Screen('GetFlipInterval', d.win);
d.white = WhiteIndex(d.win);
d.black = BlackIndex(d.win);
d.gray = round(mean([d.white d.black]));
%scrDisPix = 100 mm * 1920pix/mm
d.syncPos = [0 0 35 45];
d.mm2pix = 531.264/1920;
d.scrDismm = 100;
d.scrDisPix = d.scrDismm./d.mm2pix;
[x,y] = RectCenter(d.Rect);
d.halfHi1mm = 1*d.scrDisPix/2; %take female to be 1mm high
d.r1mm = [x-d.halfHi1mm y-d.halfHi1mm x+d.halfHi1mm y+d.halfHi1mm];
% d.tLen = 15*60*d.fps;
d.tLen = 60*d.fps;
d.syncCol = uint8(d.white*ones(d.tLen,1));
for i = round(d.fps/4+1:2*(d.fps/4):d.tLen)
   d.syncCol(i:round(i+d.fps/4-1)) = d.black;
end
ScreenRefresh
Priority(MaxPriority(d.win));
if nargin == 1;
   while ~exist('ExitPlayback.mat', 'file');
      
%       % !!!!!!!!!!!!!!
%       MovingDot_Run;
%       % !!!!!!!!!!!!!!
      
      save('PlaybackReady', 'i');
      while ~exist('startPlayback.mat', 'file')
         if exist('ExitPlayback.mat', 'file');
            Screen('CloseAll');
            delete *Playback*
            exit;
         end
         if exist('EndPlayback.mat', 'file');
            delete('EndPlayback.mat');
         end
         pause(0.5);
      end
      
      delete('startPlayback.mat');
      delete('PlaybackReady.mat');
      %There used to be a pause here of 1 second (not sure why), but now we
      %load parameters and execute the prep function instead. Make sure
      %this takes about a second
      tic;
      
      if exist('params.mat','file')
         load params;
         d.params = runParams;
         funcName = runParams.lightStim;
      end

%       display('we are here')
      
      if (runParams.trialNum == 1)
         eval([funcName '_Prep']);
      end
      %Here is the pause that ensures we spend 1 second here as happened in
      %the original program
      pause(1-toc);
      try eval([funcName '_Run']); end

%       if strfind(funcName, 'Flash')
%          Flash_Run;
%          %     elseif ~isempty(strfind(funcName, 'NaturalDot')) && ...
%          %             ~isempty(strfind(funcName, 'Lvl'))
%          %         NaturalDot_Lvl_Run;
%       elseif ~isempty(strfind(funcName, 'DotMany'))
%          NaturalDotMany_Run;
%       elseif ~isempty(strfind(funcName, 'ColorsEachEye'))
%          NaturalDotColorsEachEye_Run;
%       elseif ~isempty(strfind(funcName, 'DotEachEye'))
%          NaturalDotEachEye_Run;
%       elseif ~isempty(strfind(funcName, 'DotColors'))
%          NaturalDotColors_Run;
%       elseif ~isempty(strfind(funcName, 'Dot'))
%          MovingDot_Run;
%       else
%          eval([funcName '_Run']);
%       end
      try d.fTims = d.fTims(1:d.frmCnt); end
      
      if exist('EndPlayback.mat', 'file');
         delete('EndPlayback.mat');
      end
      dDat = d;
      save PlaybackOutput dDat;
   end
   Screen('CloseAll');
   exit;
end
end