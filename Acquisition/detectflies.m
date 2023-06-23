function [props, delta, threshold]=detectflies(currentFrame, background)
    propFields = {'Area','Centroid' 'Orientation' 'MajorAxisLength'}; % Get items from
                                                               % regionprops
    delta = background - currentFrame;            % Make difference image
        
    
    flysize=100;
    dsize=size(delta);
    threshold=prctile(reshape(delta,[dsize(1)*dsize(2), 1]), 99.3);
    
    props = regionprops(imerode(delta >= threshold,[1 1 1; 1 1 1]), propFields);
    allareas=[props.Area];
    allareas_bool=allareas>flysize;
    flyareas_index=find(allareas_bool);
    props=props(flyareas_index);
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