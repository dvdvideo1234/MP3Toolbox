function [Out] = mirnum2(Num,Bits)
%     Mirrorizes a number in "l" bits, 
%     using bitwise operations
%     [1 1 0] --> [0 1 1]
%     [1 0 1] --> [1 0 1]
%     [0 0 1] --> [1 0 0]
%     Example:
%     mirnum2(3,3)
%     ans = 6 ( 3 --> [0 1 1] <> [1 1 0] --> 6 )
    Tmp = 0;
    for k = 1:Bits
        Tmp = bitshift(Tmp,1);
        Tmp = bitor(Tmp,bitand(Num,1));
        Num = bitshift(Num,-1);
    end
    Out = Tmp;
end