function [stimTimes, stim, duration] = constructStimulus_m(A_,B_,swapp)
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

    chargeTime = 5;


% odors = {'Apple' 'Grape'};
% conc = [0.05 0.1];                  % proportion saturated vapor

odors = {A_ B_};
conc = [0.08 0.15];                  % proportion saturated vapor          % 150119 - balancing concs:
 %conc = [0.15 0.15];                                                                % 2U = [0.14 0.15]
                                                                           % MB010B/shi[ts1] = [0.18 0.08]
                                                                           % R46E11/shi[tsJFRC] = [0.15 0.10]
       
                                                                           % R14H04/shi[tsJFRC] = [<0.15 >0.13] or [0.17 0.10]
                                                                           % R14C11/TNT = [0.14 0.15]
% 
% odorDur = [3,3,30,10,10,10];                                                                           % VT046560/shi[tsJFRC] = [0.1 0.1]
%  isi = [3,3,3,10,10,10];
%  odorDur = [120,90,90,90,90,180];                        % in sec
%  isi = [0,90,60,90,60,90];                            % in sec
%  odorDur = [120,90,90,90,90,120];                        % in sec
% %isi = [0]; 
isi = [0,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30,30,15,30];                            % in sec
odorDur = [60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60,30,30,60];   
isi = [0,90,30,90,90,30,90,90,30,90,90,30,90,90,30,90,90,30,90,90,30,90,90,30,90];
odorDur = [60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60];
isi = [0,60,30,60,60,30,60,60,30,60,60,30,60,60,30,60,60,30,60];
odorDur = [60,15,15,60,15,15,60,15,15,60,15,15,60,15,15,60,15,15,60];
isi = [0,60,30,60,60,30,60,60,30,60,60,30,60,60,30,60,60,30,60];
odorDur = [30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30];
nBlocks = length(odorDur);                         % number of odor blocks

preTime = [60];                       % wait time before first odor block
postTime = 30;                      % wait time after last odor block

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
OdorAonTop = [repmat(false,1,nBlocks)];                                                        % KH141217 - hardcode this for consistency
if swapp
    od(1) = 2;
    od(2) = 1;
else
    od(1) = 1;
    od(2) = 2;
end
%Odor matrix: [top/bottom concentration; top/bottom valves]
for qq = 1:nBlocks
    
    if OdorAonTop(qq)
        valve(1) = v{3}(strmatch(odors{1}, v{1}));
        valve(2) = v{2}(strmatch(odors{2}, v{1}));
    elseif qq == 1
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 2
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 3
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 4
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 5
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 6
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 7
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 8
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 9
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 10
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 11
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 12
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 13
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 14
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 15
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 16
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 17
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 18
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 19
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 20
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 21
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 22
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 23
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 24
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 25
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 26
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 27
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 28
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    elseif qq == 29
        valve(1) = v{2}(strmatch(odors{od(2)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(2)}, v{1}));
    elseif qq == 30
        valve(1) = v{2}(strmatch(odors{od(1)}, v{1}));
        valve(2) = v{3}(strmatch(odors{od(1)}, v{1}));
    elseif qq == 31
        valve(1) = v{2}(strmatch(odors{1}, v{1}));
        valve(2) = v{3}(strmatch(odors{2}, v{1}));
    end
    if v{1}{find(v{2} == valve(1))} == 'MCH'   
        con(1) = 0.11;
        %con(1) = 0.09;
    else
        con(1) = 0.15;
        %con(1) = 0.2;
    end
    if v{1}{find(v{3} == valve(2))} == 'MCH'   
        con(2) = 0.11;
        %con(2) = 0.09;
    else
        con(2) = 0.15;
        %con(2) = 0.2;
    end
    if swapp
        sttt = con;
        con(1) = sttt(2);con(2) = sttt(1);
    end
%     if qq ~= 1 && qq ~= 6
%         con = con+0.03;
%     end
    
    
    stim(qq).odor = [con(1), con(2); double(valve)];
    
    % Sort odor labels [Side A, Side B]
    if sum((v{2}==valve(1)))
        stim(qq).labels = [v{1}(v{2}==valve(1)) v{1}(v{3}==valve(2))];
    else
        stim(qq).labels = [v{1}(v{2}==valve(2)) v{1}(v{3}==valve(1))];
    end
    
end

%Build stimulus epochs
if nBlocks > 1
    lastTime = preTime - isi(1);                 % Runs on first block only
    
    for i=1:nBlocks
        startTime = lastTime + isi(i);
        stim(i).times = startTime:(startTime + chargeTime + odorDur(i));
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