function [] = drawSurfDFT(fhDFT, fnWind, plyAud, smpSig, fhDraw, namDFT, maxSig, lenDFT, falDFT)
  % Draws a fourier DFT surface relative to the current sample of an audio player
  % with draw method provided and matrix size, limiting the max value
  %
  % Example: void drawSurfDFT(fhDFT, fnWind, plyAud, smpSig, fhDraw, namDFT, maxSig, lenDFT, falDFT)
  %
  % fhDraw - The drawing method of the surface ( matrix ), provided as a function handle
  % fnWind - The window to be used, provided as a function handle
  % fhDFT  - The DFT calcolator to be used, provided as a function handle
  % smpSig - The sample signal plotted, or gathered from a file as matrix-column
  % plyAud - The object of type audioplayer, keping in track of the DFT state
  % lenDFT - The number of points the DFT is calcolated for, the higher, the accurate
  % falDFT - How many DFT are displayed in the matrix back in time ( fall behind )
  % maxSig - The maximum saturation value for the signal
  % namDFT - The name of the subplots of DFT
  if(lenDFT <= 0) return; end  
  half = floor(lenDFT/2);
  wind = fnWind(lenDFT);
  ftl  = zeros(half,falDFT);
  ftr  = zeros(half,falDFT);
  df   = strcat(num2str(floor(plyAud.SampleRate/lenDFT)),'n','[Hz]');
  fig  = getNextFigure();
  brdv = [-130 20];
  brdm = [0 maxSig];
  brdf = [1 falDFT];
  brdh = [0 half];
  figure(fig);
  while((plyAud.CurrentSample < plyAud.TotalSamples) && (plyAud.CurrentSample ~= 1))
    if(~ishandle(fig))
      break;
    elseif(plyAud.CurrentSample > lenDFT) figure(fig);
      left = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,1);
      righ = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,2);
      left = left(1:lenDFT);
      righ = righ(1:lenDFT);
      fl = abs(fhDFT(left.*wind));
      fr = abs(fhDFT(righ.*wind));
      ftl = shiftArr(ftl,1);
      ftr = shiftArr(ftr,1);
      ftl(:,1) = satMatrix(fl(1:half),brdm); %swaparr(fl(1:half),2);
      ftr(:,1) = satMatrix(fr(1:half),brdm); %swaparr(fr(1:half),2);
      subplot(2,2,1), plot(left), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
      xlim([1 lenDFT]), ylim([-1 1]), grid
      subplot(2,2,2), plot(righ), title('Sampled Signal'),xlabel('Sample'), ylabel('Value'),
      xlim([1 lenDFT]), ylim([-1 1]), grid
      subplot(2,2,3), fhDraw(ftl), title(namDFT), xlabel('SampleTime'),...
      ylabel(df), zlabel('|X(n)|'), ylim(brdh), xlim(brdf), zlim(brdm), view(brdv), grid
      subplot(2,2,4), fhDraw(ftr), title(namDFT), xlabel('SampleTime'),...
      ylabel(df), zlabel('|X(n)|'), ylim(brdh), xlim(brdf), zlim(brdm), view(brdv), grid, drawnow
    end
  end
  endNextFigure(fig);
end
