function Out = ValuePersistInArray(Val,Arr)
  % Searches for a value in array of any type
  Out = 0;
  for i=1:1:length(Arr)
    if(Val == Arr(i)) 
      Out = 1;
      break;
    end
  end
  return;
end
