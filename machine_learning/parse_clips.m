function [ y ] = parse_clips( stimulus)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes h
stimulae = find(stimulus==2);
length(stimulae)
y = [];
for i = 1:length(stimulae);
    y(i) = stimulus(stimulae(i)-1);
end

end
