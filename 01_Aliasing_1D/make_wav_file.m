% Program to create a warbling wave file with variable amplitude and pitch.
function make_wav_file()
% Initialization / clean-up code.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

% Create the filename where we will save the waveform.
folder = pwd;
baseFileName = 'Test_Wave.wav';
fullFileName = fullfile(folder, baseFileName);
fprintf('Full File Name = %s\n', fullFileName);

% Set up the time axis:
t = 1:8000;

% Set up the period (pitch, frequency):
T = 10;
% T = linspace(25, 8, length(t)); % Pitch changes.

% Create the maximum amplitude:
Amplitude = 32767 * ones(1,length(t));
% Add an exponential decay:
% Amplitude = Amplitude .* exp(-0.0003*t);

% Add an ocillation on the amplitude:
% Amplitude = Amplitude .* rand(1, length(t)); % Makes a shushing/roaring sound.
Amplitude = Amplitude .* sin(2.*pi.*t./2000); % Decaying pulsing sound.

% Construct the waveform:
y = int16(Amplitude .* sin(2.*pi.*t./T));
% y = abs(int16(Amplitude .* sin(2.*pi.*x./T)));

% Plot the waveform:
plot(t, y, 'b-');
title('Waveform', 'FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Y', 'FontSize', fontSize);
grid on;
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
fprintf('Writing file %s...\n', fullFileName);

% Write the waveform to a file:
audiowrite(fullFileName,y,8192);

% Play the sound as many times as the user wants.
playAgain = true;
counter = 1;
while playAgain
	% Play the sound that we just created.
	fprintf('Playing file %s   %d times...\n', fullFileName, counter);
	PlaySoundFile(folder, baseFileName);
	% Ask user if they want to play the sound again.
	promptMessage = sprintf('You have played the sound %d times.\nDo you want to play the sound again?', counter);
	titleBarCaption = 'Continue?';
	button = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'Yes');
	if strcmpi(button, 'No')
		playAgain = false;
		break;
	end
	counter = counter + 1;
end

% Alert user that we are done.
message = sprintf('Done playing %s.\n', fullFileName);
fprintf('%s\n', message);
promptMessage = sprintf('Done playing %s.\nClick OK to close the window\nor Cancel to leave it up.', fullFileName);
titleBarCaption = 'Continue?';
button = questdlg(promptMessage, titleBarCaption, 'OK', 'Cancel', 'OK');
if strcmpi(button, 'OK')
	close all;	% Close down the figure.
end

%================================================================================================
% Play a wav file.  You can pass in 'random' and it will pick one at random from the folder to play.
% PlaySoundFile(handles.soundFolder, 'chime.wav');
% PlaySoundFile(handles.soundFolder, 'random');
function PlaySoundFile(soundFolder, baseWavFileName)
	global waveFileData;
	global Fs;	% Wave file information.
	try				% Read the sound file into MATLAB, and play the audio.
% 		soundFolder = fullfile(soundFolder, 'Sound Files');
		if ~exist(soundFolder, 'dir')
				warningMessage = sprintf('Warning: sound folder not found:\n%s', soundFolder);
				WarnUser(warningMessage);
				return;
		end
		if strcmpi(baseWavFileName, 'random')
			itWorked = false;
			tryCount = 1;
			while itWorked == false
				% Pick a file at random.
				filePattern = fullfile(soundFolder, '*.wav');
				waveFiles = dir(filePattern);
				numberOfFiles = length(waveFiles);
				% Get a random number
				fileToPlay = randi(numberOfFiles, 1);
				baseWavFileName = waveFiles(fileToPlay).name;
				fullWavFileName = fullfile(soundFolder, baseWavFileName);
				waveFileData = -1;
				try
					if exist(fullWavFileName, 'file')
						[waveFileData, Fs] = audioread(fullWavFileName);
						sound(waveFileData, Fs);
						% 		soundsc(y,Fs,bits,range);
					else
						warningMessage = sprintf('Warning: sound file not found:\n%s', fullWavFileName);
						WarnUser(warningMessage);
					end
					% It worked.  It played because the audio format was OK.
					itWorked = true;
				catch
					% Increment the try count and try again to find a file that plays.
					tryCount = tryCount + 1;
					if tryCount >= numberOfFiles
						break;
					end
				end
			end % of while()
		else
	% 		baseWavFileName = 'Chime.wav';
			fullWavFileName = fullfile(soundFolder, baseWavFileName);
			waveFileData = -1;
			if exist(fullWavFileName, 'file')
				[waveFileData, Fs] = audioread(fullWavFileName);
				sound(waveFileData, Fs);
				% 		soundsc(y,Fs,bits,range);
			else
				warningMessage = sprintf('Warning: sound file not found:\n%s', fullWavFileName);
				WarnUser(warningMessage);
			end
		end
	catch ME
		if strfind(ME.message, '#85')
			% Unrecognized format.  Play chime instead.			
			fprintf('Error in PlaySoundFile(): %s.\nUnrecognized sound format in file:\n\n%s\n', ME.message, fullWavFileName);
	 		baseWavFileName = 'Chime.wav';
			fullWavFileName = fullfile(soundFolder, baseWavFileName);
			waveFileData = -1;
			if exist(fullWavFileName, 'file')
				[waveFileData, Fs] = audioread(fullWavFileName);
				sound(waveFileData, Fs);
				% 		soundsc(y,Fs,bits,range);
			end
		end
		errorMessage = sprintf('Error in PlaySoundFile().\nThe error reported by MATLAB is:\n\n%s', ME.message);
		fprintf('%s\n', errorMessage);
		WarnUser(errorMessage);
	end
	return; % from PlaySoundFile