function [out,s] = myfft2(in) 
        % Returns same dimansion as it gets
        % The function calcolates DFT 
        % using well known Cooley-Tukey 
        % algorithm on N-doted signal
        % Call it like [out,s] = myfft2(in)
        % where in is the signal array, s is the
        % function grouping state
        % and out is the DFT result 
        %         Example:
        %         [y,s] = myfft2([1 2 3 4]')
        % 
        % y =
        % 
        %   10.0000          
        %   -2.0000 - 2.0000i
        %   -2.0000          
        %   -2.0000 + 2.0000i
        % 
        % 
        % s =
        % 
        %      1     1     2     0     1
        %      1     2     1     0    -1
        %      1     3     4     0     1
        %      1     4     3     0    -1
        %      2     1     3     0     1
        %      2     2     4     1     1
        %      2     3     1     0    -1
        %      2     4     2     1    -1
     sz=size(in);
     if(sz(1) > sz(2))
         in = in';
         Tflag = 1;
     else
         Tflag = 0;
     end
       in = zerofil(in);
       s = [];
       N = length(in);   % Broi To4ki
       N2 = floor(N/2);  % Peperudi na faza
       A = zeros(1,N);   % Prazen masiv za peperudite
       Warr = zeros(1,N2); % Masiv za stepenite na W
       % v kolko bita da se napravi nirrornum
       Bitreversed = getbit2(N-1); 
       for k=0:1:N-1
           A(k+1) = in(mirnum2(k,Bitreversed)+1);
       end
       % Calculates all W-s
       for k = 1:1:N2
           Warr(k) = exp(-pi*sqrt(-1)*(k-1)/N2);
       end

    phasemask = 1;

    while(phasemask ~= N)  
            for k = 1:N 
                % generaciq na A vuv faza "phasemask"
                f = bitand(k-1,phasemask-1)+1;
                if(bitand(phasemask,k-1))
                    l = k-phasemask;
                    Arrout(k)= A(l)-Warr(f)*A(k);
                    c = -1;
                else
                    l = k+phasemask;
                    Arrout(k)= A(k)+Warr(f)*A(l);
                    c = 1;
                end
               s=[s;[phasemask k l f-1 c]];
            end 
        A = Arrout;
        phasemask = bitshift(phasemask,1);  
    end
 if(Tflag)
    out = A';
 else
    out = A;
 end
end




