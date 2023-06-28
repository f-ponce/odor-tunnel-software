function flyTracks = flyTracker2022(odors, conc)
%FLYTRACKER2022 Test odor preferences of individual flies.
%   FLYTRACKS = FLYTRACKER2013 tracks several individual flies in realtime
%   and controls stimulus delivery for testing odor preference.  Output
%   flyTracks is a structure containing individual fly statistics from the
%   experiment.
%
%   Revised June 11, 2014
%   Kyle Honegger, Harvard & CSHL


clf                             % open clean figure window

global NI AC valveState vid     % pull in nidaq, alicat, and camera objects
                                % defined by initializeTunnels.m
                                
dbstop if error                 % enter debug if an error is thrown
warning off                     % supress annoying warnings

try
    webread('http://lab.debivort.org/mu.php?id=smells&st=1');
end

% Create temp data files
t = datestr(clock,'mm-dd-yyyy_HH-MM-SS');
fpath = 'C:\Users\Debivortlab\Documents\MATLAB\TunnelData\tempData\';
cenID = [fpath t '_Centroid.dat'];          % File ID for centroid data
oriID = [fpath t '_Orientation.dat'];       % File ID for orientation
majID = [fpath t '_MajorAxis.dat'];         % File ID for major axis length

dlmwrite(cenID, [])                         % create placeholder ASCII file
dlmwrite(oriID, [])                         % create placeholder ASCII file
dlmwrite(majID, [])                         % create placeholder ASCII file

recordMovie = 1;                            % whether to stream experiment to MP4 movie file
useTemplateMatching = 0;                    % whether to use template matching for bg detection
recordThermocouple = 0;                     % whether to record data from thermocouple - synced with display updates, every 'dispRate' frames
if recordThermocouple, initializeThermocouple; end

% User-specified parameters
runningLength = 200;            % grabbed frames for tails

dispRate = 5;                   % rate (in frames) at which to update 
                                % tracking display - tradeoff with max
                                % attainable frame rate

chargeTime = 5;                                 % Amount of time (sec)
                                                % given for odor to charge
                                                % before flipping final
                                                % valve

propFields = {'Centroid' 'Orientation' 'MajorAxisLength'}; % Get items from
                                                           % regionprops

                                                           
                                                           
% Begin main script
[stimTimes, stim, duration] = constructStimulus(chargeTime, odors, conc);
%[stimTimes, stim, duration] = constructStimulus_m('MCH','OCT',false); % Stimlus
                                                           % timecourse
                                                           % for experiment

odorPeriod = presentAir([0.2 0.2], 0, 1);       % Start flushing with air
                                                % (Right now only setting 
                                                % state of delivery period)
                                                
flyTracks.times = NaN(1,60*duration);        % pre-allocate vectors for speed

if recordThermocouple
    flyTracks.thermocouple = NaN(1,60*duration); % pre-allocate vectors for speed
end
                                                
if useTemplateMatching
    arenaData = backgroundTemplateMatching;     % run bg detection script
else
    arenaData = detectBackground;               % run bg detection script
end

% Set up video writer object to record movie
if recordMovie
    writerObj = VideoWriter(['flyTracksMovie-' t],'MPEG-4');
    writerObj.Quality = 100;
    writerObj.FrameRate = 24; % estimated frame rate (fps)
    dispRate = 2;        % increase frame rate for smooth playback of video
    runningLength = 100;
    open(writerObj);
end

flyTracks.nFlies = sum(arenaData.tunnelActive); % get total number of flies

currentFrame = peekdata(vid,1);                 % grab first display frame

figure(2);
h = image(currentFrame); colormap(gray)         % set initial display

% For display
colors = hsv(flyTracks.nFlies + 1);             % set colormap for flies
tailCount = 0;                                  % initialize tail counter 


ct = 0;     % Initialize counter
tic         % Start experiment timer
finalValveState = 0; % Set initial Final Valve state



% This frame-by-frame loop runs continuously for total experiment duration
while toc < duration

    
    % Downsample if getting > 60 fps, to avoid processing duplicate frames
    if ct
        if etime(clock, datevec(flyTracks.times(ct))) <= 1/60
            continue
        end
    end
    
    
    ct = ct + 1;  % Update counter

    % 1. On each pass, set stimuli
    if stimTimes(ceil(toc))                  % If this is an odor period...
        
        block = stimTimes(ceil(toc));
        
        epoch = ['Stim ' sprintf('%d', ...   % Used below to label display
            stimTimes(ceil(toc)))];
        
        if ~odorPeriod          % Run only when beginning an odor period
            
            odorTime = clock;   % Each time odor period starts, make
                                % timestamp, wait for chargeTime, then
                                % flip final valve
            
            valves = stim(block).odor(2,:);
            conc = stim(block).odor(1,:);
            odorPeriod = presentOdor(valves, conc);
        end
        
        if ~finalValveState && etime(clock, odorTime) >= chargeTime
            finalValveState = flipFinalValve;
        end
        
    else                                            % otherwise present air
        epoch = 'Air';  % Used below to label display
        
        if odorPeriod   % Run only if terminating an odor period
            conc = [0.2 0.2];
            odorPeriod = presentAir(conc, 0); % Closes FinalValves too
            finalValveState = 0; % Reset Final Valve state
        end
        
    end
    
    % 2. Detect flies, extract kinematic data
    currentFrame = peekdata(vid,1);                 % Grab new frame
    flyTracks.times(ct) = now;                      % Timestamp the frame
%     delta = arenaData.bg - currentFrame;            % Make difference image
%     
%     dsize=size(delta);
%     threshold=prctile(reshape(delta,[dsize(1)*dsize(2), 1]), 99.3); %Adjust this threshold if there seems to be a problem
% %     error("check delta here")
% %     threshold=
%     %props = regionprops((delta >= 50), propFields);
% %     props = regionprops((delta >= min(arenaData.flyThresh)), propFields); % Get fly properties
% %     props = regionprops(imdilate(delta >= min(arenaData.flyThresh),[1 1 1; 1 1 1]), propFields);
%     props = regionprops(imerode(delta >= threshold,[1 1 1; 1 1 1]), propFields);
%     
    [props, delta, threshold]=detectflies(currentFrame, arenaData);
    props=props';

    if length(props)>15
        disp("Detecting too many flies")
        error("Detecting too many flies")
    elseif length(props)<15
        disp("Detected less than 15 flies")
    end

    %Median was a cludge, but this should probably be done for eachfly,
    %unclear how it is supposed to work?

    % Match each props element to preceeding fly centroids
    
    if ct == 1           % on first pass, load previous idxs from arenaData
        
        flyTracks.lastCentroid = arenaData.lastCentroid; % cell array of 
                                                         % previous fly 
                                                         % centroids
        
        c = [];
        ori = [];
    end
    
    % Find the props elements corresponding to previous flies
    flyTracks.centroid = NaN(flyTracks.nFlies,2);
    flyTracks.orientation = NaN(1,flyTracks.nFlies);
    flyTracks.majorAxisLength = NaN(1,flyTracks.nFlies);
    
%     if size(props,1)<2
%         error("Not enough fields")
%     end
    
    for i = 1:length(props)
        
%         % calculate the distance (in px) between previous fly positions and
%         % newly detected objects, identify matches.
%         tmp = [props(i).Centroid; [flyTracks.lastCentroid{:}]'];
%         dx = repmat(dot(tmp, tmp, 2), 1, size(tmp, 1));
%         d = sqrt(dx + dx' - 2* tmp* tmp');
%         d = d(1,2:(length(flyTracks.lastCentroid) + 1));
% 
%         % a props element corresponds to a fly when the centroid distance
%         % is < 18 px since last frame
%         flyIdx = find(d < 30);%increased to 30 for higher res camera
%         
        
%         if flyIdx
%         if length(props(i).Centroid)>0
        flyTracks.centroid(i,:) = single(props(i).Centroid);
        flyTracks.orientation(i) = single(props(i).Orientation);
        flyTracks.majorAxisLength(i) = ...
            single(props(i).MajorAxisLength);
        flyTracks.lastCentroid{i} = single(props(i).Centroid)';
%         end
%         end

%         if i==3
%             error('check here')
%         end

    
        
    end
    
   
    
    % write data to temp file
    dlmwrite(cenID, flyTracks.centroid, '-append')
    dlmwrite(oriID, flyTracks.orientation, '-append')
    dlmwrite(majID, flyTracks.majorAxisLength, '-append')
    
    
    % enter data into runningTracks for plot update
    if ct > runningLength
        flyTracks.runningTracks(:,:,runningLength + 1) = flyTracks.centroid;
        flyTracks.runningTracks(:,:,1) = [];
    else
        flyTracks.runningTracks(:,:,ct) = flyTracks.centroid;
    end
    
    
    % update the display with centroid, major axis, and running tail
    if mod(ct,dispRate) == 0
%         error("hello")
        [tailCount c ori] = updatePlot(h, delta>threshold, duration, epoch,...
            tailCount, flyTracks, colors, c, ori);
%         [tailCount c ori] = updatePlot(h, currentFrame, duration, epoch,...
%             tailCount, flyTracks, colors, c, ori);
                
      
        if recordThermocouple
            flyTracks.thermocouple(ct) = inputSingleScan(NI);
        end
        
    end
   
end





% On finish add pertinent data to the output structure
flyTracks.duration = toc;
flyTracks.bg = arenaData.bg;
flyTracks.blankBg = arenaData.blankBg;
flyTracks.tunnels = arenaData.tunnels;
flyTracks.pxRes = arenaData.pxRes;
flyTracks.tunnelActive = arenaData.tunnelActive;
flyTracks.chargeTime = chargeTime;
flyTracks.times = flyTracks.times(1:ct); % trim pre-allocated NaNs
if recordThermocouple, flyTracks.thermocouple = flyTracks.thermocouple(~isnan(flyTracks.thermocouple)); end % trim pre-allocated NaNs

% Pull in ASCII data, format into matrices
flyTracks.orientation = dlmread(oriID);
flyTracks.majorAxisLength = dlmread(majID);

tmp = dlmread(cenID);
for i = 1:ct
    
    for k = 1:flyTracks.nFlies
        flyTracks.centroid(i, :, k) = tmp(((i - 1) * flyTracks.nFlies) ...
            + k, :);
    end
    
end

% clean up files and structure
delete(cenID, oriID, majID)
flyTracks = rmfield(flyTracks, 'lastCentroid');
flyTracks = rmfield(flyTracks, 'runningTracks');

% Format stimulus info
for s = 1:length(stim)                                                     
    flyTracks.stim{1,s} = ['Stim ' sprintf('%d',s)];
    flyTracks.stim{2,s} = stim(s).times;     % Frame indices for stim block
    flyTracks.stim{3,s} = stim(s).odor;      % Odor conc and valve index
    flyTracks.stim{4,s} = stim(s).labels;    % Odor labels [Side A, Side B]
end

stop(vid)
% vid.ROIPosition = [0 0 640 480];            % Reset camera ROI to full size

if recordMovie
    close(writerObj)
    delete(writerObj)
end

save(strcat(fpath,t,".mat"), "flyTracks");




% Helper function for updating the plot
    function [tailCount c ori] = updatePlot(h, currentFrame, duration, ...
        epoch, tailCount, flyTracks, colors, c, ori)
    
        set(h,'CData',currentFrame)     % update display with current frame
        
        
        timeLeft = round(duration - toc);
        title(['Tracking Flies - ' epoch ' (' sprintf('%d',timeLeft) ...
            's remaining)'])
        tailCount = tailCount + 1;
        
      
        % calculate major axis limits
        for i = 1:flyTracks.nFlies
            
            r = flyTracks.majorAxisLength(i)/2;
            x = r * cos(flyTracks.orientation(i) * (pi/180));
            y = r * sin(flyTracks.orientation(i) * (pi/180));
            
            lx = [flyTracks.centroid(i,1) + x, ...
                flyTracks.centroid(i,1) - x];
            ly = [flyTracks.centroid(i,2) - y, ...
                flyTracks.centroid(i,2) + y];
            
            majAx{i} = [lx; ly];
        end


% update the display with new cen, maj ax, and running tails
for k = 1:flyTracks.nFlies
    
    hold all
    
    if tailCount > 1
        set(c(k), 'XData', squeeze(flyTracks.runningTracks(k,1,:)), ...
            'YData', squeeze(flyTracks.runningTracks(k,2,:)),...
            'LineWidth', 2, 'Color', colors(k,:));
        
        set(ori(k), 'XData', majAx{k}(1,:), ...
            'YData', majAx{k}(2,:),...
            'LineWidth', 2, 'Color', 'g');
        
    else
        c(k) = plot(squeeze(flyTracks.runningTracks(k,1,:)),...
            squeeze(flyTracks.runningTracks(k,2,:)),...
            'LineWidth', 2, 'color', colors(k,:));
        
        ori(k) = plot(majAx{k}(1,:), majAx{k}(2,:), ...
            'LineWidth',2,'color','g');
        
    end
    
end

  drawnow
    
    if recordMovie
        writeVideo(writerObj,getframe);
    end


try
webread('http://lab.debivort.org/mu.php?id=smells&st=2');
end

end
end

