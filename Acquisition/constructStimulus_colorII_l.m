function [stimTimes, stim, duration] = constructStimulus_color(A_,B_,classical,swapp,stm)
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
plusO = true;

% odors = {'Apple' 'Grape'};
% conc = [0.05 0.1];                  % proportion saturated vapor
odors = {A_ B_};
od = {A_ B_};
odors = {'Air' 'Air'};
conc = [0.18 0.18];                  % proportion saturated vapor          % 150119 - balancing concs:
%conc = [0.15 0.15];                                                                % 2U = [0.14 0.15]
% MB010B/shi[ts1] = [0.18 0.08]
% R46E11/shi[tsJFRC] = [0.15 0.10]

% R14H04/shi[tsJFRC] = [<0.15 >0.13] or [0.17 0.10]
% R14C11/TNT = [0.14 0.15]
%
% odorDur = [3,3,30,10,10,10];                                                                           % VT046560/shi[tsJFRC] = [0.1 0.1]
% isi = [3,3,3,10,10,10];
odorDur = [60,repmat(15,1,40),60];
%odorDur = [60,15,15,15,15,15,15,15,15,15,15,15,30,15,30,15,30,15,30,15,30,60];

% in sec

isi = [0,repmat(2,1,20),30];                            % in sec
isi = [0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,15,0,60];
isi = [0,repmat(15,1,40),60];
%odorDur = [180];
%isi = [0];
nBlocks = length(odorDur);                         % number of odor blocks

preTime = [30];                       % wait time before first odor block
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
color{2} = 'OCT';
color{3} = 'Air';

%Odor matrix: [top/bottom concentration; top/bottom valves]
for qq = 1:nBlocks
    
    if OdorAonTop(qq)
        valve(1) = v{3}(strmatch(odors{1}, v{1}));
        valve(2) = v{2}(strmatch(odors{2}, v{1}));
    elseif qq == 1
        valve(1) = v{2}(strmatch('Air', v{1}));
        valve(2) = v{3}(strmatch('Air', v{1}));
    elseif qq == 2
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 3
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 4
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 5
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 6
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 7
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 8
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 9
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 10
        valve(1) = v{2}(strmatch('Air', v{1}));
        valve(2) = v{3}(strmatch('Air', v{1}));
        %         valve(1) = v{2}(strmatch(color{3}, v{1}));
        %         valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 11
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 12
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 13
        valve(1) = v{2}(strmatch(color{2}, v{1}));
        valve(2) = v{3}(strmatch(color{3}, v{1}));
    elseif qq == 14
        valve(1) = v{2}(strmatch('Air', v{1}));
        valve(2) = v{3}(strmatch('Air', v{1}));
    elseif qq == 15
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 16
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 17
        valve(1) = v{2}(strmatch(color{3}, v{1}));
        valve(2) = v{3}(strmatch(color{2}, v{1}));
    elseif qq == 18
        valve(1) = v{2}(strmatch('Air', v{1}));
        valve(2) = v{3}(strmatch('Air', v{1}));
    end
    
    if classical
        if qq == 1
            valve(1) = v{2}(strmatch('Air', v{1}));
            valve(2) = v{3}(strmatch('Air', v{1}));
        elseif qq == 2
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 3
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 4
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 5
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 6
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 7
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 8
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 9
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 10
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 11
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 12
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 13
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 14
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 15
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 16
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 17
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 18
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 19
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 20
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 21
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 22
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 23
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 24
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 25
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 26
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 27
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 28
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 29
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 30
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 31
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 32
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 33
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 34
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 35
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 36
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 37
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 38
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 39
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 40
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 41
            valve(1) = v{2}(strmatch(color{3}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        elseif qq == 42
            valve(1) = v{2}(strmatch('Air', v{1}));
            valve(2) = v{3}(strmatch('Air', v{1}));
        end
        if sum(qq == (stm*2)+1) > 0 && plusO
            valve(1) = v{2}(strmatch(color{2}, v{1}));
            valve(2) = v{3}(strmatch(color{3}, v{1}));
        end
    end
    %     if qq ~= 1 && qq ~= 6
    %         con = con+0.03;
    %     end
    
    stim(qq).odor = [conc(1), conc(2); double(valve)];
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