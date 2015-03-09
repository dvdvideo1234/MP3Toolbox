function bits = str2bits(str,mode)
    bits = [];
    data = [];
    z = zeros(1,8);
    intdata = double(str);
    for k = 1:numel(intdata)
        z = int2bits(intdata(k),8);
        data = [data z];
    end
    if(mode == 2)
        bits = data;
    end
    if(mode == 1)
        for k = 1:numel(data)
            bits = [bits num2str(data(k))];
        end
    end
end