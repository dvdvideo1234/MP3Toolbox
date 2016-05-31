function Out = ValuePersistInArray(Val,Arr)
  Out = 0;
  for i=1:1:length(Arr)
    if(Val == Arr(i)) 
      Out = 1;
      break;
    end
  end
end
