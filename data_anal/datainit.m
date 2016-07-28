

% get filenames
filepath = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/trialdata/';
filepathp = '/Users/hwab/Dropbox (HHMI)/2015-16 experiment/task1/DataBuffer/positiondata/';
fnamesp = dir(strcat(filepathp,'*.csv'));
fnames = dir(strcat(filepath,'*.csv'));
nopos = 1;%0 = no positionstuff; 1 = yes
ns = length(fnames);%number of test subjects
ad = zeros(500,13,ns);%alldata
np = zeros(ns);
rprob = [0.1,0.25,0.5, 0.75,0.9];
b = 50; %block
for k = 1:ns
    fname = fnames(k).name;
    ad(:,:,k) = csvread(strcat(filepath,fname), 2,0);
    if nopos == 1
        fnamep = fnamesp(k).name;    
        pd1 = csvread(strcat(filepathp,fnamep), 2,0);
        np(k) = numel(pd1(:,2));
    end
end

% threshes = 2%for old csv
%trial data for task1 and 2
half = 2;
colp = size(pd1,2);
mpd = max(np);
rn = numel(unique(ad(:,4,1)));
pn = numel(unique(ad(:,5,1)));
col = size(ad,2);
tt = pn*b/half;
cl = varycolor(rn + 1);

hd = reshape((b/2)+1:b,(b/2),1);
for i = 1:(rn*pn)
    hdx(1+(b/2)*(i-1):(b/2)*i,1) = hd(:,1) + b*(i-1);
end
hindex = reshape(hdx,tt,rn);
if rn == 2
    version = 1;
end
if rn == 5
    version = 2;
end
chleft = zeros(pn,rn,ns);
avg = zeros(pn,rn);
td = zeros((size(ad,1)/rn)/half,size(ad,2),rn,ns);
td1 = zeros((size(ad,1)/rn),size(ad,2),rn,ns);
correct = zeros(tt,rn,ns);
idxc = zeros(rn,ns);
incorrect = zeros(tt,rn,ns);% trial number for correct
idxn = zeros(rn,ns);
for k = 1:ns
    for t = 1:rn
        %     separate into thresh 3dim = each separate reach
        td1(:,:,t,k) = ad(ad(:,4,k)==t,:,k);

        % sort based on prob
        [y,idx] = sort(td1(:,5,t,k));
        td1(:,:,t,k) = td1(idx,:,t,k);
        if half == 2
            td(:,:,t,k) = td1(ismember(td1(:,2,t,k),hindex(:,t)),:,t,k);
        else
            td(:,:,t,k) = td1(:,:,t,k);
        end
        if version == 1
        %   CORRECT
            idxc(t,k) = numel(find(td(:,6,t,k) == 1));
            correct(1:idxc(t,k),t,k) ...
                = td((td(:,6,t,k) == 1),2,t,k);
            correct(idxc(t,k):tt,t,k) = 0;
        %   INCORRECT
            idxn(t,k) = tt - idxc(t,k);
            incorrect(1:idxn(t,k),t,k) ...
                = td((td(:,6,t,k) == 0),2,t,k);
            incorrect(idxn(t,k):tt,t,k) = 0;
        end
        if version == 2
        %   CORRECT TEST OUT WITH NEW CSV
            idxc(t,k) = numel(find(td(:,6,t,k) == td(:,7,t,k)));
            correct(1:idxc(t,k),t,k) ...
                = td((td(:,6,t,k) == td(:,7,t,k)),2,t,k);
            correct(idxc(t,k):tt,t,k) = 0;
        %   INCORRECT
            idxn(t,k) = tt - idxc(t,k);
            incorrect(1:idxn(t,k),t,k) ...
                = td((td(:,6,t,k) ~= td(:,7,t,k)),2,t,k);
            incorrect(idxn(t,k):tt,t,k) = 0;

        end
        for i = 1:5
            if half == 2% take 2nd half
                sl = (b/2);
                sdx = 1+ (i-1)*25;
            else
                sl = b;%take all trials
                sdx = 1+(b)*(i-1);
            end
            if version == 1
%               PROB CHOOSE LEFT
                chleft(i,t,k) = (numel(td((td(sdx:sl*i,6,t,k) == 1 & td(sdx:sl*i,7,t,k) == 1))) ...
                    + numel(td((td(sdx:sl*i,6,t,k)== 0 & td(sdx:sl*i,7,t,k) == 2))))/sl;
                pt(k,:,t,i) = reshape(cumsum(td(sdx:sl*i,6,t,k)==td(sdx:sl*i,7,t,k))./reshape(1:(sl),sl,1),1,sl); 

%
            end
            if version == 2
%               PROB CHOOSE LEFT
            %  new "timestamp, trialNum, blockWidth, reach, leftprob, playerpos, Rewpos, forageDist, CollDist, totDist, optdist, diff, score";      
                chleft(i,t,k) = (numel(td((td(sdx:sl*i,6,t)== 1))))/sl;
                pt(k,:,t,i) = reshape(cumsum(td(sdx:sl*i,6,t,k))./reshape(1:(sl),sl,1),1,sl);
            end
        end        
    end
end
for i = 1:rn
    avg(:,i) = (sum(chleft(:,i,:),3)/ns);
end
avg1 = sum(avg,2)/rn;
% ==============================================================
% TASK1positionstuff
% ==============================================================
if nopos == 1
    clearvars tpd
    for k = 1:ns
        if np(k)< mpd
            tpd(1:np(k),:,k) = csvread(strcat(filepathp,fnamep), 2,0);
            tpd(np(k):mpd,:,k) = 0;
        else
            tpd(:,:,k) = csvread(strcat(filepathp,fnamep), 2,0);
        end
        for t = 1:rn%rn
            for i = 1:5
                rt{t,k} = tpd(ismember(tpd(:, 1, k),correct(:,t,k)) & tpd(:,4,k)==t,:,k);
                wn{t,k} = tpd(ismember(tpd(:, 1, k),incorrect(:,t,k)) & tpd(:,4,k)==t,:,k);
    %                 rt{t,k} = tpd(ismember(tpd(:, 1, k),correct(:,t,k)) & tpd(:,4,k)==t,:,k);
    %                 wn{t,k} = tpd(ismember(tpd(:, 1, k),incorrect(:,t,k)) & tpd(:,4,k)==t,:,k);
            end
        end
    end
end
% for i = 1:rn
%     rt{i} = cat(1,rt1{i,:});
%     wn{i} = cat(1,wn1{i,:});
% end
% ==============================================================
% FIGURES
% ==============================================================
figure(1);
    set(gca, 'ColorOrder', cl);
    set(gca,'fontsize',18);
    hold all;
    for i = 1:rn+1
        if i <rn+1
            plot(rprob,avg(:,i));
        else
            plot(rprob,avg1);
        end
    end
    if version == 1
        legend('r1','r2','avg all');
    end
    if version == 2
        legend('r1','r2','r3','r4','r5','avg all');
    end
    
    xlabel('P(reward)');
    ylabel('P(choose left)');
    title('P(choose L) as function of P(reward)');
if nopos == 1 
    for t = 1:rn
        figure(t+1);
%         hold all
        for i = 1:pn
        hold on            
            subplot(5,2,i);
            x = 1:length(pt(:,:,t,i));
            shadedErrorBar(x,pt(:,:,t,i),{@mean, @(x) 1*std(x)},'r',0);
            hold all
            plot(1:length(pt(:,:,t,i)),pt(:,:,t,i));
            title(['p(r)=' num2str(rprob(i))]);
            xlabel('trials');
        %     ylabel('choice prob');
        end
        a = axes;
        if half == 2
            t1 = title(['P(choose L) second half of trials at reach' num2str(t)]);
        else
            t1 = title(['P(choose L) at reach' num2str(t)]);
        end
        a.Visible = 'off';
        t1.Visible = 'on';
    end
    for r = 1:rn
        for k = ns
        figure((r+rn+1));
        xlabel('X');
        ylabel('Y');
%         hold all
            for i = 1: 5
                if version == 1
    %               CORRECT & rt{r,k}(:,4)==r
                    subplot(5,4,1+4*(i-1));
                    scatter(rt{r,k}(rt{r,k}(:,colp)== 2 & rt{r,k}(:,5)== rprob(i),6) ...
                    ,rt{r,k}(rt{r,k}(:,colp)== 2 & rt{r,k}(:,5)== rprob(i),7));
                    title(['correct choices p(r)=' num2str(rprob(i))]);
                    subplot(5,4,2+4*(i-1));
                    n = hist3([rt{r,k}(rt{r,k}(:,colp)== 2 & rt{r,k}(:,5)== rprob(i),6) ...
                    ,rt{r,k}(rt{r,k}(:,16)== 2 & rt{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(n);
    %               INCORRECT
                    subplot(5,4,3+4*(i-1));
                    scatter(wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),6) ...
                    ,wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),7));
                    title(['incorrect choices p(r)=' num2str(rprob(i))]);
                    subplot(5,4,4+4*(i-1));
                    nw = hist3([wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),6) ...
                    ,wn{r,k}(wn{r,k}(:,colp)== 2 & wn{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(nw);
                end
                if version == 2
    %               CORRECT  
                    subplot(5,4,1+4*(i-1));
                    scatter(rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i),6) ...
                    ,rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i),7));
                    title(['correct choices p(r)=' num2str(rprob(i))]);
                    subplot(5,4,2+4*(i-1));
                    n = hist3([rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i),6) ...
                    ,rt{r,k}(rt{r,k}(:,15)== 2 & rt{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(n);
    %               INCORRECT
                    subplot(5,4,3+4*(i-1));
                    scatter(wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i),6) ...
                    ,wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i) & wn{r,k}(:,4)==r,7));
                    title(['incorrect choices p(r)=' num2str(rprob(i))]);
                    subplot(5,4,4+4*(i-1));
                    nw = hist3([wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i),6) ...
                    ,wn{r,k}(wn{r,k}(:,15)== 2 & wn{r,k}(:,5)== rprob(i),7)],[10,10]);
                    imagesc(nw);
                end
            end
        end
        a = axes;
        if half == 2
            t1 = title(['Forage trajectories (second half of trials) reach ' num2str(k)]);
        else
            t1 = title(['Forage trajectories reach ' num2str(k)]);
        end
        a.Visible = 'off';
        t1.Visible = 'on';
    end
end
% figure(7);
% scatter(rt{r,k}(rt{r,k}(:,16)== 2 & rt{r,k}(:,5)== rprob(2)& rt{r,k}(:,4)==2,6) ...
%                 ,rt{r,k}(rt{r,k}(:,16)== 2 & rt{r,k}(:,5)== rprob(2)& rt{r,k}(:,4)==2,7));
% figure(8);
% scatter(wn{r,k}(wn{r,k}(:,16)== 2 & wn{r,k}(:,5)== rprob(2)& wn{r,k}(:,4)==2,6) ...
%                 ,wn{r,k}(wn{r,k}(:,16)== 2 & wn{r,k}(:,5)== rprob(2)& wn{r,k}(:,4)==2,7));
% 
% figure(4);