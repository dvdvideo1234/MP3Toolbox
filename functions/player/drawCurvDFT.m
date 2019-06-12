function [] = drawCurvDFT(fnDFT, fnWind, plyAud, smpSig, fhDraw, namDFT, maxSig, lenDFT)
  % Draws a fourier DFT curve relative to the current sample of an audio player
  % with draw method provided and matrix size, limiting the max value
  %
  % Example: void drawCurvDFT(fnDFT, plyAud, smpSig, fhDraw, namDFT, maxSig, lenDFT)
  %
  % fhDraw - The drawing method of the curve ( matrix ), provided as a function handle
  % fnWind - The window to be used, provided as a function handle
  % fhDFT  - The DFT calcolator to be used, provided as a function handle
  % smpSig - The sample signal plotted, or gathered from a file as matrix-column
  % plyAud - The object of type audioplayer, keping in track of the DFT state
  % lenDFT - The number of points the DFT is calcolated for, the higher, the accurate
  % maxSig - The maximum saturation value for the signal
  % namDFT - The name of the subplots of DFT
  if(lenDFT <= 0) return; end
  half = floor(lenDFT/2);
  wind = fnWind(lenDFT);
  df   = plyAud.SampleRate/lenDFT;
  freq = (1:1:lenDFT) * df;
  freq = freq(1:half);
  fig  = getNextFigure();
  brdm = [0 maxSig];
  brdf = [0 plyAud.SampleRate/2];
  brds = [-1 1];
  figure(fig);
  while((plyAud.CurrentSample < plyAud.TotalSamples) && (plyAud.CurrentSample ~= 1))
    if(~ishandle(fig))
      break;
    elseif(plyAud.CurrentSample > lenDFT) figure(fig);
      left = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,1);
      righ = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,2);
      ft(:,1)=fnDFT(left(1:lenDFT).*wind);
      ft(:,2)=fnDFT(righ(1:lenDFT).*wind);
      ftt = satMatrix(abs(ft(1:half,:)),brdm); %ftt = ftt(1:b,:);                    
      subplot(2,2,1), plot(left), title('Sampled Signal'), xlabel('Sample'),
      ylabel('Value'), xlim([0 lenDFT]), ylim(brds), grid
      subplot(2,2,2), plot(righ), title('Sampled Signal'), xlabel('Sample'),
      ylabel('Value'), xlim([0 lenDFT]), ylim(brds), grid
      subplot(2,2,3), fhDraw(freq,ftt(:,1)), title(namDFT),xlim(brdf),ylim(brdm),
      xlabel('Frequency'), ylabel('|X(n)|'), grid
      subplot(2,2,4), fhDraw(freq,ftt(:,2)), title(namDFT),xlim(brdf),ylim(brdm),
      xlabel('Frequency'), ylabel('|X(n)|'), grid, drawnow
    end
  end
  endNextFigure(fig);
end
