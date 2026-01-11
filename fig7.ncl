begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f1 = addfile(filedir + "Calculate_beibu_type.nc","r")
;f1 = addfile("/wind1/home/zhouchling/myncl/Calculate_beibu_type.nc","r")
type1 = f1->type
f2 = addfile(filedir + "Calculate_NSCS_type.nc","r")
;f2 = addfile("/wind1/home/zhouchling/myncl/Calculate_NSCS_type.nc","r")
type2 = f2->type

yyyymmddhh = new((/4392/),"integer")
i=0
do im = 4,9
    tt = days_in_month(2001,im)
    do id = 1,tt
        do ih = 0,23
            yyyymmddhh(i) = (2001*1000000 + im*10000 + id*100 + ih)
            i=i+1
        end do
    end do
end do

ntim  = dimsizes(yyyymmddhh)
yyyy  = yyyymmddhh/1000000 
;print(max(yyyy))
mmddhh = yyyymmddhh%1000000             
;print(max(mmddhh))
mm    = mmddhh/10000
;print(max(mm))
ddhh    = mmddhh%10000                 
;print(max(ddhh))
dd    = ddhh/100                          
;print(max(dd))
hh    = ddhh%100
mn    = dd
sc    = dd
mn    = 0
sc    = 0
units  = "hours since 2001-04-01 00:00:00" 
time   = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, 0)
time!0 = "time"
utc_date = cd_calendar(time, 0)
month  = tointeger(utc_date(:,1))    ; use sprinti 
day    = tointeger(utc_date(:,2))
hour   = tointeger(utc_date(:,3))

num_month = new((/2,6/),"integer")
num_hour   = new((/2,24/),"integer")
num_type = new((/24,6,6/),"integer")

num_month = 0
num_hour   = 0
num_type = 0

do year = 2001,2023
    iyr = year-2001
    ind_num1 = ind(type1(iyr,:).eq.1)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i)) 
            num_month(0,imon) = num_month(0,imon) + 1
            num_hour(0,ihour) = num_hour(0,ihour) + 1
            num_type(ihour,imon,0) =  num_type(ihour,imon,0) +1
        end do
    end if
    delete(ind_num1)

    ind_num1 = ind(type1(iyr,:).eq.2)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i))
            num_type(ihour,imon,1) =  num_type(ihour,imon,1) +1
            num_month(0,imon) = num_month(0,imon) + 1
            num_hour(0,ihour) = num_hour(0,ihour) + 1
        end do
    end if
    delete(ind_num1)

    ind_num1 = ind(type1(iyr,:).eq.3)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i))
            num_type(ihour,imon,2) =  num_type(ihour,imon,2) +1
            num_month(0,imon) = num_month(0,imon) + 1
            num_hour(0,ihour) = num_hour(0,ihour) + 1
        end do
    end if
    delete(ind_num1)

    ind_num1 = ind(type2(iyr,:).eq.1)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i))
            num_type(ihour,imon,3) =  num_type(ihour,imon,3) +1
            num_month(1,imon) = num_month(1,imon) + 1
            num_hour(1,ihour) = num_hour(1,ihour) + 1
        end do
    end if
    delete(ind_num1)

    ind_num1 = ind(type2(iyr,:).eq.2)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i))
            num_type(ihour,imon,4) =  num_type(ihour,imon,4) +1
            num_month(1,imon) = num_month(1,imon) + 1
            num_hour(1,ihour) = num_hour(1,ihour) + 1
        end do
    end if
    delete(ind_num1)

    ind_num1 = ind(type2(iyr,:).eq.3)
    if (.not.all(ismissing(ind_num1))) then
        do i = 0,dimsizes(ind_num1)-1
            imon = month(ind_num1(i)) - 4
            ihour = hour(ind_num1(i))
            num_type(ihour,imon,5) =  num_type(ihour,imon,5) +1
            num_month(1,imon) = num_month(1,imon) + 1
            num_hour(1,ihour) = num_hour(1,ihour) + 1
        end do
    end if
    delete(ind_num1)
end do

num_type_mon = dim_sum_n(num_type,0)
num_type_day = dim_sum_n(num_type,1)
printVarSummary(num_type_day)

;print(max(num_month))
;print(min(num_month))
;print(max(num_hour(0,:)))
;print(max(num_hour(1,:)))
;print(min(num_hour))
print(max(num_type))
print(min(num_type))
print(max(num_type_mon))
print(min(num_type_mon))
print(max(num_type_day))
print(min(num_type_day))
time_month = (/"Apr","May","Jun","Jul","Aug","Sep"/)
time_hr = (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23/)
num_type!1 = "month"
num_type&month = time_month
num_type!0 = "hour"
num_type&hour = time_hr


plot = new(6, "graphic")
pngname = "Calculate_monthly_day_type"
type = "pdf"
wks = gsn_open_wks(type,pngname)
cmap = read_colormap_file("WhiteBlueGreenYellowRed")
res = True 
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnMaximize     =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
;res@gsnMaximize     =           True
;res@pmTickMarkDisplayMode       = "Always" 

;------tickmark settings
res@tmXBLabelFontHeightF        =           0.022        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.022
res@tmXBMajorLengthF            =           0    ; change the tickmark length
res@tmYLMajorLengthF            =           0
res@tmXTMajorLengthF            =           0    ; change the tickmark length
res@tmYRMajorLengthF            =           0
res@tmXTOn = False
res@tmYROn = False
res@vpHeightF                   = 0.65
res@vpWidthF                    = 0.6


res@cnFillOn                    =           True
res@cnFillMode                  =           "RasterFill"  ; Turn on raster fill
res@cnLinesOn                   =           False         ; Turn off contour lines
res@cnLineLabelsOn              =           False         ; turns off contour line labels
res@cnFillPalette               =        cmap(:220,:);"WhiteBlueGreenYellowRed"
;res@cnFillOpacityF              =        0.95

res@cnInfoLabelOn               =           False
res@lbLabelBarOn                =           True
res@lbOrientation               =           "Vertical"
res@lbLabelFontHeightF          =        0.028
res@pmLabelBarWidthF           =           0.07

startf = (/1,10,4,1,4,2/)
endf   = (/12,120,48,12,48,24/)     
spacingf = (/1,10,4,1,4,2/)

startf = (/1,1,10,4,4,2/)
endf   = (/12,12,120,48,48,24/)     
spacingf = (/1,1,10,4,4,2/)
res@cnLevelSelectionMode        =           "ManualLevels"


res@tmXBMode             = "Explicit"                ; explicit labels
;res@tmXBValues           = (/0.2,0.6,1,1.4,1.8,2.2/) 
res@tmXBValues           = fspan(0.2,2.2,6)
res@tmXBLabels           = (/"Apr","May","Jun","Jul","Aug","Sep"/)        
res@sfXArray             = fspan(0,2.4,7)
res@tmYLMode             = "Explicit"                ; explicit labels
;res@tmYLValues           = (/0.1,0.3,0.5,0.7,0.9,1.1,1.3,1.5,1.7,1.9,2.1,2.3,2.5,2.7,2.9,3.1,3.3,3.7,3.9,4.1,4.3,4.5,4.7,4.9/) 
res@tmYLValues           = fspan(0.1,4.9,24)
res@tmYLLabels           = (/"08"," ","10"," ","12"," ","14"," ","16"," ","18"," ","20"," ","22"," ","00"," ","02"," ","04"," ","06"," "/)    
res@tmXBLabelFontHeightF = 0.032 
res@tmYLLabelFontHeightF = 0.03  
res@sfYArray             = fspan(0,5,25)
res@tiYAxisString        =  "Time (LST)"
res@tiYAxisFontHeightF    = 0.032

;res@gsnLeftStringFontHeightF  = 0.032
it = 0
do i = 0,5,2
    if (i.eq.0 .or. i.eq.2 .or. i.eq.4) then
        res@tiYAxisString        =  "Time (LST)"
    else 
        res@tiYAxisString        =  " "
    end if
    ;res@gsnLeftString = fig_strs(i)
    res@cnMinLevelValF              =           startf(i)
    res@cnMaxLevelValF              =           endf(i)
    res@cnLevelSpacingF             =           spacingf(i)
    plot(i) = gsn_csm_contour(wks, num_type(:,:,it), res)
    it = it + 1
end do

do i = 1,5,2
    if (i.eq.0 .or. i.eq.2 .or. i.eq.4) then
        res@tiYAxisString        =  "Time (LST)"
    else 
        res@tiYAxisString        =  " "
    end if
    ;res@gsnLeftString = fig_strs(i)
    res@cnMinLevelValF              =           startf(i)
    res@cnMaxLevelValF              =           endf(i)
    res@cnLevelSpacingF             =           spacingf(i)
    plot(i) = gsn_csm_contour(wks, num_type(:,:,it), res)
    it = it + 1
end do

fig_strs = (/"(a) Type-D","(b) Type-D","(c) Type-C","(d) Type-C","(e) Type-O","(f) Type-O"/)

;pres@gsnMaximize                =           True
;pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
;pres@lbTitleOn                  =           True
;pres@lbTitleString              =           "%"
;pres@lbTitlePosition            =           "Right"
;pres@lbTitleFontHeightF         =           0.015
;pres@lbTitleJust                =           "CenterRight"
;pres@pmLabelBarWidthF           =           0.7  ;设置标签条的宽度
;pres@lbLabelFontHeightF         =           0.02 ;设置标签条标签的字体高度
;pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
;pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
;pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
;pres@gsnPanelFigureStringsFontHeightF   =       0.013 ;设置图形面板中子图标识符的字体高度为0.013
;pres@gsnPanelYWhiteSpacePercent = 2 ;设置每行图的间距
;pres@gsnPanelXWhiteSpacePercent = 0.1 ;设置每行图的间距
;pres@pmLabelBarOrthogonalPosF    = -0.1 ;色标垂直方向偏离的位置，正下，负上
;pres@pmLabelBarParallelPosF      = 0.5;色标水平方向偏离的位置，正右，负左
;pres@txString = "the frequency of DLLJ events" 
;pres@txString = "the number of DLLJs" 
;pres@txFontHeightF = 0.024
;pres@gsnPanelDebug          = True
pres                 = True
pres@gsnPanelTop                =           0.93
pres@gsnPanelBottom             =           0.03
pres@gsnPanelYWhiteSpacePercent = 0 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   -1 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.016 ;设置图形面板中子图标识符的字体高度为0.013
fig_strs1 = (/"BBG","NSCS"/)
txres1               = True
txres1@txFontHeightF = 0.022
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.352,0.955,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.68,0.955,txres1)
gsn_panel(wks,plot,(/3,2/),pres)
end