function [tmin,tmax] = songBoundsForSegmentation(segmentation)
    tmin = 0;
    tmax = 0;
    for i=1:length(segmentation.segmentation)
        points= segmentation.segmentation{i}{1};
        if tmin==0
            tmin = points(1);
        end
        if tmax==0
            tmax = points(length(points));
        end 
        tmin = min(tmin, points(1));
        tmax = max(tmax, points(length(points)));
    end
        
end 
