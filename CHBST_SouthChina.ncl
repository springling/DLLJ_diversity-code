begin
filedir  = "/sky1/home/zhouchling/data/CMABSTdata/"
ysta = 1998
yend = 2023
;x1 = (/106.0,110.5,110.5,106.0,106.0/);北部湾
;y1 = (/18.0,18.0,22.5,22.5,18.0/)

minlonA = 105
maxlonA = 120
minlatA = 15
maxlatA = 30

fidir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
fnameA = "CHBST_SouthChina.txt"
hlist = [/"66666"/]
;write_table(fnameA, "w", hlist, "%s")
;write_table(fnameB, "w", hlist, "%s")
;write_table(fnameC, "w", hlist, "%s")
;write_table(fnameD, "w", hlist, "%s")
;write_table(fnameE, "w", hlist, "%s")
;write_table(fnameF, "w", hlist, "%s")
do year = ysta,yend 
    cma = "CH"+year+"BST.txt"
    nrow = numAsciiRow(filedir+cma)
    track_cma = asciiread(filedir+cma, -1, "string")
    do i = 0,nrow-1
        head1 = stringtofloat(str_get_field(track_cma(i),1," "))
        if(head1.eq.66666) then
            numline_cma = stringtoint(str_get_field(track_cma(i),3," "))
            YYYYMMDDHH_cma = new(numline_cma,"string")
            lat_cma = new(numline_cma,"float")
            lon_cma = new(numline_cma,"float")
            vmax_cma = new(numline_cma,"float")
            tcname_cma = stringtoint(str_get_field(track_cma(i),2," "))
            tcname_cma2 = str_get_field(track_cma(i),8," ")
            do j=0,numline_cma-1
                YYYYMMDDHH_cma(j) = str_get_field(track_cma(i+j+1),1," ")
                lat_cma(j) = stringtofloat(str_get_field(track_cma(i+j+1),3," "))/10.
                lon_cma(j) = stringtofloat(str_get_field(track_cma(i+j+1),4," "))/10.
                vmax_cma(j) = stringtofloat(str_get_field(track_cma(i+j+1),6," "))
            end do
            i = i+numline_cma
            DateChar = stringtochar(YYYYMMDDHH_cma)
            YYYY = chartostring(DateChar(:,0:3))
            MM = chartostring(DateChar(:,4:5))
            DD = chartostring(DateChar(:,6:7))
            HH = chartostring(DateChar(:,8:9))
            ;print(lat_cma)
            ;print(lat_cma)
            
            ind_num = ind((lon_cma.ge.minlonA).and.(lon_cma.le.maxlonA).and.(lat_cma.ge.minlatA).and.(lat_cma.le.maxlatA))
            if (.not.all(ismissing(ind_num))) then
                alist = [/YYYY(ind_num),MM(ind_num),DD(ind_num),HH(ind_num),lat_cma(ind_num),lon_cma(ind_num)/]
                write_table(fidir+fnameA, "a", alist, "%s%s%s%s%5.1f%5.1f")
                delete(alist)
            end if
            delete(ind_num)
        end if
        delete(numline_cma)
        delete(YYYYMMDDHH_cma)
        delete(lat_cma)
        delete(lon_cma)
        delete(vmax_cma)
        delete(tcname_cma)
        delete(tcname_cma2)
        delete(DateChar)
        delete(YYYY)
        delete(MM)
        delete(DD)
        delete(HH)
    end do
    delete(track_cma)
    delete(head1)
end do

end