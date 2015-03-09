function eq = points2eq(P1,P2)
syms x y
eq = [char(( P1(2)-P2(2))*(x - P2(1)) - ((P1(1)-P2(1))*(y - P2(2)))) ' = 0'];
end