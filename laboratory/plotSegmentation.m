function plotSegmentation(segmentation, oneSong)
    Fs = 10000;
    figure
    colormap default
    hold on
    [ta, tb] = songBoundsForSegmentation(segmentation);

    T = uint64(ta*Fs): uint64(tb*Fs);
    song = oneSong(T);

    plot(double(T)/Fs, song);
    for i=1:length(segmentation.segmentation)
        seg=segmentation.segmentation{i};
        x = seg{1};
        t = uint64(x*Fs);
        y = oneSong(t);
        plot(x, abs(y), '.', 'MarkerSize', 15)
    end

end
