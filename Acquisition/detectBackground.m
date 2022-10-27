function out = detectBackground
%DETECTBACKGROUND Detect individual tunnels and flies.
%   OUT = DETECTBACKGROUND detects tunnels and flies, crops the camera ROI
%   to increase acquisition speed, creates a background image for
%   realtime subtraction, and calculates pixel resolution.  Data are
%   contained in structure OUT.
%
%   Revised November 14, 2013
%   Kyle Honegger, Harvard & CSHL


global vid;

if isempty(vid)
    initializeCamera(0)
end

if isrunning(vid)
    stop(vid)
end

flysize=20;
% vid.ROIPosition = [0 0 640 480];
% vid.ROIPosition = [250 250 1800 800];
x1=250;
y1=252;
% x1=0;
% y1=0;
% x2=1800+x1;
% y2=800+y1;
x2=1744;
y2=712;
vid.ROIPosition = [x1 y1 x2 y2];

triggerconfig(vid,'manual');
start(vid);
pause(5)
background_detected=0;
try
    load('C:\Users\Debivortlab\Documents\MATLAB\TunnelData\blankBg.mat', 'blankBg')
    disp("Sucesfully loaded blankBg.mat")
    background_detected=1;
catch
    warning('There was an error loading the background image file blankBg.mat')
    blankBg = uint8(zeros(size(peekdata(vid,1))));
end

ct = 0;
% disp("ct equals zero")

if background_detected
    timeout=30;
else
    timeout = 300;  % 5 min timeout period
end
props = {'Area', 'BoundingBox', 'MajorAxisLength', 'MinorAxisLength'};

tic

while toc < timeout
    ct = ct + 1;  % on ct = 1, I reset vid ROI, so DO NOT index by ct
%     disp(ct)
%     disp(size(blankBg))
%     disp(size(uint8(peekdata(vid,1))))
    fr = uint8(peekdata(vid,1));
%     error("subtracted background")
    % 1. Identify contiguous areas of bright space (tunnels)
    clf
    clear p l idx
    tun = [];
    
    if ct == 1
        
% ------------------- FIT A GAUSSIAN MIXTURE MODEL ------------------------
        % This doesn't work too well - distributions are not well-fit by
        % gaussians
%         I = double(fr);
%         I(I<5) = NaN;
%         display('Fitting Distribution')
%         hist(log(I(:)),30)
%         nGm = 3;
%         gm = gmdistribution.fit(I(:),nGm,'Replicates',1);
%         display('Finished fitting!')
%         id = find(gm.mu == min(gm.mu));
%         idx = cluster(gm,I(:));
%         thresh = max(I(idx==id));
        
        % thresh = 35; %25
        
        % p = regionprops(logical(fr < thresh), props);
 % ------------------------------------------------------------------------
        % Correct background for intensity fluctuations
        bp_x=135;
        bp_y=250;
        bp_w=40;
        bp_h=40;
        b = fr(bp_x:bp_x+bp_w,bp_y:bp_y+bp_h);
        b_ref = blankBg(bp_x:bp_x+bp_w,bp_y:bp_y+bp_h);
        intensity_offset = mean(b(:))-mean(b_ref(:));
%                 intensity_offset = mean(b(:))-mean(b_ref(:));

%         disp(intensity_offset)
%         figure(3)
%         clf
%         imagesc(blankBg)
%         figure(4)
%         clf
        blankBg = blankBg + intensity_offset;
%         imagesc(blankBg)
%         figure(5)
%         clf
%         disp(max(max(fr)))
%         disp(min(min(fr)))
%         fr = fr - intensity_offset;
%         figure(4)
%         disp(size(fr))
%         disp(max(max(fr)))
%         disp(min(min(fr)))
%         imshow(fr)
%         break
        % Best results are obtained by setting an upper and lower bound on 
        % tunnel intensity
%         lb = 10; %3; % tunnel area lower bound
%         ub = 60; %32; % tunnel area upper bound
%         l = imdilate(logical(fr <= ub & fr >= lb), [1; 1; 1; 1; 1; 1; 1]);
%         figure(5);imshow(l)
%         break %debug RM
%         if background_detected
%             l=findarenas(blankBg);
%         else
%             l=findarenas(fr);
%         end
% %         fr=-1*(blankBg-fr);
%         fr=fr-blankBg;
% 
%         p = regionprops(imerode(l>0,[1 1 1; 1 1 1]), props);
% %         p = regionprops(l>0, props);
% %         error("test here")
% %         disp(length(p))
%         
%         for i = 1:length(p)
%             tun(i) = 1;
% %             tun(i) = p(i).Area >= 3000 & p(i).Area <= 4500 & p(i).MajorAxisLength >= 225 & p(i).MajorAxisLength <= 250;
%         end
% %         disp(length(tun))
% %         disp(tun)
% %         error()
    end

    % l = imdilate(logical(fr < thresh), [1 1 1; 1 1 1]);
    %         l = imdilate(logical(fr <= ub & fr >= lb), [1; 1; 1; 1; 1; 1; 1]);
    %Prefer figuring out ROIs from background image, otherwise use fr
    if background_detected
        l=findarenas(blankBg);
    else
        l=findarenas(fr);
    end
    fr=100+fr-blankBg;
    fr=max(max(blankBg))+fr-blankBg;
    %         p = regionprops(l>0, props);
    p = regionprops(imerode(l>0,[1 1 1; 1 1 1]), props);
    

    for i = 1:length(p)
        tun(i)=1;
    end

    
    
    if ct == 1 && sum(tun) < 15
        ct = 0;
%         disp("we're getting here (line 128)")
        continue % force initial detection of 15 tunnels
    end
    
% Debug - KH
%     if sum(tun) < 15
%         display('stop')
%     end
    
    if ct > 1 && sum(tun) < sum(hasFlies)
        ct = ct - 1; % not great fix - but it works for now...             -KH151120A
        continue % return to head until all tunnels w/flies are detected
    end

%     imshow(imerode(l>32,[1 1 1; 1 1 1]));
%     imshow(imerode(l>32,[1 1 1; 1 1 1]));
    imshow(fr)
%     error("here")
    hold on
    
    idx = find(tun > 0);
    
    for i = 1:length(idx)
        b = p(idx(i)).BoundingBox;
        rectangle('Position', b, 'EdgeColor', 'r')
        tunnel(i).ROI = imcrop(fr, b);
        tunnel(i).globalLocation = b;
    end
    
    roiIntensity = [];
    
    for i = 1:length(tunnel)
        roiIntensity = [roiIntensity; tunnel(i).ROI(:)];
%     end
    
    % Assume values in the upper 0.7% of tunnel intensities are flies
%     flyThresh = prctile(roiIntensity,99.3);
        flyThresh(i) = prctile(roiIntensity,.7); %try lowering it

    
    % 2. Identify and count flies within tunnels
%     for i = 1:length(tunnel)
        
        p = regionprops(logical(tunnel(i).ROI <= flyThresh(i)), ...
            'Area', 'Centroid', 'BoundingBox');
        
        for ii = 1:length(p)
            
            if p(ii).Area > flysize  % Flies must have area greater than 12 px
                tunnel(i).fly.Centroid = p(ii).Centroid;
                tunnel(i).fly.Box = p(ii).BoundingBox;
            end
            
        end
        
    end
%     error('debug here')
    if ct == 1, hasFlies = ~cellfun('isempty',{tunnel.fly}); end

    
    % get 'global bounding box', set camera ROI
%     disp("ct")
%     disp(ct)
    if ct == 1
%         bigBounds = [find(hasFlies,1,'first') find(hasFlies,1,'last')];
%         
%         bigROI = [(tunnel(bigBounds(1)).globalLocation(1) - 15), ...
%             (tunnel(bigBounds(1)).globalLocation(2) - 15), ...
%             ((tunnel(bigBounds(2)).globalLocation(1)  +    ...
%             tunnel(bigBounds(2)).globalLocation(3)) -    ...
%             tunnel(bigBounds(1)).globalLocation(1) + 30), ...
%             (tunnel(bigBounds(1)).globalLocation(4) + 30)];
%         
%         stop(vid)
%         vid.ROIPosition = round(bigROI);
%         start(vid)
        pause(1)
%         
        bg = uint8(peekdata(vid,1));
%         
%         %bg = imcrop(bg, round(bigROI)-1); % this correction works, but isn't correct
%         blankBg = imcrop(blankBg, round(bigROI)-1);
%         
%         clear tunnel
        
        continue
    end
    
    
    % Display detection image
    if exist('toUpdate', 'var')
        % Plot segmented flies in green, unsegmented flies in red
        for i = toUpdate
            plot(tunnel(i).fly.Centroid(1) + tunnel(i).globalLocation(1), ...
                tunnel(i).fly.Centroid(2) + tunnel(i).globalLocation(2), '*r')
        end
        
        for i = setdiff(find(hasFlies),toUpdate)
            plot(tunnel(i).fly.Centroid(1) + tunnel(i).globalLocation(1), ...
                tunnel(i).fly.Centroid(2) + tunnel(i).globalLocation(2), '*g')
        end
    else
        for i = find(hasFlies)
            plot(tunnel(i).fly.Centroid(1) + tunnel(i).globalLocation(1), ...
                tunnel(i).fly.Centroid(2) + tunnel(i).globalLocation(2), '*r')
        end
    end
    
    title(['Segmenting background - ' sprintf('%d', length(idx)) ' tunnels and ' sprintf('%d', ...
        sum(hasFlies)) ' flies detected'])
    elapsed=toc;
    xlabels=[num2str(round(elapsed)),' out of ',num2str(timeout),' seconds'];
%     disp(xlabels)
    xlabel(xlabels);
    
    pause(0.001)
    
    % 3. Run background acquisition based on fly positions
    
    % 3.1 Keep the smallest bounding box for each tunnel (largest x and y,
    % smallest length and width)
    for i = 1:length(tunnel)
        bb(ct-1,:,i) = tunnel(i).globalLocation; % bounding box of tunnels
    end
    
    % 3.2 Run until centroid reaches some distance from start pos
    if ct == 2
        
        for i = find(hasFlies)
            pcen(i).initial = tunnel(i).fly.Centroid;
            pbound(i).initial = tunnel(i).fly.Box + ...
                [tunnel(i).globalLocation(1)-4 ...
                tunnel(i).globalLocation(2)-4 8 8]; %expand the fly box by 4px around
            rectangle('Position', pbound(i).initial, 'EdgeColor', 'g')
        end
        
        toUpdate = find(hasFlies);
        
    else
        
        for i = toUpdate
            current = tunnel(i).fly.Centroid;
            
            if pdist([current; pcen(i).initial]) > flysize*2 % current fly centroid > 20 pixels away from original
                % 3.3 When pixel idx no longer overlaps with original idx,
                % collect that info piecewise and merge to obtain full bg image
                
                [clip, idx] = imcrop(fr, pbound(i).initial); % revert clip to original reference intensity
                bgold=bg;
                bg(idx(2):(idx(2)+idx(4)), idx(1):(idx(1)+idx(3))) = clip;
%                 bg
%                 imshow(bgold-bg)
%                 error("patch fly")
                toUpdate(toUpdate == i) = []; % delete fly index from remaining list
                if ~exist('pcen','var')
                    pause(0.01)
                end
            end
            
        end
        
    end
    
    if isempty(toUpdate)
        break % terminate loop once bg image is fully updated
    end
    
end

if (toc > timeout) && ~background_detected
    error('Timeout period reached: at least one fly has not moved')
end

% 4. Format outputs
% out.bg = bg;  %background image
if background_detected
    out.bg=blankBg
else
    out.bg = bg;  %background image
end
out.blankBg = blankBg; %blank background image of ROI
out.tunnelActive = hasFlies;  %whether each tunnel contains a fly
out.tunnels = [squeeze(max(bb(:,[1 2],:),[],1)); ...
    squeeze(max(bb(:,[3 4],:),[],1))];  %tunnel boundaries
out.pxRes = 50/mean(out.tunnels(4,:));  %pixel resolution (mm/pixel)
out.flyThresh = flyThresh;

% Global centroids of final fly positions
ct = 0;
for i = find(hasFlies)
    ct = ct + 1;
    
    b = tunnel(i).globalLocation;
    out.lastCentroid{ct} = [tunnel(i).fly.Centroid(1) + b(1), ...
        tunnel(i).fly.Centroid(2) + b(2)]';
end


% Display final bg image and tunnels
% error("end")median(arenaData.flyThresh)

clf
imshow(bg)
hold on

for i=1:length(tunnel)
    rectangle('Position', out.tunnels(:,i), 'EdgeColor', 'r')
end

