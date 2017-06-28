function clusterizedResults = clusterizeSegment(timepoints, N)
    if length(timepoints)==1
        segmentation= {{timepoints, 1}};
        classes = 1;
        clusters = timepoints*0+1;
        clusterizedResults(1).segmentation = segmentation;
        clusterizedResults(1).classes = classes;
        clusterizedResults(1).timepoints = timepoints;
        clusterizedResults(1).clusters = clusters;
    else  
        clusters = kmeans(timepoints, N);
        classes = unique(clusters);
        segmentation = cell(length(classes),1);
        for i=1:length(segmentation)
            cseg = classes(i);
            segmentation{i} = {...
                timepoints(clusters == cseg),...
                cseg};
        end
        clusterizedResults(1).segmentation = segmentation;
        clusterizedResults(1).classes = classes;
        clusterizedResults(1).timepoints = timepoints;
        clusterizedResults(1).clusters = clusters;
    end   
end

