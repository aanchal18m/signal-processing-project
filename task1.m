[audio,fs]=audioread('1.wav'); 
audio=audio(:,1); 
%audio=audio/max(abs(audio));
fileID=fopen('1.txt');
data=textscan(fileID, '%s %f %f %*d'); %last column %*d
fclose(fileID);
words=data{1}; 
start_times=data{2}; 
end_times=data{3};

loudness=zeros(length(words),1);
rms_values=zeros(length(words),1);
threshold_rms=0.1233;

for i=1:length(words)
    start_idx=max(1,round(start_times(i)*fs));
    end_idx=min(length(audio),round(end_times(i)*fs)); 
    segment=audio(start_idx:end_idx);
    rms_value=sqrt(mean(segment.^2));
    rms_values(i)=rms_value;
    if rms_value>threshold_rms
        loudness(i)=1; % for loud
    else
        loudness(i)=0; % not loud
    end
end

disp('word | rms values | loudness');
for i=1:length(words)
    fprintf('%s | %.4f | %d\n',words{i},rms_values(i),loudness(i));
end