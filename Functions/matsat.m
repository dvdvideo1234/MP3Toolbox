function out = matsat(in,bounds)
  % Saturates a matrix
  sz = size(in);
  out = zeros(sz);
  for i =1:sz(1)
    for j = 1:sz(2)
      elem = in(i,j); 
      out(i,j) = elem *(elem >  bounds(1)) * (elem < bounds(2)) +...
                 bounds(1)*(elem <= bounds(1)) + bounds(2)*(elem >= bounds(2));
    end    
  end
end
