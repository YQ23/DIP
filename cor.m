%固定B,C找到最接近直角的A
function [x,y] = cor(A,B,C) 
 xa = A(1);
 ya = A(2);
 m = 1;
 for i = xa-2:xa+2
     for j = ya-2:ya+2
         cosA = cal_a([i,j],B,C);
          if(abs(cosA)<m)
              x = i;
              y = j;
              m = abs(cosA);
          end
     end
 end
 end