function [dayCell,hot] = annotaterMatt

cd('C:\Users\khonegger\Documents\MATLAB\TunnelData\Matt')
a = cd('C:\Users\khonegger\Documents\MATLAB\TunnelData\Matt');

search1 = dir(a);
ct = 1;
filen = 1;

for ii = 1:length(search1)
    if search1(ii).name(1) == '.'
        continue
    end
    if search1(ii).isdir
        a2 = strcat(a,'\',search1(ii).name);
        search2 = dir(a2);
        cd(a2)
        ct = 1;
        for iii = 1:length(search2)
            if search2(iii).name(1) == '.'
                continue
            end
            if search2(iii).isdir
                a3 = strcat(a2,'\',search2(iii).name);
                cd(a3)
                search3 = dir(a3);
                for iv = 1:length(search3)
                    if search3(iv).name(1) == '.'
                        continue
                    end
                    if length(search3(iv).name) > 13
                        if search3(iv).name(end-13:end) == '-processed.mat'
                            dayCell{filen,1} = search3(iv).name;
                            dayCell{filen,2} = a3;
                            filen = filen+1;
                        end
                    end
                end
                cd(a2)
                continue
            end
                if length(search2(iii).name) > 13
                    if search2(iii).name(end-13:end) == '-processed.mat'
                        dayCell{filen,1} = search2(iii).name;
                        dayCell{filen,2} = a2;
                        filen = filen+1;
                    end
                end
            end
        end
end

load wrdClassify

for k = 1:length(dayCell)
    temp = [];
    cnt = 1;
    hot = [];
    charc = {};
    mrk = false(1,length(wrdClassify));
    temp = [];
    temp = lower(dayCell{k,1});
    if length(temp) > 13
        if temp(end-13:end) == '-processed.mat'
            temp = lower(temp(1:end-14));
        end
    elseif temp(end-3:end) == '.mat'
        temp = lower(temp(1:end-4));
    end
    for ll = 1:length(wrdClassify)
        if strfind(temp,wrdClassify{ll})
            if mrk(ll) == false
                charc{cnt} = wrdClassify{ll};
                cnt = cnt+1;
                mrk(ll) = true;
            end
        end
    end
    dayCell{k,3} = charc;
    dayCell{k,4} = mrk;
end













