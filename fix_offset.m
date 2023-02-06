function [x] = fix_offset(x,col,u)
    
    [rows,cols] = size(x);
    if (u == 1)
        if (cols > 1)
            if (x(1,col) > x(rows,col))
                diff = x(1,col);
            else
                diff = x(rows,col);
            end

            if (abs(diff) > 0.005)
                for i = 1:rows
                    x(i,col) = x(i,col) - diff;
                end
            end
        else
            if (abs(x(1)) > abs(x(rows)))
                diff = x(1);
            else
                diff = x(rows);
            end

            if (abs(diff) > 0.005)
                for i = 1:rows
                    x(i) = x(i) - diff;
                end
            end
        end
 
    elseif (cols > 1 && u == 0)
        if (abs(0-x(1,col)) > 0.005)
            offset = x(1,col);
            for i = 1:rows
                x(i,col) = x(i,col) - offset;
            end
        end
        
    elseif (cols == 1 && u == 0) 
        if (abs(0-x(1)) > 0.005)
            offset = x(1);
            for i = 1:rows
                x(i) = x(i) - offset;
            end
        end
    end  
end
    
    
    
    