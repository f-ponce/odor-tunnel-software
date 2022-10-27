function [NI AC vid] = initializeTunnels

try
    webread('http://lab.debivort.org/mu.php?id=smells&st=2');
end

% Seed randomizer to be different across sessions
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

% Make session variables global
global NI AC

% Initialize hardware interfaces
warning off; NI = connectToUSB6501;
AC = connectAlicat;
presentAir([0.2 0.2], 1.5, 1);

% Flush for 5sec, then zero flow
pause(5)
presentAir([0.2 0.2], 0, 0);

initializeCamera();

global vid

warning on