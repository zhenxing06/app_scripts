# 打开配置文件:
# vim /root/.vimrc

# 添加如下信息：
autocmd BufNewFile *.sh exec ":call AddTitleForShell()"
function  AddTitleForShell()
    call append(0,"#!/bin/bash")
    call append(1,"# **********************************************************")
    call append(2,"# * Author        : fml")
    call append(3,"# * Email         : asdfasdfasd@163.com")
    call append(4,"# * Create time   : ".strftime("%Y-%m-%d %H:%M"))
    call append(5,"# * Filename      : ".expand("%:t"))
    call append(6,"# * Description   : xxxxxxxxxxxxxxxxxxxxxxxxxxx")
    call append(7,"# **********************************************************")
endfunction

##
:set nonu

## 
:set paste
