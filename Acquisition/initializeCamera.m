function src=initializeCamera(previewOn)

if nargin == 0
    previewOn = 1;
end

global vid;

vid = videoinput('gentl', 1, 'Mono8');
% vid = videoinput('pointgrety', 1, 'Mono8_640x480');

src = getselectedsource(vid);

triggerconfig(vid,'manual');
set(vid,'ReturnedColorSpace','gray');
% return
% % Set values manually so they persist
% src.BrightnessMode = 'Manual';
% src.Brightness = 255;
% 
% src.ExposureMode = 'Manual';
% src.Exposure = 62;
% 
% src.FrameRateMode = 'Manual';
% src.FrameRate = '60';
% 
% src.ShutterMode = 'Manual';
% src.Shutter = 4;
% 
% src.GainMode = 'Manual';
% src.Gain = 0;


start(vid);
pause(5)

if previewOn
    preview(vid);
end