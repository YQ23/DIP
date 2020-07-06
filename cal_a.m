 %已知三个点坐标，求夹角A 
function cos_A = cal_a(A,B,C)
    a=sqrt((C(1)-B(1))^2+(C(2)-B(2))^2);
    b=sqrt((A(1)-C(1))^2+(A(2)-C(2))^2);
    c=sqrt((A(1)-B(1))^2+(A(2)-B(2))^2);
    cos_A = (c^2+b^2-a^2)/(2*b*c);
 end