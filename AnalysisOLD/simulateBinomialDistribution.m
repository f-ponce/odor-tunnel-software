day = 1;
ct = 0;

% get the number of choices made by each fly
for i = 1:length(choices)
    for ii = 1:length(choices{day,i})
        ct = ct + 1;
        n(ct) = length(choices{day,i}{ii});
    end
end

% discard any flies making < 15 choices
%n(n<15) = [];
n(:,find(isnan(comb(day,:)))) = [];

combBothDays = comb;
%combBothDays(:,find(isnan(combBothDays(1,:)))) = [];
%combBothDays(:,find(isnan(combBothDays(2,:)))) = [];

nSamp = 21;
edgs = linspace(0,1,nSamp);

% iteratively make a binomial sample w/appropriate number of choices
for k = 1:1e3
    %tmp = random('bino', n, nanmean(combBothDays(day,:))) ./ n;
    tmp = random('bino', n, nanmean(comb(day,:))) ./ n;
    out(k,:) = histc(tmp, edgs);
end

% compute mean count and 95% CI for each hist bin
p = mean(out);

for i = 1:length(p)
    ci(i,:) = prctile(out(:,i),[2.5,97.5]);
end

%x = histc(combBothDays(day,:), edgs);
x = histc(comb(day,:), edgs);

hold on
plot(p/sum(p),'.-', 'Color', [0.5 0.5 0.5], 'lineWidth', 3)
plot(ci(:,1)/sum(p), 'Color', [0.5 0.5 0.5])
plot(ci(:,2)/sum(p), 'Color', [0.5 0.5 0.5])
plot(x/sum(x),'.-b', 'lineWidth', 3)

xlim([1 nSamp])
set(gca, 'XTick', 1:nSamp)
set(gca, 'XTickLabel', edgs)


