load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f1 = addfile(filedir + "Beibu_DLLJ_event_duration.nc","r")
num_duration1 = f1->num_duration
num_type1     = f1->num_type
f2 = addfile(filedir + "NSCS_DLLJ_event_duration.nc","r")
num_duration2 = f2->num_duration
num_type2     = f2->num_type

iarr_B  = new((/3,5/),float)
iarr_N  = new((/3,5/),float)
iarr_B1  = new((/3/),float)
iarr_N1  = new((/3/),float)

do i = 0,2
    dimt = num_type1(i)
    x10  = round(0.1*dimt,3)-1
    x25  = round(0.25*dimt,3)-1     ; -1 to account for NCL indexing starting
    x75  = round(0.75*dimt,3)-1
    x90  = round(0.9*dimt,3)-1

    qsort(num_duration1(i,0:dimt-1))
    iarr_B(i,:) = (/num_duration1(i,x10), num_duration1(i,x25), dim_median(num_duration1(i,0:dimt-1)), num_duration1(i,x75),num_duration1(i,x90)/)
    iarr_B1(i)  = dim_avg(num_duration1(i,0:dimt-1))
end do

do i = 0,2
    dimt = num_type2(i)
    x10  = round(0.1*dimt,3)-1
    x25  = round(0.25*dimt,3)-1     ; -1 to account for NCL indexing starting
    x75  = round(0.75*dimt,3)-1
    x90  = round(0.9*dimt,3)-1

    qsort(num_duration2(i,0:dimt-1))
    iarr_N(i,:) = (/num_duration2(i,x10), num_duration2(i,x25), dim_median(num_duration2(i,0:dimt-1)), num_duration2(i,x75),num_duration2(i,x90)/)
    iarr_N1(i)  = dim_avg(num_duration2(i,0:dimt-1))
end do
print(iarr_B1)
print(iarr_N1)

Type_B1 = (/10,461,220/)
Type_N1 = (/25,204,88/)
Type_B2 = (/86,4052,2020/)
Type_N2 = (/163,1824,720/)

plot = new((/4/),graphic)
plotLine = new((/2/),graphic)
plotM1   = new((/3/),graphic)
plotM2   = new((/3/),graphic)
wks = gsn_open_wks("pdf","draw_duration_Beibu_NSCS")
color_brown_blue_red = (/"#bf812d","#4393c3","#d6604d"/)
color_brown_blue_red1 =(/(/191./255,129./255,45./255/),(/67./255,147./255,195./255/),(/214./255,96./255,77./255/)/)
color_brown_blue_red2 = (/(/223./255,194./255,125./255/),(/146./255,192./255,222./255/),(/244./255,165./255,130./255/)/)

res            = True                         ; plot mods desired
res@gsnMaximize                =           False
res@tmYRBorderOn    = True         ; Habilita a borda do eixo y direito (YR). 
res@tmXTBorderOn    = True 
res@tmYLLabelFontHeightF = 0.024 
res@tiYAxisString   = "Duration of DLLJ events (h)"
res@tiYAxisFontHeightF = 0.026
res@vpWidthF              = 0.6
res@vpHeightF             = 0.5
res@tmYLMode        = "Manual"	   ; Eixo y esquerdo (YL) de forma manual.
res@tmXBLabels = (/"Type-D","Type-C","Type-O"/) ; labels for each box
res@tmXBLabelFontHeightF = 0.026
res@tmYLMajorLengthF         = -0.012
res@tmYLMajorOutwardLengthF  = -0.012
res@tmYLMinorLengthF         = -0.007
res@tmYLMinorOutwardLengthF  = -0.007
;res@tmXBMajorLengthF         = 0
;res@tmXBMajorOutwardLengthF  = 0


sres1 = True
sres1@gsnDraw               = False
sres1@gsnFrame              = False
sres1@vpWidthF              = 0.6
sres1@vpHeightF             = 0.5

sres1@gsnXYBarChart         = True
sres1@gsnXYBarChartBarWidth = 0.25           ; change bar widths
sres1@tmXBMode              = "Explicit"         ; explicit labels
sres1@tmXBValues            = ispan(1,3,1)
sres1@tmXBLabels = (/"Type-D","Type-C","Type-O"/)

sres1@tmXTOn                = False 
sres1@tmYROn                = False 
sres1@tmXTBorderOn    = True
sres1@tmYRBorderOn    = True 
sres1@tmXBLabelFontHeightF  = 0.026
sres1@tmYLLabelFontHeightF  = 0.024
sres1@tiYAxisString         = "Number of DLLJ events"
sres1@tiYAxisFontHeightF    = 0.026

sres1@tmXBMajorLengthF         = 0
sres1@tmXBMajorOutwardLengthF  = 0 
sres1@tmYLMajorLengthF         = -0.012
sres1@tmYLMajorOutwardLengthF  = -0.012
sres1@tmYLMinorLengthF         = -0.007
sres1@tmYLMinorOutwardLengthF  = -0.007
sres1@gsnXYBarChartColors = color_brown_blue_red2
sres1@gsnXYBarChartColors2 = color_brown_blue_red1

; resources for polylines that draws the boxes
;**********************************************  
llres                   = True			
llres@gsLineThicknessF  = 2.5                 ; line thickness 
;**********************************************
; resources that control color and width of boxes
;**********************************************  
opti          = True			
opti@boxWidth = 0.3				; Width of box (x units)
opti@boxColors = color_brown_blue_red 	; Color of box(es)
;***********************************************
x = (/1, 2, 3/)
sres1@trXMinF = 0
sres1@trXMaxF = 4
sres1@trYMinF = 0
sres1@trYMaxF = 550
plot(0) = gsn_csm_xy(wks,x,Type_B1,sres1)
sres1@tiYAxisString   = " "
plot(1) = gsn_csm_xy(wks,x,Type_N1,sres1)

resText = True
resText@txFontHeightF = 0.022
resText@txFontColors  = color_brown_blue_red1
xx = (/1,2.5,3/)
;yy = (/73.,463.,283./)
yy = (/40.,430.,250./)
text = (/"(10)","(461)","(220)"/)
plotText1 = gsn_add_text(wks,plot(0),text,xx,yy,resText)
text = (/"(86)","(4052)","(2020)"/)
xx = (/1,2.5,3/)
yy = (/40,430,250/)
;plotText2 = gsn_add_text(wks,plot(0),text,xx,yy,resText)

Type_N1 = (/26,204,122/)

xx = (/1,2,3/)
yy = (/88,267,151/)
yy = (/55,234,118/)
text = (/"(25)","(204)","(88)"/)
plotText3 = gsn_add_text(wks,plot(1),text,xx,yy,resText)
text = (/"(163)","(1824)","(720)"/)
xx = (/1,2,3/)
yy = (/55,234,118/)
;plotText4 = gsn_add_text(wks,plot(1),text,xx,yy,resText)

;res@tmXBLabelsOn = False
res@trYMinF         = 0;tointeger(min(iarr_B)-1)          
res@trYMaxF         = 22;tointeger(max(iarr_B)+1)               
res@tmYLTickStartF  = res@trYMinF  
res@tmYLTickEndF    = res@trYMaxF
res@tmYLTickSpacingF = 4

plot(2) = boxplot(wks,x,iarr_B,opti,res,llres)	
res@tiYAxisString   = " "
;res@tmYLLabelsOn    = False    
plot(3) = boxplot(wks,x,iarr_N,opti,res,llres)	

xx = (/1.38,2.38,3.38/)
yy = iarr_B1
text = (/"4.90","8.18","8.60"/)
plotText5 = gsn_add_text(wks,plot(2),text,xx,yy,resText)

yy = iarr_N1
text = (/"4.52","8.28","7.13"/)
plotText5 = gsn_add_text(wks,plot(3),text,xx,yy,resText)

resMark							= True
resMark@gsMarkerIndex 			= 16
resMark@gsMarkerSizeF = 0.007

do i = 0,2
    resMark@gsMarkerColor = color_brown_blue_red(i)
    plotM1(i) = gsn_add_polymarker(wks,plot(2),x(i),iarr_B1(i),resMark)
    plotM2(i) = gsn_add_polymarker(wks,plot(3),x(i),iarr_N1(i),resMark)
end do
fig_strs1 = (/"BBG","NSCS"/)
fig_strs = (/"(a) Number of DLLJ events" , "(b) Number of DLLJ events","(c) Duration of DLLJ events" , "(d) Duration of DLLJ events"/)
pres1 = True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           True
pres1@gsnPanelTop       = 0.98
pres1@gsnPanelBottom    = 0.02
pres1@gsnPanelLeft      = 0.02
pres1@gsnPanelRight     = 0.9
pres1@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres1@gsnPanelFigureStringsBackgroundFillColor   =   -1 ;调整背景颜色，0为白色，-1为透明
pres1@gsnPanelFigureStringsPerimOn = False
pres1@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres1@gsnPanelFigureStringsFontHeightF   =       0.018
pres1@gsnPanelYWhiteSpacePercent = 0 ;设置每行图的间距
pres1@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距

txres1               = True
txres1@txFontHeightF = 0.024 
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.28,0.89,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.715,0.89,txres1)
gsn_panel(wks,plot,(/2,2/),pres1)

end 