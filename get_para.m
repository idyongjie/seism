%%��ȡ�Ӳ�����%%
parm = zeros(11,2);
for k = 1:11
%%
    %��ֵ,��y����ʮ��֮һ�Ĳ�ֵ������������
    name = "BF.D"+string(k)+".xlsx";
    A = xlsread(name);
    B = zeros(65,3);
    for i = 1:65
        for j = 1:3
            B(i,j) = A(513+i,j);
        end
    end
    [~,indexn] = max(B(:,3));
    [~,indexm] = min(B(:,3));
    a=min(indexm,indexn);
    b=max(indexm,indexn);
    indexm=a;
    indexn=b;
    x=(indexm-1):0.1:(indexn+1);
    y=interp1(B(:,1),B(:,3),x,'spline');
    %plot(x,y)
    y=y';
    %%
    %�����٣���Ƶ����Ƶ
    [n,indexn] = max(y(:,1));
    [m,indexm] = min(y(:,1));
     a=min(indexm,indexn);
    b=max(indexm,indexn);
    indexm=a;
    indexn=b;
    parm1 = abs(indexn-indexm);
    %%
    %�����ڣ����β��,�Ӳ�ֵ����������С�����ֵ��Ӧ��ʱ��ֵ
    cf1=zeros(parm1,1);
    cf2=zeros(parm1-1,1);
    for i= 1:parm1
        cf1(i,1) = y(i+indexm,1)-y(i+indexm-1,1);
    end
    for i = 1:parm1-1
        cf2(i,1) = cf1(i+1,1)-cf1(i,1);
    end
    [min2,index2] = min(abs(cf2(:,1)));
    parm2 = 2*(parm1 - index2);
    %%
    %��ȡ��������
    parm(k,:)=[parm1/10,parm2/10];
end