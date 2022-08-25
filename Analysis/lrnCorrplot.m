function lrnCorrplot(exp1,exp2,cc)
if nargin < 3
    cc = false;
end
if cc == false
figure;
else
    hold on
end

ind = exp1 < -0.9;ind2 = exp2 < -0.9;
ind = ind+ind2;d = ind >=1;ind(d) = 1;
exp1 = exp1(~ind);exp2 = exp2(~ind);


[corrScore,pVal] = corrcoef(exp1,exp2,'rows','pairwise')
a = scatter(exp1,exp2);
axis([-1 1 -1 1])
if cc
    a.MarkerFaceColor = 'r';
    a = lsline;
    a(1).Color = [1 0.7 0.7];
    x1 = 0.25;y1 = 0.85;
    x2 = 0.25;y2 = 0.75;
    cl = [1 0 0];
else
    a.MarkerFaceColor = 'b';
    a = lsline;
    a(1).Color = [0.7 0.7 1];
    x1 = 0.75;y1 = 0.85;
    x2 = 0.75;y2 = 0.75;
    cl = [0 0 1];
end

a(1).LineWidth = 2.5;

text1 = strcat('r-value: ',num2str(corrScore(2)));
a = text(x1,y1,text1,'HorizontalAlignment','right');
a.FontSize = 15;
a.Color = cl;
text1 = strcat('p-value: ',num2str(pVal(2)));
a = text(x2,y2,text1,'HorizontalAlignment','right');
a.FontSize = 15;
a.Color = cl;