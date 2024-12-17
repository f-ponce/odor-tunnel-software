%make sure the infrared is on and room light is off
function acquireBlankBackground

global vid;

if isempty(vid)
    initializeCamera(0)
end

if isrunning(vid)
    stop(vid)
end

x1=660;
y1=298;
% x1=0;
% y1=0;
% x2=1800+x1;
% y2=800+y1;
x2=1744;
y2=712;
vid.ROIPosition = [x1 y1 x2 y2];

% vid.ROIPosition = [0 0 640 480];

start(vid)
pause(1)

nFrames = 100; % n frames over which to average

for i =1:nFrames
    blankBg(:,:,i) = uint8(peekdata(vid,1));
    pause(0.05);
end

blankBg = uint8(mean(blankBg,3));
clf
imshow(blankBg)
save('C:\Users\Debivortlab\Documents\MATLAB\TunnelData\blankBg.mat', 'blankBg')
