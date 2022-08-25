function flyTracks = redrawTunnelBoundaries(flyTracks)

imshow(flyTracks.bg)
hold on

for i=1:15
    idx = mean([flyTracks.tunnels(1,i), flyTracks.tunnels(1,i)+flyTracks.tunnels(3,i)]);
    tmp = flyTracks.bg(:,round(idx-5:idx+5));
    theta(i) = prctile(tmp(:),16.3);
    tun_top(i) = find(mean(tmp,2)>theta(i),1,'first')-2;
    tun_bot(i) = find(mean(tmp,2)>theta(i),1,'last')+2;
    line([idx-5 idx+5], [tun_top(i) tun_top(i)],'Color','r');
    line([idx-5 idx+5], [tun_bot(i) tun_bot(i)],'Color','r');
    flyTracks.tunnels(2,i) = tun_top(i);
    flyTracks.tunnels(4,i) = tun_bot(i) - tun_top(i);
end