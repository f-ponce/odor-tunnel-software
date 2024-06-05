function plotodoroccupancytime(flyTracks)
    figure()
    hold on
    for i=1:15
        plot(flyTracks.centroid(:,2,i))
    end
