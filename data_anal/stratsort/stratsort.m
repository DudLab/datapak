subji = 1;
trl = 457;%457 has TRAPLINE%33whack

psort = zeros(size(ad,1),3,ns);%subjchoice,correct/incorrect,trapline
for k = 1:ns
    for p = 1:size(ad,1)
        ptrial = tpd(tpd(:,1,k)==p & tpd(:,colp,k)==2,:,k);
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
        if NuoLi(end,1)<lrb
            trap = 0;
        else
            trap = 1;
        end
        psort(p,:,k) = [pchoice; rw; trap];
    end
end
% trapline  = find(psort(:,3
	ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
	t = text(0.5, 1,['rpos=' num2str(ad(trl,(6+version),subji)), ...
        ', prc=' num2str(pchoice) ', prw=' num2str(rw) ', trap=' num2str(trap)],'HorizontalAlignment' ...
	,'center','VerticalAlignment', 'top');
	t.FontSize = 18;