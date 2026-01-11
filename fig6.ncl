begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f1 = addfile(filedir + "Calculate_Beibu_type.nc","r")
type1 = f1->type
f2 = addfile(filedir + "Calculate_NSCS_type.nc","r")
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

wks = gsn_open_wks("pdf","Calculate_monthly_day") 
sres = True
sres@gsnDraw               = False
sres@gsnFrame              = False

sres@vpWidthF              = 0.6
sres@vpHeightF             = 0.3
sres@trXMinF               = 0.4
sres@trXMaxF               = 6.6
sres@trYMinF               = 0
sres@trYMaxF               = 2200

sres@gsnXYBarChart         = True
sres@gsnXYBarChartBarWidth = 0.2           ; change bar widths

sres@tmXBMode              = "Explicit"         ; explicit labels
sres@tmXBValues            = ispan(1,6,1)
;sres@tmXBLabels            = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep", \
;                                "Oct","Nov","Dec"," "/)
sres@tmXBLabels            = (/"Apr","May","Jun","Jul","Aug","Sep"/)

sres@tmXTOn                = False 
sres@tmYROn                = False 
sres@tmXTBorderOn          = False
sres@tmYRBorderOn          = False
sres@tmXBLabelFontHeightF  = 0.022
sres@tmXTLabelFontHeightF  = 0.022
sres@tmYLLabelFontHeightF  = 0.022
sres@gsnRightString        = ""
sres@tiYAxisString         = "Number of DLLJs"
sres@tiYAxisFontHeightF    = 0.022

sres@tmYRLabelsOn  =False
sres@tmXBMajorLengthF         = 0
sres@tmXBMajorOutwardLengthF  = 0
sres@tmYLMajorLengthF         = 0
sres@tmYLMajorOutwardLengthF  = 0
sres@tmYLMinorLengthF         = 0
sres@tmYLMinorOutwardLengthF  = 0
sres@tmXBLabelFontHeightF     = 0.022
sres@tmYLLabelFontHeightF     = 0.022
sres@gsnLeftString = "(a)"
sres@gsnLeftStringFontHeightF = 0.022

colors = (/(/209/255.,229/255.,240/255./),(/67/255.,147/255.,195/255./),(/253/255.,219/255.,199/255./),(/214/255.,96/255.,77/255./)/)
plots = new((/2/),graphic)
sres@gsnXYBarChartBarWidth = 0.2 
sres@gsnXYBarChartColors = colors(1,:)
plots(0) = gsn_csm_xy(wks,fspan(.9,5.9,6),num_month(0,:),sres)
sres@gsnXYBarChartColors = colors(3,:)
plots(1) = gsn_csm_xy(wks,fspan(1.1,6.1,6),num_month(1,:),sres)
overlay(plots(0),plots(1))


;;;;;;;;;;;;;;设置图例;;;;;;;;;;;;;;;;;;;;;;;;
res_text    = True  
res_text@txFontHeightF  =0.02  
res_text@txJust ="CenterRight" 
dum11 = gsn_add_text(wks,plots(0),"BBG",6.3,1965,res_text) ;添加图例标签,1960,2.7为位置
;res_text@txFontHeightF  =0.015 
;dum22 = gsn_add_text(wks,plots(0),"southerly",4.5,740,res_text) ;添加图例标签,1960,2.7为位置
;dum33 = gsn_add_text(wks,plots(0),"northerly",4.5,685,res_text) ;添加图例标签,1960,2.7为位置
res_text@txFontHeightF  =0.02 
dum111 = gsn_add_text(wks,plots(0),"NSCS",6.3,1745,res_text) ;添加图例标签,1960,2.7为位置
;res_text@txFontHeightF  =0.014 
;dum222 = gsn_add_text(wks,plots(0),"southerly wind",1.9,700,res_text) ;添加图例标签,1960,2.7为位置
;dum333 = gsn_add_text(wks,plots(0),"northerly wind",1.88,645,res_text) ;添加图例标签,1960,2.7为位置

bres1           = True
bres1@gsEdgesOn = True 
bres1@gsFillColor    = colors(1,:)
bres1@gsLineColor    = colors(1,:)
ybar      = (/1930,1930,2000,2000,1930/)
xbar      = (/4.8,5.,5.,4.8,4.8/)
dum1111 = gsn_add_polygon(wks,plots(0),xbar,ybar,bres1)

bres1@gsFillColor    = colors(3,:)
bres1@gsLineColor    = colors(3,:)
ybar      = (/1710,1710,1780,1780,1710/)
xbar      = (/4.8,5.,5.,4.8,4.8/)
dum2222 = gsn_add_polygon(wks,plots(0),xbar,ybar,bres1)


sres1 = True
sres1@gsnDraw               = False
sres1@gsnFrame              = False

sres1@vpWidthF              = 0.65
sres1@vpHeightF             = 0.3
sres1@trXMinF               = 0.4
sres1@trXMaxF               = 24.6
sres1@trYMinF               = 0
sres1@trYMaxF               = 600

; Y主轴标题及刻度的颜色
sres1@tiYAxisFontColor 			= colors(1,:)
sres1@tmYLLabelFontColor 		= colors(1,:)
sres1@tmYLMajorLineColor 		= colors(1,:)
sres1@tmYLMinorLineColor 		= colors(1,:)

sres1@gsnXYBarChart         = True
sres1@gsnXYBarChartBarWidth = 0.25           ; change bar widths

sres1@tmXBMode              = "Explicit"         ; explicit labels
sres1@tmXBValues            = ispan(1,24,1)
sres1@tmXBLabels            = (/"08"," ","10"," ","12"," ","14"," ","16", \
                                " ","18"," ","20"," ","22"," ","00"," ","02"," ","04"," ","06"," "/)
;sres@tmXBValues            = ispan(1,12,1)
;sres@tmXBLabels            = (/"8","10","12","14","16","18","20","22","0","2","4","6"/)

sres1@tmXTOn                = False 
sres1@tmYROn                = False 
sres1@tmBorderLineColor     = "Gray55"
sres1@tmXBLabelFontHeightF  = 0.022
sres1@tmXTLabelFontHeightF  = 0.022
sres1@tmYLLabelFontHeightF  = 0.022
sres1@gsnRightString        = ""
sres1@tiYAxisString         = "Number of DLLJs"
sres1@tiYAxisFontHeightF    = 0.022
sres1@tiXAxisString         = "Time (LST)"
sres1@tiXAxisFontHeightF    = 0.022

sres1@tmYRLabelsOn  =False
sres1@tmXTBorderOn          = False
sres1@tmYLLabelsOn  =True
sres1@tmXBMajorLengthF         = 0
sres1@tmXBMajorOutwardLengthF  = 0 
sres1@tmYLMajorLengthF         = 0
sres1@tmYLMajorOutwardLengthF  = 0
sres1@tmYLMinorLengthF         = 0
sres1@tmYLMinorOutwardLengthF  = 0
sres1@tmXBLabelFontHeightF     = 0.022
sres1@tmYLLabelFontHeightF     = 0.022
sres1@gsnLeftString = "(b)"
sres1@gsnLeftStringFontHeightF = 0.022

sres2 							= True
sres2@gsnDraw 					= False
sres2@gsnFrame 					= False
sres2@vpWidthF              = 0.65
sres2@vpHeightF             = 0.3
sres2@trXMinF               = 0.4
sres2@trXMaxF               = 24.6
; Y次轴的范围值
sres2@trYMinF 					= 0
sres2@trYMaxF 	 				= 300

sres2@tmXTOn                = False 
sres2@tmXBOn                = False
sres2@tmYLOn                = False
sres2@tmYROn                = True 
sres2@tmYUseLeft            = False
sres2@tmBorderLineColor     = "Gray55"

; Y主轴标题及刻度的颜色
sres2@tiYAxisFontColor 			= colors(3,:)
sres2@tmYRMajorLineColor 		= colors(3,:)
sres2@tmYRMinorLineColor 		= colors(3,:)
sres2@tmYRLabelFontColor 		= colors(3,:)

sres2@gsnXYBarChart         = True
sres2@gsnXYBarChartBarWidth = 0.25           ; change bar widths
sres2@tmXBMode              = "Explicit"         ; explicit labels
sres2@tmXBValues            = ispan(1,24,1)
sres2@tmXBLabels            = (/"8"," ","10"," ","12"," ","14"," ","16", \
                                " ","18"," ","20"," ","22"," ","0"," ","2"," ","4"," ","6"," "/)
;res2@tmXBValues            = ispan(1,12,1)
;res2@tmXBLabels            = (/"8","10","12","14","16","18","20","22","0","2","4","6"/)

sres2@tmXBLabelFontHeightF  = 0.022
sres2@tmXTLabelFontHeightF  = 0.022
sres2@tmYRLabelFontHeightF  = 0.022
sres2@gsnRightString        = ""

;res2@tmYLLabelsOn            =False
sres2@tmXTBorderOn          = False
sres2@tmYRLabelsOn            =True
sres2@tiYAxisString           = "Number of DLLJs"
sres2@tiYAxisSide             = "Right"
sres2@tiYAxisAngleF           = 270  
sres2@tiYAxisFontHeightF      = 0.022
sres2@tmXBMajorLengthF         = 0
sres2@tmXBMajorOutwardLengthF  = 0 
sres2@tmYRMajorLengthF         = 0
sres2@tmYRMajorOutwardLengthF  = 0
sres2@tmYRMinorLengthF         = 0
sres2@tmYRMinorOutwardLengthF  = 0
sres2@tmXBLabelFontHeightF     = 0.022
sres2@tmYRLabelFontHeightF     = 0.022


plots1 = new((/2/),graphic)
sres1@gsnXYBarChartColors = colors(1,:)
plots1(0) = gsn_csm_xy(wks,fspan(.875,23.875,24),num_hour(0,:),sres1)
sres2@gsnXYBarChartColors = colors(3,:)
plots1(1) = gsn_csm_xy(wks,fspan(1.125,24.125,24),num_hour(1,:),sres2)
anno_id  = gsn_add_annotation(plots1(0), plots1(1), True)

pres1 = True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           False
pres1@gsnPanelTop       = 0.9
pres1@gsnPanelBottom    = 0.6
pres1@gsnPanelLeft      = 0.25
pres1@gsnPanelRight     = 0.8

gsn_panel(wks,plots(0),(/1,1/),pres1)
pres2 = True
pres2@gsnMaximize                =           False
pres2@gsnFrame                   =           False
pres2@gsnPanelTop       = 0.61
pres2@gsnPanelBottom    = 0.31
pres2@gsnPanelLeft      = 0.24
pres2@gsnPanelRight     = 0.9
gsn_panel(wks,plots1(0),(/1,1/),pres2)
end