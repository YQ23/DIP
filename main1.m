clear;%清除无关变量
clc;%清空命令行
close all%关闭所有图窗

img1 = imread('芯片载板图片1.jpg');%读取图片
img1_gray = rgb2gray(img1);%将图片转为灰度图

%绘图
figure(1);
imshow(img1);
title('原始的芯片载板图片');


[g2,t2] = edge(img1_gray,'sobel',[],'horizontal');%水平方向
[g3,t3] = edge(img1_gray,'sobel',[],'vertical');%垂直方向
g4 = sqrt(g2.^2 + g3.^2);%梯度
figure(2);
subplot(121);
imshow(img1_gray);
title('grayimage');
subplot(122);
imshow(g4);
title('gradmag');

hy = fspecial('sobel');%sobel算子
hx = hy';
Iy = imfilter(double(img1_gray), hy, 'replicate');%滤波求y方向边缘
Ix = imfilter(double(img1_gray), hx, 'replicate');%滤波求x方向边缘
g = sqrt(Ix.^2 + Iy.^2);%求摸
figure(3);
subplot(121);
imshow(img1_gray);
subplot(122);
imshow(g);

L = watershed(g);%直接应用分水岭算法
Lr = label2rgb(L);%转化为彩色图像
figure(4); 
imshow(Lr) %显示分割后的图像
title('直接应用分水岭算法');


se1 = strel('disk',20);%结构元素为半径为20的圆盘
A = imerode(img1_gray,se1);%灰度图被se1腐蚀
B = imreconstruct(A,img1_gray);%重构开运算
C = imdilate(B,se1);%膨胀
D = imreconstruct(imcomplement(C),imcomplement(B));
D = imcomplement(D);

figure(5);
subplot(121);
imshow(B);
title('腐蚀重建图');
subplot(122);
imshow(D);
title('膨胀重建图');


f = imregionalmax(D);%局部极大值
figure(6);
subplot(121);
imshow(f); %显示重建后局部极大值图像
title('局部极大前景标记');
I2 = img1_gray;
I2(f) = 255;%局部极大值处像素值设为255 
subplot(122);
imshow(I2); %在原图上显示极大值区域
title('原图与前景标记的叠加');
se2 = strel(ones(5,5));%结构元素为5*5的全1矩阵
f2 = imclose(f, se2);%关操作
f3 = imerode(f2, se2);%腐蚀
f4 = bwareaopen(f3, 20);%开操作
I3 = img1_gray;
I3(f4) = 255;%前景处设置为255

bw = im2bw(D, graythresh(D));%OTSU法转化为二值图像
Dis = bwdist(bw);%计算距离
DL = watershed(Dis);%分水岭变换

gradmag2 = imimposemin(g,f4);%置最小值
L = watershed(gradmag2);%分水岭变换
I4 = img1_gray;
I4(imdilate(L == 0, ones(3, 3)) | f4) = 255;%前景及边界处置255

figure(7);
subplot(121);
imshow(I4);%突出前景及边界
title('原图与修改后的前景标记的叠加');
L2 = label2rgb(L, 'jet', 'w', 'shuffle');%转化为伪彩色图像
subplot(122); 
imshow(L2)%显示伪彩色图像
title('伪彩色图像')

figure(8);
subplot(121);
imshow(img1_gray);hold on;
hI = imshow(L2);%在原图上显示伪彩色图像
set(hI, 'AlphaData', 0.3);
title('原图伪彩像');

 xx = L;
 xx(xx==2) = 100;
 xx(xx<10) = 0;
 xx = xx ./ 100;
 yy= B.*xx;

 subplot(122);
 imshow(yy);
 title('分割后的结果');
 
 
 [left_h,left_l,right_h,right_l] = find_loc(xx);%确定四个顶点位置
 gg = [left_h(1),left_l(1),right_l(1),right_h(1)];
 ff = [left_h(2),left_l(2),right_l(2),right_h(2)];
 Bw = roipoly(B,ff,gg);

 img_s = B;
 img_s(Bw==0) = 0;
 img_rec = pt(img_s,left_h,right_h,left_l,right_l);%进行透视变换
 
 figure(9);
 imshow(img_rec);
 title('透视变换后的矩形区域');
 
 [gs,ts] = edge(img_rec,'sobel',0.06,'both');%使用sobel算子
 [gc,tc] = edge(img_rec,'canny',[],'both');%使用canny算子
 figure(10);
 subplot(121);
 imshow(gs);
 title('sobel算子');
 subplot(122);
 imshow(gc);
 title('canny算子');
 
 se2 = strel('disk',2);
 img_se = imdilate(gs,se2);%膨胀
 se3 = strel('disk',1);
 img_open = imopen(~img_se,se3);%开操作
 img_open = img_open(:,2:end-1);
 figure(11);
 imshow(img_open);
 title('完整芯片载板处理结果');
 
 dis = 9;%扫描模板为9*9
 th = 50;%阈值为50
 [d,count,img_res] = scan(img_open,dis,th);%对图片进行遍历,确定芯片个数及位置
 figure(12);
 imshow(img_res);
 title('识别出的芯片结果');
 
 