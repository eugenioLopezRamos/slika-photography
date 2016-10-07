module ApplicationHelper
    
    def full_title(page_title = '')
        base_title = "Leonardo Antonio PhotoArt"
        if page_title.empty?
            base_title
        else
            page_title + " | " + base_title
        end
    end
    

    def size_breakpoints

      [2000, 1500, 1100, 900, 700, 480, 100] 

    #defines the breakpoints. If the img_width is higher than a given breakpoint, reduce it to all breakpoints below it
 
    #        img_width > 2000 ? -> 2000 & 1500 & 1100 & 900 & 700 & 480 & 100
    # 2000 > img_width > 1500 ? -> 1500 & 1100 & 900 & 700 & 480 & 100
    # 1500 > img_width > 1100 ? -> 1100 & 900 & 700 & 480 & 100
    # 1100 > img_width > 900 ? -> 900 & 700 & 480 & 100
    # 900 > img_width > 700 ? -> 700 & 480 & 100
    # 700 > img_width > 480 ? -> 480 & 100
    # 480 > img_width ? -> img_width & 100

    end

end
