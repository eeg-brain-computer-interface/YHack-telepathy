function [percent_correct,g,error] = everything(name)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
fr = 100;
stim = load([name '.mat']);
stim = stim.eeg(:,1);
filtered_data = dataimport_forruth('data');

span = .5;
reaction_time = .2; 
wind_down = .2;


y = parse_clips(stim);
features = [];
[a,v,c] = size(filtered_data);
for i = 1:c
    features = [features; exctract(filtered_data(:,:,i))];
end


X = features;
X = double(X);
y(end)=[];
[g,error] = log_reg(X,y')

end