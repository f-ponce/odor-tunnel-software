function [pre_r,post_r,gen1] = qwikOproc(flyTracks)
pree = [];postt = [];geno = [];
x = find(flyTracks.shock(:,1));
ttt = flyTracks.shock(:,1);


times = zeros(1,length(flyTracks.velocity(:,1)));
mch = [];
decci = false;reppi = 0;
while decci == false
    if reppi == 0;
        odorr = 'MCH';
    elseif reppi == 1;
        odorr = 'OCT';
    elseif reppi == 2;
        odorr = 'PNT';
    else
        odorr = 'HPT';
    end
    for i = 2:4:length(flyTracks.stim(:))-2
        names = flyTracks.stim{i+2};
        if names{1} == odorr & names{2} == odorr
            mch = [find(flyTracks.relTimes > flyTracks.stim{i}(1) & flyTracks.relTimes < flyTracks.stim{i}(end))];
            times((mch)) = true;
        end
    end
    %The chosen string is what is being conditioned to move
    %towards
    noshkmch = ~logical(flyTracks.shock(:,1))';
    noshkmch2 = logical(times.*noshkmch);
    if sum(ttt'.*times) > 10
        decci = true;
        odorr
    else
        reppi = reppi+1;
    end
end

noshkvel = flyTracks.velocity(noshkmch2,:);
noshkori = diff(flyTracks.orientation(noshkmch2,:));
%         figure;plot(g)
pre = find((flyTracks.relTimes > flyTracks.stim{2}(1) & flyTracks.relTimes < flyTracks.stim{2}(end)));
post = find((flyTracks.relTimes > flyTracks.stim{24-2}(1) & flyTracks.relTimes < flyTracks.stim{24-2}(end)));
    pre_r = (nan(1,15));post_r = (nan(1,15));
for i = 1:flyTracks.nFlies
    ll = min(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
    mm = max(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
    if isempty(ll)
        sideA1(i) = nan;sideA2(i) = nan;sideB1(i) = nan;sideB2 = nan;pre_r(i) = nan;post_r(i) = nan;diffy(i) = nan;score(i) = nan;
        continue
    end
    
    sidee{1,1} = nansum(flyTracks.headPosition(pre,2,i) < ll);
    sidee{1,2} = nansum(flyTracks.headPosition(pre,2,i) > mm);
    
    sidee{2,1} = nansum(flyTracks.headPosition(post,2,i) < ll);
    sidee{2,2} = nansum(flyTracks.headPosition(post,2,i) > mm);
    %Compare odorr with stim sides to find opposite of where
    %shock is
    ccntt = 1;
    for odoc = [flyTracks.stim{4}(1),flyTracks.stim{24}(1)]
        lv = logical((strcmp(odorr,odoc)));
        if lv(1) == true
            scr(ccntt) = sidee{ccntt,2}/(sidee{ccntt,1}+sidee{ccntt,2});
        else
            scr(ccntt) = sidee{ccntt,1}/(sidee{ccntt,1}+sidee{ccntt,2});
        end
        ccntt= ccntt +1;
    end
    post_r(i) = scr(2);
    pre_r(i) = scr(1);
    
    score(i) = (post_r(i)-pre_r(i));
end
%         metric = score.*diffy;
try
    if ~isempty(flyTracks.genotype)
        gen1 = [flyTracks.genotype];
        cattle = true;
    end
catch
    gen1 = [nan(1,flyTracks.nFlies)];
    cattle = false;
end
try
    if ~isempty(flyTracks.pers)
        pers = nan(1,15);pers2 = nan(1,15);cnt = 1;
        for i = 1:length(flyTracks.pers)
            pers(flyTracks.pers(i)) = pre_r(cnt);
            pers2(flyTracks.pers(i)) = post_r(cnt);
            cnt = cnt+1;
        end
        pre_r = pers;
        post_r = pers2;
        gen1 = flyTracks.genotype;
    end
catch
end


