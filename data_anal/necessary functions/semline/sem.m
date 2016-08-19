function [ out ] = sem( in )
out=nanstd(in)./sqrt(sum(~isnan(in)));


end

