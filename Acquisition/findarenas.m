function [blockedimage, boundingbox]=findarenas(testimage, horizontalthresh, verticalthresh,minwidth, minheight, padding, debug)
    arguments
        testimage;
        horizontalthresh (1,1) double=.6;
        verticalthresh (1,1) double=.7;
        minwidth (1,1) double = 50;
        minheight (1,1) double = 450;
        padding (1,1) double=15;
        debug logical=false;
    end
% findarenas autocalculates where the arenas are based on an empty arena
% image. Thresholds should work for current setup, but try missing with
% thresholds if it's not autodetecting properly. Different cameras or field
% of view will require changing other parameters.

testimage=double(testimage);
imsize=size(testimage);

hline=median(testimage, 1);

hlinefilt_lp=lowpass(double(hline), .001);

hlinefilt_hp=highpass(double(hline), .005);
hlinefilt=lowpass(hlinefilt_hp, .005);

arenahbounds=hlinefilt>horizontalthresh;


if debug
    figure(4);
    clf
    imagesc(testimage)
    
    %Find horizontal edges of boxes
    
    figure(5);
    clf


    plot(hline, 'k')
    hold on
    plot(hlinefilt_lp, 'g')
    plot(hlinefilt_hp, 'b')
    plot(hlinefilt, 'r')
    plot(arenahbounds, 'b')


end

hshape=repmat(arenahbounds, [imsize(1),1]);

% disp(size(hshape))
blockedimage=testimage.*hshape;

vprofile=mean(blockedimage, 2)/max(mean(blockedimage,2));


vprofile_filt=highpass(vprofile, .00001);
hold on
vprofile_cent=vprofile_filt-min(vprofile_filt);
vprofile_cent=vprofile_cent/max(vprofile_cent);
arenavbounds=vprofile_cent>verticalthresh;
arenavbounds_min=find(arenavbounds, 1, 'first');
arenavbounds_max=find(arenavbounds, 1, 'last');
arenavbounds(arenavbounds_min:arenavbounds_max)=1;
vshape=repmat(arenavbounds, [1, imsize(2)]);
blockedimage=blockedimage.*vshape;

if debug
    figure(6);
    clf
    hold on
    plot(vprofile, 'k');
    plot(vprofile_cent, 'r');
    plot(arenavbounds, 'b');

    figure(7)

    imagesc(blockedimage);

end


props = {'Area', 'BoundingBox', 'MajorAxisLength', 'MinorAxisLength'};

bi_bb=regionprops(blockedimage>1, props);
% disp(size(bi_bb))
bi_bb(1).BoundingBox;
% boundingbox2=reshape([bi_bb(:).BoundingBox], [length(bi_bb),4])';
boundingbox2=reshape([bi_bb(:).BoundingBox], [4,length(bi_bb)]);
boundingbox=boundingbox2;
boundingbox(1,:)=max(boundingbox(1,:)-padding,2);
boundingbox(2,:)=max(boundingbox(2,:)-padding,2);
boundingbox(3,:)=min(boundingbox2(1,:)+boundingbox2(3,:)+padding,imsize(2));
boundingbox(4,:)=min(boundingbox2(2,:)+boundingbox2(4,:)+padding,imsize(1));
% boundingbox(3,:)=boundingbox(3,:);
boundingbox=round(boundingbox);
blockedimage=blockedimage.*0;
% 

% if length(boundingbox>16)
% %     debug=true
%     
% end
for i=1:length(boundingbox)
    if (prod(boundingbox(:,i)>0) && minheight<(boundingbox(4,i)- boundingbox(2,i)) && minwidth<(boundingbox(3,i)-boundingbox(1,i)))
%     disp(boundingbox(1,i):boundingbox(3,:))
        
        blockedimage(boundingbox(2,i):boundingbox(4,i),boundingbox(1,i):boundingbox(3,i))=1;
    end
end
% disp(size(blockedimage))
blockedimage=testimage.*blockedimage;
if debug
    disp("Found "+num2str(length(boundingbox))+" arenas");
    figure(7);
    imagesc(blockedimage);
%     error('debug is on')
end
