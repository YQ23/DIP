%�ҵ��ĸ��ǵ�λ��,����:img,������������������µ�λ������ 
function [left_h,left_l,right_h,right_l] = find_loc(img)
 left_h = zeros(1,2);
 left_l = zeros(1,2);
 right_h = zeros(1,2);
 right_l = zeros(1,2);
% [m,n] = size(img);
 sc = sum(img,1);%�������
 sr = sum(img,2);%�������
 fc = find(sc>0);
 fr = find(sr>0);
 a1 = fc(1);%��Ϊ0�ĵ�һ��
 a2 = fc(end);%��Ϊ0�����һ��
 a3 = fr(1);%��Ϊ0�ĵ�һ��
 a4 = fr(end);%��Ϊ0�����һ��
 
 x = img(a3,:);
 xx = find(x>0);
 left_h(1) = a3;%����
 left_h(2) = xx(1);
 
 x = img(:,a2);
 xx = find(x>0);
 right_h(1) = xx(1);%����
 right_h(2) = a2;
 
 x = img(:,a1);
 xx = find(x>0);
 left_l(1) = xx(end);%����
 left_l(2) = a1;
 
 x = img(a4,:);
 xx = find(x>0);
 right_l(1) = a4;%����
 right_l(2) = xx(end);
 
 % [right_h(1),right_h(2)] = cor(right_h,left_h,right_l);
  [left_l(1),left_l(2)] = cor(left_l,left_h,right_l);
 
 
 
 end