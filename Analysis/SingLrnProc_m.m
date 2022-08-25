function lrnProc(flyTracks)

try
[pre,b] = gen_odor_lrn(flyTracks);
catch
[pre,b] = gen_color_pers(flyTracks);
end

%     eind = find(genO == 1);
%     econt = find(genO == 0);
%     econt2 = find(genO == 2);
%     eind = find(genO == 0);
%     econt = find(genO == 0);
%     econt2 = find(genO == 0);
%     
%     
%     %expC{i} = (postC{i}-preC{i})./(1-preC{i});
if length(pre{1}) == 2
    for i = 1:length(pre)
    expO(i) = (pre{i}(2)-pre{i}(1))./(1-pre{i}(1));
    expOrev(i) = (pre{i}(2)-pre{i}(1))./(1-pre{i}(1));
    if expO(i) < -1
        expO(i) = -1;
    end
    end
end
%     expOrev = (postOi-preOi)./(1-preOi);
%      expO = (postO-preO);
%      expOrev = (postOi-preOi);
     
%     
%     % expC{i} = (postC{i}-preC{i});
%    % expO = (postO-preO);
%     
%     
%     %exp2 = pre{i};
%     if ~isempty(expO)
%         cntO = expO(econt);
%         cntO2 = expO(econt2);
%         expO = expO(eind);
%     end

mattBox({expOrev},{expO})
expO
expOrev
%kk = ~isnan(expOrev).*~isnan(expO);
%lrnCorrplot(expOrev,expO)




