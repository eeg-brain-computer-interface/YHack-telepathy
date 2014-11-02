function [features] = exctract(signal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

signal = signal';

features = [];
[r,c,m] = size(signal);
for i = 1:m
features = [features mean(signal(i))];
features = [features sum(signal.^2)/length(signal)];
features = [features std(signal)];
end
end

