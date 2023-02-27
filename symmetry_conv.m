%% 读取文件
    fid = fopen("vel_model_823.dat","rb");
    [A,~] = fread(fid,[1171,1710],'float');
    fclose(fid);    
    clear fid;
%% 解析一列数据，每一层速度
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
%% 反射--0.5m--0.25ms
time_interval = 0.25                                                %设置时间间隔
fs_lv = [1/31;3/35;1/77;1/14;-1/8;1/11;1];        %各层反射率
fs_all = zeros(687/time_interval,56);           %创建反射率空矩阵
%求波在各层的时间
time1 = (ceng_hou(1,1)-1)/ceng_v(1,1);
time2 = time1+(ceng_hou(2,1)-ceng_hou(1,1))/ceng_v(2,1);
time3 = time2+(ceng_hou(3,1)-ceng_hou(2,1))/ceng_v(3,1);
time4 = time3+(ceng_hou(4,1)-ceng_hou(3,1))/ceng_v(4,1);
time7_lin = (ceng_hou(7,1)-ceng_hou(6,1))/ceng_v(7,1);
% 将各层的时间转化为序号
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

%% 读取某个频率各个子波，并写入一个矩阵N
k=13;                                                    %该频率的文件数
N = zeros(257,k+1);                                       %创建空矩阵
x = time_interval:time_interval:(64+time_interval);                                       %创建数据长度
N(:,1) = x';                %写时间间隔
for j=2:k
    %该频率有k个文件
    name = 'BF.D'+string(j)+'.txt';     %文件名
    fid = fopen(name,'rt');             %打开文件
    M = dlmread(name,' ' ,513,1);           %读取矩阵
    N(:,j+1) = M(:,4)+M(:,5);               %消除多余空格影响
    fclose(fid);                        %关闭文件
end
clear x j fid M name;
%% 子波函数与反射率进行卷积并生成矩阵Q 
for i = 2:k
    for j=1:56
        Q(:,j) = conv(fs_all(:,j),N(:,i+1));
        for lin = 1:30          %for循环反演出地层界面，可去
            P(:,lin+j*30-30) = Q(:,j);
        end
        clear lin;
    end
    %% 将矩阵Q写入二进制文件 conv_pinlv_jiange.dat
    name = 'convBF.D'+string(i)+'.dat';
    fid = fopen(name,"wb");
    % fwrite(fid,Q,'float');
    fwrite(fid,P,'float');
    fclose(fid);
    clear fid;
end
%% 作图
% figure
% subplot(1,2,1)
% plot(hanshu(:,56))
% subplot(1,2,2)
% plot(hanshu(:,1))