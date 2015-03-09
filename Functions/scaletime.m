function [CPUtimeConstant,interval]=scaletime(ind,scale,EndSecs)
% Scalling CPU time constant - How many CPU
% cycles are EndSecs seconds
% ind - where to begin procedure from
% tilt = EndSecs/scale - integrating coefficient 
% EndSecs - seconts to present
% EndSecs ( tic -> toc ) =
% CPUtimeConstant * Operation time ( cputime )
% [CPUtimeConstant,interval]=scaletime(ind,scale,EndSecs)
% Example: [CPUtimeConstant,interval]=scaletime(8,160,1.2)
% CPUtimeConstant = 0.1756
% interval = [6.8484  1.2025  3118]

num = floor(exp(ind));
reztime = 0;
if(scale > 0)
    tilt = EndSecs/scale;
elseif(scale < 0)
    tilt = EndSecs/(-scale);
else
    tilt = EndSecs/100;
end
while(reztime < EndSecs)
        a = rand(num,num);
        t = cputime;
        Start=tic;
        a*a;
        reztime=toc(Start);
        CPUtimeConstant = cputime - t;
        ind = ind + tilt;
        num = floor(exp(ind));
end
interval = [CPUtimeConstant reztime num];
CPUtimeConstant = reztime/CPUtimeConstant;