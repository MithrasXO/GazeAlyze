function GA_gui_set(mainGUI, flag)

%flag 1 = maingui set

if flag == 1
    
    %Generate Data for Listbox Parameter Overview
    mfiledata = gencode(mainGUI.data);
    mfiledatasize = length(mfiledata);
    
    for k=1:mfiledatasize
        mfiledata{1,k}= mfiledata{1,k}(5:end);
    end
    
    mfiledata= (mfiledata)';
    set(mainGUI.listbox_overview, 'String', mfiledata);
    set(mainGUI.listbox_overview, 'Max', length(mfiledata));
    set(mainGUI.listbox_overview, 'Value', []);
    
    %Pass data to main window
    mainGUI_handle = findobj('type','figure','tag','GA_mainWin');
    guidata(mainGUI_handle, mainGUI);
    
end
