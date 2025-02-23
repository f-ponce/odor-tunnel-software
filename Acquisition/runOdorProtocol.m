function runOdorProtocol(odors, conc, totalFlow)
% Use this function to test odor delivery in the absence of fly tracking
% Calls constructStimulus to assemble odor protocol, so odor delivery
% should be the same as during a tracking experiment.

if nargin < 3
%     totalFlow = [1.5 1.537]; %total flow rate through MFCs (L/min)
    totalFlow = [1.5 1.5]; %total flow rate through MFCs (L/min) %Tweak this to calibrate right vs left total
%     totalFlow = [1 1]; %total flow rate through MFCs (L/min) %Tweak this to calibrate right vs left total


end

disp("Running the following odors in a test")
disp(odors)
disp(conc)

chargeTime = 5;                                 % Amount of time (sec)
                                                % given for odor to charge
                                                % before flipping final
                                                % valve
                                                
odorPeriod = presentAir([0.2 0.2]);   % Start flushing tunnels with air

[stimTimes stim duration] = constructStimulus(chargeTime, odors, conc);
disp(duration)
% disp(stimTimes)
disp(stim)

finalValveState = 0; % Set initial Final Valve state


tic

while toc < duration
    
    if stimTimes(ceil(toc))                  % If this is an odor period...
        
        block = stimTimes(ceil(toc));
        
        if ~odorPeriod          % only runs when entering from air period
            odorTime = clock;   % Each time odor period starts, make
            % timestamp, wait for chargeTime, then
            % flip final valve
            
            valves = stim(block).odor(2,:);
            disp('present odor')
            disp(toc)

            conc = stim(block).odor(1,:);
            disp(valves);
            disp(conc);
            odorPeriod = presentOdor(valves, conc, totalFlow);
        end
        
        if ~finalValveState && etime(clock, odorTime) >= chargeTime
            finalValveState = flipFinalValve;
        end
        
    else                                            % otherwise present air
        epoch = 'Air';  % Used below to label display
        
        if odorPeriod
            conc = [0.2 0.2];
            odorPeriod = presentAir(conc); % Closes FinalValves too
            finalValveState = 0; % Reset Final Valve state
        end
        
    end
end

disp("Done with runOdorProtocol")