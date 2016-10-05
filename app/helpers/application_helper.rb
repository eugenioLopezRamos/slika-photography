module ApplicationHelper

    size_breakpoints = [2000, 1500, 1100, 900, 700, 480, 100] #used on the file manager to convert uploads and on slidersContent
    #to know what image size options are available
    
    def full_title(page_title = '')
        base_title = "Leonardo Antonio PhotoArt"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end


    
end
