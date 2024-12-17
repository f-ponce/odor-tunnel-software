%% If not starting from a clean slate, do the following or restart matlab
clear all
clear global

%% Set the Odors and concentration. These are looked up in odors.csv
%odors = {'Air' 'OCT'};
%conc = [0.03 0.02];%  -aMW ctrl   
%odors = {'OCT' 'Air'}; %SK, this is the line you want to swap to%
%conc = [0.02 0.03];%  -aMW ctrl
%odors = {'OCT' 'OCT'}; %SK, this is the line you want to swap to
%conc = [0.02 0.02];%  -aMW ctrl
%odors = {'MCH' 'OCT'};
%conc = [0.02 0.32];%  -aMW ctrl         
%odors = {'OCT' 'MCH'};
odors = {'Air' 'MCH'};
conc = [1.00 0.39];%  -aMW ctrl      


%% Initialize the system. If this fails try above or reboot matlab. Also consider resetting nidac via nimax a[[
initializeTunnels

%% IF necessary, use acquireBlankBackground with lights off and no flies in arena
% Once per day is usually fine, sometimes you can go weeks without changing
% if nothing gets bumped
acquireBlankBackground

%% Do tracking and odors Must be in MATLAB directory (type PWD, should BE MATLAB)
dbstop if error
%error using VideoWriter/writeVideo
%testing without recording video option
%394s long? 
flyTracks = flyTracker2022(odors, conc);

%% Export Occupancy as CSV (in current directory) and quick summary of data.
%This should run automatically at the end of 
%CalculateOdorOccupancy(flyTracks,'C:\Users\Debivortlab\Documents\MATLAB\TunnelData\tempData\')
%need to be run in the Analysis directory
%check how occupancy is calculated and if air period at the end is saved
CalculateOdorOccupancy(flyTracks,'C:\Users\Debivortlab\Documents\MATLAB\TunnelData\tempData\12-10-2024_15-42-40.mat')
%% Just run odors (Useful for troubleshooting, doesn't deal with camera or flies)
runOdorProtocol(odors,conc)

%% Test Maximal Odor (optional, for debugging only)
odors = {'OCT' 'MCH'}; %SK, this is the line you want to swap to
conc = [1 1];%  -aMW ctrl 
runOdorProtocol(odors, conc, [1 1])

%% Test Max (optional, for debugging only)
odors = {'OCT' 'MCH'}; %SK, this is the line you want to swap to
conc = [.6 .6];%  -aMW ctrl 
runOdorProtocol(odors, conc, [1.5 1.5])