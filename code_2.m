[audio, fs] = audioread('1.wav'); 
audio = audio(:, 1); 
fileID = fopen('1.txt', 'r');
data = textscan(fileID, '%s %*f %*f %*d');
fclose(fileID);

words = data{1}; % Words

% Normalize the audio
audio = audio / max(abs(audio)); 
num_words=length(words);

frame_size = round(0.02 * fs);
frame_shift = round(0.01 * fs); 
num_frames = floor((length(audio) - frame_size) / frame_shift) + 1;
loudness = zeros(num_words, 1);
energy = zeros(num_frames, 1);
for i = 1:num_frames
    start_idx = (i - 1) * frame_shift + 1;
    end_idx = start_idx + frame_size - 1;
    energy(i) = sum(audio(start_idx:end_idx).^2);
    if energy > threshold_energy
        loudness(i) = 1; % Loud
    else
        loudness(i) = 0; % Not loud
    end
end


threshold_energy = 0.01;
speech_frames = energy > threshold_energy;

speech_diff = diff([0; speech_frames; 0]);
start_indices = find(speech_diff == 1);
end_indices = find(speech_diff == -1) - 1;


start_times = (start_indices - 1) * frame_shift / fs;
end_times = (end_indices - 1) * frame_shift / fs;


num_segments = length(start_times);
num_words = length(words);

if num_segments < num_words
    error('Not enough segments detected for the given number of words.');
end


word_start_times = start_times(1:num_words);
word_end_times = end_times(1:num_words);

disp('Word | Start Time | End Time | loudness');
for i = 1:num_words
    fprintf('%s | %.2f | %.2f | %d\n', words{i}, word_start_times(i), word_end_times(i),loudness(i));
end
