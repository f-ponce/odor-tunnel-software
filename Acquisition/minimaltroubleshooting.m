%% minimaltroubleshooting
[NI, AC, vid]=initializeTunnels(); %Initiate NIDAQ and get object to control NIDAQ
%% or
initializeTunnels(); %Initiate NIDAQ and get object to control NIDAQ
%%
global NI AC vid
%% Turn all solenoids off
valveState = zeros(1,24);  outputSingleScan(NI,valveState); % close empty valves
%% Turn all solenoids on
valveState = ones(1,24);  outputSingleScan(NI,valveState); % open empty valves
%%
valveState(21)=1; outputSingleScan(NI,valveState); % Turn on one valve (21 in this case)
%% CYCLE THROUGH EACH VALVE
for i=1:24; valveState = zeros(1,24); valveState(i)=1; disp(i); outputSingleScan(NI,valveState); pause(.5); end % close empty valve


%% close all valves, wait a second, open one valve (21 in this case)
valveState = zeros(1,24);outputSingleScan(NI,valveState); pause(1); valveState(21)=1;  outputSingleScan(NI,valveState); % close empty valves


%% close or open one valve
valveState(18)= 1; outputSingleScan(NI,valveState); % close empty valves

%% Control flow rates (64000 max), A, B, C, D for different flow rates

fprintf(AC, sprintf('%s%0.0f','D',1));

%% Control Alicat flow automatically
Offset=0
totalFlow=1.5
conc_debug= 0.39
flowtoalicat_air=calcFlow(totalFlow-(totalFlow*conc_debug) + Offset*(totalFlow>0),5) %air
flowtoalicat_odor=calcFlow(totalFlow*conc_debug + Offset*(totalFlow>0),1) %odor

fprintf(AC, sprintf('%s%0.0f','A',flowtoalicat_air));
fprintf(AC, sprintf('%s%0.0f','D',flowtoalicat_odor));


fprintf(AC, sprintf('%s%0.0f','B',flowtoalicat_air));
fprintf(AC, sprintf('%s%0.0f','C',flowtoalicat_odor));

%%
valveState = ones(1,24);  outputSingleScan(NI,valveState); % open empty valves

%%
valveState = zeros(1,24);  outputSingleScan(NI,valveState); % close empty valves

%%
time = datestr(flyTracks.times)
time = datetime(time)
figure(6)
numpoints=length(flyTracks.centroid(:,1,1));
hold on
for i =1:15
    plot(time,flyTracks.centroid(:,2,i))
end
%%