function [f_pre,f_post,geno] = color_pers(directory,folder1,name,numm)


digg = numm;
inddxx = [];final_d2 = [];final_d1 = [];final_d3 = [];f_pre = [];f_post = [];
done = 0;

while done <= digg
    if done == 0
        cd(directory)
        re = cd(strcat(directory,folder1));
        
    elseif done == 1
        cd(directory)
        re = cd(strcat(directory,folder1));
        name = strcat(name(1:(end-1)),'2');
    elseif done == 2
        cd(directory)
        re = cd(strcat(directory,folder1));
        name = strcat(name(1:(end-1)),'3');
    elseif done == 3
        cd(directory)
        re = cd(strcat(directory,folder1));
        name = strcat(name(1:(end-1)),'4');
    elseif done == 4
        cd(directory)
        re = cd(strcat(directory,folder1));
        name = strcat(name(1:(end-1)),'5');
    end
    a1 = dir(name);
    cd(name)
    values = [];pree = [];postt = [];diffi = [];h_1 = [];h_2 = [];geno = [];pers = [];
    counter_re = 1;
    for i = 1:length(a1)
        if a1(i).name(1) == '.' || a1(i).name(end-4) ~= 'd' || lower(a1(i).name(1)) == 'o'
            continue
        else
            i1 = i;
            load(a1(i1).name)
            i = i1;
            a1(i1).name
            x = find(flyTracks.shock(:,1));
            ttt = flyTracks.shock(:,1);
            if counter_re == 1
                parse = find((a1(i1).name) == '1');
                counter_re = 2;
            end
            iden = str2num(a1(i1).name(parse(1)));
            times = zeros(1,length(flyTracks.velocity(:,1)));
            mch = [];
            decci = false;reppi = 0;
            
            
            
            
            pre = find((flyTracks.relTimes > flyTracks.stim{2}(1) & flyTracks.relTimes < flyTracks.stim{2}(end)));
            post = find((flyTracks.relTimes > flyTracks.stim{end-2}(1) & flyTracks.relTimes < flyTracks.stim{end-2}(end)));
            
            if strcmp(flyTracks.stim{12}{1},'Blue')
                blu = true;
                display('Learn Blue')
            else
                blu = false;
                display('Learn Green')
            end
            
            if strcmp(flyTracks.stim{4}{1},'Green')
                revvi = false;
            else
                revvi = true;
            end
            
            
            
            if done == 0
                pre_r = (nan(1,15));post_r = (nan(1,15));
            end
            for i = 1:flyTracks.nFlies
                ll = min(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
                mm = max(flyTracks.headPosition(flyTracks.inCorridor(i).enterFr(:),2,i));
                if isempty(ll)
                    sideA1(i) = nan;sideA2(i) = nan;sideB1(i) = nan;sideB2 = nan;pre_r(i) = nan;post_r(i) = nan;diffy(i) = nan;score(i) = nan;
                    continue
                end
                
                
                
                
                %                 sidee{1,1} = nansum(flyTracks.headPosition(pre,2,i) < ll);
                %                 sidee{1,2} = nansum(flyTracks.headPosition(pre,2,i) > mm);
                %
                %                 sidee{2,1} = nansum(flyTracks.headPosition(post,2,i) < ll);
                %                 sidee{2,2} = nansum(flyTracks.headPosition(post,2,i) > mm);
                
                sidee{1,1} = 1-(abs(mean(flyTracks.headPosition(pre(1:7200),2,i))-11)/215);
                sidee{1,2} = (abs(mean(flyTracks.headPosition(pre(1:7200),2,i))-11)/215);
                sidee{2,1} = 1-(abs(mean(flyTracks.headPosition(post(1:7200),2,i))-11)/215);
                sidee{2,2} = (abs(mean(flyTracks.headPosition(post(1:7200),2,i))-11)/215);
                
                
                
                
                
                ccntt = 1;
                for odoc = [flyTracks.stim{4}(1),flyTracks.stim{end}(1)]
                    if blu
                        scr(1) = sidee{1,1};
                        if revvi == false
                            scr(1) = sidee{1,2};
                        end
                        scr(2) = sidee{2,2};
                    else
                        scr(1) = sidee{1,2};
                        if revvi == false
                            scr(1) = sidee{1,1};
                        end
                        scr(2) = sidee{2,1};
                    end
                    
                        
                    post_r(i) = scr(2);
                    pre_r(i) = scr(1);
                    
                    score(i) = (post_r(i)-pre_r(i));
                end
            end
            %         metric = score.*diffy;
            values = [values,score];
            try
                if ~isempty(flyTracks.genotype)
                    gen1 = [flyTracks.genotype];
                    cattle = true;
                end
            catch
                gen1 = [nan(1,flyTracks.nFlies)];
                cattle = false;
            end
            try
                if ~isempty(flyTracks.pers)
                    pers = nan(1,15);pers2 = nan(1,15);cnt = 1;
                    for i = 1:length(flyTracks.pers)
                        pers(flyTracks.pers(i)) = pre_r(cnt);
                        pers2(flyTracks.pers(i)) = post_r(cnt);
                        cnt = cnt+1;
                    end
                    pre_r = pers;
                    post_r = pers2;
                    gen1 = flyTracks.genotype;
                end
            catch
            end
            pree = [pree, pre_r];
            postt = [postt, post_r];
            geno = [geno,gen1];
            clear post_r pre_r
            close;
            indent{(done+1),iden} = score;
            
        end
        close
        
    end
    done = done+1;
    f_pre = [f_pre,pree];
    f_post = [f_post,postt];
end






