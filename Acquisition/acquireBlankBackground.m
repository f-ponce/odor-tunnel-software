%make sure the infrared is on and room light is off
function acquireBlankBackground

global vid;

if isempty(vid)
    initializeCamera(0)
end

if isrunning(vid)
    stop(vid)
end

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
disp('saved BlakBackground');