function [out] = registerFunctionList(nam, in)
  out.Inf = nam;
  out.Cur = 1;
  out.Alg = {};
  cnt = 0;
  flg = 0;
  foo = 0;
  for iD = 1:length(in);
    name = strtrim(in{iD}{1});
    if(exist(name))
      cnt = cnt + 1;
      foo = str2func(name);
      new = {foo};
      for iK = 2:length(in{iD})
        new{iK} = in{iD}{iK};
      end
      out.Alg = [out.Alg; {new}];
    else
      if(flg == 0) flg = 1;
        disp('');
        disp(strcat('Initializing set: <', nam,'>'));
        disp('---------------------------------');
      end
      disp(strcat('Function unavailable: <', name,'>'));
    end
  end
  out.Siz = cnt;
end
