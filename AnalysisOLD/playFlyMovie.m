function playFlyMovie(flyTracks, startTime)

if nargin < 2, startTime = 0; end

for k = 1:flyTracks.nFlies
    for i = 1:size(flyTracks.centroid,1)
        
        r = flyTracks.majorAxisLength(i,k)/2;
        
        x = r* cos(flyTracks.orientation(i,k)*(pi/180));
        y = r* sin(flyTracks.orientation(i,k)*(pi/180));
        
        % x-values of endpts
        lx(i,:,k) = [flyTracks.centroid(i,1,k)+x flyTracks.centroid(i,1,k)-x];
        
        % y-values of endpts
        ly(i,:,k) = [flyTracks.centroid(i,2,k)-y flyTracks.centroid(i,2,k)+y];
        
    end
end

t = find(flyTracks.etimes > startTime,1);


for i = t:length(flyTracks.centroid)
    imshow(flyTracks.bg)
    hold on
    
    for k = 1:flyTracks.nFlies
        plot(lx(i,:,k), ly(i,:,k), '-g')
        % plot(flyTracks.centroid(i,1,k), flyTracks.centroid(i,2,k), '*')
        plot(flyTracks.headPosition(i,1,k), flyTracks.headPosition(i,2,k), '.k')
    end
    title(sprintf('%f', flyTracks.etimes(i)))
    pause(0.001)
    clf
end