function d = getConstants()
d.fps=144;
d.syncPos = [0 0 35 45];
d.mm2pix = 531.264/1920;
d.scrDismm = 100;
d.scrDisPix = d.scrDismm./d.mm2pix;
d.halfHi1mm = 1*d.scrDisPix/2; %take female to be 1mm high
% d.tLen = 15*60*d.fps;
d.tLen = 60*d.fps;
end