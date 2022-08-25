function [preO,postO,genO] = SingLrnProc(flyTracks)

[preO,postO,genO] = qwikOproc(flyTracks);

    lrnCorrplot(preO,postO)
    
    eind = find(genO == 1);
    econt = find(genO == 0);
    econt2 = find(genO == 2);
    
    %expC{i} = (postC{i}-preC{i})./(1-preC{i});
    expO = (postO-preO)./(1-preO);
    
    % expC{i} = (postC{i}-preC{i});
   % expO = (postO-preO);
    
    
    %exp2 = pre{i};
    if ~isempty(expO)
        cntO = expO(econt);
        cntO2 = expO(econt2);
        expO = expO(eind);
    end


mattBox({cntO},{expO})
figure;
for i = 1:length(postO)
    a = plot([0,1],[preO(i),postO(i)],'b');
    a.Marker = 'o';
    a.MarkerFaceColor = 'b';
    hold on
end
axis([-0.5 1.5 -0.1 1.1])


