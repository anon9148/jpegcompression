[path,user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('ERROR'),'Error','Error');
    return;
end
path