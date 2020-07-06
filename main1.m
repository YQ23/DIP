clear;%����޹ر���
clc;%���������
close all%�ر�����ͼ��

img1 = imread('оƬ�ذ�ͼƬ1.jpg');%��ȡͼƬ
img1_gray = rgb2gray(img1);%��ͼƬתΪ�Ҷ�ͼ

%��ͼ
figure(1);
imshow(img1);
title('ԭʼ��оƬ�ذ�ͼƬ');


[g2,t2] = edge(img1_gray,'sobel',[],'horizontal');%ˮƽ����
[g3,t3] = edge(img1_gray,'sobel',[],'vertical');%��ֱ����
g4 = sqrt(g2.^2 + g3.^2);%�ݶ�
figure(2);
subplot(121);
imshow(img1_gray);
title('grayimage');
subplot(122);
imshow(g4);
title('gradmag');

hy = fspecial('sobel');%sobel����
hx = hy';
Iy = imfilter(double(img1_gray), hy, 'replicate');%�˲���y�����Ե
Ix = imfilter(double(img1_gray), hx, 'replicate');%�˲���x�����Ե
g = sqrt(Ix.^2 + Iy.^2);%����
figure(3);
subplot(121);
imshow(img1_gray);
subplot(122);
imshow(g);

L = watershed(g);%ֱ��Ӧ�÷�ˮ���㷨
Lr = label2rgb(L);%ת��Ϊ��ɫͼ��
figure(4); 
imshow(Lr) %��ʾ�ָ���ͼ��
title('ֱ��Ӧ�÷�ˮ���㷨');


se1 = strel('disk',20);%�ṹԪ��Ϊ�뾶Ϊ20��Բ��
A = imerode(img1_gray,se1);%�Ҷ�ͼ��se1��ʴ
B = imreconstruct(A,img1_gray);%�ع�������
C = imdilate(B,se1);%����
D = imreconstruct(imcomplement(C),imcomplement(B));
D = imcomplement(D);

figure(5);
subplot(121);
imshow(B);
title('��ʴ�ؽ�ͼ');
subplot(122);
imshow(D);
title('�����ؽ�ͼ');


f = imregionalmax(D);%�ֲ�����ֵ
figure(6);
subplot(121);
imshow(f); %��ʾ�ؽ���ֲ�����ֵͼ��
title('�ֲ�����ǰ�����');
I2 = img1_gray;
I2(f) = 255;%�ֲ�����ֵ������ֵ��Ϊ255 
subplot(122);
imshow(I2); %��ԭͼ����ʾ����ֵ����
title('ԭͼ��ǰ����ǵĵ���');
se2 = strel(ones(5,5));%�ṹԪ��Ϊ5*5��ȫ1����
f2 = imclose(f, se2);%�ز���
f3 = imerode(f2, se2);%��ʴ
f4 = bwareaopen(f3, 20);%������
I3 = img1_gray;
I3(f4) = 255;%ǰ��������Ϊ255

bw = im2bw(D, graythresh(D));%OTSU��ת��Ϊ��ֵͼ��
Dis = bwdist(bw);%�������
DL = watershed(Dis);%��ˮ��任

gradmag2 = imimposemin(g,f4);%����Сֵ
L = watershed(gradmag2);%��ˮ��任
I4 = img1_gray;
I4(imdilate(L == 0, ones(3, 3)) | f4) = 255;%ǰ�����߽紦��255

figure(7);
subplot(121);
imshow(I4);%ͻ��ǰ�����߽�
title('ԭͼ���޸ĺ��ǰ����ǵĵ���');
L2 = label2rgb(L, 'jet', 'w', 'shuffle');%ת��Ϊα��ɫͼ��
subplot(122); 
imshow(L2)%��ʾα��ɫͼ��
title('α��ɫͼ��')

figure(8);
subplot(121);
imshow(img1_gray);hold on;
hI = imshow(L2);%��ԭͼ����ʾα��ɫͼ��
set(hI, 'AlphaData', 0.3);
title('ԭͼα����');

 xx = L;
 xx(xx==2) = 100;
 xx(xx<10) = 0;
 xx = xx ./ 100;
 yy= B.*xx;

 subplot(122);
 imshow(yy);
 title('�ָ��Ľ��');
 
 
 [left_h,left_l,right_h,right_l] = find_loc(xx);%ȷ���ĸ�����λ��
 gg = [left_h(1),left_l(1),right_l(1),right_h(1)];
 ff = [left_h(2),left_l(2),right_l(2),right_h(2)];
 Bw = roipoly(B,ff,gg);

 img_s = B;
 img_s(Bw==0) = 0;
 img_rec = pt(img_s,left_h,right_h,left_l,right_l);%����͸�ӱ任
 
 figure(9);
 imshow(img_rec);
 title('͸�ӱ任��ľ�������');
 
 [gs,ts] = edge(img_rec,'sobel',0.06,'both');%ʹ��sobel����
 [gc,tc] = edge(img_rec,'canny',[],'both');%ʹ��canny����
 figure(10);
 subplot(121);
 imshow(gs);
 title('sobel����');
 subplot(122);
 imshow(gc);
 title('canny����');
 
 se2 = strel('disk',2);
 img_se = imdilate(gs,se2);%����
 se3 = strel('disk',1);
 img_open = imopen(~img_se,se3);%������
 img_open = img_open(:,2:end-1);
 figure(11);
 imshow(img_open);
 title('����оƬ�ذ崦����');
 
 dis = 9;%ɨ��ģ��Ϊ9*9
 th = 50;%��ֵΪ50
 [d,count,img_res] = scan(img_open,dis,th);%��ͼƬ���б���,ȷ��оƬ������λ��
 figure(12);
 imshow(img_res);
 title('ʶ�����оƬ���');
 
 