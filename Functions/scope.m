function scope()
    fs = 44100;
    nbits = 16;
    chans = 2;
    dev = audiodevinfo;
    devnum=length(dev.input);
    DevID = zeros(devnum,1);   
    for i =1:devnum
        disp(strcat('Dev >',dev.input(i).Name,'< Ver>',num2str...
        (dev.input(i).DriverVersion),'< ID >',num2str(dev.input(i).ID)));
        DevID(i,1) = dev.input(i).ID;
    end
    while(1)
        tempch=input('Device ID? >>','s');
        tempch = fix(str2double(tempch));
        DevID = (tempch == DevID)'*DevID;
        if(length(DevID) == 1), break; end
        if(strcmp(tempch,'q')), return; end
    end
        rec = audiorecorder(fs,nbits,chans,DevID);
        rec.Tag = 'Sampled signal';
        keep('rec')
if(isempty(get(0,'CurrentFigure')))
    fig = 1;
else
    fig = max(get(0,'Children')) + 1;
end
while(1)
        figure(fig)
        if(~ishandle(fig))
           break;
        else
           record(rec);
           delay(2000)
           stop(rec);
           y = getaudiodata(rec);
           ylen = length(y);
           df = rec.SampleRate/ylen;
           f = abs(fft(y.*[blackman(ylen), blackman(ylen)]));
           f = matsat(f(1:floor(ylen/2),:),[0,30]);
           xy = (0:df/ylen:df-df/ylen)';
           xf = (0:df:rec.SampleRate/2-df)';
           subplot(2,1,1), plot(xy,y(:,1),xy,y(:,2)), ylim([-1 1]), xlim([0,df-df/ylen])
           xlabel('Time in 100 th of second'), ylabel('Value'), grid
           subplot(2,1,2), plot(xf,f(:,1),xf,f(:,2)), ylim([0 30]), xlim([0,rec.SampleRate/2])
           xlabel('Frequency [Hz]'), ylabel('|X(n)|'), grid
        end
end
    if(sum(fig*ones(size(get(0,'Children'))) == get(0,'Children'))), close(fig), end
    return
end