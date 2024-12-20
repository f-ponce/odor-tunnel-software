function odorState = presentOdor(valves, conc, totalFlow)

if nargin < 3
%     totalFlow = [1.5 1.537]; %total flow rate through MFCs (L/min)
    totalFlow = [1.5 1.5]; %total flow rate through MFCs (L/min) %Tweak this to calibrate right vs left total
%     totalFlow = [1 1]; %total flow rate through MFCs (L/min) %Tweak this to calibrate right vs left total


end

global NI AC valveState

% Set valve states
valveState = zeros(1,24);   % close empty valves
valveState(valves(1)) = 1;  % open odor valves
valveState(valves(2)) = 1;
valveState(11) = 1; % leave SainSmart off
% disp(valveState)
outputSingleScan(NI,valveState);

% Fudge factors to compensate for MFC offset and tubing leaks
aOffset = 0; %0.004;
bOffset = 0; %0.029;
cOffset = 0; %0.011;
dOffset = 0; %0.004;

% Calculate flow rates, send to MFCs
flowA = calcFlow(totalFlow(1)-(totalFlow(1)*conc(1)) + aOffset*(totalFlow(1)>0),5); %left side air
flowB = calcFlow(totalFlow(2)-(totalFlow(2)*conc(2)) + bOffset*(totalFlow(2)>0),5); %right side air
flowD = calcFlow(totalFlow(1)*conc(1) + dOffset*(totalFlow(1)>0),1); % left side odor
flowC = calcFlow(totalFlow(2)*conc(2) + cOffset*(totalFlow(2)>0),1); % right side odor
% disp(flowA)
% disp(AC)
% disp(sprintf('%s%0.0f','A',flowA))

fprintf(AC, sprintf('%s%0.0f','A',flowA));
fprintf(AC, sprintf('%s%0.0f','B',flowB));
fprintf(AC, sprintf('%s%0.0f','C',flowC));
fprintf(AC, sprintf('%s%0.0f','D',flowD));
disp(strcat("FlowA:",num2str(flowA)," FlowB:",num2str(flowB)," FlowC:",num2str(flowC)," FlowD:",num2str(flowD)))
odorState = 1;
end