function mattBox(cntO,expO)

figure;
%How many files in each folder:
ffiles = 1;
cntnum = 3;
expnum = 3;

ccpltt = [];xxpltt = [];
cmrk = [];xmrk = [];

for tt = 1:length(cntO)
    ccpltt = [ccpltt,cntO{tt}];
    xxpltt = [xxpltt,expO{tt}];
    cmrk = [cmrk,zeros(1,length(cntO{tt}))+tt];
    xmrk = [xmrk,zeros(1,length(expO{tt}))+tt-0.5];
end

filt = abs(ccpltt) == inf;
filt2 = abs(xxpltt) == inf;
if ~isempty(filt)
    ccpltt = ccpltt(~filt);
    cmrk = cmrk(~filt);
end
if ~isempty(filt2)
    xxpltt = xxpltt(~filt2);
    xmrk = xmrk(~filt2);
end

c = notBoxPlot(ccpltt,cmrk);
hold on
h = notBoxPlot(xxpltt,xmrk);

for i = 1:length(expO)
c1 = c(i).semPtch;set(c1,'FaceColor',[0.9 0.9 1]);
h1 = h(i).semPtch;set(h1,'FaceColor',[1 0.6 0.6]);
end

s  = xlabel('Experimental               Control-chrimson')
set(s,'FontSize',20)
s  = ylabel('Learning score')
set(s,'FontSize',20)
axis([0 1.5 -0.3 1])