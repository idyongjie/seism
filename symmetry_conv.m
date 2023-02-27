%% ��ȡ�ļ�
    fid = fopen("vel_model_823.dat","rb");
    [A,~] = fread(fid,[1171,1710],'float');
    fclose(fid);    
    clear fid;
%% ����һ�����ݣ�ÿһ���ٶ�
ceng_hou = zeros(7,56);
ceng_v = [1500;1600;1900;1950;2250;1750;2100];
for j = 1:56
    u = j*30-29;
    m = 1;
    for i = 1:1171
        if ceng_v(m,1) == A(i,u)
            continue
        else 
            ceng_hou(m,j) = i;
            m = m+1;
        end
    end
end
for i = 1:6
    ceng_hou(5,i) = 804+i;
end
clear m u i j;
%% ����--0.5m--0.25ms
time_interval = 0.25                                                %����ʱ����
fs_lv = [1/31;3/35;1/77;1/14;-1/8;1/11;1];        %���㷴����
fs_all = zeros(687/time_interval,56);           %���������ʿվ���
%���ڸ����ʱ��
time1 = (ceng_hou(1,1)-1)/ceng_v(1,1);
time2 = time1+(ceng_hou(2,1)-ceng_hou(1,1))/ceng_v(2,1);
time3 = time2+(ceng_hou(3,1)-ceng_hou(2,1))/ceng_v(3,1);
time4 = time3+(ceng_hou(4,1)-ceng_hou(3,1))/ceng_v(4,1);
time7_lin = (ceng_hou(7,1)-ceng_hou(6,1))/ceng_v(7,1);
% �������ʱ��ת��Ϊ���
for j = 1:56
    fs_all(round(time1*1000/time_interval),j) = fs_lv(1,1);
    fs_all(round(time2*1000/time_interval),j) = fs_lv(2,1);
    fs_all(round(time3*1000/time_interval),j) = fs_lv(3,1);
    fs_all(round(time4*1000/time_interval),j) = fs_lv(4,1);
    time5 = time4 + (ceng_hou(5,j)-ceng_hou(4,j))/ceng_v(5,1);
    fs_all(round(time5*1000/time_interval),j) = fs_lv(5,1);
    time6 = time5 + (ceng_hou(6,j)-ceng_hou(5,j))/ceng_v(6,1);
    fs_all(round(time6*1000/time_interval),j) = fs_lv(6,1);
    time7 = time6+time7_lin;
    fs_all(round(time7*1000/time_interval),j) = fs_lv(7,1);
end
clear time1 time2 time3 time4 time5 time6 time7 time_interbal time7_lin;

%% ��ȡĳ��Ƶ�ʸ����Ӳ�����д��һ������N
k=13;                                                    %��Ƶ�ʵ��ļ���
N = zeros(257,k+1);                                       %�����վ���
x = time_interval:time_interval:(64+time_interval);                                       %�������ݳ���
N(:,1) = x';                %дʱ����
for j=2:k
    %��Ƶ����k���ļ�
    name = 'BF.D'+string(j)+'.txt';     %�ļ���
    fid = fopen(name,'rt');             %���ļ�
    M = dlmread(name,' ' ,513,1);           %��ȡ����
    N(:,j+1) = M(:,4)+M(:,5);               %��������ո�Ӱ��
    fclose(fid);                        %�ر��ļ�
end
clear x j fid M name;
%% �Ӳ������뷴���ʽ��о�������ɾ���Q 
for i = 2:k
    for j=1:56
        Q(:,j) = conv(fs_all(:,j),N(:,i+1));
        for lin = 1:30          %forѭ�����ݳ��ز���棬��ȥ
            P(:,lin+j*30-30) = Q(:,j);
        end
        clear lin;
    end
    %% ������Qд��������ļ� conv_pinlv_jiange.dat
    name = 'convBF.D'+string(i)+'.dat';
    fid = fopen(name,"wb");
    % fwrite(fid,Q,'float');
    fwrite(fid,P,'float');
    fclose(fid);
    clear fid;
end
%% ��ͼ
% figure
% subplot(1,2,1)
% plot(hanshu(:,56))
% subplot(1,2,2)
% plot(hanshu(:,1))