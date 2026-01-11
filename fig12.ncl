begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
fn1 = addfile(filedir+"composite_Com_pre_Beibu_type_event_after9h.nc","r")
preB0        = fn1->preB(:,{15:35},{100:125})  
preB = preB0/9.0
copy_VarMeta(preB0, preB)
 
f1 = addfile(filedir+"composite_Com_pre_Beibu_type_event_befor9h.nc","r") 
preB2        = f1->preB(:,{15:35},{100:125}) 

fn2 = addfile(filedir+"composite_Com_pre_NSCS_type_event_after9h.nc","r") 
preN0        = fn2->preB(:,{15:35},{100:125}) 
preN = preN0/9.0
copy_VarMeta(preN0, preN)

f2 = addfile(filedir+"composite_Com_pre_NSCS_type_event_befor9h.nc","r")
preN2        = f2->preB(:,{15:35},{100:125}) 
;printVarSummary(preB) 
;preB = (/preB1-preB2/)
;preN = (/preN1-preN2/)
;copy_VarCoords(preB1,preB)
;copy_VarCoords(preN1,preN)
wrf_smooth_2d(preB,2)
wrf_smooth_2d(preN,2) 
print(max(preB))
print(max(preN))

plot = new(6,graphic)
line0 = new(6,graphic)
pngname = "draw_pre_type_Beibu_NSCS_event_after9h"
;pngname = "draw_pre_type_Beibu_NSCS_event_befor9h"
;pngname = "draw_pre_type_Beibu_NSCS_event_after-befor_9h"
cmap = read_colormap_file("WhiteBlueGreenYellowRed")
cmap1 = read_colormap_file("MPL_coolwarm")
cmap2 = read_colormap_file("BlueWhiteOrangeRed")
cmap3 = read_colormap_file("WhiteBlue")
type = "pdf"
wks = gsn_open_wks(type,pngname) 
res                 =           True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
res@gsnAddCyclic    =           False 
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

res@cnFillOn                    =           True
res@cnLinesOn                   =           False 
res@cnLevelSelectionMode        = "ExplicitLevels"
;res@cnLevels = (/1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7,7.5,8,9/)
res@cnLevels = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1/)
;res@cnLevels = (/20,40,60,80,100,120,140,160,180,200/)
;res@cnLevelSelectionMode        =           "ManualLevels"
;res@cnMinLevelValF              =           -5;startf
;res@cnMaxLevelValF              =           5;endf
;res@cnLevelSpacingF             =           1;spacingf
;res@cnLevels = (/0,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.5,3,4/)
;res@cnFillPalette               =           "MPL_coolwarm";"WhiteBlueGreenYellowRed"
res@cnFillPalette               =           cmap(2:225,:);"WhiteBlueGreenYellowRed";cmap3(2:200:,:);cmap2(30:220,:);cmap3(2:185:,:);cmap2(30:220,:);"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"WhiteBlueGreenYellowRed"cmap1(20:105,:);
res@cnInfoLabelOn               =           False
res@lbLabelBarOn                =           False
res@cnLineLabelsOn              =           False

;res@cnLevels = (/0.1,0.3,0.5,1,3,5,7,10,15,20,25/)

resLine 							= True
; --------------------------------------------------------------
dir 								= "/sky1/home/zhouchling/data/map/shapefile_China/" ; 数据的位置
fShape1Name							= dir + "china.shp"
fShape3Name							= dir + "river.shp"
; 中国国界
resLine@gsLineColor 				= "Black"
resLine@gsLineThicknessF 			= 2.

res@tmXBLabelsOn = False
plot(0)    = gsn_csm_contour_map_ce(wks, preB(0,:,:), res)
line0(0)   = gsn_add_shapefile_polylines(wks, plot(0), fShape1Name,resLine)

plot(2)    = gsn_csm_contour_map_ce(wks, preB(1,:,:), res)
line0(2)   = gsn_add_shapefile_polylines(wks, plot(2), fShape1Name,resLine)

res@tmXBLabelsOn = True
plot(4)    = gsn_csm_contour_map_ce(wks, preB(2,:,:), res)
line0(4)   = gsn_add_shapefile_polylines(wks, plot(4), fShape1Name,resLine)

res@tmXBLabelsOn = False
res@tmYLLabelsOn = False
plot(1)    = gsn_csm_contour_map_ce(wks, preN(0,:,:), res)
line0(1)   = gsn_add_shapefile_polylines(wks, plot(1), fShape1Name,resLine)

plot(3)    = gsn_csm_contour_map_ce(wks, preN(1,:,:), res)
line0(3)   = gsn_add_shapefile_polylines(wks, plot(3), fShape1Name,resLine)

res@tmXBLabelsOn = True
plot(5)    = gsn_csm_contour_map_ce(wks, preN(2,:,:), res)
line0(5)   = gsn_add_shapefile_polylines(wks, plot(5), fShape1Name,resLine)

resLine1             = True ;打开线条属性设置
resLine1@gsLineThicknessF    = 4. ;设置线条的粗细为2
resLine1@gsLineDashPattern   = 0   ;设置线条的虚线模式,0为实线
resLine1@gsLineColor         = "black";
resLine1@gsLineThicknessF    = 2.
resLine1@gsLineDashPattern   = 11
x1 = (/107.,120.,120.,107.,107./);北部湾
y1 = (/18.0,18.0,32,32,18.0/)
plotLine3            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
;plotLine2            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)
;plotLine1            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)
;plotLine4            = gsn_add_polyline(wks,plot(0),x1,y1,resLine1)
;plotLine5            = gsn_add_polyline(wks,plot(1),x1,y1,resLine1)
;plotLine6            = gsn_add_polyline(wks,plot(5),x1,y1,resLine1)

x1 = (/112.,112.,112.,112.,112./);北部湾
y1 = (/18.0,18.0,32,32,32.0/)
;plotLine33            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
;plotLine22            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)
;plotLine11            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)
;plotLine44            = gsn_add_polyline(wks,plot(0),x1,y1,resLine1)
;plotLine55            = gsn_add_polyline(wks,plot(1),x1,y1,resLine1)
;plotLine66            = gsn_add_polyline(wks,plot(5),x1,y1,resLine1)
resLine1@gsLineColor         = "royalblue";"black";
resLine1@gsLineThicknessF    = 5.
resLine1@gsLineDashPattern   = 1
x1 = (/108.,112.,112.,108.,108./);北部湾
y1 = (/24.0,24.0,26.5,26.5,24.0/)
;plotLine10            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)

resLine1@gsLineColor         = "royalblue";"red";
resLine1@gsLineDashPattern   = 0
x1 = (/107.,112.,112.,107.,107./);北部湾
y1 = (/27.0,27.0,31,31,27.0/)
;plotLine12            = gsn_add_polyline(wks,plot(2),x1,y1,resLine1)


resLine1@gsLineColor         = "purple";"royalblue";
resLine1@gsLineDashPattern   = 1
x1 = (/106,117.,117.,106,106/);北部湾
y1 = (/21.0,20.0,26,27,21.0/)
;plotLine14            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
;plotLine15            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)

resLine1@gsLineColor         = "purple";
resLine1@gsLineDashPattern   = 0
x1 = (/109.,120.,120.,109.,109./);北部湾
y1 = (/27.0,26.0,30,31.,27.0/)
;plotLine16            = gsn_add_polyline(wks,plot(3),x1,y1,resLine1)
;plotLine17            = gsn_add_polyline(wks,plot(4),x1,y1,resLine1)


resLine1@gsLineColor         ="Black";"orchid1"
x1 = (/106.,120.,120,106.,106./);北部湾
y1 = (/18.0,21.0,27.,24,18.0/)
;plotLine20            = gsn_add_polyline(wks,plot(5),x1,y1,resLine1)

;fig_strs = (/"(a) Type-1 (+3h)","(d) Type-1 (+3h)","(b) Type-2 (+3h)","(e) Type-2 (+3h)","(c) Type-3 (+3h)","(f) Type-3 (+3h)"/)
;fig_strs = (/"(a) Type-1 (+7h)","(d) Type-1 (+7h)","(b) Type-2 (+7h)","(e) Type-2 (+7h)","(c) Type-3 (+7h)","(f) Type-3 (+7h)"/)
;fig_strs = (/"(a) Type-1 (+8h)","(d) Type-1 (+8h)","(b) Type-2 (+8h)","(e) Type-2 (+8h)","(c) Type-3 (+8h)","(f) Type-3 (+8h)"/)
;fig_strs = (/"(a) Type-1 (+5h)","(d) Type-1 (+5h)","(b) Type-2 (+5h)","(e) Type-2 (+5h)","(c) Type-3 (+5h)","(f) Type-3 (+5h)"/)
fig_strs = (/"(a) Type-D","(d) Type-D","(b) Type-C","(e) Type-C","(c) Type-O","(f) Type-O"/)


fig_strs1 = (/"BBG","NSCS"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                  =           False 
pres@gsnPanelTop               = 0.93
pres@gsnPanelBottom            = 0.05
pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "(mm h~S~~F18~-~F21~1~N~)";"("+ sclab5+" "+div@units +")"
pres@lbTitleFontHeightF         =           0.018
pres@pmLabelBarWidthF           =           0.01  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.6
pres@lbLabelFontHeightF         =           0.016 ;设置标签条标签的字体高度
;pres@lbLabelFont = "helvetica-bold"
;pres@lbFontThicknessF      = 1.2
pres@lbOrientation              =          "Vertical"
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStringsPerimOn = True
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.016 ;设置图形面板中子图标识符的字体高度为0.013 
pres@gsnPanelYWhiteSpacePercent = 0.1 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@pmLabelBarOrthogonalPosF    = -0.02 ;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      = -0.15;色标垂直方向偏离的位置，正上，负下
;pres@gsnPanelDebug          = True
txres1               = True
txres1@txFontHeightF = 0.026
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.3,0.95,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.71,0.95,txres1)

gsn_panel(wks, plot, (/3,2/), pres)
frame(wks)
end 