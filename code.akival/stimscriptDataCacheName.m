function cachename = stimscriptDataCacheName(stimscript)
    [pathstr, name, ~] = fileparts(stimscript);
    cachename = strcat(pathstr, '/',name, '_DATACACHE', '.mat');
end
