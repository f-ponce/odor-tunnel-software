% pers = [15:-1:1];
% flyTracks = flyTracker2014;flyTracks.pers = pers;save odor_r3 flyTracks
% flyTracks = flyTrackerColor(true);flyTracks.pers = pers;save color_r3 flyTracks

% pers = [1,3:15];
% flyTracks = flyTracker2014_m(true,false);flyTracks.pers = pers;save odor_3-3 flyTracks
% pause(300)
% flyTracks = flyTrackerColor(true);flyTracks.pers = pers;save color_3-3 flyTracks

% pers = [15,13:-1:2];
% flyTracks = flyTracker2014_calib(true,false);flyTracks.pers = pers;save extinction_6   
% genotype = [true(1,8),false(1,7)];
% flyTracks = flyTracker2014_m(true,false);flyTracks.genotype = genotype;save odor_v12_curlyold_curlyr flyTracks
flyTracks = flyTracker2014_calib(true,false);