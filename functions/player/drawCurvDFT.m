function [] = drawCurvDFT(fnDFT, fnWind, plyAud, smpSig, cnDraw)
  % Draws a fourier DFT curve relative to the current sample of an audio player
  % with draw method provided and matrix size, limiting the max value
  %
  % Example: void drawCurvDFT(fnDFT, fnWind, plyAud, smpSig, cnDraw)
  %
  % fnWind - The window to be used, provided as a function handle
  % fhDFT  - The DFT calcolator to be used, provided as a function handle
  % smpSig - The sample signal plotted, or gathered from a file as matrix-column
  % plyAud - The object of type audioplayer, keping in track of the DFT state
  % fhDraw = cnDraw{1}; - The drawing method of the curve ( matrix ), provided as a function handle
  % namDFT = cnDraw{2}; - The name of the subplots of DFT
  % maxSig = cnDraw{3}; - The maximum saturation value for the signal
  % lenDFT = cnDraw{4}; - The number of points the DFT is calcolated for, the higher, the accurate
  fhDraw = cnDraw{1};
  namDFT = cnDraw{2};
  maxSig = cnDraw{3};
  lenDFT = cnDraw{4};
  if(lenDFT <= 0) return; end
  func = func2str(fhDraw);
  half = floor(lenDFT/2);
  wind = fnWind(lenDFT);
  df   = plyAud.SampleRate/lenDFT;
  freq = (1:1:lenDFT) * df;
  freq = freq(1:half)';
  brdm = [0 maxSig];
  brdf = [0 plyAud.SampleRate/2];
  brds = [-1 1];
  fig  = figure(getNextFigure()); set(fig, 'name', 'Curve graph');
  while((plyAud.CurrentSample < plyAud.TotalSamples) && (plyAud.CurrentSample ~= 1))
    if(~ishandle(fig))
      break;
    elseif(plyAud.CurrentSample > lenDFT) figure(fig);
      left = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,1);
      righ = smpSig(plyAud.CurrentSample-lenDFT:plyAud.CurrentSample,2);
      ft(:,1)=fnDFT(left(1:lenDFT).*wind);
      ft(:,2)=fnDFT(righ(1:lenDFT).*wind);
      dft = satMatrix(abs(ft(1:half,:)),brdm); %dft = ftt(1:b,:);
      subplot(2,2,1), plot(left), title('Sampled Signal'), xlabel('Sample'),
      ylabel('Value'), xlim([0 lenDFT]), ylim(brds), grid
      subplot(2,2,2), plot(righ), title('Sampled Signal'), xlabel('Sample'),
      ylabel('Value'), xlim([0 lenDFT]), ylim(brds), grid
      try
        subplot(2,2,3), title(namDFT)
        if all(func(1:3) == 'pie')
          fhDraw(dft(:,1))
          xlabel('Frequency'), ylabel('|X(n)|')
        elseif all(func(1:4) == 'hist')
          brdf(1, 2) = half;
          fhDraw(dft(:,1)), xlim(brdm), ylim(brdf)
          xlabel('|X(n)|'), ylabel('Frequency')
        else
          fhDraw(freq,dft(:,1))
          xlim(brdf), ylim(brdm)
          xlabel('Frequency'), ylabel('|X(n)|')
        end
        grid
      catch ex
        warning(strcat(ex.identifier, ': Function error at [L][',num2str(plyAud.CurrentSample), ']:',ex.message))
        warning('Parameters are exported to the base workspace!');
        assignin('base','ex_F',freq)
        assignin('base','ex_L',dft(:,1))
        break;
      end
      try
        subplot(2,2,4), title(namDFT)
        if all(func(1:3) == 'pie')
          fhDraw(dft(:,2))
          xlabel('Frequency'), ylabel('|X(n)|')
        elseif all(func(1:4) == 'hist')
          brdf(1, 2) = half;
          fhDraw(dft(:,2)), xlim(brdm), ylim(brdf)
          xlabel('|X(n)|'), ylabel('Frequency')
        else
          fhDraw(freq,dft(:,2))
          xlim(brdf), ylim(brdm)
          xlabel('Frequency'), ylabel('|X(n)|')
        end
        grid
      catch ex
        warning(strcat(ex.identifier, ': Function error at [R][',num2str(plyAud.CurrentSample), ']:',ex.message))
        warning('Parameters are exported to the base workspace!');
        assignin('base','ex_F',freq)
        assignin('base','ex_R',dft(:,2))
        break;
      end
      drawnow
    end
  end
  endNextFigure(fig);
end
