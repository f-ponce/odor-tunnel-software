%fix USB port connection issue after first run
%Alicat massflow control connection problem
%edit initializeCamera to include entire view of the arena
function [NI AC vid] = initializeTunnels

try
    webread('http://lab.debivort.org/mu.php?id=smells&st=2');
end


% Seed randomizer to be different across sessions
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

% Make session variables global
global NI AC

% Initialize hardware interfaces
warning off;
daqreset;
NI = connectToUSB6501;
disp('connected to nidaq device');

%disconnecting existing serial port connections
existing_serialports = serialportfind;
delete(existing_serialports);
AC = connectAlicat;
disp('connected to alicat device');

presentAir([0.2 0.2], 1.5, 1);

% Flush for 5sec, then zero flow
pause(5)
presentAir([0.2 0.2], 0, 0);

initializeCamera();


global vid

warning on

