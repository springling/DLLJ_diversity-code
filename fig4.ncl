begin
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
;filedir = "/wind1/home/zhouchling/myncl/"
fn1 = addfile(filedir+"composite_UVws_Beibu_type_event.nc","r")
uB          = fn1->uB
vB          = fn1->vB
wsB         = fn1->wsB
num_typeB   = fn1->num_type 
print(num_typeB)
printVarSummary(uB)
;level = fn1->level(::-1)

fn2 = addfile(filedir+"composite_UVws_NSCS_type_event.nc","r")
uN          = fn2->uB
vN          = fn2->vB
wsN         = fn2->wsB
num_typeN   = fn2->num_type  
;print(num_typeN)

levelhpa = (/950,750/);华南
;colors = (/(/253/255.,181/255.,126/255./),(/242/255.,110/255.,76/255./),(/107/255.,174/255.,214/255./),(/33/255.,102/255.,172/255./)/)
colors = (/(/252/255.,197/255.,88/255./),(/252/255.,161/255.,47/255./),(/183/255.,228/255.,246/255./),(/119/255.,189/255.,230/255./)/)

plot    = new(6, "graphic")
wsLine1 = new(6, "graphic")
wsLine2 = new(6, "graphic")
vector1 = new(6, "graphic")
vector2 = new(6, "graphic")
line0   = new(6, "graphic")
plotLine2 = new(6,"graphic")
plotLine11 = new(6,"graphic")
plotLine22 = new(6,"graphic")
plotLine33 = new(6,"graphic")
plotLine44 = new(6,"graphic")
text  = new(12,"graphic")
pngname = "draw_UV_type_Beibu_NSCS_event"
type = "pdf"
wks = gsn_open_wks(type,pngname)
res                 =           True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
;res@gsnAddCyclic    =           False

vres = res 
vres@vcGlyphStyle                =           "LineArrow"
vres@vcLineArrowThicknessF       =           2.4
vres@vcPositionMode              =           "ArrowTail"
vres@vcLineArrowColor           =          "#ca1e14"; "orchid1";colors(0,:)      ;设置线箭头的颜色为
vres@vcMinMagnitudeF            =           10.0
vres@vcMinDistanceF             =           0.04    ;设置箭头之间的最小距离
;参考箭头
vres@vcRefAnnoOn                =           True
vres@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
vres@vcRefAnnoString1           =           "10 m s~S~~F18~-~F21~1~N~"
vres@vcRefAnnoString2           =           "950 hPa"
vres@vcRefAnnoFontColor         =           "#ca1e14";"orchid1";colors(0,:)  
vres@vcRefLengthF               =           0.03    ;设置参考矢量的长度
vres@vcRefAnnoBackgroundColor   =           "white"
vres@vcRefAnnoPerimOn           =           True  ;不加边框
vres@vcRefAnnoString2On         =           True   ; 下的字符
vres@vcRefAnnoString1On         =           True ;设定参考箭头上
vres@vcRefAnnoFontHeightF       =           0.02 ;矢量标签字体大小

vres0 = vres
vres0@vcMinDistanceF             =           0.04
vres0@vcLineArrowColor           =            "#1E4C9C";"purple";colors(2,:) 
vres0@vcRefAnnoFontColor        =             "#1E4C9C";"purple";colors(2,:) 
vres0@vcRefAnnoString1           =           "10 m s~S~~F18~-~F21~1~N~"
vres0@vcRefAnnoString2           =           "750 hPa"

vres1 = res
vres1@vcGlyphStyle                =           "LineArrow"
vres1@vcLineArrowThicknessF       =           2.4
vres1@vcPositionMode              =           "ArrowTail"
vres1@vcLineArrowColor           =           colors(0,:)   ;设置线箭头的颜色为
vres1@vcMinMagnitudeF            =           10.0
vres1@vcMinDistanceF             =           0.04    ;设置箭头之间的最小距离


;参考箭头
vres1@vcRefAnnoOn                =           True
vres1@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
vres1@vcRefAnnoString1           =           "10 m/s"
vres1@vcRefAnnoFontColor         =           colors(0,:)  
;vres1@vcRefAnnoFontColor         =           "black"
vres1@vcRefAnnoString2           =           levelhpa(0)+"hPa"
vres1@vcRefLengthF               =           0.03    ;设置参考矢量的长度
vres1@vcRefAnnoBackgroundColor   =           "white"
vres1@vcRefAnnoPerimOn           =           False  ;不加边框
vres1@vcRefAnnoString2On         =           True       ; 下的字符
vres1@vcRefAnnoString1On         =           True ;设定参考箭头上
vres1@vcRefAnnoFontHeightF       =           0.028  ;矢量标签字体大小
vres1@vcRefAnnoOrthogonalPosF    =            0.05 ;垂直移动参考箭头位置
;vres1@vcRefAnnoParallelPosF      =            -0.001 ;水平移动参考箭头位置
;vcrs1@vcRefAnnoParallelPosF      =           0.1  ;水平移动参考箭头位置

vres00 = vres1
vres00@vcLineArrowColor           =           colors(2,:) 
vres00@vcMinDistanceF             =            0.03
vres00@vcRefAnnoOrthogonalPosF    =           0.05 ;垂直移动参考箭头位置
vres00@vcRefAnnoString2           =            levelhpa(1)+"hPa"
vres00@vcRefAnnoFontColor         =            colors(2,:) 
vres1@vcRefAnnoParallelPosF      =            -2.0 ;水平移动参考箭头位置


vsres               =           res
res@gsnMaximize     =           False
res@pmTickMarkDisplayMode       = "Always" 
res@tmBorderThicknessF          =           2
res@tmXBMajorThicknessF         =           2
res@tmXBMinorThicknessF         =           2
res@tmYLMajorThicknessF         =           2
res@tmYLMinorThicknessF         =           2
;------tickmark settings
res@tmXBLabelFontHeightF        =           0.028        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.028
res@tmXBMajorLengthF            =           0.01    ; change the tickmark length
res@tmYLMajorLengthF            =           0.01

;-------map settings
res@mpLimitMode                 =           "LatLon"
res@mpGeophysicalLineColor      =           "Black"
res@mpNationalLineColor         =           "Black" 
res@mpUSStateLineColor          =           "Black"
res@mpGridLineColor             =           "Black"
res@mpLimbLineColor             =           "Black"
res@mpPerimLineColor            =           "Black"
res@mpGeophysicalLineThicknessF =           1.0
res@mpGridLineThicknessF        =           0.5
res@mpLimbLineThicknessF        =           0.5
res@mpNationalLineThicknessF    =           0.8
res@mpUSStateLineThicknessF     =           1.0
res@mpGridAndLimbOn             =           False
res@mpDataBaseVersion           =           "Ncarg4_1" 
;res@mpDataSetName               =           "/Users/zhouchunling/my_ncl/map/Earth..4"
res@mpDataSetName               =           "/sky1/home/zhouchling/data/map/Earth..4"
;res@mpDataSetName               =           "/wind1/home/zhouchling/myncl/map/Earth..4"
res@mpOutlineOn                 =           True
res@mpOutlineSpecifiers         =           (/"China:states","Taiwan"/)
res@mpCountyLineThicknessF      =           2.0
res@mpProvincialLineColor       =           "gray40"
res@mpProvincialLineThicknessF  =           1.4
res@mpLandFillColor             =           -1
res@mpFillOn                    =           False
res@mpMinLatF                   =           15;latmin
res@mpMaxLatF                   =           35;latmax
res@mpMinLonF                   =           100;lonmin
res@mpMaxLonF                   =           125;lonmax
res@vpWidthF                    =           0.68
res@vpHeightF                   =           0.5

resLine 							= True
; --------------------------------------------------------------
dir 								= "/sky1/home/zhouchling/data/map/shapefile_China/" ; 数据的位置
;dir 								= "/wind1/home/zhouchling/myncl/map/shapefile_China/" ; 数据的位置
fShape1Name							= dir + "china.shp"
fShape3Name							= dir + "river.shp"
; 中国国界
resLine@gsLineColor 				= "gray40"
resLine@gsLineThicknessF 			= 2.2

vsres@cnLineLabelsOn             =             False
vsres@cnFillOn                   =             False
vsres@cnLinesOn                  =             True
vsres@cnLevelSelectionMode       =             "ExplicitLevels"
vsres@cnLevels                   =             (/10,12/)
;vsres@cnLineColors               =            (/"Transparent","gray60"/)
;vsres@cnFillDrawOrder            =            "PostDraw"
vsres@cnFillOpacityF             =             1
;vsres@cnFillPattern              =             3
vsres@lbLabelBarOn               =             False
vsres@cnInfoLabelOn              =             False
vsres@cnLineColor                =             "black"
vsres@cnLineThicknessF           =             4.5
vsres1                           =             vsres
vsres@cnMonoLineColor            =             False
vsres@cnLineColors               =             colors(0:1,:)
vsres1@cnMonoLineColor           =             False
vsres1@cnLineColors              =             colors(2:3,:)

res@tmXBLabelsOn = False 

vres@vcRefAnnoParallelPosF      =            0.998
vres@vcRefAnnoOrthogonalPosF    =           -0.71
vres0@vcRefAnnoParallelPosF      =            0.998
vres0@vcRefAnnoOrthogonalPosF    =           -0.46;.5
plot(0)     = gsn_csm_map(wks, res)
line0(0)	= gsn_add_shapefile_polylines(wks, plot(0), fShape1Name,resLine) 
wsLine1(0)  = gsn_csm_contour(wks, wsB(0,{levelhpa(0)},:,:), vsres)
wsLine2(0)  = gsn_csm_contour(wks, wsB(0,{levelhpa(1)},:,:), vsres1)
vres@vcMinMagnitudeF            =           7.5
vector1(0)   = gsn_csm_vector(wks, uB(0,{levelhpa(0)},:,:), vB(0,{levelhpa(0)},:,:), vres)
vector2(0)  = gsn_csm_vector(wks, uB(0,{levelhpa(1)},:,:), vB(0,{levelhpa(1)},:,:), vres0)

vres@vcRefAnnoOn                =           False
vres0@vcRefAnnoOn                =           False
vres@vcMinMagnitudeF            =           10.0
plot(2)     = gsn_csm_map(wks, res)
line0(2)	= gsn_add_shapefile_polylines(wks, plot(2), fShape1Name,resLine) 
wsLine1(2)  = gsn_csm_contour(wks, wsB(1,{levelhpa(0)},:,:), vsres)
wsLine2(2)  = gsn_csm_contour(wks, wsB(1,{levelhpa(1)},:,:), vsres1)
vector1(2)   = gsn_csm_vector(wks, uB(1,{levelhpa(0)},:,:), vB(1,{levelhpa(0)},:,:), vres)
vector2(2)  = gsn_csm_vector(wks, uB(1,{levelhpa(1)},:,:), vB(1,{levelhpa(1)},:,:), vres0)

res@tmXBLabelsOn = True
plot(4)     = gsn_csm_map(wks, res)
line0(4)	= gsn_add_shapefile_polylines(wks, plot(4), fShape1Name,resLine) 
wsLine1(4)  = gsn_csm_contour(wks, wsB(2,{levelhpa(0)},:,:), vsres)
wsLine2(4)  = gsn_csm_contour(wks, wsB(2,{levelhpa(1)},:,:), vsres1)
vector1(4)   = gsn_csm_vector(wks, uB(2,{levelhpa(0)},:,:), vB(2,{levelhpa(0)},:,:), vres)
vector2(4)  = gsn_csm_vector(wks, uB(2,{levelhpa(1)},:,:), vB(2,{levelhpa(1)},:,:), vres0)

res@tmXBLabelsOn = False
res@tmYLLabelsOn = False
vres@vcMinMagnitudeF            =           7.
plot(1)     = gsn_csm_map(wks, res)
line0(1)	= gsn_add_shapefile_polylines(wks, plot(1), fShape1Name,resLine) 
wsLine1(1)  = gsn_csm_contour(wks, wsN(0,{levelhpa(0)},:,:), vsres)
wsLine2(1)  = gsn_csm_contour(wks, wsN(0,{levelhpa(1)},:,:), vsres1)
vector1(1)   = gsn_csm_vector(wks, uN(0,{levelhpa(0)},:,:), vN(0,{levelhpa(0)},:,:), vres)
vector2(1)  = gsn_csm_vector(wks, uN(0,{levelhpa(1)},:,:), vN(0,{levelhpa(1)},:,:), vres0)

vres@vcMinMagnitudeF            =           10.0
plot(3)     = gsn_csm_map(wks, res)
line0(3)	= gsn_add_shapefile_polylines(wks, plot(3), fShape1Name,resLine) 
wsLine1(3)  = gsn_csm_contour(wks, wsN(1,{levelhpa(0)},:,:), vsres)
wsLine2(3)  = gsn_csm_contour(wks, wsN(1,{levelhpa(1)},:,:), vsres1)
vector1(3)   = gsn_csm_vector(wks, uN(1,{levelhpa(0)},:,:), vN(1,{levelhpa(0)},:,:), vres)
vector2(3)  = gsn_csm_vector(wks, uN(1,{levelhpa(1)},:,:), vN(1,{levelhpa(1)},:,:), vres0)

res@tmXBLabelsOn = True
plot(5)     = gsn_csm_map(wks, res)
line0(5)	= gsn_add_shapefile_polylines(wks, plot(5), fShape1Name,resLine) 
wsLine1(5)  = gsn_csm_contour(wks, wsN(2,{levelhpa(0)},:,:), vsres)
wsLine2(5)  = gsn_csm_contour(wks, wsN(2,{levelhpa(1)},:,:), vsres1)
vector1(5)   = gsn_csm_vector(wks, uN(2,{levelhpa(0)},:,:), vN(2,{levelhpa(0)},:,:), vres)
vector2(5)  = gsn_csm_vector(wks, uN(2,{levelhpa(1)},:,:), vN(2,{levelhpa(1)},:,:), vres0)

do i =0,5
    overlay(plot(i),wsLine1(i))
    overlay(plot(i),wsLine2(i))
    overlay(plot(i),vector1(i))
    overlay(plot(i),vector2(i))
end do

resLine3                           =           True
resLine3@gsLineColor               =           "forestgreen"
resLine3@gsLineThicknessF          =           4.5
resLine3@tfPolyDrawOrder           =           "PostDraw"
resLine3@gsLineDashPattern         =           0

txres = True 
txres@txFontColor = "forestgreen"
txres@txFontThicknessF = 1.2
txres@txFont           = "helvetica-bold"
txres@txFontHeightF    = 0.034

x3 = (/16.0,32/)
y3 = (/108.0,108.0/)
plotLine2(0) = gsn_add_polyline(wks,plot(0),y3,x3,resLine3)
ya = x3(0)
xa = y3(0)+1
yb = x3(1)
xb = y3(1)+1
text(0) = gsn_add_text(wks,plot(0),"A",xa,ya,txres)
text(1) = gsn_add_text(wks,plot(0),"B",xb,yb,txres)

x3 = (/16.0,32/)
y3 = (/112.5,112.5/)
plotLine2(1) = gsn_add_polyline(wks,plot(1),y3,x3,resLine3)
ya = x3(0)
xa = y3(0)+1
yb = x3(1)
xb = y3(1)+1
text(2) = gsn_add_text(wks,plot(1),"C",xa,ya,txres)
text(3) = gsn_add_text(wks,plot(1),"D",xb,yb,txres)

resLine1             = True ;打开线条属性设置
resLine1@gsLineThicknessF    = 3.5 ;设置线条的粗细为2
resLine1@gsLineDashPattern   = 0   ;设置线条的虚线模式,0为实线
resLine1@gsLineColor         = "purple"  ;设置线条颜色

x1 = (/110.5,106,106.,110.5,110.5/);北部湾
y1 = (/23.5,23.5,28.5,28.5,23.5/)
plotLine11(0)            = gsn_add_polyline(wks,plot(0),x1,y1,resLine1)
;y1 = (/20.0,20.0,30,30,20.0/)
y1 = (/22.0,22.0,27,27,22.0/)
plotLine11(1)            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)

y1 = (/18.0,18.0,23,23,18.0/)
plotLine11(2)            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)

resLine1@gsLineDashPattern   = 1
resLine1@gsLineColor         = "black"
y1 = (/18.0,18.0,22,22,18.0/)
plotLine22(0)            = gsn_add_polyline(wks,plot(0),x1,y1,resLine1)
plotLine22(1)            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)
plotLine22(2)            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)


resLine1@gsLineColor         = "purple";"black";"red";"#b2182b";
resLine1@gsLineDashPattern   = 0 
x1 = (/110.5,117,117.,110.5,110.5/);北部湾
;y1 = (/25.0,25.0,30,30,25.0/)
y1 = (/23.5,23.5,28.5,28.5,23.5/)
plotLine33(0)            = gsn_add_polyline(wks,plot(1),x1,y1,resLine1)
;y1 = (/20.0,20.0,30,30,20.0/)
y1 = (/22.0,22.0,27,27,22.0/)
plotLine33(1)            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
y1 = (/18.0,18.0,23,23,18.0/)
plotLine33(2)            = gsn_add_polyline(wks,plot(5),x1,y1,resLine1)

resLine1@gsLineDashPattern   = 1
resLine1@gsLineColor         = "black"
y1 = (/18.0,18.0,22,22,18.0/)
plotLine44(0)            = gsn_add_polyline(wks,plot(1),x1,y1,resLine1)
plotLine44(1)            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
plotLine44(2)            = gsn_add_polyline(wks,plot(5),x1,y1,resLine1)


legend = (/"950 hPa"," ","750 hPa"," "/)
lgres                    = True
lgres@lgMonoDashIndex    = True
lgres@lgLineColors       = colors(::-1,:)
lgres@lgLineThicknessF   = vsres@cnLineThicknessF  ; legend line thickness = contour line thickness
lgres@lgLineDashSegLenF  = 0.8
lgres@lgItemType         = "Lines"        ; show lines only (default)
lgres@lgLabelFontHeightF = .1            ; set the legend label font thickness
lgres@vpWidthF           = 0.2           ; width of legend (NDC)
lgres@vpHeightF          = 0.15            ; height of legend (NDC)
lgres@lgPerimColor       = "black"       ; draw the box perimeter in orange
lgres@lgPerimThicknessF  = 1.5           ; thicken the box perimeter
lgres@lgPerimFill        = "SolidFill"
lgres@lgPerimFillColor   = "white"
lbid = gsn_create_legend(wks,4,legend(::-1),lgres)         ; create legend

amres = True
amres@amParallelPosF   = 0.339         ; move legend to the right
amres@amOrthogonalPosF = -0.347             ; move the legend down
annoid1 = gsn_add_annotation(plot(0),lbid,amres)   ; add legend to plot

fig_strs = (/"(a) Type-D","(d) Type-D","(b) Type-C","(e) Type-C","(c) Type-O","(f) Type-O"/)
fig_strs1 = (/"BBG","NSCS"/)
;---Resources for paneling
pres1 = True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           False
pres1@gsnPanelTop       = 0.93
pres1@gsnPanelBottom    = 0.03
pres1@gsnPanelLeft      = 0.03
pres1@gsnPanelRight     = 0.93
;pres1@gsnPanelLabelBar           =           True ;打开图形面板的标签条
;pres1@lbTitleOn                  =           True 
;pres1@lbTitleString              =           "(gpm)";"Anomaly of 950 hPa geopotential height (gpm)"
;pres1@pmLabelBarWidthF           =           0.015  ;设置标签条的宽度
;pres1@pmLabelBarHeightF          =           0.35  ;设置标签条的宽度
;pres1@lbLabelFontHeightF         =           0.35 ;设置标签条标签的字体高度
;pres1@lbOrientation               =          "Vertical";"horizontal"
;pres1@lbTitleFontHeightF         =           0.014
;pres@lbTitleJust                =           "BottomCenter"
pres1@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres1@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
;pres@gsnPanelFigureStringsPerimOn = False
pres1@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres1@gsnPanelFigureStringsFontHeightF   =       0.016 ;设置图形面板中子图标识符的字体高度为0.013
pres1@gsnPanelYWhiteSpacePercent = 0.1 ;设置每行图的间距
pres1@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
;pres1@pmLabelBarOrthogonalPosF    = 0.018 ;色标水平方向偏离的位置，正右，负左
;pres1@pmLabelBarParallelPosF      = -0.15;色标垂直方向偏离的位置，正上，负下
txres1               = True
txres1@txFontHeightF = 0.024
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.3,0.95,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.74,0.95,txres1)

gsn_panel(wks,plot,(/3,2/),pres1)
frame(wks)
end