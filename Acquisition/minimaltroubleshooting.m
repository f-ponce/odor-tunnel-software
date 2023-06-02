%% minimaltroubleshooting
[NI, AC, vid]=initializeTunnels(); %Initiate NIDAQ and get object to control NIDAQ
%% or
initializeTunnels(); %Initiate NIDAQ and get object to control NIDAQ
global NI AC vid
%%
valveState = zeros(1,24);  outputSingleScan(NI,valveState); % close empty valves

valveState = ones(1,24);  outputSingleScan(NI,valveState); % open empty valves

valveState(21)=1; outputSingleScan(NI,valveState); % Turn on one valve (21 in this case)
%% CYCLE THROUGH EACH VALVE
for i=1:24; valveState = zeros(1,24); valveState(i)=1; disp(i); outputSingleScan(NI,valveState); pause(.5); end % close empty valve


%% close all valves, wait a second, open one valve (21 in this case)
valveState = zeros(1,24);outputSingleScan(NI,valveState); pause(1); valveState(21)=1;  outputSingleScan(NI,valveState); % close empty valves


%% close or open one valve
valveState(4)=0; outputSingleScan(NI,valveState); % close empty valves

%% Control flow rates (64000 max), A, B, C, D for different flow rates

fprintf(AC, sprintf('%s%0.0f','D', 64000));

%%
valveState = ones(1,24);  outputSingleScan(NI,valveState); % open empty valves

%%
valveState = zeros(1,24);  outputSingleScan(NI,valveState); % close empty valves
