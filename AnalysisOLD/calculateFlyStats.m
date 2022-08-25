function varargout = calculateFlyStats(fname)
%CALCULATEFLYSTATS Initial analysis of fly tunnel behavioral data.
%   FLYTRACKS = CALCULATEFLYSTATS(FLYTRACKS) performs data pre-processing,
%   calculates several useful metrics for individual flies (including
%   velocity, distance traveled, and odor choice probability) and returns a
%   data structure with new information appended.
%
%   INPUT:
%          fname - a path to the structure created by flyTracker2013.m
%
%   OUTPUT:
%          flyTracks(optional) - an updated version of the input structure
%          with new information appended. This structure can be supplied to
%          MbockPlot2013.m and other plotting functions. If no output
%          variable is requested, the function will save a copy of the
%          input structure to a file with name 'fname-processed.mat
%
%   DEPENDENCIES:
%          FINDHEAD.m
%          FLYVELOCITY.m
%
%
%   September 27, 2013
%   Kyle Honegger, Harvard & CSHL



% Load data
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
load(fname);                                % load flyTracks data structure

if ~exist('flyTracks','var')             % check for correct data structure
    error('input file does not contain a valid flyTracks structure')
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Smooth data (improves quality of velocity estimate)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
winSz = 4;                % 125ms - assuming an average frame rate of 32fps

% Identify flies with missing data
hasNaNs = logical(sum(isnan(squeeze(flyTracks.orientation))));

for i = find(~hasNaNs)            % skip flies that have NaNs in the tracks
    flyTracks.centroid(:,1,i) = smooth(flyTracks.centroid(:,1,i),winSz);
    flyTracks.centroid(:,2,i) = smooth(flyTracks.centroid(:,2,i),winSz);
    %flyTracks.orientation(:,i) = smooth(flyTracks.orientation(:,i),winSz);    
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Calculate timestamps relative to experiment start
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
for i = 1:length(flyTracks.times)
    flyTracks.etimes(i) = etime(datevec(flyTracks.times(i)), ...
        datevec(flyTracks.times(1)));
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


% Reorder shuffled tunnel positions to original Day 1 positions
% !!!! FIX: Flies missing on Day 2 are not treated as such  !!!!!!
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% if isfield(flyTracks,'day1Idx')
%     flyTracks.centroid(:,:,flyTracks.day1Idx) = flyTracks.centroid;
%     flyTracks.orientation(:,flyTracks.day1Idx) = flyTracks.orientation;
%     flyTracks.majorAxisLength(:,flyTracks.day1Idx) = flyTracks.majorAxisLength;
%     flyTracks.tunnels(:,flyTracks.day1Idx) = flyTracks.tunnels;
%     flyTracks.tunnelActive(flyTracks.day1Idx) = flyTracks.tunnelActive;
% end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Calculate average frame rate (in fps)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
nFrames = size(flyTracks.centroid,1);
flyTracks.rate = nFrames/flyTracks.duration;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Total distance traveled
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
for k = 1:flyTracks.nFlies
    flyTracks.dist(k) = sum(abs(diff(flyTracks.centroid(:,2,k))) ...
        * flyTracks.pxRes);
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


% Find head (major axis endpt closest to instantaneous direction vector)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
flyTracks.headPosition = findHead(flyTracks);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


% Re-scale orientation to range [0 180]
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
for k = 1:flyTracks.nFlies
    a = flyTracks.orientation(:,k);
    flyTracks.orientation(a < 0,k) = 180 + a(a<0);
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Instantaneous centroid velocity (have seperate vel plotting function)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
[flyTracks.velocity, flyTracks.velBins] = flyVelocity(flyTracks);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Calculate choice statistics (corridor entry/exit, side/odor chosen)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% # times entering choice zone (total and during odor period)

    % write new function to calculate this info - pull out of Mbockplot
    
    % make odor event time vector:
    %   0 - no odor
    %   1 - odor on side A
    %   2 - odor on side B
    
    % make corridor exit events time vector by comparing to odor events:
    %   0 - no exit
    %   1 - exit toward ref odor
    %   2 - exit away from refOdor
    
    % prob choosing Odor A over Odor B, etc.



% 1. Calculate fly positions relative to tunnels
activeTunnels = find(flyTracks.tunnelActive);

for i = 1:length(activeTunnels)
    tun = flyTracks.tunnels(:,activeTunnels(i));
    flyTracks.centroidLocal(:,:,i) = [(flyTracks.centroid(:,1,i) - tun(1)), ...
        (flyTracks.centroid(:,2,i) - tun(2))];
end


% 2. Determine choice corridors (maybe expand region slightly)

corridorSize = 10; % in mm (formerly 8mm)
corridorPx = corridorSize/flyTracks.pxRes; % distance across corridor in px
tunnelCenter = mean(flyTracks.tunnels(4,:)) / 2;

corridorPos = [round(tunnelCenter - 0.5* corridorPx) : ...
    round(tunnelCenter + 0.5* corridorPx)]; % along y-axis


% 3. Mark event each time the fly (only head?) enters and exits corridor

inCorridor = zeros(size(flyTracks.centroidLocal,1),1,size(flyTracks.centroidLocal,3));

for i=1:length(corridorPos)
    inCorridor(round(flyTracks.centroidLocal(:,2,:)) == corridorPos(i)) = 1;
end

inCorridor = squeeze(inCorridor);
allEnters = diff(inCorridor) > 0;
allExits = diff(inCorridor) < 0;


% 4. Figure out which side the refOdor is on
odorIdx = [];
refOdorOnSideA = [];

for i = 1:size(flyTracks.stim,2)
    
    odorIdx = [odorIdx flyTracks.stim{2,i}(flyTracks.chargeTime:end) flyTracks.stim{2,i}(end) + 1];
    
    if find(strncmp(refOdor, flyTracks.stim{4,i}, 3)) == 1
        refOdorOnSideA = [refOdorOnSideA ones(1, length(flyTracks.stim{2,i}(flyTracks.chargeTime:end)) + 1)];
    else
        refOdorOnSideA = [refOdorOnSideA zeros(1, length(flyTracks.stim{2,i}(flyTracks.chargeTime:end)) + 1)];
    end
    
end



% Begin terrible, slow hack...
for k = 1:size(allEnters,2)
    enterInd = find(allEnters(:,k));
    exitInd = find(allExits(:,k));
    
    if isempty(exitInd) % give NaNs to flies w/out exits during odor period
       refOdorChosen{k} = NaN;
       preOdorExits(k) = NaN;
       preOdorBias(k) =  NaN;
       tunnelRange(k) = range(flyTracks.centroid(:,2,k));
       dist(k) = sum(abs(diff(flyTracks.centroid(:,2,k)))*flyTracks.pxRes);
       continue
    end
    
    
    for ii = 2:length(enterInd)
        clip = flyTracks.centroidLocal(enterInd(ii-1):enterInd(ii),2,k);
        extrema = [min(clip) max(clip)];
        
        if sum(abs(flyTracks.centroidLocal(enterInd(ii),2,k) - ...
                extrema) < 10) == 2,
            allEnters(enterInd(ii),k) = 0;
            
            % if an exit has no corresponding entrance, delete the previous
            % exit
            allExits(exitInd(ii-1),k) = 0;
        end
    end
    
    % Update idices
    enterInd = find(allEnters(:,k));
    exitInd = find(allExits(:,k));
    
    % 4. Determine from which side fly exited - mark as odor choice (Side A == 1)
    
    exitPos = flyTracks.centroidLocal(logical([0; allExits(:,k)]),2,k);
    sideAexit{k} = exitPos > 100;
    
    
    % 5. Map choices back to odor periods, translate into odor choice
    
    ExitDuringOdorPeriod{k} = zeros(1,length(exitInd));
    RefAidx = zeros(1,length(exitInd));
    
    

    for ii = 1:length(ExitDuringOdorPeriod{k})
        t = flyTracks.etimes(exitInd(ii));  % the time of this exit
        
        if sum(floor(t) == odorIdx) % if exit occurs during odor block
            ExitDuringOdorPeriod{k}(ii) = 1;
            RefAidx(ii) = refOdorOnSideA(find(floor(t) == odorIdx)); % same size as ExitDuringOdorPeriod
        end
        
    end
    
    
    
if  any(ExitDuringOdorPeriod{k})
    preOdorExits(k) = find(ExitDuringOdorPeriod{k}, 1, 'first') - 1;  % number of pre-odor choices
    preOdorBias(k) =  nanmean(sideAexit{k}(1:preOdorExits(k)));
else
    preOdorExits(k) = NaN;
    preOdorBias(k) =  NaN;
end
    
    tunnelRange(k) = range(flyTracks.centroid(:,2,k));
    dist(k) = sum(abs(diff(flyTracks.centroid(:,2,k)))*flyTracks.pxRes);
    
    
    refOdorChosen{k} = [];
    
    for i = find(ExitDuringOdorPeriod{k}) % for every choice during odor block
        
        if sideAexit{k}(i) == RefAidx(i) % test whether the exit was towards refOdor
            refOdorChosen{k} = [refOdorChosen{k} 1];
            
        else
            refOdorChosen{k} = [refOdorChosen{k} 0]; % or away from refOdor
        end
        
    end
    
end

% 6. Format output
flyTracks.refOdorChosen = refOdorChosen;
flyTracks.preOdorExits = preOdorExits;
flyTracks.preOdorBias = preOdorBias;
flyTracks.tunnelRange = tunnelRange;
flyTracks.dist = dist;
flyTracks.hasNaNs = logical(sum(isnan(squeeze(flyTracks.centroid(:,2,:)))));
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Calculate occupancy times for each odor
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %



% Return output structure, if requested, or save new structure
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
if nargout == 1
    varargout{1} = flyTracks;
else
    
    if strcmp('.mat', fname(end-3:end))
        fname(end-3:end) = [];
    end
    
    save([fname '-processed.mat'], 'flyTracks')
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %


