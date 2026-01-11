begin
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
;filedir = "/wind1/home/zhouchling/myncl/"
f1 = addfile(filedir + "composite_UVws_Beibu_type_event_day0.nc","r")
uB = f1->uB
vB = f1->vB
wsB = f1->wsB
num_type1 = f1->num_type
print(num_type1) 
printVarSummary(uB)

f2 = addfile(filedir + "composite_UVws_NSCS_type_event_day0.nc","r")
uN = f2->uB
vN = f2->vB
wsN = f2->wsB
num_type2 = f2->num_type
print(num_type2)

ndim = dimsizes(uB)
;dim(0)-BLJ/SLLJ; dim(1)-Type; dim(2)-24hour
data_uB = new((/2,ndim(0),ndim(1)/),"float")
data_vB = new((/2,ndim(0),ndim(1)/),"float")
data_wsB = new((/2,ndim(0),ndim(1)/),"float")
data_uN = new((/2,ndim(0),ndim(1)/),"float")
data_vN = new((/2,ndim(0),ndim(1)/),"float")
data_wsN = new((/2,ndim(0),ndim(1)/),"float")

;Type1_BLJ
lonmin = 106.
lonmax = 110.5
latmin = 18.
latmax = 22.
data_uB(0,2,:) = dim_avg_n_Wrap(uB(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(0,2,:) = dim_avg_n_Wrap(vB(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(0,2,:) = dim_avg_n_Wrap(wsB(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type2_BLJ
latmin = 18.
latmax = 22.
data_uB(0,1,:) = dim_avg_n_Wrap(uB(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(0,1,:) = dim_avg_n_Wrap(vB(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(0,1,:) = dim_avg_n_Wrap(wsB(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type3_BLJ
latmin = 18.
latmax = 22.
data_uB(0,0,:) = dim_avg_n_Wrap(uB(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(0,0,:) = dim_avg_n_Wrap(vB(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(0,0,:) = dim_avg_n_Wrap(wsB(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type1_SLLJ
latmin = 23.5
latmax = 28.5
data_uB(1,2,:) = dim_avg_n_Wrap(uB(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(1,2,:) = dim_avg_n_Wrap(vB(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(1,2,:) = dim_avg_n_Wrap(wsB(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type2_SLLJ
latmin = 22.
latmax = 27.
data_uB(1,1,:) = dim_avg_n_Wrap(uB(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(1,1,:) = dim_avg_n_Wrap(vB(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(1,1,:) = dim_avg_n_Wrap(wsB(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type3_SLLJ
latmin = 18.
latmax = 23.
data_uB(1,0,:) = dim_avg_n_Wrap(uB(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vB(1,0,:) = dim_avg_n_Wrap(vB(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsB(1,0,:) = dim_avg_n_Wrap(wsB(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
smoothed_data_wsB = runave(data_wsB, 5, 0)
smoothed_data_wsB(:,:,0)    = data_wsB(:,:,0)
smoothed_data_wsB(:,:,1)    = (data_wsB(:,:,0)+data_wsB(:,:,2))/2.
smoothed_data_wsB(:,:,23)   = data_wsB(:,:,23)
smoothed_data_wsB(:,:,22)    = (data_wsB(:,:,21)+data_wsB(:,:,23))/2.


;Type1_BLJ
lonmin = 110.5
lonmax = 117.
latmin = 18.
latmax = 22.
data_uN(0,2,:) = dim_avg_n_Wrap(uN(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(0,2,:) = dim_avg_n_Wrap(vN(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(0,2,:) = dim_avg_n_Wrap(wsN(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type2_BLJ
latmin = 18.
latmax = 22.
data_uN(0,1,:) = dim_avg_n_Wrap(uN(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(0,1,:) = dim_avg_n_Wrap(vN(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(0,1,:) = dim_avg_n_Wrap(wsN(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type3_BLJ
latmin = 18.
latmax = 22.
data_uN(0,0,:) = dim_avg_n_Wrap(uN(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(0,0,:) = dim_avg_n_Wrap(vN(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(0,0,:) = dim_avg_n_Wrap(wsN(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type1_SLLJ
latmin = 23.5
latmax = 28.5
data_uN(1,2,:) = dim_avg_n_Wrap(uN(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(1,2,:) = dim_avg_n_Wrap(vN(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(1,2,:) = dim_avg_n_Wrap(wsN(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type2_SLLJ
latmin = 22.
latmax = 27.
data_uN(1,1,:) = dim_avg_n_Wrap(uN(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(1,1,:) = dim_avg_n_Wrap(vN(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(1,1,:) = dim_avg_n_Wrap(wsN(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))

;Type3_SLLJ
latmin = 18.
latmax = 23.
data_uN(1,0,:) = dim_avg_n_Wrap(uN(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_vN(1,0,:) = dim_avg_n_Wrap(vN(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
data_wsN(1,0,:) = dim_avg_n_Wrap(wsN(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/))
smoothed_data_wsN = runave(data_wsN, 5, 0)
smoothed_data_wsN(:,:,0)    = data_wsN(:,:,0)
smoothed_data_wsN(:,:,1)    = (data_wsN(:,:,0)+data_wsN(:,:,2))/2.
smoothed_data_wsN(:,:,23)   = data_wsN(:,:,23)
smoothed_data_wsN(:,:,22)    = (data_wsN(:,:,21)+data_wsN(:,:,23))/2.

wks = gsn_open_wks("pdf","draw_wind_daily_2_raw")
;color_warm = (/"#FEE8DD","#F5B99E","#E2745E"/)
;color_cold = (/"#E7F2F6","#C8E0EF","#4C9AC9"/)
;color_warm = (/"#fddbc7","#f4a582","#d6604d","#b2182b","#67001f"/)
;color_cold = (/"#d1e5f0","#92c5de","#4393c3","#2166ac","#053061"/)
color_warm = (/"#996E2E","#F6944B","#F4DBB2"/)
color_cold = (/"#315A89","#0787C3","#ABCFE8"/)

sres1 = True
sres1@gsnDraw               = False
sres1@gsnFrame              = False
sres1@gsnMaximize           = False
sres1@vpWidthF              = 0.65
sres1@vpHeightF             = 0.35
sres1@trXMinF               = 0
sres1@trXMaxF               = 23

;sres1@gsnXYBarChart         = True
;sres1@gsnXYBarChartBarWidth = 0.25           ; change bar widths

sres1@tmXBMode              = "Explicit"         ; explicit labels
sres1@tmXBValues            = ispan(0,23,1)
sres1@tmXBLabels            = (/"08"," ","10"," ","12"," ","14"," ","16", \
                                " ","18"," ","20"," ","22"," ","00"," ","02"," ","04"," ","06"," "/)
;sres@tmXBValues            = ispan(1,12,1)
;sres@tmXBLabels            = (/"8","10","12","14","16","18","20","22","0","2","4","6"/)

sres1@tmXTOn                = False
sres1@tmYROn                = False 
sres1@tmBorderLineColor     = "Gray55"
sres1@tmXBLabelFontHeightF  = 0.024
sres1@tmYLLabelFontHeightF  = 0.024
sres1@gsnRightString        = ""
sres1@tiYAxisString         = "Wind speed of BLJ (m s~S~~F18~-~F21~1~N~)"
sres1@tiYAxisFontHeightF    = 0.026
sres1@tiXAxisString         = "Time (LST)"
sres1@tiXAxisFontHeightF    = 0.026

sres1@tmYRLabelsOn          = False
sres1@tmXTLabelsOn          = False
sres1@tmYLLabelsOn  =True
sres1@tmXBMajorLengthF         = -0.008 
sres1@tmXBMajorOutwardLengthF  = -0.008
sres1@tmYLMajorLengthF         = -0.008
sres1@tmYLMajorOutwardLengthF  = -0.008
sres1@tmYLMinorLengthF         = 0
sres1@tmYLMinorOutwardLengthF  = 0
sres1@xyDashPattern            = 0
sres1@xyLineThicknesses        = (/  2.5,   2.5, 2.5/)          ; make second line thicker

sres2 = sres1
sres2@tiYAxisString         = "Wind speed of SLLJ (m s~S~~F18~-~F21~1~N~)"

; Y主轴标题及刻度的颜色
sres1@tiYAxisFontColor 			= color_warm(1)
sres1@tmYLLabelFontColor 		= color_warm(1)
sres1@tmYLMajorLineColor 		= "Gray55"
sres1@tmYLMinorLineColor 		= "Gray55"
sres1@tmXBMajorLineColor        = "Gray55"

sres1@pmLegendDisplayMode    = "Always"            ; turn on legend,"NoCreate"
sres1@pmLegendSide           = "Top"               ; Change location of 
sres1@pmLegendParallelPosF   = 1.18                 ; move units right
sres1@pmLegendOrthogonalPosF = -0.34               ; move units down
sres1@pmLegendWidthF         = 0.12                ; Change width and
sres1@pmLegendHeightF        = 0.16                ; height of legend.
sres1@lgLabelFontHeightF     = 0.024                 ; change font height
sres1@lgTitleOn              = True                ; turn on legend title
sres1@lgTitleString          = "BLJ"           ; create legend title
sres1@lgTitleFontHeightF     = 0.026                ; font of legend title
sres1@xyExplicitLegendLabels = (/"Type-O","Type-C","Type-D"/)         ; explicit labels

sres2@tiYAxisFontColor 			= color_cold(1)
sres2@tmYLLabelFontColor 		= color_cold(1)
sres2@tmYLMajorLineColor 		= "Gray55"
sres2@tmYLMinorLineColor 		= "Gray55"
sres2@tmXBMajorLineColor        = "Gray55"

sres2@pmLegendDisplayMode    = "Always"            ; turn on legend,"NoCreate"
sres2@pmLegendSide           = "Top"               ; Change location of 
sres2@pmLegendParallelPosF   = 1.18                 ; move units right
sres2@pmLegendOrthogonalPosF = -1.12                ; move units down
sres2@pmLegendWidthF         = 0.12                ; Change width and
sres2@pmLegendHeightF        = 0.16                ; height of legend.
sres2@lgLabelFontHeightF     = 0.024                ; change font height
sres2@lgTitleOn              = True                ; turn on legend title
sres2@lgTitleString          = "SLLJ"           ; create legend title
sres2@lgTitleFontHeightF     = 0.026                ; font of legend title
sres2@xyExplicitLegendLabels = (/"Type-O","Type-C","Type-D"/)         ; explicit labels

plot1 = new((/4/),graphic)
sres1@xyLineColors             = color_warm(:)        ; change line color
sres1@trYMinF               = 6
sres1@trYMaxF               = 13
sres1@pmLegendDisplayMode    = "NoCreate"

plot1(2)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_data_wsB(0,:,:),sres1) ; create plot
;plot1(2)  = gsn_csm_xy (wks,ispan(0,23,1),data_wsB(0,:,:),sres1) ; create plot
sres1@pmLegendDisplayMode    = "Always"
sres1@trYMinF               = 7
sres1@trYMaxF               = 14
sres1@tiYAxisString = ""
plot1(3)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_data_wsN(0,:,:),sres1)
;plot1(3)  = gsn_csm_xy (wks,ispan(0,23,1),data_wsN(0,:,:),sres1)
sres2@xyLineColors             = color_cold(:) 
sres2@trYMinF               = 8
sres2@trYMaxF               = 14
sres2@pmLegendDisplayMode    = "NoCreate"
sres2@tiXAxisString         = " "
plot1(0)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_data_wsB(1,:,:),sres2) 
;plot1(0)  = gsn_csm_xy (wks,ispan(0,23,1),data_wsB(1,:,:),sres2) 
sres2@pmLegendDisplayMode    = "Always"
;sres2@trYMinF               = 9
;sres2@trYMaxF               = 12
sres2@tiYAxisString = ""
plot1(1)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_data_wsN(1,:,:),sres2) 
;plot1(1)  = gsn_csm_xy (wks,ispan(0,23,1),data_wsN(1,:,:),sres2) 

resLine33                           =           True
resLine33@gsLineColor               =           "black"
resLine33@gsLineThicknessF          =           1.5
resLine33@tfPolyDrawOrder           =           "PostDraw"
resLine33@gsLineDashPattern         =           1

xx0 = (/0,23/)

plotLine_B1 = new((/3/),graphic)
plotLine_B2 = new((/3/),graphic)
plotLine_N1 = new((/3/),graphic)
plotLine_N2 = new((/3/),graphic)

do i = 0,2
    resLine33@gsLineColor           =    color_warm(i)
    yy0 = (/dim_avg(smoothed_data_wsB(0,i,:)),dim_avg(smoothed_data_wsB(0,i,:))/)
    ;yy0 = (/dim_avg(data_wsB(0,i,:)),dim_avg(data_wsB(0,i,:))/)
    plotLine_B1(i) = gsn_add_polyline(wks,plot1(2),xx0,yy0,resLine33) 
    yy0 = (/dim_avg(smoothed_data_wsN(0,i,:)),dim_avg(smoothed_data_wsN(0,i,:))/)
    ;yy0 = (/dim_avg(data_wsN(0,i,:)),dim_avg(data_wsN(0,i,:))/)
    plotLine_N1(i) = gsn_add_polyline(wks,plot1(3),xx0,yy0,resLine33) 

    resLine33@gsLineColor           =    color_cold(i)
    yy0 = (/dim_avg(smoothed_data_wsB(1,i,:)),dim_avg(smoothed_data_wsB(1,i,:))/)
    ;yy0 = (/dim_avg(data_wsB(1,i,:)),dim_avg(data_wsB(1,i,:))/)
    plotLine_B2(i) = gsn_add_polyline(wks,plot1(0),xx0,yy0,resLine33) 
    yy0 = (/dim_avg(smoothed_data_wsN(1,i,:)),dim_avg(smoothed_data_wsN(1,i,:))/)
    ;yy0 = (/dim_avg(data_wsN(1,i,:)),dim_avg(data_wsN(1,i,:))/)
    plotLine_N2(i) = gsn_add_polyline(wks,plot1(1),xx0,yy0,resLine33) 
    
end do

fig_strs = (/"(a) Wind speed of SLLJ","(b) Wind speed of SLLJ","(c) Wind speed of BLJ","(d) Wind speed of BLJ"/)

fig_strs1 = (/"BBG","NSCS"/) 
pres1                            =           True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           True
pres1@gsnPanelTop       = 0.9
pres1@gsnPanelBottom    = 0.1
pres1@gsnPanelLeft      = 0.1
pres1@gsnPanelRight     = 0.8
pres1@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres1@gsnPanelFigureStringsBackgroundFillColor   =   -1 ;调整背景颜色，0为白色，-1为透明
pres1@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres1@gsnPanelFigureStringsPerimOn = False
pres1@gsnPanelFigureStringsFontHeightF   =       0.014 ;设置图形面板中子图标识符的字体高度为0.013
pres1@gsnPanelYWhiteSpacePercent = 2 ;设置每行图的间距
pres1@gsnPanelXWhiteSpacePercent = 1

txres1               = True
txres1@txFontHeightF = 0.018
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.3,0.72,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.65,0.72,txres1)

gsn_panel(wks,plot1,(/2,2/),pres1)
end