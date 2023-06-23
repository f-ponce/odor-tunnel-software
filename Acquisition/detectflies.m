function [props, delta, threshold]=detectflies(currentFrame, background)
    propFields = {'Area','Centroid' 'Orientation' 'MajorAxisLength'}; % Get items from
                                                               % regionprops
    delta = background - currentFrame;            % Make difference image
        
    
    flysize=50;
    dsize=size(delta);
    threshold=prctile(reshape(delta,[dsize(1)*dsize(2), 1]), 99.3);
    
    numerodes=2;
    thresholdedimage=delta >= threshold;
    for erodes=1:numerodes
        thresholdedimage=imerode(thresholdedimage,[1 1 1; 1 1 1]);
        disp(erodes)
    end

    props = regionprops(thresholdedimage, propFields);
    allareas=[props.Area];
    allareas_bool=allareas>flysize;
    flyareas_index=find(allareas_bool);
    props=props(flyareas_index);
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