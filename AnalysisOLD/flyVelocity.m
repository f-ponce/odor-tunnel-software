function [velocity binEdges] = flyVelocity(flyTracks, doPlot)
%
%
%
%

if nargin < 2
    doPlot = 0;
end


binSize = 0.2; %bin size in sec
%binSize = 0.4; %bin size in sec

if ~isfield(flyTracks, 'etimes')
    for i = 1:length(flyTracks.times)
        flyTracks.etimes(i) = etime(datevec(flyTracks.times(i)), datevec(flyTracks.times(1)));
    end
end


pxmm = 1/flyTracks.pxRes; % convert mm/px to px/mm
times = round(100*flyTracks.etimes)/100; %rounded frame times
blocks = min(times):binSize:max(times); %bin edges in time


for k = 1:(length(blocks)-1)
    
    for i=1:size(flyTracks.centroid,3)
        fr = find(times >= blocks(k) & times <= blocks(k+1)); %bin edges in frames
        if fr
            deltaX(k,i) = abs(diff(flyTracks.centroid([min(fr) max(fr)],1,i)));
            deltaY(k,i) = abs(diff(flyTracks.centroid([min(fr) max(fr)],2,i)));
        else
            deltaX(k,i) = NaN;
            deltaY(k,i) = NaN;
        end
    end
end

velocity = sqrt(deltaX.^2 + deltaY.^2)/(binSize*pxmm); %convert to mm/sec
binEdges = blocks(2:end);

if doPlot
    plot(binEdges,smooth(mean(velocity,2),20))
    xlabel('time (sec)')
    ylabel(['mean speed (mm / sec) calculated in ' sprintf('%0.1f', binSize) 'sec bins'])
    
    yl=ylim;
    xl=[min(flyTracks.stim{2})+flyTracks.chargeTime max(flyTracks.stim{2})];
    color = [0.5 0.5 0.5];
    ptch = patch([xl(1) xl(1) xl(2) xl(2)],[yl fliplr(yl)],'k');
    set(ptch,'edgecolor','none','facecolor',color, 'faceAlpha', 0.5)
end