function [song, pulseTimesAutomatic] = getSongAndSegment()
    addpath(genpath('src'))
    addpath('/Users/akivalipshitz/Dropbox/Akiva/songSegmenter/')

    %% load data
    % CantonS recording from Stern (2014)
    load('dat/PS_20130625111709_ch3.mat')
    % hand-annotated pulse times for that recording from Kyriacou et al. (2017)
    load('dat/PS_20130625111709_ch3manual.mat', 'pulseTimes')

    % cut recording to the part that is hand-annotated and shorten to speed up
    % processing for this demo
    minPulseTime = 180;%s
    maxPulseTime = 270;%max(pulseTimes);
    pulseTimes(pulseTimes<minPulseTime | pulseTimes>maxPulseTime)=[];
    pulseTimesManual = pulseTimes-minPulseTime;

    Fs = Data.fs; %Hz
    recording = Data.d(minPulseTime*Fs:maxPulseTime*Fs,:);
    channels = size(recording, 2); % recording is time x channels

    %% process recording - detect sine and pulse
    chn = 1;
    [sInf(chn).nLevel, sInf(chn).winSine, sInf(chn).pulseInfo, sInf(chn).pulseInfo2, sInf(chn).pcndInfo] = ...
       segmentSong(recording(:,chn), 'params.m')


    %% post process
    % automatically identify recording of duration `bufferLen` samples that does not
    % contain song for estimating the noise floor in the recording
    bufferLen =  2e3;
    noiseSample = findNoise(recording, bufferLen);

    % clean up pulses, identify bouts etc.
    oneSong = recording; % same for single-channel data
    [sInf, pInf, wInf, bInf, Song] = postProcessSegmentation(sInf, recording, oneSong, noiseSample);
    pulseTimesAutomatic = pInf.wc/Fs;%s
    song = oneSong;
end 