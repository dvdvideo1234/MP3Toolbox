function [sig, sf, bits]=wavread(wavefile, siz)

% WAVREAD  Load Microsoft Windows .WAV format sound files.
%
%  [sig, sf, bits] = wavread(wavfile [, siz])
%  
%        sig : signal
%         sf : sampling freq.
%       bits : the number of bits per sample
%    wavfile : file name
%              (The ".wav" extension is appended if no extension is given.)
%        siz : 'size' returns the size of the audio data
%            : [N1 N2] returns only samples N1 through N2

  if nargin < 1
    help wavread;
    return;
  end

  if isempty(findstr(wavefile,'.'))
    wavefile=[wavefile,'.wav'];
  end

  fid=fopen(wavefile,'r','ieee-le');
  if fid == -1
    error('Can''t open .WAV file for input!');
  end;

  % read riff chunk
  header=fread(fid,4,'uchar');
  header=fread(fid,1,'ulong');
  header=fread(fid,4,'uchar');

  % read format sub-chunk
  header=fread(fid,4,'uchar');
  header=fread(fid,1,'ulong');

  format(1)=fread(fid,1,'ushort');                % Format
  format(2)=fread(fid,1,'ushort');                % Channel
  format(3)=fread(fid,1,'ulong');                 % Samples per second
  header=fread(fid,1,'ulong');
  block=fread(fid,1,'ushort');
  format(4)=fread(fid,1,'ushort');                % Bits per sample

  % read data sub-chunck
  header=fread(fid,4,'uchar');
  nbyteforsamples=fread(fid,1,'ulong');

  nsamples=nbyteforsamples/block;
  if(nargin < 2)
    siz = [1 nsamples];
  end

  sf = format(3);
  bits = format(4);
  if(strcmp(siz, 'size'))
    sig = [nsamples, format(2)];
    fclose(fid);
    return;
  end

  st = siz(1);
  et = siz(2);

  if (format(4)+format(2) == 9)
    fseek(fid, (st-1), 0);
    [sig, cnt] = fread(fid, [1, et-st+1],'uchar');
    sig = (sig-128)/128;
  end
  if (format(4)+format(2) == 10)
    fseek(fid, (st-1)*2, 0);
    [sig, cnt] = fread(fid, [2,et-st+1], 'uchar');
    sig = (sig-128)/128;
  end

  if (format(4)+format(2) == 17)
    fseek(fid, (st-1)*2, 0);
    [sig, cnt] = fread(fid, [1, et-st+1], 'short');
    sig = sig/32768;
  end

  if (format(4)+format(2) == 18)
    fseek(fid, (st-1)*4, 0);
    [sig, cnt] = fread(fid,[2,et-st+1],'short');
    sig = sig/32768;
  end
  fclose(fid);

  sig = sig'; 
end
