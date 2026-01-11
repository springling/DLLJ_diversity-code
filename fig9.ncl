;----topographic
undef("read_elev_data")
function read_elev_data(topo_file)
local nlat, nlon, topo_file, lat, lon
begin
;---Read data as a straight binary file
nlat = 2160  
nlon = 4320
setfileoption("bin","ReadByteOrder","BigEndian")
elev = cbinread(topo_file,(/nlat,nlon/),"short")

;---Create 1D coordinate arrays
lat       = fspan(90,-90,nlat)
lon       = fspan(0,360,nlon)
lat!0     = "lat"
lon!0     = "lon"
lat@units = "degrees_north"
lon@units = "degrees_east"
lat&lat   = lat
lon&lon   = lon

;---Attach the coordinate arrays
elev!0    = "lat"
elev!1    = "lon"
elev&lat  = lat
elev&lon  = lon
 
return(elev)
end

begin 
topofile = "/sky7/zhouchling/data/ETOPO5.dat"
elev = read_elev_data(topofile)
elevt = elev({15:38},{97:125})
print(max(elevt))

filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
filename0 = "z_avg_China_uvwws_2001_22mn.nc"
f0 = addfile(filedir+filename0,"r")
z0 = f0->z(3:8,{200:1000},{40:10},{85:135}) 
z00 = z0/9.8
copy_VarCoords(z0,z00)
z_av = dim_avg_n_Wrap(z00, 0)
copy_VarMeta(z0(0,:,:,:), z_av)
printVarSummary(z_av)

f1 = addfile(filedir+"composite_UVws_NSCS_type_event_-24h.nc","r")
uB          = f1->uB(:,{200:1000},{40:10},{85:135})
vB          = f1->vB(:,{200:1000},{40:10},{85:135})
wsB         = f1->wsB(:,{200:1000},{40:10},{85:135})

f2 = addfile(filedir+"composite_UVws_NSCS_type_event.nc","r")
uB1          = f2->uB(:,{200:1000},{40:10},{85:135})
vB1          = f2->vB(:,{200:1000},{40:10},{85:135})
wsB1         = f2->wsB(:,{200:1000},{40:10},{85:135})

f3 = addfile(filedir+"composite_UVws_NSCS_type_event_+24h.nc","r")
uB2          = f3->uB(:,{200:1000},{40:10},{85:135})
vB2          = f3->vB(:,{200:1000},{40:10},{85:135})
wsB2         = f3->wsB(:,{200:1000},{40:10},{85:135})

path = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
filename1 = "composite_ZW_NSCS_type_event_-24h.nc"
fn1 = addfile(path+filename1,"r")
zB          = fn1->zB(:,{200:1000},{40:10},{85:135})
wB          = fn1->wB(:,{200:1000},{40:10},{85:135})

filename2 = "composite_ZW_NSCS_type_event.nc"
fn2 = addfile(path+filename2,"r")
zB1         = fn2->zB(:,{200:1000},{40:10},{85:135})
wB1         = fn2->wB(:,{200:1000},{40:10},{85:135})

filename3 = "composite_ZW_NSCS_type_event_+24h.nc"
fn3 = addfile(path+filename3,"r")
zB2         = fn3->zB(:,{200:1000},{40:10},{85:135})
wB2         = fn3->wB(:,{200:1000},{40:10},{85:135})

wrf_smooth_2d(z_av,2)
wrf_smooth_2d(zB,2)
wrf_smooth_2d(zB1,2)
wrf_smooth_2d(zB2,2)

zB_1  = (/zB/9.8/)
copy_VarCoords(zB,zB_1)
zB1_1  = (/zB1/9.8/)
copy_VarCoords(zB,zB1_1)
zB2_1  = (/zB2/9.8/)
copy_VarCoords(zB,zB2_1)

ndim = dimsizes(zB)
zB_2 = new((/ndim(0),ndim(1),ndim(2),ndim(3)/),"float")
zB1_2 = new((/ndim(0),ndim(1),ndim(2),ndim(3)/),"float")
zB2_2 = new((/ndim(0),ndim(1),ndim(2),ndim(3)/),"float")
copy_VarCoords(zB,zB_2)
copy_VarCoords(zB,zB1_2)
copy_VarCoords(zB,zB2_2)

do i = 0,ndim(0)-1
    zB_2(i,:,:,:)  = (/zB_1(i,:,:,:)-z_av/)
    zB1_2(i,:,:,:) = (/zB1_1(i,:,:,:)-z_av/)
    zB2_2(i,:,:,:) = (/zB2_1(i,:,:,:)-z_av/)
end do


plot    = new(9,graphic)
plot1   = new(9,graphic)
plot2   = new(9,graphic)
line0   = new(9,graphic)
wsplot  = new(9,graphic) 
wsplot2 = new(9,graphic)
uvplot  = new(9,graphic)
topo    = new(9,graphic)
plottext0 = new(9,graphic)
plottext00 = new(9,graphic)
plottext01 = new(9,graphic)
plottext001 = new(9,graphic)
cmap = read_colormap_file("BlueWhiteOrangeRed")
;index1 			= (/8, 18, 34, 50, 66, 82, 92, 102, 143, 159, 175, 191,207,223,239,249/)
;pngname = "draw_Z_type_Beibu_750_500_event_2"
pngname = "draw_Z_type_NSCS_750_500_event_2"
type = "pdf"
wks = gsn_open_wks(type,pngname)

res                 = True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnAddCyclic    =           False
res@gsnMaximize     =           False
res@pmTickMarkDisplayMode       = "Always" 
res@gsnAddCyclic    =           False
res@tmBorderThicknessF          =           2.
res@tmXBMajorThicknessF         =           2
res@tmXBMinorThicknessF         =           2
res@tmYLMajorThicknessF         =           2
res@tmYLMinorThicknessF         =           2

resws = res
res2  = res
res3  = res
sres  = res

sres@cnLineLabelsOn             =           False
sres@cnFillOn                   =           True
sres@cnLinesOn                  =           False
sres@cnLevelSelectionMode       =           "ExplicitLevels"
sres@cnLevels                   :=           1500
sres@cnFillColors               :=           (/"Transparent","#e8e8e8"/)
;sres@cnFillDrawOrder            =           "PostDraw"
sres@cnFillOpacityF             =           0.8
sres@lbLabelBarOn               =           False
sres@cnInfoLabelOn              =           False
;sres@cnLineThicknessF           =           3.0
;sres@cnLinePalette              = 1

resws@cnLinesOn                 =           True
resws@cnLineThicknessF          =           3.0
resws@cnLineLabelsOn            =           False
resws@cnLineColor               =           "purple";"orchid1"
resws@cnFillOn                  =           False 
resws@cnLevelSelectionMode       =             "ExplicitLevels"
resws@cnLevels                   =             (/10/)
resws@lbLabelBarOn               =           False
resws@cnInfoLabelOn              =           False

vres = res 
vres@vcGlyphStyle                =           "LineArrow"
vres@vcLineArrowThicknessF       =           2.
vres@vcPositionMode              =           "ArrowTail"
vres@vcLineArrowColor           =            "orchid1";"#fb9eb5";"#f968a1";"#E995C9";"purple" "#F19ABC";   ;设置线箭头的颜色为
;vres@vcMinMagnitudeF            =           10.0
vres@vcMinDistanceF             =           0.06    ;设置箭头之间的最小距离
;参考箭头
vres@vcRefAnnoOn                =           False
vres@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
vres@vcRefAnnoString2           =           "10 m s~S~~F18~-~F21~1~N~"
vres@vcRefAnnoFontColor         =          "orchid1"; "#fb9eb5";"#f968a1";"#E995C9";"purple"
vres@vcRefLengthF               =           0.07    ;设置参考矢量的长度
vres@vcRefAnnoBackgroundColor   =           "white"
vres@vcRefAnnoPerimOn           =           True  ;不加边框
;vres@vcRefAnnoString2On         =           False   ; 下的字符
vres@vcRefAnnoString1On         =           False ;设定参考箭头上
vres@vcRefAnnoFontHeightF       =           0.03 ;矢量标签字体大小

vres2 = vres 
vres2@vcRefAnnoOn                =           True
vres2@vcRefAnnoOrthogonalPosF    =           -1.15
vres2@vcRefAnnoParallelPosF      =           1.22

;------tickmark settings
res@tmXBLabelFontHeightF        =           0.032        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.032
res@tmXBMajorLengthF            =           0.01    ; change the tickmark length
res@tmYLMajorLengthF            =           0.01
;res@tmYLLabelAngleF      = 90

;-------map settings
res@mpLimitMode                 =           "LatLon"
;res@mpGeophysicalLineColor      =           "Black"
res@mpNationalLineColor         =           "Black"
;res@mpUSStateLineColor          =           "Black"
;res@mpGridLineColor             =           "Black"
;res@mpLimbLineColor             =           "Black"
;res@mpPerimLineColor            =           "Black"
;res@mpGeophysicalLineThicknessF =           1.0
;res@mpGridLineThicknessF        =           0.5
;res@mpLimbLineThicknessF        =           0.5
res@mpNationalLineThicknessF    =           0.8
;res@mpUSStateLineThicknessF     =           1.0
;res@mpGridAndLimbOn             =           False
res@mpDataBaseVersion           =           "Ncarg4_1" 
;res@mpDataSetName               =           "/Users/zhouchunling/my_ncl/map/Earth..4"
res@mpDataSetName               =           "/sky1/home/zhouchling/data/map/Earth..4"
res@mpOutlineOn                 =           True
res@mpOutlineSpecifiers         =           (/"China","Taiwan"/)
res@mpCountyLineThicknessF      =           2.5
;res@mpProvincialLineColor       =           "black"
;res@mpProvincialLineThicknessF  =           1.25
res@mpLandFillColor             =           -1
res@mpFillOn                    =           False
res@mpMinLatF                   =           15;latmin
res@mpMaxLatF                   =           40;latmax
res@mpMinLonF                   =           97;lonmin
res@mpMaxLonF                   =           125;lonmax
res@vpWidthF                    =           0.68
res@vpHeightF                   =           0.5
res1 = res


res2@lbLabelBarOn                =           False
res2@cnFillOn                   = False             ; turn on color
res2@cnLinesOn                  = True            ; turn off contour lines
res2@cnLineLabelsOn             = True            ; turn off contour lines
res2@cnLineLabelFontColor       = "#756bb1"
res2@cnLevelSelectionMode 		=  "ManualLevels";"ExplicitLevels";
;res2@cnLevels  = (/5700,5720,5740,5760,5780,5800,5820,5840,5860/)
res2@cnMaxLevelValF				= 2580
res2@cnMinLevelValF				= 2400.
res2@cnLineColor                = "#756bb1";"#4b1d91";
res2@cnLevelSpacingF				=10.
res2@cnLineThicknessF			= 2.5
res2@cnLineLabelFontHeightF 		= 0.024
res2@cnLabelMasking 				= True
res2@cnLineLabelBackgroundColor	= -1
res2@cnInfoLabelOn              =           False
;res2@cnLineLabelPlacementMode 		= "Constant"
res2@cnLabelMasking             =           True 
res2@cnLineLabelPlacementMode 		= "Computed"
res2@cnLineLabelInterval        = 1
;res2@cnLineLabelDensityF         =  1
;res2@cnLineLabelBackgroundColor  =          "White"

res3@lbLabelBarOn                =           False
res3@cnFillOn                   = False             ; turn on color
res3@cnLinesOn                  = True            ; turn off contour lines
res3@cnLineLabelsOn             = True            ; turn off contour lines
res3@cnLevelSelectionMode 		=  "ExplicitLevels";"ManualLevels"
res3@cnLevels  = (/5880/)
;res2@cnMaxLevelValF				= 5880
;res2@cnMinLevelValF				= 5640.
res3@cnLineColor                = "#756bb1"
;res2@cnLevelSpacingF				=20.
res3@cnLineThicknessF			= 2.
res3@cnLineLabelFontHeightF 		= 0.016
res3@cnLabelMasking 				= True
res3@cnLineLabelBackgroundColor	= -1
res3@cnInfoLabelOn              =           False



res1@cnFillOn          = True             ; turn on color
res1@cnLinesOn         = False            ; turn off contour lines
res1@cnLineLabelsOn    = False            ; turn off contour lines
;res1@cnFillPalette     = "temp_19lev"       ; set White-in-Middle color map
res1@lbLabelBarOn      = False            ; turn off individual cb's
res1@cnFillDrawOrder             =           "PreDraw"
;res1@cnFillOpacityF              =           0.9
res1@cnLevelSelectionMode = "ExplicitLevels";"ManualLevels"; "ExplicitLevels" manual set levels so lb consistent
;res1@cnMaxLevelValF       = 17.5          ; min level
;res1@cnMinLevelValF       = -15.     ; min level
;res1@cnLevelSpacingF      =  2.5   
res1@cnInfoLabelOn        =           False
res1@cnFillPalette        = cmap(25:220,:);"BlueWhiteOrangeRed";cmap(index1,:)
res1@cnLevels = (/-40,-30,-25,-20,-15,-10,-5,0,3,6,9,12,16,18,21/)
;res1@cnLevels = (/-55,-45,-35,-25,-15,-10,-5,0,5,10,15,20,25,30/)

LEVP = 750
LEVP1 = 750

;res@tiMainString =  fig_strs1(0)
;res@tiMainFontHeightF = 0.028
;res@gsnCenterStringFontHeightF = 0.032
res1@tmXBLabelsOn = False
;plot(0)  = gsn_csm_streamline_map_ce(wks,uB(0,{LEVP},:,:), vB(0,{LEVP},:,:),res)
plot1(0) = gsn_csm_contour_map_ce(wks,zB_2(0,{LEVP},:,:), res1)
plot(0)  = gsn_csm_contour(wks,zB_1(0,{LEVP1},:,:), res2)
uvplot(0) = gsn_csm_vector(wks,uB(0,{LEVP},:,:), vB(0,{LEVP},:,:),vres)

res1@tmYLLabelsOn = False
plot1(1) = gsn_csm_contour_map_ce(wks,zB_2(1,{LEVP},:,:), res1)
plot(1)  = gsn_csm_contour(wks,zB_1(1,{LEVP1},:,:), res2)
uvplot(1) = gsn_csm_vector(wks,uB(1,{LEVP},:,:), vB(1,{LEVP},:,:),vres)

plot1(2) = gsn_csm_contour_map_ce(wks,zB_2(2,{LEVP},:,:), res1)
plot(2)  = gsn_csm_contour(wks,zB_1(2,{LEVP1},:,:), res2)
uvplot(2) = gsn_csm_vector(wks,uB(2,{LEVP},:,:), vB(2,{LEVP},:,:),vres)

res1@tmYLLabelsOn = True
plot1(3) = gsn_csm_contour_map_ce(wks,zB1_2(0,{LEVP},:,:), res1)
plot(3)  = gsn_csm_contour(wks,zB1_1(0,{LEVP1},:,:), res2)
uvplot(3) = gsn_csm_vector(wks,uB1(0,{LEVP},:,:), vB1(0,{LEVP},:,:),vres)

res1@tmYLLabelsOn = False
plot1(4) = gsn_csm_contour_map_ce(wks,zB1_2(1,{LEVP},:,:), res1)
plot(4)  = gsn_csm_contour(wks,zB1_1(1,{LEVP1},:,:), res2)
uvplot(4) = gsn_csm_vector(wks,uB1(1,{LEVP},:,:), vB1(1,{LEVP},:,:),vres)

res1@tmYLLabelsOn = False
plot1(5) = gsn_csm_contour_map_ce(wks,zB1_2(2,{LEVP},:,:), res1)
plot(5)  = gsn_csm_contour(wks,zB1_1(2,{LEVP1},:,:), res2)
uvplot(5) = gsn_csm_vector(wks,uB1(2,{LEVP},:,:), vB1(2,{LEVP},:,:),vres)

res1@tmYLLabelsOn = True
res1@tmXBLabelsOn = True
vres@vcRefAnnoOn                =           False 
vres@vcRefAnnoParallelPosF      =            -1.26
vres@vcRefAnnoOrthogonalPosF    =           -0.8
plot1(6) = gsn_csm_contour_map_ce(wks,zB2_2(0,{LEVP},:,:), res1)
plot(6)  = gsn_csm_contour(wks,zB2_1(0,{LEVP1},:,:), res2)
uvplot(6) = gsn_csm_vector(wks,uB2(0,{LEVP},:,:), vB2(0,{LEVP},:,:),vres)

res1@tmYLLabelsOn = False
vres@vcRefAnnoOn                =           False
plot1(7) = gsn_csm_contour_map_ce(wks,zB2_2(1,{LEVP},:,:), res1)
plot(7)  = gsn_csm_contour(wks,zB2_1(1,{LEVP1},:,:), res2)
uvplot(7) = gsn_csm_vector(wks,uB2(1,{LEVP},:,:), vB2(1,{LEVP},:,:),vres)

vres@vcRefAnnoOn                =           True
vres@vcRefAnnoOrthogonalPosF    =           0.1
vres@vcRefAnnoParallelPosF      =           0.8
res1@tmYLLabelsOn = False
plot1(8) = gsn_csm_contour_map_ce(wks,zB2_2(2,{LEVP},:,:), res1)
plot(8)  = gsn_csm_contour(wks,zB2_1(2,{LEVP1},:,:), res2)
uvplot(8) = gsn_csm_vector(wks,uB2(2,{LEVP},:,:), vB2(2,{LEVP},:,:),vres)
do i =0,8
    topo(i) = gsn_csm_contour(wks, elevt, sres)
    overlay(plot1(i),plot(i))
    overlay(plot1(i),uvplot(i))
    overlay(plot1(i),topo(i))
end do 

resText = True 
resText@txFontHeightF = 0.07
resText@txFont                = "helvetica-bold"
resText@txFontColor   = "#756bb1";"black"
text = (/"H"/)
xx = 117.
yy = 28. 
;plottext1 = gsn_add_text(wks, plot1(3), text, xx, yy, resText)
xx = 112.7
yy = 28. 
resText@txFontHeightF = 0.05
;plottext1 = gsn_add_text(wks, plot1(0), text, xx, yy, resText)
xx = 122.
yy = 20
resText@txFontHeightF = 0.07
;plottext3 = gsn_add_text(wks, plot1(4), text, xx, yy, resText)
;plottext3 = gsn_add_text(wks, plot1(1), text, xx, yy, resText)

text = (/"L"/)
resText@txFontColor   = "#d6604d"
xx = 105.
yy = 30.
;plottext3 = gsn_add_text(wks, plot1(4), text, xx, yy, resText)
xx = 110.5
yy = 28
;plottext3 = gsn_add_text(wks, plot1(5), text, xx, yy, resText)
xx = 106
yy = 29
;plottext3 = gsn_add_text(wks, plot1(2), text, xx, yy, resText)



resText = True 
resText@txFontHeightF = 0.07
resText@txFont                = "helvetica-bold"
resText@txFontColor   = "#756bb1";"black"
text = (/"H"/)
xx = 114.
yy = 20.
plottext2 = gsn_add_text(wks, plot1(3), text, xx, yy, resText)
xx = 111.
yy = 19.
plottext2 = gsn_add_text(wks, plot1(0), text, xx, yy, resText)
xx = 118.
yy = 17.5
plottext4 = gsn_add_text(wks, plot1(4), text, xx, yy, resText)
plottext4 = gsn_add_text(wks, plot1(1), text, xx, yy, resText)

text = (/"L"/)
resText@txFontColor   = "#d6604d"
xx = 110.
yy = 30.
plottext3 = gsn_add_text(wks, plot1(4), text, xx, yy, resText)
xx = 106.
yy = 30.
plottext33 = gsn_add_text(wks, plot1(1), text, xx, yy, resText)
xx = 115
yy = 25
plottext3 = gsn_add_text(wks, plot1(5), text, xx, yy, resText)
plottext34 = gsn_add_text(wks, plot1(2), text, xx, yy, resText)
fig_strs = (/"(a)","(d)","(g)","(b)","(e)","(h)","(c)","(f)","(i)"/)

resText = True 
resText@txFontHeightF = 0.024
resText@txFont                = "helvetica"
resText@txFontColor   = "black"
text0 = (/"Yun-Gui"/)
text00 = (/"Plateau"/)

text01 = (/"Tibetan"/)
text001 = (/"Plateau"/)

do i =0,8
xx = 101.7
yy = 26.7
plottext0(i) = gsn_add_text(wks, plot1(i), text0, xx, yy, resText)

yy = 25.2
plottext00(i) = gsn_add_text(wks, plot1(i), text00, xx, yy, resText)

xx = 100
yy = 34.
plottext01(i) = gsn_add_text(wks, plot1(i), text01, xx, yy, resText)

yy = 32.5
plottext001(i) = gsn_add_text(wks, plot1(i), text001, xx, yy, resText)
end do

fig_strs1 = (/"Beibu Gulf","NSCS"/)

fig_strs2 = (/"Type-D","Type-C","Type-O"/)
fig_strs3 = (/"-24 hr","0 hr","+24 hr"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                  =           False 
pres@gsnPanelTop               = 0.93
pres@gsnPanelBottom            = 0.05
pres@gsnPanelLeft              = 0.08
pres@gsnPanelRight             = 0.97

pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "750-hPa geopotential height anomalies (gpm)";"("+ sclab5+" "+div@units +")"
pres@lbTitleFontHeightF         =           0.016
pres@pmLabelBarWidthF           =           0.6  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.07
pres@lbLabelFontHeightF         =           0.014 ;设置标签条标签的字体高度
pres@lbOrientation              =          "horizontal"
;pres@lbTitlePosition            =          "Bottom"
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStringsPerimOn = True
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.014 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 1 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@pmLabelBarOrthogonalPosF    = 0.052 ;色标垂直方向偏离的位置，正上，负下
;pres@pmLabelBarParallelPosF      = 0.2;色标水平方向偏离的位置，正右，负左
;pres@gsnPanelDebug          = True
txres1               = True
txres1@txFontHeightF = 0.024
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs2(0) ,0.25,0.883,txres1)
gsn_text_ndc(wks,fig_strs2(1),0.55,0.883,txres1)
gsn_text_ndc(wks,fig_strs2(2),0.85,0.883 ,txres1)

txres1@txFontHeightF = 0.024
txres1@txAngleF = 90
gsn_text_ndc(wks,fig_strs3(0) ,0.052,0.75,txres1)
gsn_text_ndc(wks,fig_strs3(1),0.052,0.52,txres1)
gsn_text_ndc(wks,fig_strs3(2),0.052,0.3,txres1)
;txres1@txFontHeightF = 0.025
;gsn_text_ndc(wks,"NSCS & 750hPa (SLLJ)" ,0.51,0.971,txres1)
;gsn_text_ndc(wks,"950hPa (BLJ)" ,0.48,0.98,txres1)
gsn_panel(wks, plot1, (/3,3/), pres)
frame(wks)
end 