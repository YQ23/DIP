%����:Դͼ �������������������� 
%����任���ͼ��
 function Imgout = pt(imgIn,LT,RT,LB,RB)
    outWidth=round(sqrt((LT(1)-RT(1))^2+(LT(2)-RT(2))^2));     %��ԭ�ı��λ���¾��ο�
    outHeight=round(sqrt((LT(1)-LB(1))^2+(LT(2)-LB(2))^2));     %��ԭ�ı��λ���¾��θ�
    [H,W,D] = size(imgIn);
    %Ϊ������ͶӰ�任����Ҫ��4����ת��Ϊ��������
    v1 = LB - LT;
    v2 = RT - LT;
    v3 = RB - LT;
    %��v3��ʾ��v1��v2��������ϣ���ʹ������������
    A = [v1', v2'];
    B = v3';
    S = A\B;
    a0 = S(1);
    a1 = S(2);
    
    %�������
    Imgout = uint8(zeros(outHeight,outWidth,D));
   
    %����ѭ����������ÿ�����ص㸳ֵ
    for heightLoop = 1:outHeight
        for widthLoop = 1:outWidth
            x0 = heightLoop/outHeight;
            x1 = widthLoop/outWidth;
            deno = a0+a1-1+(1-a1)*x0+(1-a0)*x1;     %��ĸ
            y0 = a0*x0/deno;
            y1 = a1*x1/deno;
            
            %���ݵõ��Ĳ����ҵ���Ӧ��Դͼ���е�����λ�ã�����ֵ
            co = y0*v1 + y1*v2 + LT;
            hC = round(co(1));
            wC = round(co(2));
                if (hC > H || hC <= 0 || wC >W || wC <=0 )
                    disp(['������Χ' num2str(hC) num2str(wC)]);
                    pause();
                    return;
                end
            for dimentionLoop = 1:D
                %ʹ����������ֵ��ʹ�ø߼���ֵ����Ч�������
                Imgout(heightLoop,widthLoop,dimentionLoop) = imgIn(hC,wC,dimentionLoop);
            end
        end
    end
    
    [m,n] = size(Imgout);
    last_col = Imgout(:,end);
    last_row = Imgout(end,:);
    for i = 1:m
        if(last_col(i)==0)
            Imgout(i,end) = Imgout(i,end-1);
        end
    end
    for i = 1:n
        if(last_row(i)==0)
            Imgout(end,i) = Imgout(end-1,i);
        end
    end
    
   Imgout = Imgout(:,2:end-1);
    
  % figure; imshow(Imgback); title('ͶӰ�任�Ľ��');
 end