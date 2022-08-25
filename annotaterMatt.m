function [dayCell,hot] = annotaterMatt

cd('C:\Users\khonegger\Documents\MATLAB\TunnelData\Matt')
a = cd('C:\Users\khonegger\Documents\MATLAB\TunnelData\Matt');

search1 = dir(a);
ct = 1;
day = 1;

for ii = 1:length(search1)
    if search1(ii).name(1) == '.'
        continue
    end
    if search1(ii).isdir
        a2 = strcat(a,'\',search1(ii).name);
        search2 = dir(a2);
        cd(a2)
        ct = 1;
        dayCell{1,day} = search1(ii).name;
        
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
                    if search3(iv).name(end-3:end) == '.mat'
                        dayCell{2,day}{ct} = search3(iv).name;
                        ct = ct+1;
                    end
                end
                cd(a2)
                continue
            end
            if search2(iii).name(end-3:end) == '.mat'
                dayCell{2,day}{ct} = search2(iii).name;
                ct = ct+1;
            end
        end
        day = day+1;
    end
end

load wrdClassify

for l = 1:length(dayCell)
    temp = [];
    cnt = 1;
    hot = [];
    charc = {};
    mrk = false(1,length(wrdClassify));
    for k = 1:length(dayCell{2,l})
        temp = [];
        temp = lower(dayCell{2,l}{k});
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
    end
    dayCell{3,l} = charc;
    dayCell{4,l} = mrk;
end
    
    
    
    
    
    
    
    
    
    
    
    
    
