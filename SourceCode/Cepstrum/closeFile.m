%% Function to close file
% openedFile : opened file object
function closeFile(openedFile)
    status = fclose(openedFile);    % close file

    % error exception
    if status == 0
        disp('Could close file correctly')
    else
        disp('Can not close file correctly')
    end
end