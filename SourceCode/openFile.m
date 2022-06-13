%% Function to open file
% sourceFilePath : file path would like to open
% permission : file open mode
function [openedFile] = openFile(sourceFilePath, permission)
    [openedFile, errmsg] = fopen(sourceFilePath, permission); % open file

    % error exception
    if openedFile < 0
        disp('openedFile : ', openedFile);
        disp('errmsg : ', errmsg);
    else
        disp('Could open file correctly');
    end
end