%找到四个角的位置,输入:img,输出左上左下右上右下的位置坐标 
function [left_h,left_l,right_h,right_l] = find_loc(img)
 left_h = zeros(1,2);
 left_l = zeros(1,2);
 right_h = zeros(1,2);
 right_l = zeros(1,2);
% [m,n] = size(img);
 sc = sum(img,1);%按列求和
 sr = sum(img,2);%按行求和
 fc = find(sc>0);
 fr = find(sr>0);
 a1 = fc(1);%不为0的第一列
 a2 = fc(end);%不为0的最后一列
 a3 = fr(1);%不为0的第一行
 a4 = fr(end);%不为0的最后一行
 
 x = img(a3,:);
 xx = find(x>0);
 left_h(1) = a3;%左上
 left_h(2) = xx(1);
 
 x = img(:,a2);
 xx = find(x>0);
 right_h(1) = xx(1);%右上
 right_h(2) = a2;
 
 x = img(:,a1);
 xx = find(x>0);
 left_l(1) = xx(end);%左下
 left_l(2) = a1;
 
 x = img(a4,:);
 xx = find(x>0);
 right_l(1) = a4;%右下
 right_l(2) = xx(end);
 
 % [right_h(1),right_h(2)] = cor(right_h,left_h,right_l);
  [left_l(1),left_l(2)] = cor(left_l,left_h,right_l);
 
 
 
 end