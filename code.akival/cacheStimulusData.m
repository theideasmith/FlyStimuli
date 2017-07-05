function cacheStimulusData(stimscript, data)
    savetoFname = stimscriptDataCacheName(stimscript);
    save(savetoFname, 'data');
end 

