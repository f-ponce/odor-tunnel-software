function [stimTimes, stim, duration] = constructStimulus_mattc(chargeTime)
% function [stimTimes, stim, duration] = constructStimulus
%
% Currently only supports a single pair of odors.
%
%   To do:
%   1. Add capability for >1 odor pair or concentration
%   2. Convert to GUI for easier setup of complicated exp protocols
%
%   Revised July 21, 2013
%   Kyle Honegger, Harvard & CSHL

if nargin < 1
    chargeTime = 5;
end

% odors = {'Apple' 'Grape'};
% conc = [0.05 0.1];                  % proportion saturated vapor

odors = {'MCH' 'OCT'};
conc = [0.1 0.15]; %  default -aMW ctrl               % proportion saturated vapor          % 150119 - balancing concs:
%conc = [0.10 0.175];

OdorAonRight = false;                                                        % KH141217 - hardcode this for consistency

% if odor A is on right, need to make sure concentration swaps as well
if OdorAonRight == true
   concT=conc;
   conc(2)=concT(1);
   conc(1)=concT(2);
end

odorDur = 180;                        % in sec
isi = 10;                            % in sec
nBlocks = 1;                         % number of odor blocks

preTime = 180;                       % wait time before first odor block
postTime = 10;                      % wait time after last odor block


% Read valve assignments from csv file
fid = fopen('C:\Users\khonegger\Documents\MATLAB\TunnelSoftware\Acquisition\odors.csv');
v = textscan(fid, '%s %d %d', 'delimiter', ','); % Format: {Odor, SideA, SideB}
fclose(fid);

% Alternate sides, with random starting side
%OdorAonTop = repmat(randperm(2)-1, [1, ceil(nBlocks/2)]); % Logical vector
% indicating
% blocks with
% odors{1} on top
% (Side B)


%Odor matrix: [top/bottom concentration; top/bottom valves]
for qq = 1:nBlocks
    
    if OdorAonRight(qq)
        valve(1) = v{3}(strmatch(odors{1}, v{1}));
        valve(2) = v{2}(strmatch(odors{2}, v{1}));
        
        display([odors{1} ' will be released from right side (valve: ' num2str(valve(1)) ').'])
        display([odors{2} ' will be released from left side (valve: ' num2str(valve(2)) ').'])
    else
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
        display([odors{1} ' will be released from left side (valve: ' num2str(valve(1)) ').'])
        display([odors{2} ' will be released from right side (valve: ' num2str(valve(2)) ').'])
    end
    

    stim(qq).odor = [conc(1), conc(2); double(valve)];
    
    % Sort odor labels [Side A, Side B]
    if sum((v{2}==valve(1)))
        stim(qq).labels = [v{1}(v{2}==valve(1)) v{1}(v{3}==valve(2))];
    else
        stim(qq).labels = [v{1}(v{2}==valve(2)) v{1}(v{3}==valve(1))];
    end
end

% 
% 
% if OdorAonRight
%     if v{1}{find(v{3} == valve(1))} == odors{1}
%         conc(1) = conc(1);
%     else
%         conc(1) = conc(2);
%     end
%     if v{1}{find(v{2} == valve(2))} == odors{1}
%         conc(2) = conc(1);
%     else
%         conc(2) = conc(2);
%     end
% else
%     if v{1}{find(v{2} == valve(1))} == odors{1}
%         conc(1) = conc(1);
%     else
%         conc(1) = conc(2);
%     end
%     if v{1}{find(v{3} == valve(2))} == odors{1}
%         conc(2) = conc(1);
%     else
%         conc(2) = conc(2);
%     end
% end


%Build stimulus epochs
if nBlocks > 1
    lastTime = preTime - isi;                 % Runs on first block only
    
    for i=1:nBlocks
        startTime = lastTime + isi;
        stim(i).times = startTime:(startTime + chargeTime + odorDur);
        lastTime = max(stim(i).times) - chargeTime;
    end
    
else
    
    startTime = preTime;
    stim.times = startTime:(startTime + chargeTime + odorDur);
    lastTime = max(stim.times) - chargeTime;
end

duration = lastTime + postTime + chargeTime;

stimTimes = zeros(1,duration + 1);

for qqq=1:nBlocks
    stimTimes(stim(qqq).times) = qqq;
end