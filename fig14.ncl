function arrow(wks,plt,xpts,ypts,res)
local x0, x1, y0, y1, xp1, xp2, yp1, yp2, xp1n, xp2n, yp1n, yp2n, pi, \
rad2deg, theta, asp, fhead, ahead, phi, resp, lambda1, lambda2, arr_str, \
x1an, ya1n, xa1, ya1, xpts1, ypts1, xa2n, ya2n, xa2, ya2, xpts2, ypts2
begin

 res2 = res    ; make a copy so we can modify it if needed.

 getvalues plt
  "trXMinF": x0
  "trXMaxF": x1
  "trYMinF": y0
  "trYMaxF": y1
 end getvalues

 arr_str = unique_string("arr")   ; need to make sure this is unique
 plt@$arr_str$ = gsn_add_polyline(wks,plt,xpts,ypts,res2)

; determines how broad should the arrow be
 asp = 0.4

 xp1 = xpts(0)
 xp2 = xpts(1)
 yp1 = ypts(0)
 yp2 = ypts(1)

 xp1n = (xp1 - x0)/(x1-x0)
 xp2n = (xp2 - x0)/(x1-x0)
 yp1n = (yp1 - y0)/(y1-y0)
 yp2n = (yp2 - y0)/(y1-y0)

 pi = get_pi("float")
 rad2deg = get_r2d("float")

 theta = atan2((yp2n-yp1n),(xp2n-xp1n))

 if(theta.lt.0 .and. yp2.gt.yp1)then
  theta = pi + theta
 else
  if(theta.gt.0 .and. yp2.lt.yp1)then
   theta = pi + theta
  end if
 end if

; length of the line of arrowhead as a fraction of the length of the given line
 fhead = 0.3
 ahead = sqrt((xp2n-xp1n)*(xp2n-xp1n) + (yp2n-yp1n)*(yp2n-yp1n))*fhead
 phi = atan(asp)

 lambda1 = theta + phi
 xa1n = xp2n - ahead*cos(lambda1)
 ya1n = yp2n - ahead*sin(lambda1)
 xa1 = x0 + xa1n*(x1-x0)
 ya1 = y0 + ya1n*(y1-y0)

;---Don't add line labels to arrowhead.
 if(isatt(res2,"gsLineLabelString")) then
    delete(res2@gsLineLabelString)
 end if

 xpts1 = (/xa1,xp2/)
 ypts1 = (/ya1,yp2/)
 arr_str = unique_string("arr")   ; need to make sure this is unique
 plt@$arr_str$ = gsn_add_polyline(wks,plt,xpts1,ypts1,res2)

 lambda2 = theta - phi
 xa2n = xp2n - ahead*cos(lambda2)
 ya2n = yp2n - ahead*sin(lambda2)
 xa2 = x0 + xa2n*(x1-x0)
 ya2 = y0 + ya2n*(y1-y0)
 xpts2 = (/xa2,xp2/)
 ypts2 = (/ya2,yp2/)
 arr_str = unique_string("arr")   ; need to make sure this is unique
 plt@$arr_str$ = gsn_add_polyline(wks,plt,xpts2,ypts2,res2)

 return (plt)
end

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
latmin = 18
latmax = 32
lonmin1 = 107;112
lonmax1 = 120;120
lonmin2 = 107;112
lonmax2 = 120;120
lonmid = 112

topofile = "/sky7/zhouchling/data/ETOPO5.dat"
elev = read_elev_data(topofile)
elevt = elev({latmin:latmax},{lonmin1:lonmax1})
elevt1=where(elevt.ge.0, elevt,0)
elevt2=1013.25*(1-elevt1*0.0065/288.15)^5.25145
copy_VarCoords(elevt,elevt2)
printVarSummary(elevt2)
elevt3 = dim_avg_n_Wrap(elevt2,1)
printVarSummary(elevt3)
lat = elevt3&lat

ndim  = dimsizes(elevt3)
npoints = ndim+2
dx = new(npoints,"float")
dhgt = new(npoints,"float")
dx(0) = lat(0) 
dx(1:ndim) = lat
dx(ndim+1) = lat(ndim-1)

dhgt(0) = 1000
dhgt(1:ndim) = elevt3  
dhgt(ndim+1) = 1000
print(dhgt)

elevt0 = elev({latmin:latmax},{lonmin2:lonmax2})
elevt10=where(elevt0.ge.0, elevt0,0)
elevt20=1013.25*(1-elevt10*0.0065/288.15)^5.25145
copy_VarCoords(elevt0,elevt20)
printVarSummary(elevt20)
elevt30 = dim_avg_n_Wrap(elevt20,1)
printVarSummary(elevt3)
lat0 = elevt30&lat

ndim0  = dimsizes(elevt30)
npoints = ndim0+2
dx0 = new(npoints,"float")
dhgt0 = new(npoints,"float")
dx0(0) = lat0(0) 
dx0(1:ndim0) = lat0
dx0(ndim0+1) = lat0(ndim0-1)

dhgt0(0) = 1000
dhgt0(1:ndim0) = elevt30  
dhgt0(ndim0+1) = 1000
print(dhgt0)

filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
filename = "composite_Com_MFC_div_Beibu_type_event_after9h.nc"
fn = addfile(filedir+filename,"r")
MFC1 = fn->duvq(:,{1000:650},{latmin:latmax},{lonmin1:lonmax1})
MFC_B = dim_avg_n_Wrap(MFC1,3)

;elevt3 = conform(MFC1, elevt2, (/2/))
;printVarSummary(elevt3)

fn1 = addfile(filedir+ "composite_Com_div_vor_Beibu_type_event_after9h.nc","r")
div01 = fn1->div(:,{1000:650},{latmin:latmax},{lonmin1:lonmax1})
vor01 = fn1->vor(:,{1000:650},{latmin:latmax},{lonmin1:lonmax1})
vor1 = (/vor01/9.0/)
copy_VarCoords(vor01,vor1)
div1 = (/div01/9.0/)
copy_VarCoords(div01,div1)
div_B = dim_avg_n_Wrap(div1,3)
vor_B = dim_avg_n_Wrap(vor1,3)

f1 = addfile(filedir+"composite_Com_UVws_Beibu_type_event_after9h.nc","r")
v10          = f1->vB(:,{1000:650},{latmin:latmax},{lonmin1:lonmax1})
num_typeB   = f1->num_type 
v1  = (/v10/9.0/)
copy_VarCoords(v10,v1)
vB = dim_avg_n_Wrap(v1,3)

print(max(vB))
print(min(vB))

f2 = addfile(filedir+"composite_Com_ZW_Beibu_type_event_after9h.nc","r")
w10          = f2->wB(:,{1000:650},{latmin:latmax},{lonmin1:lonmax1})
w1  = (/w10/9.0/)
copy_VarCoords(w10,w1)
wB = dim_avg_n_Wrap(w1*(-100), 3)
copy_VarCoords(w1(:,:,:,0), wB)
print(max(wB))
print(min(wB))

filename = "composite_Com_MFC_div_NSCS_type_event_after9h.nc"
fn = addfile(filedir+filename,"r")
MFC2 = fn->duvq(:,{1000:650},{latmin:latmax},{lonmin2:lonmax2})
MFC_N = dim_avg_n_Wrap(MFC2,3)

fn1 = addfile(filedir+ "composite_Com_div_vor_NSCS_type_event_after9h.nc","r")
div02 = fn1->div(:,{1000:650},{latmin:latmax},{lonmin2:lonmax2})
vor02 = fn1->vor(:,{1000:650},{latmin:latmax},{lonmin2:lonmax2})
vor2 = (/vor02/9.0/)
copy_VarCoords(vor02,vor2)
div2 = (/div02/9.0/)
copy_VarCoords(div02,div2)
div_N = dim_avg_n_Wrap(div2,3)
vor_N = dim_avg_n_Wrap(vor2,3)

f1 = addfile(filedir+"composite_Com_UVws_NSCS_type_event_after9h.nc","r")
v20          = f1->vB(:,{1000:650},{latmin:latmax},{lonmin2:lonmax2})
num_typeN   = f1->num_type 
v2  = (/v20/9.0/)
copy_VarCoords(v20,v2)
vN = dim_avg_n_Wrap(v2,3)

f2 = addfile(filedir+"composite_Com_ZW_NSCS_type_event_after9h.nc","r")
w20          = f2->wB(:,{1000:650},{latmin:latmax},{lonmin2:lonmax2})
w2  = (/w20/9.0/)
copy_VarCoords(w20,w2)
wN = dim_avg_n_Wrap(w2*(-100), 3)
copy_VarCoords(w2(:,:,:,0), wN)
print(max(wN))
print(min(wN))

;wrf_smooth_2d(w,2)
;wrf_smooth_2d(div, 3)
;wrf_smooth_2d(MFC, 3)

scl5  = 1e5                                  ; arbitrary: used for nicer plot values
sclab5= "10~S~-5~N~"                       ; used later   
SCLAB5= "(10~S~5~N~)"           

scl4  = 1e4  
sclab4= "(10~S~-4~N~)"         
SCLAB4= "(10~S~4~N~)" 

pdfname = "fig_Div_W_ver_Beibu_NSCS_event1"
type = "pdf"
wks = gsn_open_wks(type,pdfname)
cmap    = read_colormap_file("cmp_b2r")
cmap1    = read_colormap_file("MPL_coolwarm")
plot  = new(6,"graphic")
plot1  = new(6,"graphic")
plot2  = new(6,"graphic")
plot3  = new(6,"graphic")
oro   = new(6,"graphic")
plotLine22 = new(6, "graphic")
plotLine33 = new(6, "graphic")
plotLine220 = new(6, "graphic")
plotLine330 = new(6, "graphic")

res                     =           True
res@gsnFrame            =           False 
res@gsnDraw             =           False 
res@gsnLeftString       =           ""
res@gsnRightString      =           ""
res@vpWidthF            =           0.75
res@vpHeightF           =           0.6
res@gsnAddCyclic        =           False

;res@pmTickMarkDisplayMode       = "Always" 
res@tmBorderThicknessF          =           1.8
res@tmXBMajorThicknessF         =           1.5
res@tmXBMinorThicknessF         =           1.5
res@tmYLMajorThicknessF         =           1.5
res@tmYLMinorThicknessF         =           1.5

;------tickmark settings
res@tmXBLabelFontHeightF        =           0.036        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.034
res@tmXBMajorLengthF            =           0.015    ; change the tickmark length
res@tmYLMajorLengthF            =           0.015

res2 = res 
res1 = res 
res3 = res 

res2@cnLevelSelectionMode        =   "ExplicitLevels"
res2@cnLevels  = (/-2,-1,-0.5,0.5,1,2/)
res2@cnLineThicknessF = 2.5
res2@cnLineColor = "forestgreen"
res2@cnLineLabelFontHeightF = 0.026
res2@cnLineDashPattern = 0
res2@gsnContourNegLineDashPattern = 1;负值用虚线
res2@gsnContourZeroLineThicknessF = 0 ;不显示0
res2@cnInfoLabelOn = False
res2@cnLabelMasking = True 
res2@cnLineLabelBackgroundColor = -1 
res2@tiYAxisString    = " "
res2@cnLineLabelPlacementMode 		= "Constant"

res1@cnLevelSelectionMode        =   "ExplicitLevels"
res1@cnLevels  = (/5,6,7,8/)
res1@cnLineThicknessF = 2.5
res1@cnLineColor = "#0E8585";"#467F79";"orchid1";"#35978f";"forestgreen"
res1@cnLineLabelFontHeightF = 0.026
res1@cnLineDashPattern = 0
res1@gsnContourNegLineDashPattern = 11;负值用虚线
res1@gsnContourZeroLineThicknessF = 0 ;不显示0
res1@cnInfoLabelOn = False
res1@cnLabelMasking = True 
res1@cnLineLabelBackgroundColor = -1 
res1@tiYAxisString    = " "
res1@cnLineLabelPlacementMode 		= "Constant"
res1@cnLineLabelFontColor=          "#01665f"; 

res3@cnLevelSelectionMode        =   "ExplicitLevels"
res3@cnLevels  = (/5,6,7,8/)
res3@cnLineThicknessF = 2.5
res3@cnLineColor = "red";"#467F79";"orchid1";"#35978f";"forestgreen"
res3@cnLineLabelFontHeightF = 0.026
res3@cnLineDashPattern = 1
res3@gsnContourNegLineDashPattern = 11;负值用虚线
res3@gsnContourZeroLineThicknessF = 0 ;不显示0
res3@cnInfoLabelOn = False
res3@cnLabelMasking = True 
res3@cnLineLabelBackgroundColor = -1 
res3@tiYAxisString    = " "
res3@cnLineLabelPlacementMode 		= "Constant"
res3@cnLineLabelFontColor=          "red"; 

res@pmLabelBarOrthogonalPosF    =           0.3
;res@pmTickMarkDisplayMode       =           "Always" 

;------labelbar
res@lbLabelBarOn                =           False
res@pmLabelBarOrthogonalPosF    =           0.3
res@pmLabelBarHeightF           =           0.2
res@pmLabelBarWidthF            =           0.05
res@lbLabelFontHeightF          =           0.01

;-------contour settings
res@cnLineLabelsOn              =           False
res@cnFillOn                    =           True
res@cnLinesOn                   =           False
;res@cnLevelSelectionMode        =           "ManualLevels"
;res@cnMinLevelValF              =           -0.3
;res@cnMaxLevelValF              =           0.3
;res@cnLevelSpacingF             =           0.1
;res@cnFillPalette               =           "BlueWhiteOrangeRed"
res@cnInfoLabelOn               =           False
res@cnLevelSelectionMode        =           "ExplicitLevels"
;res@cnLevels = (/-24,-20,-16,-12,-8,-4,0,4,8,12,16,20,24/)
res@cnLevels = (/-1.8,-1.5,-1.2,-0.9,-0.6,-0.3,0,0.3,0.6,0.9,1.2,1.5,1.8/)
cmap2    = read_colormap_file("MPL_RdBu")
res@cnFillPalette        =  cmap2(8:126,:);cmap1(2:118:-1,:);cmap(2:58:-1,:);;


res@vcGlyphStyle               =           "LineArrow";"CurlyVector";
res@vcMinDistanceF             =           0.05
res@vcLineArrowThicknessF      =           1.5
res@vcPositionMode             =           "ArrowTail"
res@vcLineArrowColor           =           "black"
;res1@vcMinMagnitudeF            =           8.0

res@vcRefAnnoOn                =           False
res@vcRefMagnitudeF            =           10.     ;设置参考矢量的大小
res@vcRefAnnoString2           =           "10 m s~S~~F18~-~F21~1~N~"
res@vcRefAnnoString1           =           "~F18~-~F21~0.01 Pa s~S~~F18~-~F21~1~N~"
res@vcRefAnnoFontColor        =           "black"
res@vcRefLengthF               =           0.05   ;设置参考矢量的长度
res@vcRefAnnoBackgroundColor   =           "white"
res@vcRefAnnoArrowAngleF       =           30
res@vcRefAnnoPerimOn           =           True  ;不加边框
res@vcRefAnnoString2On         =           True; 下的字符
res@vcRefAnnoString1On         =           True ;设定参考箭头上字符
res@vcRefAnnoSide              =           "Top"
res@vcRefAnnoFontHeightF       =           0.022 

res@tiYAxisString    = "Pressure (hPa)"
res@tiYAxisFontHeightF    = 0.038
res@tmYRTickSpacingF     = 1
res@tmYRMode   = "Manual"
res@tmXTMode   = "Manual"
res@tmYRMajorLengthF            = 0
res@tmYRMinorLengthF            = 0
res@tmXTMajorLengthF            = 0
res@tmXTMinorLengthF            = 0
res@tmXTOn = False
res@tmYROn = False
res2@tmXTOn = False
res2@tmYROn = False
res1@tmXTOn = False
res1@tmYROn = False
;res@tmYRTickStartF = 0
;res@tmYRTickEndF   = 3
res2@tmYRMajorLengthF = 0
res2@tmXTMajorLengthF = 0
res2@tmYRMode   = "Manual"
res1@tmYRMajorLengthF = 0
res1@tmXTMajorLengthF = 0
res1@tmYRMode   = "Manual"
;res2@tmYRTickStartF = 0
;res2@tmYRTickEndF   = 6
;res2@tmYRTickSpacingF = 1

topores=True
topores@gsFillColor="grey55"
topores@gsLineThicknessF=2
topores@gsLineColor = "black"

MFC_B1 = MFC_B 
MFC_B1 = MFC_B*scl5
div_B1 = div_B 
div_B1 = div_B*scl5
vor_B1 = vor_B 
vor_B1 = vor_B*scl4
print(max(vB))
print(min(vB))

res@tmXBLabelsOn = False
plot(0) = gsn_csm_pres_hgt_vector(wks, div_B1(0,:,:), vB(0,:,:), wB(0,:,:), res)
plot(2) = gsn_csm_pres_hgt_vector(wks, div_B1(1,:,:), vB(1,:,:), wB(1,:,:), res)
res@tmXBLabelsOn = True
plot(4) = gsn_csm_pres_hgt_vector(wks, div_B1(2,:,:), vB(2,:,:), wB(2,:,:), res)

;res@tmYLLabelsOn = False
plot2(0) = gsn_csm_pres_hgt(wks,vB(0,:,:),res1)
plot2(2) = gsn_csm_pres_hgt(wks,vB(1,:,:),res1)
plot2(4) = gsn_csm_pres_hgt(wks,vB(2,:,:),res1)

plot3(0) = gsn_csm_pres_hgt(wks,wB(0,:,:),res3)
plot3(2) = gsn_csm_pres_hgt(wks,wB(1,:,:),res3)
plot3(4) = gsn_csm_pres_hgt(wks,wB(2,:,:),res3)
oro(0) = gsn_add_polygon(wks, plot(0), dx, dhgt, topores)
oro(2) = gsn_add_polygon(wks, plot(2), dx, dhgt, topores)
oro(4) = gsn_add_polygon(wks, plot(4), dx, dhgt, topores)


MFC_N1 = MFC_N 
MFC_N1 = MFC_N*scl5
div_N1 = div_N 
div_N1 = div_N*scl5
vor_N1 = vor_N 
vor_N1 = vor_N*scl4
res@tmXBLabelsOn = False
res@tiYAxisString    = ""
res@vpXF = 0.
print(max(vN))
print(min(vN))
res@tmXBLabelsOn = False
res@vcRefAnnoOn                =           True
res@vcRefAnnoParallelPosF      =            1
res@vcRefAnnoOrthogonalPosF    =           -0.27
plot(1) = gsn_csm_pres_hgt_vector(wks, div_N1(0,:,:), vN(0,:,:), wN(0,:,:), res)
res@vcRefAnnoOn                =           False
plot(3) = gsn_csm_pres_hgt_vector(wks, div_N1(1,:,:), vN(1,:,:), wN(1,:,:), res)
res@tmXBLabelsOn = True
plot(5) = gsn_csm_pres_hgt_vector(wks, div_N1(2,:,:), vN(2,:,:), wN(2,:,:), res)

plot2(1) = gsn_csm_pres_hgt(wks,vN(0,:,:),res1)
plot2(3) = gsn_csm_pres_hgt(wks,vN(1,:,:),res1)
plot2(5) = gsn_csm_pres_hgt(wks,vN(2,:,:),res1)

plot3(1) = gsn_csm_pres_hgt(wks,wN(0,:,:),res3)
plot3(3) = gsn_csm_pres_hgt(wks,wN(1,:,:),res3)
plot3(5) = gsn_csm_pres_hgt(wks,wN(2,:,:),res3)

oro(1) = gsn_add_polygon(wks, plot(1), dx0, dhgt, topores)
oro(3) = gsn_add_polygon(wks, plot(3), dx0, dhgt, topores)
oro(5) = gsn_add_polygon(wks, plot(5), dx0, dhgt, topores)

resLine33                           =           True
resLine33@gsLineColor               =           "black"
resLine33@gsLineThicknessF          =           2.2
resLine33@tfPolyDrawOrder           =           "PostDraw"
resLine33@gsLineDashPattern         =           7

xarrow1 = (/23.,25.5/)
yarrow1 = (/  930,  840/)
xarrow2 = (/26.,27.2/)
yarrow2 = (/  870,  890/)
xarrow3 = (/27.5,30/)
yarrow3 = (/  900,  800/)

resp = True   ; Resource list for customizing arrows. Start with default arrows.
resp@gsLineColor       = "Red"
resp@gsLineDashPattern = 0    ; solid line
resp@gsLineThicknessF  = 5.0  ; 3x thicker
;plot(2) = arrow(wks,plot(2),xarrow1,yarrow1,resp)
;plot(2) = arrow(wks,plot(2),xarrow2,yarrow2,resp)
;plot(2) = arrow(wks,plot(2),xarrow3,yarrow3,resp)

xarrow1 = (/22.5,25./)
yarrow1 = (/  930,  840/)
xarrow2 = (/25.5,26.5/)
yarrow2 = (/  870,  880/)
xarrow3 = (/27,28.5/)
yarrow3 = (/  890,  800/)
;plot(3) = arrow(wks,plot(3),xarrow1,yarrow1,resp)
;plot(3) = arrow(wks,plot(3),xarrow2,yarrow2,resp)
;plot(3) = arrow(wks,plot(3),xarrow3,yarrow3,resp)

xarrow1 = (/21.2,25.5/)
yarrow1 = (/  980,  820/)
;plot(4) = arrow(wks,plot(4),xarrow1,yarrow1,resp)

xarrow1 = (/21.2,23.7/)
yarrow1 = (/  980,  780/)
;plot(5) = arrow(wks,plot(5),xarrow1,yarrow1,resp)
do i =0,5
   overlay(plot(i), plot2(i))
   ;overlay(plot(i), plot3(i))
end do
resLine33                           =           True
resLine33@gsLineColor               =           "purple"
resLine33@gsLineThicknessF          =           2.2
resLine33@tfPolyDrawOrder           =           "PostDraw"
resLine33@gsLineDashPattern         =           1

xx0 = (/18,32/)
yy0 = (/950,950/)
yy00 = (/750,750/)
;do i = 0,5
;    plotLine220(i) = gsn_add_polyline(wks,plot(i),xx0,yy0,resLine33) 
;    plotLine330(i) = gsn_add_polyline(wks,plot(i),xx0,yy00,resLine33)
;end do


fig_strs = (/"(a) Type-D","(b) Type-D","(c) Type-C","(d) Type-C","(e) Type-O","(f) Type-O"/)


fig_strs1 = (/"BBG","NSCS"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                  =           False 
pres@gsnPanelTop               = 0.93
pres@gsnPanelBottom            = 0.05 
pres@gsnPanelLeft               =           0.03
pres@gsnPanelRight              =           0.93
pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "(10~S~~F18~-~F21~5~N~"+" "+"s~S~~F18~-~F21~1~N~)";"("+ sclab5+" "+div@units +")"
pres@lbTitleFontHeightF         =           0.016
pres@pmLabelBarWidthF           =           0.06  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.6
pres@lbLabelFontHeightF         =           0.016
pres@lbLabelFontHeightF         =           0.016 ;设置标签条标签的字体高度
pres@lbOrientation               =          "vertical";"horizontal"
;pres@lbLabelFont = "helvetica-bold"
;pres@lbFontThicknessF      = 1.2
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStringsPerimOn = True
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.014 ;设置图形面板中子图标识符的字体高度为0.013 
pres@gsnPanelYWhiteSpacePercent = 3 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
;pres@pmLabelBarOrthogonalPosF    = -0.037 ;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      = -0.15;色标垂直方向偏离的位置，正上，负下
pres@pmLabelBarParallelPosF      =  0.03;;色标垂直方向偏离的位置，正上，负下
;pres@gsnPanelDebug          = True
txres1               = True
txres1@txFontHeightF = 0.026
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.285,0.93,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.69,0.93,txres1)

gsn_panel(wks, plot, (/3,2/), pres)
frame(wks)
end 