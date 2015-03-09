function Arrout = fftphase(Arrin,bitval,Fac,N)
% Gets the desired FFT fase usingonly one bit
% Call: Arrout = fftphase(Arrin,bitval,Fac,N)
% Where Arrin is the prev fase, bitval- controling bit
% power of 2, Fac- power of Wn phase factor, N = length(N);
        for k = 1:N 
            f = bitand(k-1,bitval-1)+1;
            if(bitand(bitval,k-1))
                l = k-bitval;
                Arrout(k)= Arrin(l)-Arrin(k)*Fac(f);
            else
                l = k+bitval;
                Arrout(k)= Arrin(k)+Arrin(l)*Fac(f);
            end
        end    
end