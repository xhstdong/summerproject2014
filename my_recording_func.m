function audio_vec = my_recording_func( duration )
%my own function to record sounds
%   Input: duration (in seconds)

recObj=audiorecorder
disp('Recording start')
recordblocking(recObj,duration);
disp('Recording ends')
audio_vec=getaudiodata(recObj);
%sound(audio_vec)
end

