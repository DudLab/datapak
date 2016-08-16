function psorted = stratsort(tpd,ns,version,ad)
% trl = 457;%457 has TRAPLINE%33whack
% trialtot = (numel(unique(tpd(:,1,1)))-1);%500
% psort = zeros(500,3,ns);%subjchoice,correct/incorrect,trapline
psort = zeros(500*ns,3);%subjchoice,correct/incorrect,trapline
if version == 1
    lrb = tpd(1,10,1);
    x = [tpd(1,12), tpd(1,14)];
    y = sort(unique(tpd(:,13)), 'descend');
end
if version == 2
    lrb = tpd(1,11,1,1);
    x = sort(unique(tpd(:,13)));%larger x = right, smaller x left
    y = sort(unique(tpd(:,14)), 'descend');
end
tgd = tpd(1,(8+version));
x0 = tpd(1,(9+version));
y0 = tpd(1,(10+version));
dist = [sqrt((diff(x))^2+0); sqrt((diff(x))^2+(diff(y))^2)];
mp = [[mean(x),y(1)]; [mean(x),mean(y)]]%row is reach; smaller y=furtherreach

    for p = 1:500*ns%trialtot500
        if version == 1
            ptrial = tpd(tpd(:,1)==p,:);
            rnum = ad(p,4);
%             ptrial = tpd(tpd(:,1,k)==p,:,k);
%             rnum = ad(p,4);
        end
        if version == 2
            ptrial = tpd(tpd(:,1)==p,:);
            rnum= tpd(p,5);
%             ptrial = tpd(tpd(:,1,k)==p,:,k);
%             rnum= tpd(p,5,k);ad,version+6=8
        end
        
        if numel(ptrial>0)
            [a ,cdist, b] = distance2curve(ptrial(:,(version+5):(version+6)),mp(rnum,:));
            ptrial1 = ptrial(find(ptrial(:,end-1)==2),:);
%             ptrial2 = ptrial(find(ptrial(:,end-1)==3),:);
            NuoLi = ptrial1(([1; (sum(diff(ptrial1(:,(version+5):(version+6)))~=0,2))])~=0,...
                (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
%             NuoLi2 = ptrial2(([1; (sum(diff(ptrial2(:,(version+5):(version+6)))~=0,2))])~=0,...
%                 (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
            pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);
            deriv = numel(findpeaks(movAv(abs(diff(NuoLi(:,1))./diff(reshape(1:size(NuoLi,1),size(NuoLi,1),1))),round(length(NuoLi)/12))));
            if deriv<30
            if pthresh<0.5
                pchoice = 1;%1 left
                [a ,cdist2, b] = distance2curve(NuoLi(:,:),[x(2), y(1)]);
%                 [a ,cdist2, b] = distance2curve(NuoLi2(:,:),[x(2), y(1)]);
            else
                pchoice = 2;%2 right
                [a ,cdist2, b] = distance2curve(NuoLi(:,:),[x(1), y(rnum)]);
%                 [a ,cdist2, b] = distance2curve(NuoLi2(:,:),[x(1), y(rnum)]);          
            end
            if nargin ==3 & version == 2
                if (pchoice == ptrial(2,4))
                    rw = 1;
                else
                    rw = 0;
                end
            end
            if nargin == 4 & version == 1
                if (version == 1 & pchoice == ad(p,7))%ad(p,7,k))
                    rw = 1;
                else
                    rw = 0;
                end
            end
            if cdist2>ptrial(1,8+version)*1.5
                strat = 1;
            else
                if incircle(x0,y0,NuoLi,tgd)==1
                    strat = 2;%double reach it is
                else
                    strat = 3;
                end
            end
            psort(p,:) = [abs(pchoice-2); rw; strat];
            else
                psort(p,:) = [abs(pchoice-2); rw; 9];
            end
        else
            if version == 1
                psort(p,:) = [sum((ad(p,6)==1 & ad(p,7)==1) | (ad(p,6)==0 & ad(p,7)==2)); 9; 9];
            else
                psort(p,:) = [ad(p,(version+7)); 9; 9];
            end
%             psort(p,:,k) = [2; 2; 2];
        end
    end
psorted = psort;
end
%check if increasing points(going back to start) in weighted circle
function [ yn ] = incircle(x0,y0,NuoLi,tgd)%CHECK WITH V2 TGD
    deriv  = [0, movAv(diff(NuoLi(:,2)),round(length(diff(NuoLi(:,2)))/6))];
    yn = (min(sqrt(sum(power(NuoLi((deriv>0),:)...
    -repmat([x0, y0],[numel(NuoLi((deriv>0)))...
    ,1]),2),2)))<(tgd*1.5));
end