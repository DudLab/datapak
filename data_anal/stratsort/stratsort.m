function psorted = stratsort(tpd,ns,version,ad)
% trl = 457;%457 has TRAPLINE%33whack
% trialtot = (numel(unique(tpd(:,1,1)))-1);%500
% psort = zeros(500,3,ns);%subjchoice,correct/incorrect,trapline
psort = zeros(500*ns,3);%subjchoice,correct/incorrect,trapline
if version == 1
    lrb = tpd(1,10,1,1);
    x = [tpd(1,12,1), tpd(1,14,1)];
    y = sort(unique(tpd(:,13,1)), 'descend');
end
if version == 2
    lrb = tpd(1,11,1,1);
    x = sort(unique(tpd(:,13,1)));%larger x = right, smaller x left
    y = sort(unique(tpd(:,14,1)), 'descend');
end
dist = [sqrt((diff(x))^2+0); sqrt((diff(x))^2+(diff(y))^2)];
mp = [[mean(x),y(1)]; [mean(x),mean(y)]]%row is reach; smaller y=furtherreach
for k = 1:ns
    for p = 1:500*ns%trialtot500
%         ptrial = tpd(tpd(:,1,k)==p & tpd(:,end,k)==2,:,k);
%         lrb = tpd(1,11,1,1);
%         NuoLi = ptrial(([1; (sum(diff(ptrial(:,(version+5):(version+6)))~=0,2))])~=0,...
%             (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
%         pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);

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
%             rnum= tpd(p,5,k);
        end
        
        if numel(ptrial>0)
            [a ,cdist, b] = distance2curve(ptrial(:,(version+5):(version+6)),mp(rnum,:));
            ptrial1 = ptrial(find(ptrial(:,end-1)==2),:);
            ptrial2 = ptrial(find(ptrial(:,end-1)==3),:);
            NuoLi = ptrial1(([1; (sum(diff(ptrial1(:,(version+5):(version+6)))~=0,2))])~=0,...
                (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
%             NuoLi2 = ptrial2(([1; (sum(diff(ptrial2(:,(version+5):(version+6)))~=0,2))])~=0,...
%                 (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
            pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);
            if pthresh<0.5
                pchoice = 1;%1 left
                [a ,cdist2, b] = distance2curve(ptrial(:,(version+5):(version+6)),[x(2), y(1)]);
%                 [a ,cdist2, b] = distance2curve(NuoLi2(:,:),[x(2), y(1)]);
            else
                pchoice = 2;%2 right
                [a ,cdist2, b] = distance2curve(ptrial(:,(version+5):(version+6)),[x(1), y(rnum)]);
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
%             if (pchoice==1 & NuoLi(end,1)<lrb) | ( pchoice ==2 & NuoLi(end,1)>lrb)
                if cdist<(dist(rnum)/6) & cdist2<(ptrial(8+version,1))...
                    | (sum(ptrial(:,(version+5))< mp(rnum,1)+50 & ptrial(:,(version+5))>mp(rnum,1)-50 ...
                    & ptrial(:,(version+6))< (mp(rnum,2)+100) & ptrial(:,(version+6))>0)>0 ...
                & cdist2<(ptrial(8+version,1))*1.5) | cdist<(dist(rnum)/12)
                    trap = 1;
                else
                    trap = 0;
                end
            psort(p,:) = [abs(pchoice-2); rw; trap];
%             psort(p,:,k) = [abs(pchoice-2); rw; trap];
        else
            psort(p,:) = [2; 2; 2];
%             psort(p,:,k) = [2; 2; 2];
        end
    end
psorted = psort;
end