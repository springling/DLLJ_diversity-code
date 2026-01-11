begin 
;fn_topo = addfile("/sky1/home/zhouchling/data/ERA5_topo.nc","r")
;fn_topo = addfile("/wind1/home/zhouchling/myncl/ETOPO1_Bed_g_gmt4.grd.nc","r")
fn_topo = addfile("/sky7/zhouchling/data/ETOPO1_Bed_g_gmt4.grd.nc","r")
elevt0   = fn_topo->z({10:40},{80:130})
elevt    = tofloat(elevt0)
hsf=where(elevt.ge.0, elevt,-999.)
copy_VarCoords(elevt0,hsf)
printVarSummary(hsf)
print(max(hsf))
print(min(hsf))
wrf_smooth_2d(hsf, 8)

filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
;fn1 = addfile(filedir+"avg_UVws_LLJ_event.nc","r")
fn1 = addfile(filedir+"composite_UVws_LLJ.nc","r")
uB          = fn1->uB
vB          = fn1->vB
wsB         = fn1->wsB
num_typeB   = fn1->num_type 
print(num_typeB)

fn2 = addfile(filedir+"composite_pre_LLJ_AprtoSep.nc","r")
preB = fn2->preB
num_type1 = fn2->num_type
preB0 = preB/tofloat(num_type1)
copy_VarCoords(preB,preB0)
print(num_type1)

fn3 = addfile(filedir+"composite_pre_AprtoSep.nc","r")
pre1 = fn3->preB

;pre = preB/(pre1)*100
nn = 23*24*183
;print(nn)
pre = preB0/(pre1/nn)*100
pre_av = (/pre1/nn/)
;aveX = 

copy_VarCoords(preB,pre_av)
copy_VarCoords(preB,pre)
;print(max(pre({15:35},{100:125})))
;print(min(pre({15:35},{100:125})))
;print(max(preB0({15:35},{100:125})))
;print(min(preB0({15:35},{100:125})))

;print(max(pre_av({15:35},{100:125})))
;print(min(pre_av({15:35},{100:125})))

filedir1 = "/sky6/zhouchling/data/"
fn4 = addfile(filedir1+"pre_LLJ_AprtoSep_climate_prob.nc","r")
prob = fn4->prob(0,::10,::10)
printVarSummary(prob)
printMinMax(prob, 2)
;fn4 = addfile(filedir1+"pre_LLJ_AprtoSep_climate.nc","r")
;p1 = fn4->preB(:,{15:35},{100:125})
;fn5 = addfile(filedir1+"pre_LLJ_AprtoSep.nc","r")
;p2 = fn5->preB(:,{15:35},{100:125})
;printMinMax(p1(101015,:,:),2)
;printMinMax(p2(7063,:,:),2)
;aveX = dim_avg_n_Wrap(p1, 0)
;aveY = dim_avg_n_Wrap(p2, 0)
;varX = dim_variance_n_Wrap(p1, 0)
;varY = dim_variance_n_Wrap(p2, 0)
;nX  = dimsizes(p1(:,0,0)) 
;nY  = dimsizes(p2(:,0,0)) 
;prob = ttest(aveX,varX,nX,aveY,varY,nY,True,True)
;printVarSummary(prob)
;dims =  dimsizes(p1)
;t_value = new((/dims(1),dims(2)/), "float")
;do n=0,dimsizes(p1&latitude)-1
;    do k=0,dimsizes(p1&longitude)-1
;        value = ttest(dim_avg(p1(n,k)),dim_variance(p1(:,n,k)), dimsizes(p1(:,n,k)), \
;                dim_avg(p2(:,n,k)),dim_variance(p2(:,n,k)), dimsizes(p2(:,n,k)), True, True)
;        t_value(n,k) = tofloat(value(0,0))
;    end do
;end do


;cmap = read_colormap_file("GMT_topo") 
cmap = read_colormap_file("WhiteBlueGreenYellowRed")
cmap1 = read_colormap_file("MPL_terrain")
;cmap2 = read_colormap_file("MPL_BuPu")
cmap2 = read_colormap_file("MPL_coolwarm")
;index1 			= (/52,217,201,185, 168, 152, 145, 138, 83, 90, 97, 105,112, 120, 127, 35, 30, 25, 20, 15, 10, 5/)
levelhpa = (/950,750/);华南
plot1    = new(3,"graphic")
wks = gsn_open_wks("pdf","draw_topo1")
res                 =           True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnAddCyclic    =           False
res@gsnMaximize     =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
res@gsnLeftStringFontHeightF = 0.014
res@gsnRightStringFontHeightF = 0.014
res@tmBorderThicknessF          =           2
res@tmXBMajorThicknessF         =           2
res@tmXBMinorThicknessF         =           2
res@tmYLMajorThicknessF         =           2
res@tmYLMinorThicknessF         =           2

res@pmTickMarkDisplayMode       = "Always" 
;------tickmark settings
res@tmXBLabelFontHeightF        =           0.028        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.028
res@tmXBMajorLengthF            =           0.01    ; change the tickmark length
res@tmYLMajorLengthF            =           0.01

rescn							= res
vres = res 
vres@vcGlyphStyle                =           "CurlyVector";"LineArrow"
vres@vcLineArrowThicknessF       =           1.7
vres@vcPositionMode              =           "ArrowTail"
vres@vcLineArrowColor           =            "black"      ;设置线箭头的颜色为
;vres@vcMinMagnitudeF            =           10.0
vres@vcMinDistanceF             =           0.035    ;设置箭头之间的最小距离
;参考箭头
vres@vcRefAnnoOn                =           True
vres@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
vres@vcRefAnnoString2           =           "10 m s~S~~F18~-~F21~1~N~"
;vres@vcRefAnnoString2          =           "950hPa"
vres@vcRefAnnoFontColor         =           "black";"black";colors(0,:)  
vres@vcRefLengthF               =           0.04    ;设置参考矢量的长度
vres@vcRefAnnoBackgroundColor   =           "white"
vres@vcRefAnnoPerimOn           =           True  ;边框
vres@vcRefAnnoString2On         =           True   ; 下的字符
vres@vcRefAnnoString1On         =           False ;设定参考箭头上
vres@vcRefAnnoFontHeightF       =           0.018 ;矢量标签字体大小
vres@vcRefAnnoParallelPosF      =            1.
vres@vcRefAnnoOrthogonalPosF    =           -0.186

vres1 = vres
;vres1@vcRefAnnoString2           =           "750hPa"
vres1@vcRefAnnoOrthogonalPosF    =           -0.299

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
res@mpCountyLineThicknessF      =           2.0
res@mpProvincialLineColor       =           "gray40"
res@mpProvincialLineThicknessF  =           1.5
res@mpLandFillColor             =           -1
res@mpFillOn                    =           False
res@vpWidthF                    =           0.68
res@vpHeightF                   =           0.5

res1 = res
res2 = res
res1@mpProvincialLineColor       =           "gray40"
res1@mpMinLatF                   =           14;latmin
res1@mpMaxLatF                   =           35;latmax
res1@mpMinLonF                   =           100;lonmin
res1@mpMaxLonF                   =           125;lonmax
res1@cnFillOn                    =           True
res1@cnLinesOn                   =           False 
res1@cnLevelSelectionMode        = "ExplicitLevels"
;res1@cnLevels = (/5,6,7,8,9,10,14,16,20,25,30,35,40/)
res1@cnLevels = (/0.1,0.13,0.16,0.2,0.25,0.3,0.35,0.4,0.5,0.6,0.7/)
;res1@cnFillMode                  =           "RasterFill"
;res@cnLevels = (/20,40,60,80,100,120,140,160,180,200/)
;res@cnLevelSelectionMode        =           "ManualLevels"
;res@cnMinLevelValF              =           -5;startf
;res@cnMaxLevelValF              =           5;endf
;res@cnLevelSpacingF             =           1;spacingf
;res1@cnLevels = (/0,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.5,3/)
;res@cnFillPalette               =           "MPL_coolwarm";"WhiteBlueGreenYellowRed"
res1@cnFillPalette               =           cmap(2:220:,:);cmap2(30:220,:);cmap(2:205,:);cmap3(2:185:,:);cmap2(30:220,:);"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"WhiteBlueGreenYellowRed"cmap1(20:105,:);
res1@cnInfoLabelOn               =           False
res1@lbLabelBarOn                =           True
res1@cnLineLabelsOn              =           False
res1@lbLabelBarOn                =           True
res1@lbTitleOn                  =           True
res1@lbTitleString              =           "(mm "+"h~S~~F18~-~F21~1~N~)";"(10~S~2~N~ mm)";"("+ sclab5+" "+div@units +")"
res1@lbTitleFontHeightF         =           0.022
res1@pmLabelBarWidthF           =           0.02  ;设置标签条的宽度
res1@pmLabelBarHeightF          =           0.5
res1@lbLabelFontHeightF         =           0.018 ;设置标签条标签的字体高度
res1@lbOrientation              =          "Vertical"
res1@pmLabelBarOrthogonalPosF   =           0.025

res2@mpProvincialLineColor       =           "gray40"
res2@mpMinLatF                   =           14;latmin
res2@mpMaxLatF                   =           35;latmax
res2@mpMinLonF                   =           100;lonmin
res2@mpMaxLonF                   =           125;lonmax
res2@cnFillOn                    =           True
res2@cnLinesOn                   =           False 
res2@cnLevelSelectionMode        = "ExplicitLevels"
res2@cnLevels = (/10,20,30,40,50,60,70,80,100,120,140,160,180,200,250/)
;res2@cnLevels = (/1,2,3,4,5,6,8,10,12,14,16/)
res2@cnFillMode                  =           "RasterFill"
;res@cnLevels = (/20,40,60,80,100,120,140,160,180,200/)
;res@cnLevelSelectionMode        =           "ManualLevels"
;res@cnMinLevelValF              =           -5;startf
;res@cnMaxLevelValF              =           5;endf
;res@cnLevelSpacingF             =           1;spacingf
;res1@cnLevels = (/0,0.25,0.5,0.75,1,1.25,1.5,1.75,2,2.5,3/)
;res@cnFillPalette               =           "MPL_coolwarm";"WhiteBlueGreenYellowRed"
res2@cnFillPalette               =           cmap2(10:120,:);cmap2(30:220,:);cmap(2:205,:);cmap3(2:185:,:);cmap2(30:220,:);"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"WhiteBlueGreenYellowRed"cmap1(20:105,:);
res2@cnInfoLabelOn               =           False
res2@lbLabelBarOn                =           True
res2@lbTitleOn                  =           True
res2@lbTitleString              =           "(%)";"("+ sclab5+" "+div@units +")"
res2@lbTitleFontHeightF         =           0.022
res2@pmLabelBarWidthF           =           0.1  ;设置标签条的宽度
res2@pmLabelBarHeightF          =           0.5
res2@lbLabelFontHeightF         =           0.018 ;设置标签条标签的字体高度
res2@lbOrientation              =          "Vertical"
res2@pmLabelBarOrthogonalPosF   =           0.025

res@mpMinLatF                   =           14
res@mpMaxLatF                   =           35
res@mpMinLonF                   =           100
res@mpMaxLonF                   =           125
res@cnLevelSelectionMode        =           "ManualLevels"
res@cnMinLevelValF              =           0
res@cnMaxLevelValF              =           1600
res@cnLevelSpacingF             =           100
;res@cnLevelSelectionMode        =   "ExplicitLevels"
;res@cnLevels  = (/0,100,150,200,250,300,350,400,600,800,1000,1200,1400,1600,1800,2000,2200,2400,2600,2800,3000/)

res@cnFillOn                    =           True
res@cnLineLabelsOn              =           False
res@cnFillMode                  =           "CellFill";"AreaFill";"RasterFill"
;res@cnFillDrawOrder             =           "PreDraw"
res@cnLinesOn                   =           False
res@cnFillPalette               =           cmap1(12::,:);cmap(index1,:);"MPL_Greys""MPL_Greys";"MPL_BuGn";
res@cnInfoLabelOn               =           False
res@lbLabelBarOn                =           True
res@lbTitleOn                  =           True
res@lbTitleString              =           "(m)";"("+ sclab5+" "+div@units +")"
res@lbTitleFontHeightF         =           0.022
res@pmLabelBarWidthF           =           0.08  ;设置标签条的宽度
res@pmLabelBarHeightF          =           0.5
res@pmLabelBarOrthogonalPosF   =           0.05
res@lbLabelFontHeightF         =           0.018 ;设置标签条标签的字体高度
res@lbOrientation              =          "Vertical"
;res@gsnLeftString = "(a)"
;res@gsnLeftStringFontHeightF = 0.022
;res@gsnLeftStringOrthogonalPosF = -0.01
;res@gsnLeftStringParallelPosF = -0.05
res@tmXBLabelsOn = False
fig_strs=(/"(a) Topography","(b) Rainfall Rate & 950-hPa Wind","(c) Relative Rainfall Intensity & 750-hPa Wind"/)

res@gsnLeftString = fig_strs(0)
res@gsnLeftStringFontHeightF = 0.026
res@gsnLeftStringOrthogonalPosF = -0.015
plot1(0)    = gsn_csm_contour_map_ce(wks, hsf(::5,::5), res)
;vector1   = gsn_csm_vector(wks, uB({levelhpa(0)},:,:), vB({levelhpa(0)},:,:), vres)
;overlay(plot1,vector1)
resLine 							= True
; --------------------------------------------------------------
dir 								= "/sky1/home/zhouchling/data/map/shapefile_China/" ; 数据的位置
fShape1Name							= dir + "china.shp"
fShape3Name							= dir + "river.shp"
; 中国国界
resLine@gsLineColor 				= "Black"
resLine@gsLineThicknessF 			= 1.5
line	= gsn_add_shapefile_polylines(wks, plot1(0), fShape1Name,resLine) 
; 江河
resLine@gsLineColor 				= "blue"
resLine@gsLineThicknessF 			= 1.2
river	= gsn_add_shapefile_polylines(wks, plot1(0), fShape3Name,resLine) 

resLine1             = True ;打开线条属性设置
resLine1@gsLineThicknessF    = 4. ;设置线条的粗细为2
resLine1@gsLineDashPattern   = 0   ;设置线条的虚线模式,0为实线
resLine1@gsLineColor         = "red2";"#b2182b";"#2166ac";"purple"  ;设置线条颜色

x1 = (/117,106,106.,117,117/);北部湾
y1 = (/15.0,15.0,30,30,15.0/)
plotLine1            = gsn_add_polyline(wks,plot1(0) ,x1,y1,resLine1)

x1 = (/110.5,110.5,110.5,110.5,110.5/);北部湾
y1 = (/15.0,30.0,30,30,30.0/)
resLine1@gsLineDashPattern   = 1
resLine1@gsLineThicknessF    = 2
plotLine11            = gsn_add_polyline(wks,plot1(0) ,x1,y1,resLine1)

resText = True 
resText@txFontHeightF = 0.012
;resText@txFont                = "helvetica-bold"
resText@txFontColor   = "black"

text = (/"106E","110.5E","117E","15N","24N","30N"/)
xx = (/106,110.5,117.,104.,104.,104/)
yy = (/13.5,13.5,13.5,15,24.0,30./)

;plottext = gsn_add_text(wks, plot1, text, xx, yy, resText)

resText@txFontHeightF = 0.018
resText@txFontColor   = "White"
resText@txFont                = "helvetica-bold"
resText@txAngleF      = 0.
text11 = (/"BBG"/)
xx11 = (/108./)
yy11 = (/20./)
plottext0 = gsn_add_text(wks, plot1(0), text11, xx11, yy11, resText)

text11 = (/"NSCS"/)
xx11 = (/113.5/)
yy11 = (/20./)
plottext1 = gsn_add_text(wks, plot1(0), text11, xx11, yy11, resText)

resText@txFontHeightF = 0.02
resText@txFontColor   = "Black"
text1 = (/"Nanling Mount","Wuyi Mount"/)
xx1 = (/112,118.5/)
yy1 = (/25.5,27/)
resText@txAngleF      = -5.
plottext2 = gsn_add_text(wks, plot1(0), text1(0), xx1(0), yy1(0), resText)
resText@txAngleF      = 50.
resText@txFontHeightF = 0.02
plottext3 = gsn_add_text(wks, plot1(0), text1(1), xx1(1), yy1(1), resText)

text1 = (/"Sichuan","Basin"/)
xx1 = (/105.5,105.5/)
yy1 = (/30.7,29.7/)
resText@txAngleF      = 0.
resText@txFontHeightF = 0.018
plottext4 = gsn_add_text(wks, plot1(0), text1, xx1, yy1, resText)

text1 = (/"Yun-Gui","Plateau"/)
xx1 = (/103,103/)
yy1 = (/26.,24.5/)
;resText@txAngleF      = 30.
resText@txFontHeightF = 0.022
plottext5 = gsn_add_text(wks, plot1(0), text1, xx1, yy1, resText)

text1 = (/"Tibetan","Plateau"/)
xx1 = (/102.5,102.5/)
yy1 = (/33.5,32./)
;resText@txAngleF      = 30.
resText@txFontHeightF = 0.02
plottext55 = gsn_add_text(wks, plot1(0), text1, xx1, yy1, resText)

text11 = (/"Yangtze River Basin"/)
xx11 = (/115./)
yy11 = (/30.8/)
resText@txAngleF      = 5.
resText@txFontHeightF = 0.023
plottext55 = gsn_add_text(wks, plot1(0), text11, xx11, yy11, resText)


text1 = (/"GX"/)
xx1 = (/109./)
yy1 = (/24./)
resText@txAngleF      = 0.
resText@txFontHeightF = 0.02
;resText@txBackgroundFillColor = "White"
resText@txFontColor   = "Red2"
plottext6 = gsn_add_text(wks, plot1(0), text1, xx1, yy1, resText)

text10 = (/"GD"/)
xx10 = (/113.5/)
yy10 = (/23.7/)
resText@txFontColor   = "Red2"
plottext7 = gsn_add_text(wks, plot1(0), text10, xx10, yy10, resText)

text10 = (/"HN"/)
xx10 = (/112./)
yy10 = (/27.5/)
resText@txFontColor   = "Red2"
plottext77 = gsn_add_text(wks, plot1(0), text10, xx10, yy10, resText)


text10 = (/"Annamite Range"/)
xx10 = (/105/)
yy10 = (/17.5/)
resText@txAngleF      = -45.
resText@txFontHeightF = 0.02
;resText@txBackgroundFillColor = "White"
resText@txFontColor   = "black"
plottext8 = gsn_add_text(wks, plot1(0), text10, xx10, yy10, resText)

res1@tmXBLabelsOn = False
res1@gsnLeftString = fig_strs(1)
res1@gsnLeftStringFontHeightF = 0.026
res1@gsnLeftStringOrthogonalPosF = -0.015
plot1(1)    = gsn_csm_contour_map_ce(wks, preB0, res1)
resLine@gsLineColor 				= "Black"
resLine@gsLineThicknessF 			= 1.5
line0   = gsn_add_shapefile_polylines(wks, plot1(1), fShape1Name,resLine)
vector1   = gsn_csm_vector(wks, uB({levelhpa(0)},:,:), vB({levelhpa(0)},:,:), vres)
overlay(plot1(1) , vector1)

rescn@cnLevelSelectionMode 		= "ExplicitLevels" 
rescn@cnLevels 					= (/0.05/) ; significant level
rescn@cnLinesOn					= False ; do not show contour lines
rescn@cnLineLabelsOn 			= False ; do not show contour labels
rescn@cnInfoLabelOn				= False ; do not show contour information
rescn@cnFillDotSizeF			= 0.004
rescn@cnFillColor               = "black";"#ca1e14";"#74c476";"orchid1";"forestgreen";"#dd3498";"orchid1";"#756bb1";"#80cdc1";"#35978f";"orchid1"
rescn@cnLineThicknessF          = 1.5
optSig 								= True
optSig@gsnShadeFillType				= "pattern"
optSig@gsnShadeLow					= 3;17;
plotcn1 	= gsn_csm_contour(wks,prob,rescn)
plotSig1 = gsn_contour_shade(plotcn1,0.05,999.,optSig)
overlay(plot1(1),plotcn1)


res2@gsnLeftString = fig_strs(2)
res2@gsnLeftStringFontHeightF = 0.026
res2@gsnLeftStringOrthogonalPosF = -0.015
plot1(2)    = gsn_csm_contour_map_ce(wks, pre, res2)
line1  = gsn_add_shapefile_polylines(wks, plot1(2), fShape1Name,resLine)
vector2   = gsn_csm_vector(wks, uB({levelhpa(1)},:,:), vB({levelhpa(1)},:,:), vres1)
overlay(plot1(2) , vector2)

pres1 = True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           False
pres1@gsnPanelTop       = 0.93
pres1@gsnPanelBottom    = 0.1
pres1@gsnPanelLeft      = 0.03
pres1@gsnPanelRight     = 0.93
pres1@gsnPanelLabelBar           =           False ;打开图形面板的标签条
;pres1@lbTitleOn                  =           True 
;pres1@lbTitleString              =           "(gpm)";"Anomaly of 950 hPa geopotential height (gpm)"
;pres1@pmLabelBarWidthF           =           0.015  ;设置标签条的宽度
;pres1@pmLabelBarHeightF          =           0.35  ;设置标签条的宽度
;pres1@lbLabelFontHeightF         =           0.35 ;设置标签条标签的字体高度
;pres1@lbOrientation               =          "Vertical";"horizontal"
;pres1@lbTitleFontHeightF         =           0.014
;pres@lbTitleJust                =           "BottomCenter"
;pres1@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
;pres1@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
;pres@gsnPanelFigureStringsPerimOn = False
;pres1@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
;pres1@gsnPanelFigureStringsFontHeightF   =       0.012 ;设置图形面板中子图标识符的字体高度为0.013
pres1@gsnPanelYWhiteSpacePercent = 1.5 ;设置每行图的间距
pres1@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
;pres1@pmLabelBarOrthogonalPosF    = 0.018 ;色标水平方向偏离的位置，正右，负左
;pres1@pmLabelBarParallelPosF      = -0.15;色标垂直方向偏离的位置，正上，负下
;txres1               = True
;txres1@txFontHeightF = 0.024
;txres1@txFont           = "helvetica-bold"
;gsn_text_ndc(wks,fig_strs1(0) ,0.3,0.95,txres1)
;gsn_text_ndc(wks,fig_strs1(1),0.74,0.95,txres1)

gsn_panel(wks,plot1,(/3,1/),pres1)
frame(wks)


end