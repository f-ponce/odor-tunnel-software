function src=initializeCamera(previewOn)

if nargin == 0
    previewOn = 1;
end
imaqreset
global vid;

vid = videoinput('gentl', 1, 'Mono8');
% vid = videoinput('pointgrety', 1, 'Mono8_640x480');

src = getselectedsource(vid);


%coordinates to show the full arena
x1=660;%width from the upper left corner
y1=350;
x2=x1+1080;
y2=y1+280;
vid.ROIPosition = [x1 y1 x2 y2];

triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','gray');

start(vid);
pause(5)

if previewOn
    preview(vid);
end