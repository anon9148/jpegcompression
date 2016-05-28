function matrix = zigzag(M)
  
    matrix = [];
    count=0;
    row=size(M,1);
   
    for u=2:row
        %v=1:u;
        %w=1:u;
        if(mod(u,2)==0)
            for v=1:1:u
                for w=u:-1:1
                    M(v,w)=matrix(count)
                    count=count+1
                end
            end
        else
            for v=u:-1:1
                for w=1:1:u
                    M(v,w)=matrix(count)
                    count=count+1
                end
            end
        end
    end
    for u=2:row
        v=u:row;
        w=u:row;
        if(mod(u,2)==0)
            for v=2:1:u
                for w=u:-1:2
                    M(v,w)=matrix(count)
                    count=count+1
                end
            end
        else
            for v=u:-1:2
                for w=2:1:u
                    M(v,w)=matrix(count)
                    count=count+1
                end
            end
        end
    end  %end if
end