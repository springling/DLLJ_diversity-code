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
elevt = elev({-10:60},{100:160})
elevt1=where(elevt.ge.0, elevt,0)
elevt2=1013.25*(1-elevt1*0.0065/288.15)^5.25145
copy_VarCoords(elevt,elevt2)
printVarSummary(elevt2)

filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
fn1 = addfile(filedir+"composite_UVws_Beibu_type_event.nc","r")
uB          = fn1->uB(:,{1000:650},::-1,:)
vB          = fn1->vB(:,{1000:650},::-1,:) 
wsB         = fn1->wsB(:,{1000:650},::-1,:) 
num_typeB   = fn1->num_type 

fn2 = addfile(filedir+"composite_UVws_NSCS_type_event.nc","r")
uN          = fn2->uB(:,{1000:650},::-1,:)
vN          = fn2->vB(:,{1000:650},::-1,:) 
wsN         = fn2->wsB(:,{1000:650},::-1,:) 
num_typeN   = fn2->num_type 

yy11 = (/16.0,32./)
xx11 = (/108.0,108.0/)
yy21 = (/16.0,32./)
xx21 = (/112.5,112.5/)

npts     = 100
points  = ispan(0,npts-1,1)*1.0 
ptsXsec11     = gc_latlon(yy11(0), xx11(0), yy11(1), xx11(1), npts, 2)
ptsXsec21     = gc_latlon(yy21(0), xx21(0), yy21(1), xx21(1), npts, 2)

u11    = linint2_points(uB&longitude,uB&latitude,uB(:,:,:,:),False,ptsXsec11@gclon,ptsXsec11@gclat,2)
u21    = linint2_points(uN&longitude,uN&latitude,uN(:,:,:,:),False,ptsXsec21@gclon,ptsXsec21@gclat,2)
v11    = linint2_points(vB&longitude,vB&latitude,vB(:,:,:,:),False,ptsXsec11@gclon,ptsXsec11@gclat,2)
v21    = linint2_points(vN&longitude,vN&latitude,vN(:,:,:,:),False,ptsXsec21@gclon,ptsXsec21@gclat,2)
ws11   = linint2_points(wsB&longitude,wsB&latitude,wsB(:,:,:,:),False,ptsXsec11@gclon,ptsXsec11@gclat,2)
ws21   = linint2_points(wsN&longitude,wsN&latitude,wsN(:,:,:,:),False,ptsXsec21@gclon,ptsXsec21@gclat,2)
printVarSummary(u11)

u11!1 = "level"
u11&level = vB&level
u21!1 = "level"
u21&level = vB&level

v11!1 = "level"
v11&level = vB&level
v21!1 = "level"
v21&level = vB&level

ws11!1 = "level"
ws11&level = vB&level
ws21!1 = "level"
ws21&level = vB&level

trano11   = linint2_points(elevt2&lon,elevt2&lat,elevt2,False,ptsXsec11@gclon,ptsXsec11@gclat,2)
pgonlat11 = new(102,"float")
pgonhgt11 = new(102,"float")
pgonlat11(0) = 0
pgonhgt11(0) = 1000
pgonlat11(101) = 99
pgonhgt11(101) = 1000
pgonlat11(1:100) = points 
pgonhgt11(1:100) = doubletofloat(trano11)
printVarSummary(pgonhgt11)
printVarSummary(pgonlat11)

N1           = npts-1
nLabels      = 5 
latXsecUser11  = ptsXsec11@gclat      ; convenience
lonXsecUser11  = ptsXsec11@gclon
XBValues11     = toint( fspan(0,N1,nLabels) )
XBLabels11     = new(nLabels,"string")
do i=0,nLabels-1
    x11 = lonXsecUser11(XBValues11(i))
    y11 = latXsecUser11(XBValues11(i))
    XBLabels11(i) = sprintf("%5.1f", y11)+" N"+"~C~"+sprintf("%5.1f", x11)+" E"
end do

trano21   = linint2_points(elevt2&lon,elevt2&lat,elevt2,False,ptsXsec21@gclon,ptsXsec21@gclat,2)
pgonlat21 = new(102,"float")
pgonhgt21 = new(102,"float")
pgonlat21(0) = 0
pgonhgt21(0) = 1000
pgonlat21(101) = 99
pgonhgt21(101) = 1000
pgonlat21(1:100) = points 
pgonhgt21(1:100) = doubletofloat(trano21)

latXsecUser21  = ptsXsec21@gclat      ; convenience
lonXsecUser21  = ptsXsec21@gclon
XBValues21    = toint( fspan(0,N1,nLabels) )
XBLabels21     = new(nLabels,"string")

do i=0,nLabels-1
    x21 = lonXsecUser21(XBValues21(i))
    y21 = latXsecUser21(XBValues21(i))
    XBLabels21(i) = sprintf("%5.1f", y21)+" N"+"~C~"+sprintf("%5.1f", x21)+" E"
end do


plot       = new(6, "graphic")
plot2      = new(6, "graphic")
oro        = new(6, "graphic")
txid1      = new(6, "graphic")
txid2      = new(6, "graphic")
annoid1    = new(6, "graphic")
annoid2    = new(6, "graphic")
plotLine22 = new(6, "graphic")
plotLine33 = new(6, "graphic")

pngname = "draw_UV_Vertical_event"
type = "pdf"
wks = gsn_open_wks(type,pngname)
res1                             =           True
res1@gsnDraw                     =           False
res1@gsnFrame                    =           False
res1@gsnLeftString               =           ""
res1@gsnRightString              =           ""
res1@gsnAddCyclic                =           False
res1@tmXTOn = False
res1@tmYROn = False

res3 = res1 
res2 = res1 
res3@vpWidthF                    =           0.65
res3@vpHeightF                   =           0.5
res2@cnLevelSelectionMode        =   "ExplicitLevels"
res2@cnLevels  = (/10,12/)
res2@cnLineThicknessF = 2.5
res2@cnLineColor = "forestgreen"
res2@cnLineLabelFontHeightF = 0.022
res2@cnLineDashPattern = 0
res2@cnInfoLabelOn = False
res2@cnLabelMasking = True 
res2@cnLineLabelBackgroundColor = -1 
res2@tiYAxisString    = " "

res1@pmTickMarkDisplayMode       = "Always" 
res1@tmBorderThicknessF          =           2.5
res1@tmXBMajorThicknessF         =           2
res1@tmXBMinorThicknessF         =           2
res1@tmYLMajorThicknessF         =           2
res1@tmYLMinorThicknessF         =           2

;------tickmark settings
res1@tmXBLabelFontHeightF        =           0.03        ; change maj lat tm spacing
res1@tmYLLabelFontHeightF        =           0.03
res1@tmXBMajorLengthF            =           0.015    ; change the tickmark length
res1@tmYLMajorLengthF            =           0.015

res1@vpWidthF                    =           0.65
res1@vpHeightF                   =           0.5
res1@cnFillOn                    =           True            ; turn on color fill
res1@cnLinesOn                   =           False           ; turn lines on/off         ; True is default
res1@cnLineLabelsOn              =           False
res1@lbLabelBarOn                =           False 
res1@cnInfoLabelOn               =           False

res1@vcGlyphStyle               =           "LineArrow"
res1@vcMinDistanceF             =           0.05
res1@vcLineArrowThicknessF      =           1.5
res1@vcPositionMode             =           "ArrowTail"
res1@vcLineArrowColor           =           "black" 
res1@vcMinMagnitudeF            =           7.0

res1@vcRefAnnoOn                =           False
res1@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
res1@vcRefAnnoString1           =           "10 m s~S~~F18~-~F21~1~N~"
res1@vcRefAnnoFontColor        =           "black"
res1@vcRefLengthF               =           0.03   ;设置参考矢量的长度
res1@vcRefAnnoBackgroundColor   =           "white"
res1@vcRefAnnoArrowAngleF       =           30
res1@vcRefAnnoPerimOn           =           True  ;不加边框
res1@vcRefAnnoString2On         =           False; 下的字符
res1@vcRefAnnoString1On         =           True ;设定参考箭头上字符
res1@vcRefAnnoSide              =           "Top"
res1@vcRefAnnoFontHeightF       =           0.026 


cmap = read_colormap_file("temp_diff_18lev");
;index = (/4,5,6,7,8,9,10,11,12,13,14,15,16/)
res1@cnFillPalette               =           "temp_diff_18lev";"cmp_b2r";cmap(index,:)
startf = 2
endf =16    
spacingf = 1
res1@cnLevelSelectionMode        =           "ManualLevels"
res1@cnMinLevelValF              =           startf
res1@cnMaxLevelValF              =           endf
res1@cnLevelSpacingF             =           spacingf
res1@cnFillOpacityF              =           0.85


orores=True
orores@gsFillColor="grey55"
orores@gsLineThicknessF=2
orores@gsLineColor = "black"

res1@tmYRMajorLengthF = 0
res1@tmXTMajorLengthF = 0
res1@tmYRMode   = "Manual"
res1@tmYRTickStartF = 0
res1@tmYRTickEndF   = 6
res1@tmYRTickSpacingF = 1
res2@tmYRMajorLengthF = 0
res2@tmXTMajorLengthF = 0
res2@tmYRMode   = "Manual"
res2@tmYRTickStartF = 0
res2@tmYRTickEndF   = 6
res2@tmYRTickSpacingF = 1
res1@tiYAxisString    = "Pressure (hPa)"
res1@tiYAxisFontHeightF    = 0.034

res1@tmXBMode   = "Explicit"
res1@tmXBValues = XBValues11
res1@tmXBLabels = XBLabels11
res1@tmYRLabelsOn  =False

res1@tmXBLabelsOn = False
plot(0) = gsn_csm_pres_hgt_vector(wks,ws11(0,:,:), u11(0,:,:),v11(0,:,:), res1)
plot2(0) = gsn_csm_pres_hgt(wks,ws11(0,:,:),res2) 

res1@tmXBValues = XBValues21
res1@tmXBLabels = XBLabels21
res1@vcRefAnnoOn                =           True 
res1@vcRefAnnoParallelPosF      =            1.3
res1@vcRefAnnoOrthogonalPosF    =           -0.5

res1@tiYAxisString    = ""
plot(1) = gsn_csm_pres_hgt_vector(wks,ws21(0,:,:), u21(0,:,:),v21(0,:,:), res1) 
plot2(1) = gsn_csm_pres_hgt(wks,ws21(0,:,:),res2)

res1@tmXBValues = XBValues11
res1@tmXBLabels = XBLabels11
res1@vcRefAnnoOn                =           False
res1@tiYAxisString    = "Pressure (hPa)"
plot(2) = gsn_csm_pres_hgt_vector(wks,ws11(1,:,:), u11(1,:,:), v11(1,:,:), res1) 
plot2(2) = gsn_csm_pres_hgt(wks,ws11(1,:,:),res2)

res1@tmXBValues = XBValues21
res1@tmXBLabels = XBLabels21
res1@tiYAxisString    = ""
plot(3) = gsn_csm_pres_hgt_vector(wks,ws21(1,:,:), u21(1,:,:), v21(1,:,:), res1) 
plot2(3) = gsn_csm_pres_hgt(wks,ws21(1,:,:),res2)

res1@tmXBValues = XBValues11
res1@tmXBLabels = XBLabels11
res1@tmXBLabelsOn = True
res1@tiYAxisString    = "Pressure (hPa)"
plot(4) = gsn_csm_pres_hgt_vector(wks,ws11(2,:,:), u11(2,:,:), v11(2,:,:), res1) 
plot2(4) = gsn_csm_pres_hgt(wks,ws11(2,:,:),res2)

res1@tmXBValues = XBValues21
res1@tmXBLabels = XBLabels21
res1@tiYAxisString    = ""
plot(5) = gsn_csm_pres_hgt_vector(wks,ws21(2,:,:), u21(2,:,:), v21(2,:,:), res1) 
plot2(5) = gsn_csm_pres_hgt(wks,ws21(2,:,:),res2)

do i = 0,5
    overlay(plot(i),plot2(i))
end do 

oro(0) = gsn_add_polygon(wks, plot(0),pgonlat11, pgonhgt11, orores)
oro(1) = gsn_add_polygon(wks, plot(1),pgonlat21, pgonhgt21, orores)
oro(2) = gsn_add_polygon(wks, plot(2),pgonlat11, pgonhgt11, orores)
oro(3) = gsn_add_polygon(wks, plot(3),pgonlat21, pgonhgt21, orores)
oro(4) = gsn_add_polygon(wks, plot(4),pgonlat11, pgonhgt11, orores)
oro(5) = gsn_add_polygon(wks, plot(5),pgonlat21, pgonhgt21, orores)

txres                       = True
txres@txPerimOn             = False 
txres@txBackgroundFillColor = -1
txres@txFontHeightF         = 0.03
txres@txFont                = "helvetica-bold"
txres@txFontColor           = "forestgreen"
txres@txFontThicknessF      = 1.2

amres = True
amres@amParallelPosF   = -0.49
amres@amOrthogonalPosF = 0.74
AA = (/"A","C","A","C","A","C"/)
BB = (/"B","D","B","D","B","D"/)
do i = 4,5
    txid1(i)   = gsn_create_text(wks, AA(i), txres)
    annoid1(i) = gsn_add_annotation(plot(i), txid1(i), amres)
end do

amres@amParallelPosF   = 0.49
do i = 4,5
    txid2(i) = gsn_create_text(wks, BB(i), txres)
    annoid2(i) = gsn_add_annotation(plot(i), txid2(i), amres)
end do

resLine33                           =           True
resLine33@gsLineColor               =           "black"
resLine33@gsLineThicknessF          =           2.2
resLine33@tfPolyDrawOrder           =           "PostDraw"
resLine33@gsLineDashPattern         =           1

xx0 = (/0,N1/)
yy0 = (/950,950/)
yy00 = (/750,750/)
do i = 0,5
    plotLine22(i) = gsn_add_polyline(wks,plot(i),xx0,yy0,resLine33) 
    plotLine33(i) = gsn_add_polyline(wks,plot(i),xx0,yy00,resLine33)
end do

fig_strs = (/"(a) Type-D","(b) Type-D","(c) Type-C","(d) Type-C","(e) Type-O","(f) Type-O"/)
fig_strs1 = (/"BBG","NSCS"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                   =           False
pres@gsnPanelTop                =           0.93
pres@gsnPanelBottom             =           0.03
pres@gsnPanelLeft               =           0.03
pres@gsnPanelRight              =           0.93
pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "Wind speed (m s~S~~F18~-~F21~1~N~)"
pres@lbTitleFontHeightF         =           0.02
;pres@lbTitleAngleF              =           90
pres@pmLabelBarWidthF           =           0.05  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.55
;pres@lbLabelFontHeightF         =           0.016
pres@lbLabelFontHeightF         =           0.016 ;设置标签条标签的字体高度
pres@lbOrientation               =          "vertical";"horizontal"
;pres@pmLabelBarOrthogonalPosF   =           0.03
pres@lbTitlePosition = "Right"
pres@lbTitleAngleF = 90
pres@lbTitleDirection="Across";"Down"
;pres@lbTitlePosition            =           "Right"
;pres@lbTitleFontHeightF         =           0.015
;pres@pmLegendOrthogonalPosF     =           0.07
;pres@lbTitleJust                =           "Center"
;pres@pmLabelBarWidthF           =           0.7  ;设置标签条的宽度
;pres@lbLabelFontHeightF         =           0.012 ;设置标签条标签的字体高度
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.016 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 0 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@pmLabelBarOrthogonalPosF    = -0.05;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      =  0.03;;色标垂直方向偏离的位置，正上，负下
txres1               = True
txres1@txFontHeightF = 0.022
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.27,0.92,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.69,0.92,txres1)

gsn_panel(wks, plot, (/3,2/), pres)
frame(wks)
end 