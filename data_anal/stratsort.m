function psorted = stratsort(tpd,ns,version)
% trl = 457;%457 has TRAPLINE%33whack
% trialtot = (numel(unique(tpd(:,1,1)))-1);%500
psort = zeros(500,3,ns);%subjchoice,correct/incorrect,trapline
for k = 1:ns
    for p = 1:500%trialtot
        ptrial = tpd(tpd(:,1,k)==p & tpd(:,end,k)==2,:,k);
        lrb = tpd(1,11,1,1);
        NuoLi = ptrial(([1; (sum(diff(ptrial(:,(version+5):(version+6)))~=0,2))])~=0,...
            (version+5):(version+6));%remove duplicate time-adjacent point [x,y]%fasterprocessing
        pthresh = sum(NuoLi(:,1)>lrb)/size(NuoLi,1);
        if pthresh<0.5
            pchoice = 1;%1 left
        else
            pchoice = 0;%2 right
        end
        if pchoice == ptrial(2,4)
            rw = 1;
        else
            rw = 0;
        end
        if (NuoLi(end,1)<lrb & pchoice==1) | (NuoLi(end,1)>lrb & pchoice==2)
            trap = 0;
        else
            trap = 1;
        end
        psort(p,:,k) = [pchoice; rw; trap];
    end
end
psorted = psort;
end