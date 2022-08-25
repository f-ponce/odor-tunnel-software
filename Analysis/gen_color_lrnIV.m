function [arrangeD,gen1,headP2] = gen_color_lrnII(flyTracks)


pree = [];postt = [];geno = [];


times = zeros(1,length(flyTracks.velocity(:,1)));
mch = [];
decci = false;reppi = 0;
while decci == false
    if reppi == 0;
        odorr = 'Blue';
    elseif reppi == 1;
        odorr = 'Green';
    end
    for i = 2:4:length(flyTracks.stim(:))-2
        names = flyTracks.stim{i+2};
        if strcmp(names{1},odorr) && strcmp(names{2},odorr)
            mch = [find(flyTracks.relTimes > flyTracks.stim{i}(1) & flyTracks.relTimes < flyTracks.stim{i}(end))];
            times((mch)) = true;
        end
    end
    %The chosen string is what is being conditioned to move
    %towards
decci = true;
        odorr = 'Blue';

end

% Determine where in the training period there is one side OCT and one side
% MCH. These are stored in the cell-array called evalPeriod
pnt = 1;
tt = size(flyTracks.stim);lgn = tt(1)*tt(2);

for kk = 4:4:lgn
    if ~strcmp(flyTracks.stim{kk}{1},flyTracks.stim{kk}{2})
        evalPeriod{1,pnt} = kk-2;
        evalPeriod{2,pnt} = find((flyTracks.relTimes > flyTracks.stim{kk-2}(1) & flyTracks.relTimes < flyTracks.stim{kk-2}(end)));
        pnt = pnt+1;
    end
end

pre_r = (nan(1,15));post_r = (nan(1,15));
for i = 1:flyTracks.nFlies
    
    ll = min(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
    mm = max(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
    ll = 102;
    mm = 111;
    if isempty(ll) || flyTracks.dist(i) < 500
        sideA1(i) = nan;sideA2(i) = nan;sideB1(i) = nan;sideB2 = nan;pre_r(i) = nan;post_r(i) = nan;diffy(i) = nan;score(i) = nan;
        continue
    end
    
    for kk = 1:length(evalPeriod)
        sidee(1) = 1-(abs(mean(flyTracks.headPosition(evalPeriod{2,kk},2,i))-11)/215);
        sidee(2) = (abs(mean(flyTracks.headPosition(evalPeriod{2,kk},2,i))-11)/215);
        sidee(1) = nansum(flyTracks.headPosition(evalPeriod{2,kk},2,i) < ll);
        sidee(2) = nansum(flyTracks.headPosition(evalPeriod{2,kk},2,i) > mm);
        odoc = flyTracks.stim{evalPeriod{1,kk}+2};
        lv = logical((strcmp(odorr,odoc{2})));
        if lv
            scr = sidee(1)/(sidee(1)+sidee(2));
            %scr = sidee(1);
        else
            scr = sidee(2)/(sidee(1)+sidee(2));
            %scr = sidee(2);
        end
        outPu(kk,i) = scr;
    end
end
%         metric = score.*diffy;
try
    if ~isempty(flyTracks.genotype)
        gen1 = [flyTracks.genotype];
    end
catch
    gen1 = [nan(1,flyTracks.nFlies)];
end
try
    if ~isempty(flyTracks.pers)
        outPut = nan(length(evalPeriod),15);
        for i = 1:length(flyTracks.pers)
            outPut(:,flyTracks.pers(i)) = outPu(:,cnt);
            cnt = cnt+1;
        end
        gen1 = flyTracks.genotype;
    end
catch
    outPut = outPu;
end
cnt = 1;
for i = [1:length(outPut(1,:))]
    arrangeD{i} = [outPut(1,i),outPut(end,i)];
end


for k = 1:flyTracks.nFlies
        headP{1,1} = flyTracks.headPosition(evalPeriod{2,1},2,k);
        headP{2,1} = flyTracks.headPosition(evalPeriod{2,end},2,k);
        headP{1,2} = flyTracks.centroid(evalPeriod{2,1},2,k);
        headP{2,2} = flyTracks.centroid(evalPeriod{2,end},2,k);
        headP{1,3} = flyTracks.orientation(evalPeriod{2,1},k);
        headP{2,3} = flyTracks.orientation(evalPeriod{2,end},k);
        %revRatio1(i) = sum(abs(diff(flyTracks.centroid(evalPeriod{2,i},k))));
        %revTime = flyTracks.inCorridor(k).enterFr >= evalPeriod{2,i}(1) & flyTracks.inCorridor(k).exitFr <= evalPeriod{2,i}(end);
        %revRatio1(i) = sum(flyTracks.inCorridor(k).odorDecision.*revTime'.*flyTracks.inCorridor(k).reversal)/sum(flyTracks.inCorridor(k).odorDecision.*revTime');
    headP2{k} = headP;

end

for i = 1:length(arrangeD)
    oneT(i) = arrangeD{i}(1);
    oneTT(i) = arrangeD{i}(2);
end
lrnGraph(oneT,oneTT)

end