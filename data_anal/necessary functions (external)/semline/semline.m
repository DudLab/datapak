function [ mm,ss ] = semline( in, binw, colplot)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here\
% matrix or vector columns
% if nargin==1
%   binw=1;
% end
% if nargin==2
%   if isstr(varagin{2})
%      binw=1;
%    end
% end

mm=moveavg(nanmean(in), binw);
ss=sem(in);

if exist(colplot)
  shadedErrorBar(1:length(mm),mm,ss,colplot,1);
  else
  shadedErrorBar(1:length(mm),mm,ss,colplot,1);
end

