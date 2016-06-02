function f = ramaFactorial(n)
  if(n > 0)
    sqpi = log(pi)/2;
    nne = (log(n)-1)*n;
    root = log((8*n^3+4*n^2+n+1/30))/6;
    f = (sqpi+nne+root);
  else
    f = 0;
  end
end
