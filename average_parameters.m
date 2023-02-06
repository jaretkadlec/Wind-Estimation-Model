function [avg_p] = average_parameters(array_of_param_arrays)
    
    % This function is used to average a set of parameter arrays in ascent
    % testing. The function must have at least one parameter array in the 
    % input variable and the length of the arrays must all be the same
    
    if (isempty(array_of_param_arrays))
        fprintf("\narray has no inputs\n");
    elseif (isa(array_of_param_arrays,'cell') == 0)
        fprintf("\nincorrect input type\n"); 
    else
        len = length(array_of_param_arrays{1});
        avg_p = zeros(len,1);
        for i = 1:length(array_of_param_arrays)
            temp = array_of_param_arrays{i};
            if (length(temp) ~= len)
                fprintf("\nParameter arrays have differing length\n");
                avg_p = -1;
                return;
            end
            for j = 1:len
                avg_p(j) = avg_p(j) + temp(j);
            end
        end
        for m = 1:len
            avg_p(m) = avg_p(m)/length(array_of_param_arrays);
        end
    end
    
return
    
    
        
        