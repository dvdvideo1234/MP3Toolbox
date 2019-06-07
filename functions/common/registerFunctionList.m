function [out] = registerFunctionList(in)
  out = {};
  cnt = 0;
  for iD = 1:length(in);
    name = strtrim(in{iD}{1});
    if(exist(name))
      cnt = cnt + 1;
      foo = str2func(name);
      new = {foo};
      for iK = 2:length(in{iD})
        new{iK} = in{iD}{iK};
      end
      out = [out; {new}];
    else
      disp(strcat('Function unavailable: <', name,'>'));
    end
  end
end
