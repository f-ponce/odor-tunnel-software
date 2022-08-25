function flyTracks = MbockPlot2014(flyTracks)
%
% To do:
% 1.  Fix NaN interpolation and smoothing correction for high freq exits
% 3.  Make sure it handles multiple stim blocks correctly

% KH - Revised Jan 1, 2014


figure

f = axes('Position',[0 0 1 1]);

axis off

apos = generatePositionMatrix(0.02, 0.98, 0.02, 0.95, .01, -.05, 16);


for k = 1:flyTracks.nFlies
    
    odorDecision = flyTracks.inCorridor(k).odorDecision;
    refOdorChosen = flyTracks.inCorridor(k).refOdorChosen;
    odor = flyTracks.inCorridor(k).odorSideA;
    exitIdx = flyTracks.inCorridor(k).exitFr;
    
    if isfield(flyTracks, 'day1Idx')
        axes('Position',apos(flyTracks.day1Idx(k),:))
    else
        axes('Position',apos(k,:))
    end
    
    [ptch1, ptch2] = makePatches(flyTracks,k,flyTracks.corridorPos);
    
    hold on
    
    plot(flyTracks.headLocal(:,2,k),flyTracks.relTimes,'k')
    
    plot([0 0], [0 max(flyTracks.relTimes)], '--b')
    plot([flyTracks.tunnels(4,k) flyTracks.tunnels(4,k)], [0 max(flyTracks.relTimes)], '--b')
   % plot(flyTracks.headLocal(find(flyTracks.relTimes > 360 & flyTracks.relTimes < 370),2,k), flyTracks.relTimes(find(flyTracks.relTimes > 360 & flyTracks.relTimes < 370)), '*m')
    
    % plot the exit points, colored by toward or away from ref odor
    %     if strcmp(flyTracks.refOdor, flyTracks.stim{4,1}(1))
    %         set(ptch1,'edgecolor','none','facecolor', [0.7 1 0.7])
    %         set(ptch2,'edgecolor','none','facecolor', [1 0.7 1])
    %         plot(flyTracks.headLocal(exitIdx(odorDecision & refOdorChosen),2,k), flyTracks.relTimes(exitIdx(odorDecision & refOdorChosen)), '*g')
    %         plot(flyTracks.headLocal(exitIdx(odorDecision & ~refOdorChosen),2,k), flyTracks.relTimes(exitIdx(odorDecision & ~refOdorChosen)), '*m')
    %     else
    %         set(ptch1,'edgecolor','none','facecolor', [1 0.7 1])
    %         set(ptch2,'edgecolor','none','facecolor', [0.7 1 0.7])
    %         plot(flyTracks.headLocal(exitIdx(odorDecision & refOdorChosen),2,k), flyTracks.relTimes(exitIdx(odorDecision & refOdorChosen)), '*m')
    %         plot(flyTracks.headLocal(exitIdx(odorDecision & ~refOdorChosen),2,k), flyTracks.relTimes(exitIdx(odorDecision & ~refOdorChosen)), '*g')
    %     end
    
    
    % Label each track with p(choosing refOdor) and total n choices
    % during odor period

    
    set(gca,'ydir','rev')
    axis off
    xlim([-1 flyTracks.tunnels(4,k)+1])
    
end

set(gcf, 'Color', 'w')

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ptch1, ptch2] = makePatches(flyTracks, k, corridorPos)

ct=0;

temp={};
ctr=0;

for q=1:size(flyTracks.stim,2)
    tmp = flyTracks.stim{2,q};
    
    for qq = 1:size(tmp,1)
        ctr = ctr+1;
        mins(ctr) = min(tmp(qq,:));
        temp{1,ctr} = flyTracks.stim{1,q};
        temp{2,ctr} = tmp(qq,:);
    end
end

[~, idx] = sort(mins);

% flyTracks.stim = temp;

for i = idx
    stimm = flyTracks.stim{4,idx};
    eventTimes = flyTracks.stim{2,i}(flyTracks.chargeTime:end);
    eventLabels{i} = flyTracks.stim{1,i};
    
    for ii=1:size(eventTimes,1)
        
        ct = ct+1;
        
        eventOn = min(eventTimes(ii,:));
        eventOff = max(eventTimes(ii,:)) + 1;  % Added 1 sec to analysis
        
        eventOnFrame = find(round(flyTracks.relTimes) == eventOn, 1);
        eventOffFrame = find(round(flyTracks.relTimes) == eventOff, 1);
        
        %subplot('Position',[0.05 0.05 .75 0.9])
        
        % color = [0.6,0.6,1]; %light blue
        % color=[0.5,0.5,0.5]; %gray
        if strcmp(cell2mat(flyTracks.stim{4,i}(1)),'MCH') || strcmp(cell2mat(flyTracks.stim{4,i}(1)),'OCT');
            if cell2mat(flyTracks.stim{4,i}(1)) == 'MCH';
                clr1 = [1 0.6 1];
            else
                clr1 = [0.6 1 0.6];
            end
            if cell2mat(flyTracks.stim{4,i}(2)) == 'MCH';
                clr2 = [1 0.6 1];
            else
                clr2 = [0.6 1 0.6];
            end
        else
            if strcmp(cell2mat(flyTracks.stim{4,i}(1)),'Blue');
                clr1 = [0.5 0.5 1];
           elseif strcmp(cell2mat(flyTracks.stim{4,i}(1)),'Green');
                clr1 = [0.7 0.9 0.7];
            else
                clr1 = [1 1 1];
            end
            if strcmp(cell2mat(flyTracks.stim{4,i}(2)),'Blue');
                clr2 = [0.5 0.5 1];
            elseif strcmp(cell2mat(flyTracks.stim{4,i}(2)),'Green');
                clr2 = [0.7 0.9 0.7];
            else
                clr2 = [1 1 1];
            end
        end
        
        ptch1=patch([0, corridorPos(1), corridorPos(1), 0],...
            [eventOn,eventOn,eventOff,eventOff], 0);
        
        set(ptch1,'edgecolor','none','facecolor', clr1)
        
        ptch2=patch([corridorPos(end), flyTracks.tunnels(4,k), flyTracks.tunnels(4,k), corridorPos(end)],...
            [eventOn,eventOn,eventOff,eventOff], 0);
        
        set(ptch2,'edgecolor','none','facecolor',clr2)
        
        
    end
end

end
