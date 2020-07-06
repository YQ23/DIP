%�Եڶ���ͼƬ��ʶ����
clear;%����޹ر���
clc;%���������
close all
%set(0,'defaultfigurecolor','w')%ʹ�����ɫΪ��ɫ

img = imread('оƬ�ذ�ͼƬ2.jpg');%��ȡͼƬ
img_gray = rgb2gray(img);%��ͼƬתΪ�Ҷ�ͼ
[m,n] = size(img_gray);%��ȡͼƬ�ĳ��Ϳ�

img_l = img_gray(:,1:round(n/2));%��߲���
img_r = img_gray(:,ceil(n/2):end);%�ұ߲���

figure(1);
imshow(img);
title('ԭʼ��оƬ�ذ�ͼƬ2');

figure(2);
imshow(img_gray);
title('оƬ�ذ�ͼƬ2�Ҷ�ͼ');

figure(3);
subplot(121);
imshow(img_l);
title('��߲���');
subplot(122);
imshow(img_r);
title('�ұ߲���');

[lx,ly] = size(img_l);
img_c = zeros(floor(lx/2),floor(ly/2));
xx = zeros(2,2);%�����ز���
for i = 1:floor(lx/2)
    for j = 1:floor(ly/2)
        xx = img_l((((i-1)*2+1):(((i-1)*2+2))),((j-1)*2+1):((j-1)*2+2));
        img_c(i,j) = max(max(xx));
    end
end
img_c = uint8(img_c);%תΪuint8����

figure(4);
imshow(img_c);
title('�ز�����Ľ��');

%[gs,ts] = edge(img_c,'sobel',[],'both');%ʹ��sobel����

U = double(img_c);
[H,W] = size(U);
sn = U;
%tt = zeros(H,W);
for i = 2:H-1
    for j = 2:W-1
        %sobel����
        Gx=(U(i+1,j-1)+2*U(i+1,j)+U(i+1,j+1))-(U(i-1,j-1)+2*U(i-1,j)+U(i-1,j+1));
        Gy=(U(i-1,j+1)+2*U(i,j+1)+U(i+1,j+1))-(U(i-1,j-1)+2*U(i,j-1)+U(i+1,j-1));
        sn(i,j) = sqrt((Gx.^2+Gy.^2));
    end
end

sn = uint8(sn);
so = im2bw(sn,graythresh(sn));%OTSU����
figure(5);
imshow(so);%��ֵΪ0.4745*255=120
title('�����䷽��õ��Ķ�ֵͼ');

so2 = so;
dd = 3;
xx = zeros(dd,dd);
for i = 1:floor(H/dd)
    for j = 1:floor(W/dd)
        xx = so2(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd));
        %ȥ����ɫ���ص�
        if(sum(sum(xx))<3)
            so2(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd)) = 0;
        end
    end
end

figure(8);
imshow(so2);
title('�����䷽�(ȥ����ɫ���ص�)�õ��Ķ�ֵͼ');


%ɸѡֱ��
%----------------------------------------------------------------------------------------------

%ɸѡ�����ֱ��
l1 = zeros(200,2);
cnt = 0;%ɸѡ��Եֱ�ߵ�
for i = 3:round(0.07*H)
    for j = 1:W
        if(so2(i,j)==1 & so2(i+1:i+6,j)==0)%����õ�����Ϊ1�����漸��Ϊ0����Ϊ�õ�Ϊ��Ե��
            cnt = cnt + 1;
            l1(cnt,1) = i;
            l1(cnt,2) = j;
        end
    end
end
l1 = l1(1:cnt,:);
l1_s = mean(l1,1);
l1_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l1)
    if(abs(l1(i,1)-l1_s(1))<3)
        cnt = cnt + 1;
        l1_n(cnt,:) = l1(i,:);
    end
end
l1_n = l1_n(1:cnt,:);%��Ե��

lc = so2.*0;
for i = 1:cnt
    lc(l1_n(i,1),l1_n(i,2)) = 1;
end

l1_n(:,1) = H - l1_n(:,1);
l1_a = polyfit(l1_n(:,2),l1_n(:,1),1);%�������
 

%ɸѡ�ұߵ�ֱ��
l2 = zeros(200,2);
cnt = 0;%ɸѡ��Եֱ�ߵ�
for j = round(0.8*W):0.95*W
    for i = 3:H
        if(so2(i,j)==1 & so2(i,j-6:j-1)==0)%����õ�����Ϊ1�����漸��Ϊ0����Ϊ�õ�Ϊ��Ե��
            cnt = cnt + 1;
            l2(cnt,1) = i;
            l2(cnt,2) = j;
        end
    end
end
l2 = l2(1:cnt,:);
%l2_n = l2;
l2_s = mean(l2,1);
l2_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l2)
    if(abs(l2(i,2)-l2_s(2))<4)
        cnt = cnt + 1;
        l2_n(cnt,:) = l2(i,:);
    end
end
l2_n = l2_n(1:cnt,:);%��Ե��

lc2 = so2.*0;
for i = 1:cnt
    lc2(l2_n(i,1),l2_n(i,2)) = 1;
end

l2_n(:,1) = H - l2_n(:,1);
l2_a = polyfit(l2_n(:,2),l2_n(:,1),1);%�������

%ɸѡ�±ߵ�ֱ��
l3 = zeros(200,2);
cnt = 0;%ɸѡ��Եֱ�ߵ�
for i = round(0.95.*H):H-5
    for j = 1:W
        if(so2(i,j)==1 & so2(i-5:i-1,j)==0)%����õ�����Ϊ1�����漸��Ϊ0����Ϊ�õ�Ϊ��Ե��
            cnt = cnt + 1;
            l3(cnt,1) = i;
            l3(cnt,2) = j;
        end
    end
end
l3 = l3(1:cnt,:);
l3_s = mean(l3,1);
l3_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l3)
    if(abs(l3(i,1)-l3_s(1))<3)
        cnt = cnt + 1;
        l3_n(cnt,:) = l3(i,:);
    end
end
l3_n = l3_n(1:cnt,:);%��Ե��

lc3 = so2.*0;
for i = 1:cnt
    lc3(l3_n(i,1),l3_n(i,2)) = 1;
end

l3_n(:,1) = H - l3_n(:,1);
l3_a = polyfit(l3_n(:,2),l3_n(:,1),1);%�������

%ɸѡ��ߵ�ֱ��
l4 = zeros(200,2);
cnt = 0;%ɸѡ��Եֱ�ߵ�
for j = round(0.18*W):0.23*W
    for i = 3:H
        if(so2(i,j)==1 & so2(i,j+1:j+6)==0)%����õ�����Ϊ1�����漸��Ϊ0����Ϊ�õ�Ϊ��Ե��
            cnt = cnt + 1;
            l4(cnt,1) = i;
            l4(cnt,2) = j;
        end
    end
end
l4 = l4(1:cnt,:);
%l2_n = l2;
l4_s = mean(l4,1);
l4_n = zeros(cnt,2);
cnt = 0;
for i = 1:length(l4)
    if(abs(l4(i,2)-l4_s(2))<3)
        cnt = cnt + 1;
        l4_n(cnt,:) = l4(i,:);
    end
end
l4_n = l4_n(1:cnt,:);%��Ե��

lc4 = so2.*0;
for i = 1:cnt
    lc4(l4_n(i,1),l4_n(i,2)) = 1;
end

l4_n(:,1) = H - l4_n(:,1);
%l4_a = polyfit(l4_n(:,2),l4_n(:,1),1);
l4_a = [0,round(l4_s(2))];

%����ɸѡ��������ֱ��
figure(9);
%subplot(221);
imshow(lc);
title('ɸѡ�����ϱ�ֱ�ߵ�');
%subplot(222);
figure(10);
imshow(lc2);
title('ɸѡ�����ұ�ֱ�ߵ�');
%subplot(223);
figure(11);
imshow(lc3);
title('ɸѡ�����±�ֱ�ߵ�');
%subplot(224);
figure(12);
imshow(lc4);
title('ɸѡ�������ֱ�ߵ�');

figure(13);
plot(l1_n(:,2),l1_n(:,1),'*');
t = 30:170;
y = l1_a(1).*t + l1_a(2);
hold on;
plot(t,y);

plot(l2_n(:,2),l2_n(:,1),'*');
t = 30:170;
y2 = l2_a(1).*t + l2_a(2);
hold on;
plot(t,y2);

plot(l3_n(:,2),l3_n(:,1),'*');
t = 30:180;
y3 = l3_a(1).*t + l3_a(2);
hold on;
plot(t,y3);

plot(l4_n(:,2),l4_n(:,1),'*');
t = ones(1,500).*l4_a(2);
y4 = 1:500;
hold on;
plot(t,y4);
axis([0 200 0 500]);
title('��ϳ���������Եֱ��');
%-------------------------------------------------------------------------------------

%���������ɸѡֱ�ߴ����������ĸ������������Ϊ��������
lh = [32,39];%���϶���
ll = [493,40];%���¶���
rh = [33,172];%���϶���
rl = [488,173];%���¶���

img_rec = pt(img_c,lh,rh,ll,rl);%����͸�ӱ任
figure(14);
imshow(img_rec);
title('͸�ӱ任���ͼƬ');

U2 = double(img_rec);
[H2,W2] = size(U2);
sn2 = U2;
%s2 = sn2;
%sn_t2 = 120;
for i = 2:H2-1
    for j = 2:W2-1
        %ʹ��sobel����
        Gx=(U2(i+1,j-1)+2*U2(i+1,j)+U2(i+1,j+1))-(U2(i-1,j-1)+2*U2(i-1,j)+U2(i-1,j+1));
        Gy=(U2(i-1,j+1)+2*U2(i,j+1)+U2(i+1,j+1))-(U2(i-1,j-1)+2*U2(i,j-1)+U2(i+1,j-1));
        sn2(i,j) = sqrt((Gx.^2+Gy.^2));
%        s2(i,j) = sn2(i,j);
%         if(sn2(i,j)>sn_t2)
%             sn2(i,j) = 0;
%         else
%             sn2(i,j) = 255;
%         end
    end
end


s2_o = im2bw(uint8(sn2),120./255);%��ֵ������
dd = 3;
xx = zeros(dd,dd);
for i = 1:floor(H2/dd)
    for j = 1:floor(W2/dd)
        xx = s2_o(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd));
        %ȥ����ɫ���ص�
        if(sum(sum(xx))<3)
            s2_o(((i-1)*dd+1):(i*dd),((j-1)*dd+1):(j*dd)) = 0;
        end
    end
end

s2_o = ~s2_o(:,2:end-1);
dis = 4;%4*4��ģ��
th = 11;%��ֵ
[d,count,img_res] = scan(s2_o,dis,th);%ֱ�ӽ���ʶ��

figure(15);
imshow(s2_o);
title('OTSU��(ȥ����ɫ���ص�)');
figure(16);
imshow(img_res);
title('ֱ��ʶ�����оƬ���');

%��ͼ�������̬ѧ����,�ٽ���ʶ��
se2 = strel('disk', 2);%Բ�νṹԪ��
Ie = imopen(s2_o,se2);%������
figure(17);
imshow(Ie);
title('�������߽�оƬ�ذ����մ�����');

dis2 = 5;%4*4��ģ��
th2 = 20;%��ֵ
[d2,count2,img_res2] = scan(s2_o,dis2,th2);%����ʶ��
figure(18);
imshow(img_res2);
title('����ʶ�����оƬ���');