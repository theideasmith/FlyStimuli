function exists = existsStimulusDataCache(stimscript)
    cachename = stimscriptDataCacheName(stimscript);
    exists = exist(cachename, 'file');
end
