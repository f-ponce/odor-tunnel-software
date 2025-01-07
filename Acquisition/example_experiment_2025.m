%% Example experiment script 
% Based on Ryan Maloney's minimalexperimentscript.m
%% initializeTunnels connects to the nidaq device, alicat devices, and camera
% A window should pop out and show a view of the 15 tunnels. Make sure all
% tunnels are in view, and that there are no flies or anything blocking the
% view. The room lights should be off to minimize glare.
% Turn on compressed air, and vacuum
initializeTunnels()
%% acquireBlankBackground captures a frame of the empty arena 
% this is needed to find and track the flies, room lights need to be off,
% and arena empty.
% Note from Ryan M: Once per day is usually fine, sometimes you can go weeks without changing
% if nothing gets bumped
% Output: The image should be saved at:
%'C:\Users\Debivortlab\Documents\MATLAB\TunnelData\blankBg.mat'
% acquireBlankBackground()
%% Load flies onto tunnels
%% Run experiment
% notes from Ryan:' Set the Odors and concentration. These are looked up in
% odors.csv'
% The odors.csv file is located in in the 'Acquisition' folder, I think
% this file indicates in what position each odor is located, but this might
% require troubleshooting to figure out what is the id of each solenoid
% valve
% To run flyTracker2022, make sure all the tunnels have a fly, or it will
% not run. 

% parameters:
% other paramaters Ryan used are at the bottom of this file as examples.
odors = {'Air' 'MCH'};
conc = [1.00 0.39];  
 
flyTracks = flyTracker2022(odors, conc);

% output:
% 1. A movie
% 2. 
%% example parameters
%odors = {'Air' 'OCT'};
%conc = [0.03 0.02];%  -aMW ctrl   
%odors = {'OCT' 'Air'}; %SK, this is the line you want to swap to%
%conc = [0.02 0.03];%  -aMW ctrl
%odors = {'OCT' 'OCT'}; %SK, this is the line you want to swap to
%conc = [0.02 0.02];%  -aMW ctrl
%odors = {'MCH' 'OCT'};
%conc = [0.02 0.32];%  -aMW ctrl         
%odors = {'OCT' 'MCH'};