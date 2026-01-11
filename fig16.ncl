begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
fn1 = addfile(filedir+"composite_pre_Beibu_NSCS_type.nc","r")
preB        = fn1->preB
num_typeB   = fn1->num_type 
wrf_smooth_2d(preB,3)

fn2 = addfile(filedir+"composite_UVws_Beibu_NSCS_type.nc","r")
uB          = fn2->uB(:,:,::-1,:)
vB          = fn2->vB(:,:,::-1,:) 
wsB         = fn2->wsB(:,:,::-1,:)  
print(num_typeB) 

levelhpa = (/950,750/);华南
;colors = (/(/253/255.,181/255.,126/255./),(/242/255.,110/255.,76/255./),(/107/255.,174/255.,214/255./),(/33/255.,102/255.,172/255./)/)
colors = (/(/252/255.,197/255.,88/255./),(/252/255.,161/255.,47/255./),(/107/255.,174/255.,214/255./),(/33/255.,102/255.,172/255./)/)

plot = new(4,graphic)
line0 = new(4,graphic)
wsLine1 = new(4, "graphic")
wsLine2 = new(4, "graphic")
vector1 = new(4, "graphic")
vector2 = new(4, "graphic")
plotLine2 = new(4,"graphic")
text  = new(12,"graphic")
pngname = "draw_pre_UV_type_Beibu_NSCS"
cmap = read_colormap_file("WhiteBlueGreenYellowRed")
type = "pdf"
wks = gsn_open_wks(type,pngname)
res                 =           True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
res@gsnAddCyclic    =           False

vres = res 
vres@vcGlyphStyle                =           "LineArrow"
vres@vcLineArrowThicknessF       =           2.4
vres@vcPositionMode              =           "ArrowTail"
vres@vcLineArrowColor           =           "#ca1e14";"red";"orchid1";colors(1,:)      ;设置线箭头的颜色为
vres@vcMinMagnitudeF            =           10.0
vres@vcMinDistanceF             =           0.04    ;设置箭头之间的最小距离
;参考箭头
vres@vcRefAnnoOn                =           False
vres@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
vres@vcRefAnnoString1           =           "10 m/s"
vres@vcRefAnnoFontColor         =           "#ca1e14";"red";"orchid1";colors(1,:)  
vres@vcRefLengthF               =           0.03    ;设置参考矢量的长度
vres@vcRefAnnoBackgroundColor   =           "white"
vres@vcRefAnnoPerimOn           =           False  ;不加边框
vres@vcRefAnnoString2On         =           False   ; 下的字符
vres@vcRefAnnoString1On         =           False ;设定参考箭头上
vres@vcRefAnnoFontHeightF       =           0.03 ;矢量标签字体大小

vres0 = vres
vres0@vcMinDistanceF             =           0.04
vres0@vcLineArrowColor           =           "purple";"#756bb1"colors(3,:) 
vres0@vcRefAnnoFontColor        =            "purple";;"#756bb1"colors(3,:) 


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


;res@gsnMaximize     =           True
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
res@mpOutlineOn                 =           True
res@mpOutlineSpecifiers         =           (/"China:states","Taiwan"/)
res@mpCountyLineThicknessF      =           2.5
res@mpProvincialLineColor       =           "Gray40"
res@mpProvincialLineThicknessF  =           1.4
res@mpLandFillColor             =           -1
res@mpFillOn                    =           False
res@mpMinLatF                   =           15;latmin
res@mpMaxLatF                   =           35;latmax
res@mpMinLonF                   =           100;lonmin
res@mpMaxLonF                   =           125;lonmax
res@vpWidthF                    =           0.68
res@vpHeightF                   =           0.5

res@cnLineLabelsOn              =           False
res@cnFillOn                    =           True
res@cnLinesOn                   =           False
;res@cnLevelSelectionMode        =           "ManualLevels"
;res@cnMinLevelValF              =           startf
;res@cnMaxLevelValF              =           endf
;res@cnLevelSpacingF             =           spacingf
res@cnFillPalette               =           cmap(2:225,:)
res@cnInfoLabelOn               =           False
res@lbLabelBarOn                =           False
res@cnLevelSelectionMode        = "ExplicitLevels"
;res@cnLevels = (/0.1,0.3,0.5,1,3,5,7,10,15,20,25/)
res@cnLevels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1/)



resLine 							= True
; --------------------------------------------------------------
dir 								= "/sky1/home/zhouchling/data/map/shapefile_China/" ; 数据的位置
fShape1Name							= dir + "china.shp"
fShape3Name							= dir + "river.shp"
; 中国国界
resLine@gsLineColor 				= "Black"
resLine@gsLineThicknessF 			= 2.

;fig_strs = (/"(a) Type-C (NSCS) & Type-O (Beibu)","(b) Type-C (NSCS) & Type-C (Beibu)","(c) Type-D (NSCS) & Type-C (Beibu)","(d) Type-O (NSCS) & Type-O (Beibu)"/)
fig_strs = (/"(a) Type-D (NSCS) & Type-C (BBG)","(b) Type-C (NSCS) & Type-C (BBG)","(c) Type-C (NSCS) & Type-D (BBG)","(d) Type-O (NSCS) & Type-O (BBG)"/)

res@tmXBLabelsOn = False 
res@gsnLeftString = fig_strs(0)
res@gsnLeftStringFontHeightF = 0.028
res@gsnLeftStringOrthogonalPosF = 0.
plot(0)    = gsn_csm_contour_map_ce(wks, preB(0,:,:), res)
line0(0)   = gsn_add_shapefile_polylines(wks, plot(0), fShape1Name,resLine)
wsLine1(0)  = gsn_csm_contour(wks, wsB(0,{levelhpa(0)},:,:), vsres)
wsLine2(0)  = gsn_csm_contour(wks, wsB(0,{levelhpa(1)},:,:), vsres1)
vector1(0)   = gsn_csm_vector(wks, uB(0,{levelhpa(0)},:,:), vB(0,{levelhpa(0)},:,:), vres)
vector2(0)  = gsn_csm_vector(wks, uB(0,{levelhpa(1)},:,:), vB(0,{levelhpa(1)},:,:), vres0)

res@tmYLLabelsOn = False
res@gsnLeftString = fig_strs(1)
res@gsnLeftStringOrthogonalPosF = 0.03
plot(1)    = gsn_csm_contour_map_ce(wks, preB(1,:,:), res)
line0(1)   = gsn_add_shapefile_polylines(wks, plot(1), fShape1Name,resLine)
wsLine1(1)  = gsn_csm_contour(wks, wsB(1,{levelhpa(0)},:,:), vsres)
wsLine2(1)  = gsn_csm_contour(wks, wsB(1,{levelhpa(1)},:,:), vsres1)
vector1(1)   = gsn_csm_vector(wks, uB(1,{levelhpa(0)},:,:), vB(1,{levelhpa(0)},:,:), vres)
vector2(1)  = gsn_csm_vector(wks, uB(1,{levelhpa(1)},:,:), vB(1,{levelhpa(1)},:,:), vres0)

res@tmXBLabelsOn = True
res@tmYLLabelsOn = True
res@gsnLeftString = fig_strs(2)
res@gsnLeftStringOrthogonalPosF = 0
plot(2)    = gsn_csm_contour_map_ce(wks, preB(4,:,:), res)
line0(2)   = gsn_add_shapefile_polylines(wks, plot(2), fShape1Name,resLine)
wsLine1(2)  = gsn_csm_contour(wks, wsB(4,{levelhpa(0)},:,:), vsres)
wsLine2(2)  = gsn_csm_contour(wks, wsB(4,{levelhpa(1)},:,:), vsres1)
vector1(2)   = gsn_csm_vector(wks, uB(4,{levelhpa(0)},:,:), vB(4,{levelhpa(0)},:,:), vres)
vector2(2)  = gsn_csm_vector(wks, uB(4,{levelhpa(1)},:,:), vB(4,{levelhpa(1)},:,:), vres0)


res@tmYLLabelsOn = False
res@gsnLeftString = fig_strs(3)
res@gsnLeftStringOrthogonalPosF = 0.03
plot(3)    = gsn_csm_contour_map_ce(wks, preB(5,:,:), res)
line0(3)   = gsn_add_shapefile_polylines(wks, plot(3), fShape1Name,resLine)
wsLine1(3)  = gsn_csm_contour(wks, wsB(5,{levelhpa(0)},:,:), vsres)
wsLine2(3)  = gsn_csm_contour(wks, wsB(5,{levelhpa(1)},:,:), vsres1)
vector1(3)   = gsn_csm_vector(wks, uB(5,{levelhpa(0)},:,:), vB(5,{levelhpa(0)},:,:), vres)
vector2(3)  = gsn_csm_vector(wks, uB(5,{levelhpa(1)},:,:), vB(5,{levelhpa(1)},:,:), vres0)

do i =0,3
    overlay(plot(i),wsLine1(i))
    overlay(plot(i),wsLine2(i))
    overlay(plot(i),vector1(i))
    overlay(plot(i),vector2(i))
end do

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
amres@amParallelPosF   = 0.338         ; move legend to the right
amres@amOrthogonalPosF = 0.344             ; move the legend down
annoid1 = gsn_add_annotation(plot(0),lbid,amres)   ; add legend to plot


;fig_strs1 = (/"Beibu Gulf","Northern SCS"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                  =           False 
pres@gsnPanelTop               = 0.93
pres@gsnPanelBottom            = 0.05
pres@gsnPanelLeft               = 0.05
pres@gsnPanelRight            = 0.96
pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "(mm h~S~~F18~-~F21~1~N~"+")";"mm/h";"("+ sclab5+" "+div@units +")"
pres@lbTitleFontHeightF         =           0.016
pres@pmLabelBarWidthF           =           0.01  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.5
pres@lbLabelFontHeightF         =           0.016 ;设置标签条标签的字体高度
pres@lbOrientation              =          "Vertical"
;pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
;pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
;pres@gsnPanelFigureStringsPerimOn = True
;pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
;pres@gsnPanelFigureStringsFontHeightF   =       0.014 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 3 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@pmLabelBarOrthogonalPosF    = -0.015 ;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      = -0.15;色标垂直方向偏离的位置，正上，负下
;pres@gsnPanelDebug          = True
;txres1               = True
;txres1@txFontHeightF = 0.024
;txres1@txFont           = "helvetica-bold"
;gsn_text_ndc(wks,fig_strs1(0) ,0.3,0.95,txres1)
;gsn_text_ndc(wks,fig_strs1(1),0.74,0.95,txres1)

gsn_panel(wks, plot, (/2,2/), pres)
frame(wks)
end 