filepath2 = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task2/DataBuffer/data/trialdata/';
filepathp2 = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task2/DataBuffer/data/posdata/';
fnamesp2 = dir(strcat(filepathp2,'*.csv'));
fnames2 = dir(strcat(filepath2,'*.csv'));
nopos = 1;%0 = no positionstuff; 1 = yes
ns = length(fnames2);%number of test subjects
ad2 = zeros(175,11,ns);%alldata 175*2
b = 25; %block
for k = 1:ns
    fname2 = fnames2(k).name;
    ad2(:,:,k) = csvread(strcat(filepath2,fname2), 2,0);
    if nopos == 1
        fnamep2 = fnamesp2(k).name;    
        pd2 = csvread(strcat(filepathp2,fnamep2), 2,0);
        np2(k) = numel(pd2(:,2));
    end
end
rth = numel(unique(ad2(:,4,1)));%number of reach thresholds
pn = numel(unique(ad2(:,5,1)));
sdf = size(ad2,1);
mpd = max(np2);
for k = 1:ns
    for t = 1:rth
        td2(:,:,t,k) = ad2(ad2(:,4,k)==(t-1),:,k);
    end
end
if nopos == 1
    clearvars tpd2
    for k = 1:ns
        if np(k)< mpd
            tpd2(1:np(k),:,k) = csvread(strcat(filepathp2,fnamep2), 2,0);
            tpd2(np(k):mpd,:,k) = 0;
        else
            tpd2(:,:,k) = csvread(strcat(filepathp2,fnamep2), 2,0);
        end
        for t = 1:rth
            if k<2
                p2{t,1} = tpd2(tpd2(:,3,k)==t,:,k);%1,2,etc.
            else
                p2{t,1} = vertcat(p2{t,1},tpd2(tpd2(:,4,k)==t,:,k));
            end
        end
    end
end
figure(1);
for i = 1:rth
    hold all
    subplot(7,2,1+2*(i-1));
    plot(1:(sdf/7),td2(:,9,i));
    title(['reach' num2str(i) '=' num2str(td2(1,5,i))]);
    subplot(7,2,2*i);
    scatter(p2{i,1}(:,6),p2{i,1}(:,7));
    title(['trajectory' num2str(i) '=' num2str(td2(1,5,i))]);
end

