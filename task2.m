[audio, fs]=audioread('1.wav');
audio=audio(:,1); 
%audio=audio/max(abs(audio));
fileID=fopen('1.txt');
data=textscan(fileID, '%s %*f %*f %*d');
fclose(fileID);
words=data{1};

num_words=length(words);
audio_length=length(audio);
segment_size=floor(audio_length / num_words); 

threshold_rms = 0.1196;

loudness = zeros(num_words, 1);
rms_values = zeros(length(words), 1);


for i = 1:num_words
    start_idx = (i - 1) * segment_size + 1;
    end_idx = min(i * segment_size, audio_length);
    segment = audio(start_idx:end_idx);

    rms_value = sqrt(mean(segment.^2));
    rms_values(i) = rms_value;

    if rms_value > threshold_rms
        loudness(i) = 1; % Loud
    else
        loudness(i) = 0; % Not loud
    end
end

disp('Word | rms values | Loudness');
for i = 1:length(words)
    fprintf('%s | %.4f | %d\n', words{i}, rms_values(i), loudness(i));
end
