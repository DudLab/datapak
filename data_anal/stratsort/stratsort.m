function psorted = stratsort(tpd,ns,version,ad)
% trl = 457;%457 has TRAPLINE%33whack
% trialtot = (numel(unique(tpd(:,1,1)))-1);%500
psort = zeros(500,3,ns);%subjchoice,correct/incorrect,trapline
if version == 1
    side = abs(tpd(1,14,1)-tpd(1,10,1));
end
if version == 2
    side = abs(tpd(1,13,1)-tpd(1,11,1));
end
for k = 1:ns
    for p = 1:500%trialtot
%         ptrial = tpd(tpd(:,1,k)==p & tpd(:,end,k)==2,:,k);
%         lrb = tpd(1,11,1,1);
%         NuoLi = ptrial(([1; (sum(diff(ptrial(:,(version+5):(version+6)))~=0,2))])~=0,...
%             (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
%         pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);

        if version == 1
            lrb = tpd(1,10,1,1);
            ptrial = tpd(tpd(:,1,k)==p,:,k);
        end
        if version == 2
            lrb = tpd(1,11,1,1);
            ptrial = tpd(tpd(:,1,k)==p,:,k);
        end
        if numel(ptrial>0)
            ptrial1 = ptrial(find(ptrial(:,end)==2),:);
            ptrial2 = ptrial(find(ptrial(:,end)==3),:);
            NuoLi = ptrial1(([1; (sum(diff(ptrial1(:,(version+5):(version+6)))~=0,2))])~=0,...
                (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
            NuoLi2 = ptrial2(([1; (sum(diff(ptrial2(:,(version+5):(version+6)))~=0,2))])~=0,...
                (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
            pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);
%             pthresh2 = sum(NuoLi2(:,1)>lrb)/size(NuoLi2,1);
            pthresh2 = side;
            if pthresh<0.5
                pchoice = 1;%1 left
            else
                pchoice = 2;%2 right
            end
            if nargin ==3 & version == 2
                if (pchoice == ptrial(2,4))
                    rw = 1;
                else
                    rw = 0;
                end
            end
            if nargin == 4 & version == 1
                if (version == 1 & pchoice == ad(p,7,k))
                    rw = 1;
                else
                    rw = 0;
                end
            end
            if (NuoLi(end,1)<lrb & pchoice==1) | (NuoLi(end,1)>lrb & pchoice==2)
%                 if (pthresh2>0.5 & pchoice == 1) | (pthresh2<0.5 & pchoice == 2)
                    if (pchoice==1 & min(ptrial1(:,1))<(lrb-(side/2)))...
                    | (pchoice==2 & max(ptrial1(:,1))>(lrb+(side/2)))
                        trap = 1;
                    else
                        trap = 0;
                    end
%                 else
%                     trap = 0;
% %                 end 
            else
                trap = 1;
            end
            psort(p,:,k) = [abs(pchoice-2); rw; trap];
        else
            psort(p,:,k) = [2; 2; 2];
        end
    end
end
psorted = psort;
end