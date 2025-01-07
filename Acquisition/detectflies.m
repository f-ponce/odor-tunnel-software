function [props, delta, threshold]=detectflies(currentFrame, arenaData)
    propFields = {'Area','Centroid' 'Orientation' 'MajorAxisLength'}; % Get items from
                                                               % regionprops
    delta = arenaData.bg-currentFrame;            % Make difference image
    dsize=size(delta);
    threshold=prctile(reshape(delta,[dsize(1)*dsize(2), 1]), 99.3);

    % Get all ROIS
    tunnel_corner_indexes=round(arenaData.tunnels);
    props=[];
    for i=1:length(tunnel_corner_indexes)
        tunnel_roi=imcrop(delta, tunnel_corner_indexes(:,i));
    
    
        flysize=70;
        dsize=size(tunnel_roi);
        threshold=prctile(reshape(tunnel_roi,[dsize(1)*dsize(2), 1]), 99.1);
        
        numerodes=1;
        thresholdedimage=tunnel_roi >= threshold;
        for erodes=1:numerodes
            thresholdedimage=imerode(thresholdedimage,[1 1 1; 1 1 1]);
            % disp(erodes);
        end
    
        props_roi = regionprops(thresholdedimage, propFields);
        allareas=[props_roi.Area];
        allareas_bool=allareas>flysize;
        flyareas_index=find(allareas_bool);
        props_roi=props_roi(flyareas_index);
        
        if i==1
            props=props_roi;
        end


        if sum(allareas_bool)
            % disp(i)
            props_roi.Centroid=props_roi.Centroid+tunnel_corner_indexes(1:2,i)';
            props(i)=props_roi;

        else
            save("image_debug_"+string(datetime('now','Format', 'yy-MM-dd_HH_mm_ss'))+".mat", "currentFrame", "arenaData");
            error("Failed to detect fly")
        end

    
%         props=[props; props_roi];
    end
end
%     figure(3)
%     imshow(thresholdedimage)
%     disp([props.Area])
%     disp("How many were above threshold?")
%     disp(sum(allareas_bool))

%            for i = 1:length(props)
%             
%             
%             if props(i).Area > flysize  % Flies must have area greater than flysize as determined in detectBackground
% %                 flyTracks.fly(i).Centroid = props(i).Centroid;
% %                 flyTracks.fly(i).Box = props(i).BoundingBox;
%             end
%             
%         end