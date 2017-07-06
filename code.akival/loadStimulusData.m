function data  = loadStimulusData(stimscript)
  cachename = stimscriptDataCacheName(stimscript);
  data = importdata(cachename);
end
