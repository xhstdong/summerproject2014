function test(testdir, n, code,traindir)
% Speaker Recognition: Testing Stage
%
% Input:
%       testdir : string name of directory contains all test sound files
%       n       : number of test files in testdir
%       code    : codebooks of all trained speakers
%
% Note:
%       Sound files in testdir is supposed to be: 
%               s1.wav, s2.wav, ..., sn.wav
%
% Example:
%       >> test('C:\data\test\', 8, code);

for k = 1:n                     % read test sound file of each speaker
    file = sprintf('%ss%d.wav', testdir, k);
    [s, fs] = wavread(file);      
    s=reshape(s,numel(s),1);    %make into column vector format
    v = mfcc(s, fs);            % Compute MFCC's
   
    distmin = inf;
    k1 = 0;
   
    for l = 1:length(code)      % each trained codebook, compute distortion
        d = disteu(v, code{l}); 
        dist = sum(min(d,[],2)) / size(d,1);
      
        if dist < distmin
            distmin = dist;
            k1 = l;
        end      
    end
   
    %audio & visual confirmation
    msg = sprintf('Speaker %d matches with speaker %d', k, k1);
    disp(msg);
    sound(s,fs);
    file = sprintf('%ss%d.wav', traindir, k1);
    [s, fs] = wavread(file);
    sound(s,fs);%assume same sampling
end
