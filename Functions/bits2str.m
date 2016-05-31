function ch = bits2str(bindata,mode)
  if(mode == 1)
    nd = numel(bindata);
    nc = floor((nd / 8));
    ch = [];
    ptr = 1;
    for i = 1:nc
      for k = 1:8
          if((i*8+k) > nd)
            z(k) = 0;
          else
            z(k)= str2double(bindata(i*8+k));
          end
      end
      ch = [ch char(bits2int(z))];
      ptr = ptr + 8;
    end
    for k = 1:8
      z1(k)= str2double(bindata(k));
    end
    ch = [char(bits2int(z1)) ch];
  end
  if(mode == 2)
    nd = numel(bindata);
    nc = floor((nd / 8));
    ch = [];
    ptr = 1;
    for i = 1:nc
      for k = 1:8
          if((i*8+k) > nd)
            z(k) = 0;
          else
            z(k)= bindata(i*8+k);
          end
      end
      
      ch = [ch char(bits2int(z))];
      ptr = ptr + 8;
    end
    ch = [char(bits2int(bindata(1:8))) ch];
  end
end

