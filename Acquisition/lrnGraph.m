function lrnGraph(pre,post)

figure;
for i = 1:length(pre)
a = plot([0,1],[pre(i),post(i)],'k');hold on
a.LineWidth = 1.5;
a.Marker = '.';
a.MarkerSize = 25;
end

axis([-0.25 1.25 -0 1])
set(gcf,'Color','white')
set(gca,'fontsize',20)
grid on

% a = nanmean(pre);
% b = nanmean(post);
% figure;bar([a,b]);
% hold on
% out1 = bootstrp(100000,@nanstd,pre);out1 = mean(out1);
% out2 = bootstrp(100000,@nanstd,post);out2 = mean(out2);
% 
% 
% a = errorbar([a,b],[out1,out2]);
% a.LineWidth = 5;a.Color = [0 0 0];
% a.LineStyle = 'none';
xlabel(strcat(num2str(nanmean(pre)),'__________',num2str(nanmean(post))))


