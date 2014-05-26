function [acoustic_vec ] = mfcc( sound_vec,Fs )
%Calculate MFCC of an audio file
%   Detailed explanation goes here

%[sound_vec,Fs]=wavread(file_path); %this is provided by the train function
sound_size=length(sound_vec);

%Framing-typical industry values
frame_size=256;
frame_sep=100;
max_iter=floor((sound_size-frame_size)/frame_sep);
Frame=[];
%Frame=zeros(frame_size,max_iter+1); optimize later
for i=0:max_iter
   Frame=[Frame,sound_vec((i*frame_sep+1): (i*frame_sep+frame_size))];
end

%windowing
window=hamming(frame_size);
for i=1:(max_iter+1)
    Frame(:,i)=window.*Frame(:,i);
end

%frequency domain
freq_dom=abs(fft(Frame));
%plot(freq_dom);
%imagesc(freq_dom);

%mel-frequency wrap, to get better sampling
% these coefficients improve the frequency domain results
p=20;
mf_wraps=melfb(p,frame_size,Fs);

%plot(linspace(0, (Fs/2), max_iter+1), mf_wraps),
 %              title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');
%Nyquist sampling conditions
max_sampling=floor(frame_size/2)+1;
for i=1:(max_iter+1)
    final_freq(:,i)=mf_wraps * freq_dom(1:max_sampling,i).^2 ;
end
%figure
%plot(final_freq)

%convert back to time domain
acoustic_vec=dct(final_freq);
%figure
%plot(acoustic_vec)
end

