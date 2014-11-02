 % Clear the workspace
close all;
clear all;
sca; 



% Setup PTB with some default values
PsychDefaultSetup(2);

% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));

% Set the screen number to the external secondary monitor if there is one
% connected
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2);

% Flip to clear
Screen('Flip', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);  
%ifi = 0.0167;
% Set the text size
Screen('TextSize', window, 60);

% Query the maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


%----------------------------------------------------------------------
%                       Timing Information
%----------------------------------------------------------------------

% Interstimulus interval time in seconds and frames
isiTimeSecs = 20;
isiTimeFrames = round(isiTimeSecs / ifi);

isiTimeFrames2 = round(100 / ifi);
% Numer of frames to wait before re-drawing
waitframes = 1;


%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
downKey = KbName('DownArrow');
spaceKey = KbName('SPACE');

%----------------------------------------------------------------------
%                     Colors in words and RGB
%----------------------------------------------------------------------

% We are going to use three colors for this demo. Red, Green and blue.
wordList = {'Red', 'Green', 'Blue'};
rgbColors = [1 0 0; 0 1 0; 0 0 1];

% Make the matrix which will determine our condition combinations
condMatrixBase = [sort(repmat([1 2 3], 1, 3)); repmat([1 2 3], 1, 3)];

% Number of trials per condition. We set this to one for this demo, to give
% us a total of 9 trials.
trialsPerCondition = 10   ;

% Duplicate the condition matrix to get the full number of trials
condMatrix = repmat(condMatrixBase, 1, trialsPerCondition);

% Get the size of the matrix
[~, numTrials] = size(condMatrix);

% Randomise the conditions
shuffler = Shuffle(1:numTrials);
condMatrixShuffled = condMatrix(:, shuffler);


%----------------------------------------------------------------------
%                     Make a response matrix
%----------------------------------------------------------------------

% This is a four row matrix the first row will record the word we present,
% the second row the color the word it written in, the third row the key
% they respond with and the final row the time they took to make there response.
respMat = nan(4, numTrials);
%respMat = [0,0,0,0,0,0,0,0,0; 0,0,0,0,0,0,0,0,0; 0,0,0,0,0,0,0,0,0; 0,0,0,0,0,0,0,0,0;];
dataEntries = [0 0 0 0 0 0 0 0 0];

eeg = [];
systemCommand = ['/usr/bin/python test.py'];
%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------

% Animation loop: we loop for the total number of trials
for trial = 1:numTrials

    %start collecting muse data?
    
    
    % Word and color number
    wordNum = condMatrixShuffled(1, trial);
    colorNum = wordNum;

    % The color word and the color it is drawn in
    theWord = wordList(wordNum);
    theColor = rgbColors(colorNum, :);

    % Cue to determine whether a response has been made
    respToBeMade = false;

    % If this is the first trial we present a start screen and wait for a
    % key-press
    if trial == 1
        DrawFormattedText(window, 'Press SPACE when you see Red \n\n   Press Any Key To Begin',...
            'center', 'center', black);
        Screen('Flip', window);
        KbStrokeWait;
    end

    % Flip again to sync us to the vertical retrace at the same time as
    % drawing our fixation point 
% %    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
    DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
    vbl = Screen('Flip', window);
    
    [status, result] = system(systemCommand);
    
    status
    result         

    brainWaves = load('test.mat');  
    brainwave(trial).data = brainWaves;

    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
%     response = 0;
%     for frame = 1:isiTimeFrames - 1
% 
%         % Draw the fixation point
% %        Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
% %       DrawFormattedText(window, char(theWord), 'center', 'center', theColor);
%         
%         % Flip to the screen
% %          vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%         
%         [keyIsDown,secs, keyCode] = KbCheck;
%         
%         if keyCode(spaceKey)
%             response = 1;
%         end
%     end

%     respMat(1, trial) = wordNum;
%     respMat(2, trial) = colorNum;
%     respMat(3, trial) = brainWaves;
%     respMat(4, trial) = GetSecs;
    
    respMat = brainWaves.IXDATA.raw.eeg.data;
    if (wordNum==1) 
        respMat = [ones(size(respMat,1),1) respMat ];
    else 
        respMat = [zeros(size(respMat,1),1) respMat ];
    end
    
    eeg = [eeg; respMat;];
    eeg = [eeg; 2,2,2,2,2;];
    
    %eeg(trial).data = respMat;
    
        % Flip again to sync us to the vertical retrace at the same time as
    % drawing our fixation point 
     Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
     vbl = Screen('Flip', window);

    % Now we present the isi interval with fixation point minus one frame
    % because we presented the fixation point once already when getting a
    % time stamp
%     for frame2 = 1:isiTimeFrames - 1
% 
%         % Draw the fixation point
%         Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);
%         
%         % Flip to the screen
%           vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%     end
    
    pause(.5);

end

save('data.mat', 'eeg');
save('raweeg.mat','brainwave');
% End of experiment screen. We clear the screen once they have made their
% response
DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbStrokeWait;
sca; 