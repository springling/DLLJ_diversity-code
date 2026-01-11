begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
filename = "composite_Com_MFC_div_Beibu_type_event_after9h_1.nc"
fn1 = addfile(filedir+filename,"r")
MFC10 = fn1->VIMFC
uq1  = fn1->iuq
vq1  = fn1->ivq
MFC1 = MFC10
copy_VarCoords(MFC10,MFC1)
printMinMax(MFC1,2)

filename = "composite_Com_MFC_div_NSCS_type_event_after9h_1.nc"
fn2 = addfile(filedir+filename,"r")
MFC20 = fn2->VIMFC
uq2  = fn2->iuq
vq2  = fn2->ivq
MFC2 = MFC20
copy_VarCoords(MFC20,MFC2)
wrf_smooth_2d(MFC1, 2)
wrf_smooth_2d(MFC2, 2)
wrf_smooth_2d(uq1, 3)
wrf_smooth_2d(uq2, 3)
wrf_smooth_2d(vq1, 3)
wrf_smooth_2d(vq2, 3)

filename = "composite_Com_div_vor_Beibu_type_event_after9h_1.nc"
fn = addfile(filedir+filename,"r")
vor01 = fn->vor
vor1 = (/vor01/9.0/)
copy_VarCoords(vor01,vor1) 

f1 = addfile(filedir+"composite_Com_UVws_Beibu_type_event_after9h.nc","r")
uB1          = f1->uB
vB1          = f1->vB
num_typeB   = f1->num_type 
uB  = (/uB1/9.0/)
vB  = (/vB1/9.0/)
copy_VarCoords(uB1,uB)
copy_VarCoords(vB1,vB)

f2 = addfile(filedir+"composite_Com_div_vor_NSCS_type_event_after9h_1.nc","r")
vor02          = f2->vor
vor2 = (/vor02/9.0/)
copy_VarCoords(vor02,vor2)

f3 = addfile(filedir+"composite_Com_UVws_NSCS_type_event_after9h.nc","r")
uN1          = f3->uB
vN1          = f3->vB
num_typeN   = f3->num_type 
uN  = (/uN1/9.0/)
vN  = (/vN1/9.0/)
copy_VarCoords(uN1,uN)
copy_VarCoords(vN1,vN)

wrf_smooth_2d(vor1, 5)
wrf_smooth_2d(vor2, 5)

scl4  = 1e4                                  ; arbitrary: used for nicer plot values
sclab4= "10~S~-4~N~"                       ; used later   
SCLAB4= "(10~S~4~N~)"           

scl6  = 1e6  
sclab6= "(10~S~-6~N~)"         
SCLAB6= "(10~S~6~N~)"        


plot    = new(6,"graphic")
plot1    = new(6,"graphic")
uvplot  = new(6,"graphic")
uvplot1  = new(6,"graphic")
line0   = new(6,"graphic")
line01   = new(6,"graphic")
plotShade = new(6,"graphic")
LEVP = 750
cmap    = read_colormap_file("BlueWhiteOrangeRed")
pngname = "fig_IVMFC_vor_Beibu_NSCS_event_3_2"
type = "pdf"
wks = gsn_open_wks(type,pngname)

resd                 = True
resd@gsnDraw         =           False
resd@gsnFrame        =           False
resd@gsnAddCyclic    =           False
resd@gsnMaximize     =           False
resd@pmTickMarkDisplayMode       = "Always" 
resd@tmBorderThicknessF          =           1.8
resd@tmXBMajorThicknessF         =           1.8
resd@tmXBMinorThicknessF         =           1.8
resd@tmYLMajorThicknessF         =           1.8
resd@tmYLMinorThicknessF         =           1.8
resd@gsnLeftString  = ""
resd@gsnRightString = ""
resuv = resd
resw = resd

;--------750 hPa vorticity
resw@cnLineLabelsOn            =           False
resw@cnFillOn                  =           False
resw@cnLinesOn                 =           True
resw@cnLineThicknessF          =           3.
resw@cnLineColor               =           "#35978f";"#01665f"; "orchid1";"forestgreen";;"limegreen";"skyblue";"#5ac8c8";"forestgreen";"#74c476";"#35978f";"#bf812d";"#8c510a";"green";"#dd3498"
resw@cnInfoLabelOn             =           False
;resw@lbLabelBarOn              =           False
resw@cnLevelSelectionMode      =           "ExplicitLevels"
resw@cnLineDashPattern         =           0
resw@cnLevels                  =           (/0.2/)
;resw@cnLineLabelsOn            =           True
resw@cnLineLabelFontHeightF    =           0.02
resw@cnLabelMasking            =           True 
resw@cnLineLabelBackgroundColor =          -1 
resw@cnLineLabelPlacementMode 		= "Constant"
resw@cnFillColor               =          "#35978f"; "forestgreen";"orchid1";"#5ac8c8";"forestgreen";"#74c476";"#35978f";"#bf812d";"#8c510a";"green";"#dd3498";"#be64ac"
;resw@cnFillScaleF              =           0.5

opt = True
opt@gsnShadeFillType = "pattern"
opt@gsnShadeHigh = 3
;opt@gsnShadeLow = 6;17;6;3;7;3;17
;opt@gsnShadeFillDotSizeF = 0.05
opt@gsnShadeFillScaleF   = 1.

;------tickmark settings
resd@tmXBLabelFontHeightF        =           0.034        ; change maj lat tm spacing
resd@tmYLLabelFontHeightF        =           0.034
resd@tmXBMajorLengthF            =           0.01    ; change the tickmark length
resd@tmYLMajorLengthF            =           0.01

;-------map settings
resd@mpLimitMode                 =           "LatLon"
;resd@mpGeophysicalLineColor      =           "Black"
resd@mpNationalLineColor         =           "Black"
;resd@mpUSStateLineColor          =           "Black"
;resd@mpGridLineColor             =           "Black"
;resd@mpLimbLineColor             =           "Black"
;resd@mpPerimLineColor            =           "Black"
;resd@mpGeophysicalLineThicknessF =           1.0
;resd@mpGridLineThicknessF        =           0.5
;resd@mpLimbLineThicknessF        =           0.5
resd@mpNationalLineThicknessF    =           0.8
;resd@mpUSStateLineThicknessF     =           1.0
;resd@mpGridAndLimbOn             =           False
resd@mpDataBaseVersion           =           "Ncarg4_1" 
;resd@mpDataSetName               =           "/Users/zhouchunling/my_ncl/map/Earth..4"
resd@mpDataSetName               =           "/sky1/home/zhouchling/data/map/Earth..4"
resd@mpOutlineOn                 =           True
resd@mpOutlineSpecifiers         =           (/"China","Taiwan"/)
resd@mpCountyLineThicknessF      =           2.
;resd@mpProvincialLineColor       =           "Gray"
;resd@mpProvincialLineThicknessF  =           1.4
resd@mpLandFillColor             =           -1
resd@mpFillOn                    =           False
resd@mpMinLatF                   =           15;latmin
resd@mpMaxLatF                   =           35;latmax
resd@mpMinLonF                   =           100;lonmin
resd@mpMaxLonF                   =           125;lonmax
resd@vpWidthF                    =           0.68
resd@vpHeightF                   =           0.5

resd@cnFillOn        = True                  ; color
resd@cnLinesOn       = False                 ; turn off contour lines

;;resd@cnLevelSelectionMode = "ManualLevels"   ; set manual contour levels
;resd@cnMinLevelValF       = -4.                  ; set min contour level
;resd@cnMaxLevelValF       =  4.                  ; set max contour level
;resd@cnLevelSpacingF      =   0.5                  ; set contour spacing
;resd@cnFillPalette   = "cmocean_balance"     ; NCL 6.5.0
resd@cnLevelSelectionMode        =           "ExplicitLevels"
;resd@cnLevels = (/-3.5,-2.5,-1.5,-0.5,0,0.5,1.5,2.5,3.5/)
resd@cnLevels = (/-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5/)
cmap2    = read_colormap_file("MPL_RdBu")
resd@cnFillPalette        = cmap2(20:110:-1,:);"MPL_RdBu";cmap(index,:);"BlueDarkRed18"
resd@cnInfoLabelOn        =           False
resd@lbLabelBarOn         =           False
resd@cnLineLabelsOn              =           False

resuv@vcRefAnnoOn                =           False
resuv@vcRefMagnitudeF      = 500000.                    ; make vectors larger
resuv@vcRefLengthF         = 0.015                 ; reference vector length
resuv@vcRefAnnoString2           = "(500" + " "+"kg m~S~~F18~-~F21~1~N~"+" "+"s~S~~F18~-~F21~1~N~"+")"
resuv@vcRefAnnoBackgroundColor   =           "white"
resuv@vcRefAnnoPerimOn           =           True  ;边框
resuv@vcRefAnnoString2On         =           True  ; 下的字符
resuv@vcRefAnnoString1On         =           False ;设定参考箭头上
resuv@vcRefAnnoFontHeightF       =           0.026  ;矢量标签字体大小
resuv@vcRefAnnoOrthogonalPosF    = -0.278          ; move ref vector up
resuv@vcLineArrowColor           =           "black";"#8c62aa"; "purple";"#8c62aa";"#3b4994";"#756bb1";"orchid1"
resuv@vcRefAnnoFontColor         =       "black"; "#8c62aa"; "black";"purple"; "#8c62aa";"#3b4994";"#756bb1";"orchid1"
resuv@vcGlyphStyle                =          "CurlyVector";"LineArrow";"CurlyVector"
;resuv@vcPositionMode              =           "ArrowTail"
resuv@vcLineArrowThicknessF       =           1.6
resuv@vcMinDistanceF       = 0.075
resuv@vcMinMagnitudeF         = 500000
;resuv@vcFillArrowHeadInteriorXF = 0.5
;resuv@vcFillArrowHeadXF = 0.5
;resuv@vcFillArrowHeadYF = 0.5


resLine 							= True
; --------------------------------------------------------------
dir 								= "/sky1/home/zhouchling/data/map/shapefile_China/" ; 数据的位置
fShape1Name							= dir + "china.shp"
fShape3Name							= dir + "river.shp"
; 中国国界
resLine@gsLineColor 				= "Black"
resLine@gsLineThicknessF 			= 1.5

fig_strs = (/"(a)","(b)","(e)","(f)","(i)","(j)"/)
resd@tmXBLabelsOn = False
resd@tmYLLabelsOn = False
;resd@gsnLeftString = fig_strs(0)
;resd@gsnLeftStringFontHeightF = 0.034
;resd@gsnLeftStringOrthogonalPosF = -0.01
plot(0)   = gsn_csm_contour_map_ce(wks,MFC1(0,:,:),resd)
uvplot(0) = gsn_csm_vector(wks,uq1(0,:,:),vq1(0,:,:),resuv)
line0(0)  = gsn_add_shapefile_polylines(wks, plot(0), fShape1Name,resLine) 

;resd@gsnLeftString = fig_strs(2)
plot(2)   = gsn_csm_contour_map_ce(wks,MFC1(1,:,:),resd)
uvplot(2) = gsn_csm_vector(wks,uq1(1,:,:),vq1(1,:,:),resuv)
line0(2)  = gsn_add_shapefile_polylines(wks, plot(2), fShape1Name,resLine) 

resd@tmXBLabelsOn = True
;resd@gsnLeftString = fig_strs(4)
plot(4)   = gsn_csm_contour_map_ce(wks,MFC1(2,:,:),resd)
uvplot(4) = gsn_csm_vector(wks,uq1(2,:,:),vq1(2,:,:),resuv)
line0(4)  = gsn_add_shapefile_polylines(wks, plot(4), fShape1Name,resLine) 
  
resd@tmXBLabelsOn = False
;resd@gsnLeftString = fig_strs(1)
;resd@gsnLeftStringOrthogonalPosF = 0.02
plot(1)   = gsn_csm_contour_map_ce(wks,MFC2(0,:,:),resd)
uvplot(1) = gsn_csm_vector(wks,uq2(0,:,:),vq2(0,:,:),resuv)
line0(1)  = gsn_add_shapefile_polylines(wks, plot(1), fShape1Name,resLine) 

resuv@vcRefAnnoOn                =           False
;resd@gsnLeftString = fig_strs(3)
plot(3)   = gsn_csm_contour_map_ce(wks,MFC2(1,:,:),resd)
uvplot(3) = gsn_csm_vector(wks,uq2(1,:,:),vq2(1,:,:),resuv)
line0(3)  = gsn_add_shapefile_polylines(wks, plot(3), fShape1Name,resLine)


resd@tmXBLabelsOn = True
;resd@gsnLeftString = fig_strs(5)
resuv@vcRefAnnoOn                =           True
;resuv@vcRefAnnoParallelPosF      =            1.37
resuv@vcRefAnnoOrthogonalPosF    =           0.05
plot(5)   = gsn_csm_contour_map_ce(wks,MFC2(2,:,:),resd)
uvplot(5) = gsn_csm_vector(wks,uq2(2,:,:),vq2(2,:,:),resuv)
line0(5)  = gsn_add_shapefile_polylines(wks, plot(5), fShape1Name,resLine)

do i = 0,5
    overlay(plot(i),uvplot(i))
end do

delete(resd)
delete(resuv)
resd                 = True
resd@gsnDraw         =           False
resd@gsnFrame        =           False
resd@gsnAddCyclic    =           False
resd@gsnMaximize     =           False
resd@pmTickMarkDisplayMode       = "Always" 
resd@tmBorderThicknessF          =           1.8
resd@tmXBMajorThicknessF         =           1.8
resd@tmXBMinorThicknessF         =           1.8
resd@tmYLMajorThicknessF         =           1.8
resd@tmYLMinorThicknessF         =           1.8
resd@gsnLeftString  = ""
resd@gsnRightString = ""

resuv = resd

opt = True
opt@gsnShadeFillType = "pattern"
;opt@gsnShadeHigh = 3
opt@gsnShadeLow = 11;3;17
;opt@gsnShadeFillDotSizeF = 0.005

;------tickmark settings
resd@tmXBLabelFontHeightF        =           0.034        ; change maj lat tm spacing
resd@tmYLLabelFontHeightF        =           0.034
resd@tmXBMajorLengthF            =           0.01    ; change the tickmark length
resd@tmYLMajorLengthF            =           0.01
resd@vpWidthF                    =           0.68
resd@vpHeightF                   =           0.5

;-------map settings
resd@mpLimitMode                 =           "LatLon"
resd@mpGeophysicalLineColor      =           "Black"
resd@mpNationalLineColor         =           "Black"
resd@mpUSStateLineColor          =           "Black"
resd@mpGridLineColor             =           "Black"
resd@mpLimbLineColor             =           "Black"
resd@mpPerimLineColor            =           "Black"
resd@mpGeophysicalLineThicknessF =           1.0
resd@mpGridLineThicknessF        =           0.5
resd@mpLimbLineThicknessF        =           0.5
resd@mpNationalLineThicknessF    =           0.8
resd@mpUSStateLineThicknessF     =           1.0
resd@mpGridAndLimbOn             =           False
resd@mpDataBaseVersion           =           "Ncarg4_1" 
;resd@mpDataSetName               =           "/Users/zhouchunling/my_ncl/map/Earth..4"
resd@mpDataSetName               =           "/sky1/home/zhouchling/data/map/Earth..4"
resd@mpOutlineOn                 =           True
resd@mpOutlineSpecifiers         =           (/"China","Taiwan"/)
resd@mpCountyLineThicknessF      =           2.5
;resd@mpProvincialLineColor       =           "Gray"
;resd@mpProvincialLineThicknessF  =           1.4
resd@mpLandFillColor             =           -1
resd@mpFillOn                    =           False
resd@mpMinLatF                   =           15;latmin
resd@mpMaxLatF                   =           35;latmax
resd@mpMinLonF                   =           100;lonmin
resd@mpMaxLonF                   =           125;lonmax
resd@vpWidthF                    =           0.68
resd@vpHeightF                   =           0.5
resLine 							= True

resd@cnFillOn        = True                  ; color
resd@cnLinesOn       = False                 ; turn off contour lines

;;resd@cnLevelSelectionMode = "ManualLevels"   ; set manual contour levels
;resd@cnMinLevelValF       = -4.                  ; set min contour level
;resd@cnMaxLevelValF       =  4.                  ; set max contour level
;resd@cnLevelSpacingF      =   0.5                  ; set contour spacing
;resd@cnFillPalette   = "cmocean_balance"     ; NCL 6.5.0
resd@cnLevelSelectionMode        =           "ExplicitLevels"
;resd@cnLevels = (/-2,-1.5,-1,-0.5,-0.3,0.3,0.5,1,2,3/)
;resd@cnLevels = (/-1,-0.8,-0.6,-0.4,-0.2,-0.1,0,0.1,0.2,0.4,0.6,0.8,1/)
;resd@cnLevels = (/-0.45,-0.35,-0.25,-0.15,-0.05,0,0.05,0.15,0.25,0.35,0.45/)
resd@cnLevels = (/-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4/)
resd@cnFillPalette        = cmap(40:205,:);"BlueDarkRed18"
resd@cnInfoLabelOn        =           False
resd@lbLabelBarOn         =           False
resd@cnLineLabelsOn              =           False

resuv@vcRefAnnoOn                =           False
resuv@vcRefMagnitudeF      = 10.                    ; make vectors larger
resuv@vcRefLengthF         = 0.05                 ; reference vector length
resuv@vcRefAnnoString2           =           "10 m s~S~~F18~-~F21~1~N~"
resuv@vcRefAnnoBackgroundColor   =           "white"
resuv@vcRefAnnoPerimOn           =           True  ;边框
resuv@vcRefAnnoString2On         =           True  ; 下的字符
resuv@vcRefAnnoString1On         =           False ;设定参考箭头上
resuv@vcRefAnnoFontHeightF       =           0.026  ;矢量标签字体大小
resuv@vcRefAnnoOrthogonalPosF    = -0.278          ; move ref vector up

resuv@vcGlyphStyle                =          "WindBarb";"CurlyVector";"LineArrow";"CurlyVector"
;resuv@vcPositionMode              =           "ArrowTail"
resuv@vcLineArrowThicknessF       =           1.6
resuv@vcWindBarbLineThicknessF    =           1.6
resuv@vcMinDistanceF       = 0.06
resuv@vcMinMagnitudeF         = 1.
resuv@vcWindBarbScaleFactorF  = 2.5
resuv@vcWindBarbTickSpacingF  = 0.16
resuv@vcWindBarbTickLengthF   = 0.36

resuv@vcMonoLineArrowColor  = False
resuv@vcMonoWindBarbColor   = False
colors1 = (/(/5./255,5./255,5./255/),(/221./255,52./255,152./255/)/)
resuv@vcLevelPalette        = colors1;cmap1(65:125,:)
resuv@vcLevelSelectionMode  = "ExplicitLevels";"Manuallevels"
resuv@vcLevels = (/9/)
resuv@lbLabelBarOn    = False
;resuv@vcWindBarbColor = colors1
;resuv@vcMonoLineArrowColor  = False
;cmap1 = read_colormap_file("MPL_BuGn");read_colormap_file("MPL_BuGn");MPL_Greys
;index1 = (/0,56,78,94,110,126/)
;colors1 = (/(/245./255,245./255,245./255/),(/199./255,234./255,229./255/),(/128./255,205./255,19./255/),(/53./255,151./255,143./255/),(/1./255,102./255,95./255/),(/0/255.,60/255.,48/255./)/)
;colors1 = (/(/245./255,245./255,245./255/),(/246./255,232./255,195./255/),(/223./255,194./255,125./255/),(/191./255,129./255,45./255/),(/140./255,81./255,10./255/),(/84/255.,48/255.,5/255./)/)
;colors1 = read_colormap_file("MPL_Greys")
;index1 = (/0,49,65,81,97,113/)
;colors1 = (/(/199./255,234./255,229./255/),(/128./255,205./255,19./255/),(/53./255,151./255,143./255/),(/1./255,102./255,95./255/),(/0/255.,60/255.,48/255./)/)

;resuv@vcLevelPalette        = colors1;(index1,:);cmap1(65:125,:)
;resuv@vcLevelSelectionMode  = "ExplicitLevels";"Manuallevels"
;resuv@vcLevels = (/0,50,100,150/)
;resuv@vcMinMagnitudeF      = 20.0
;resuv@vcMaxLevelValF        = 12
;resuv@vcMinLevelValF        = 8
;resuv@gsnScalarContour= True                  ; vectors over contours
;resuv@lbLabelBarOn    = False

fig_strs1 = (/"(c)","(d)","(g)","(h)","(k)","(l)"/)

DIV  = vor1(:,:,:,:)                     ; keep meta data
DIV  = DIV*scl4                               ; nicer numbers  
print(max(DIV(:,{LEVP},{15:35},{100:125})))
print(min(DIV(:,{LEVP},{15:35},{100:125})))

resd@tmXBLabelsOn = False
resd@tmYLLabelsOn = True
;resd@gsnLeftString = fig_strs1(0)
;resd@gsnLeftStringFontHeightF = 0.034
;resd@gsnLeftStringOrthogonalPosF = -0.01
plot1(0) = gsn_csm_contour_map(wks,DIV(0,{LEVP},:,:),resd)
uvplot1(0) = gsn_csm_vector(wks,uB(0,{LEVP},:,:),vB(0,{LEVP},:,:),resuv)
line01(0)	= gsn_add_shapefile_polylines(wks, plot(0), fShape1Name,resLine) 

;resd@gsnLeftString = fig_strs1(2)
plot1(2) = gsn_csm_contour_map(wks,DIV(1,{LEVP},:,:),resd)
uvplot1(2) = gsn_csm_vector(wks,uB(1,{LEVP},:,:),vB(1,{LEVP},:,:),resuv)
line01(2)	= gsn_add_shapefile_polylines(wks, plot(2), fShape1Name,resLine) 

resd@tmXBLabelsOn = True
;resd@gsnLeftString = fig_strs1(4)
plot1(4) = gsn_csm_contour_map(wks,DIV(2,{LEVP},:,:),resd)
uvplot1(4) = gsn_csm_vector(wks,uB(2,{LEVP},:,:),vB(2,{LEVP},:,:),resuv)
line01(4)	= gsn_add_shapefile_polylines(wks, plot(4), fShape1Name,resLine) 


print(max(DIV(:,{LEVP},{15:35},{100:125})))
print(min(DIV(:,{LEVP},{15:35},{100:125})))

;resd@gsnLeftStringOrthogonalPosF = 0.02
DIV2  = vor2(:,:,:,:)                     ; keep meta data
DIV2  = DIV2*scl4                               ; nicer numbers 
resd@tmYLLabelsOn = False
resd@tmXBLabelsOn = False
;resd@gsnLeftString = fig_strs1(1)
plot1(1) = gsn_csm_contour_map(wks,DIV2(0,{LEVP},:,:),resd)
uvplot1(1) = gsn_csm_vector(wks,uN(0,{LEVP},:,:),vN(0,{LEVP},:,:),resuv)
line01(1)	= gsn_add_shapefile_polylines(wks, plot(1), fShape1Name,resLine) 

resuv@vcRefAnnoOn                =           False
;resd@gsnLeftString = fig_strs1(3)
plot1(3) = gsn_csm_contour_map(wks,DIV2(1,{LEVP},:,:),resd)
uvplot1(3) = gsn_csm_vector(wks,uN(1,{LEVP},:,:),vN(1,{LEVP},:,:),resuv)
line01(3)	= gsn_add_shapefile_polylines(wks, plot(3), fShape1Name,resLine) 

resuv@vcRefAnnoOn                =           True
;resuv@vcRefAnnoParallelPosF      =            1.37
resuv@vcRefAnnoOrthogonalPosF    =           0.05
resd@tmXBLabelsOn = True
;resd@gsnLeftString = fig_strs1(5)
plot1(5) = gsn_csm_contour_map(wks,DIV2(2,{LEVP},:,:),resd)
uvplot1(5) = gsn_csm_vector(wks,uN(2,{LEVP},:,:),vN(2,{LEVP},:,:),resuv)
line01(5)	= gsn_add_shapefile_polylines(wks, plot(5), fShape1Name,resLine)

do i = 0,5
    overlay(plot1(i),uvplot1(i)) 
end do

fig_strs2 = (/"BBG","NSCS","BBG","NSCS"/)

pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                   =           False
pres@gsnPanelTop       = 0.93
pres@gsnPanelBottom    = 0.03
pres@gsnPanelLeft      = 0.06
pres@gsnPanelRight     = 0.51
pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres@lbTitleOn                  =           True
pres@lbTitleString              =           "750-hPa Vorticity (10~S~~F18~-~F21~4~N~"+" "+"s~S~~F18~-~F21~1~N~"+")";"("+ sclab5+" "+div@units +")"
pres@lbTitleFontHeightF         =           0.012
pres@pmLabelBarWidthF           =           0.31  ;设置标签条的宽度
pres@pmLabelBarHeightF          =           0.04
pres@lbLabelFontHeightF         =           0.01 ;设置标签条标签的字体高度
pres@lbOrientation              =          "horizontal" 
pres@lbTitlePosition            =           "Bottom"
;pres@lbTitleFontHeightF         =           0.015
;pres@pmLegendOrthogonalPosF     =           0.07
;pres@lbTitleJust                =           "Center"
;pres@pmLabelBarWidthF           =           0.7  ;设置标签条的宽度
;pres@lbLabelFontHeightF         =           0.012 ;设置标签条标签的字体高度
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.012 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 1.5 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
pres@pmLabelBarOrthogonalPosF    = 0.022;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      =  -0.225;;色标垂直方向偏离的位置，正上，负下

;---Resources for paneling
pres1 = True
pres1@gsnMaximize                =           False
pres1@gsnFrame                   =           False
pres1@gsnPanelTop                =           0.924
pres1@gsnPanelBottom             =           0.028
pres1@gsnPanelLeft               =           0.53
pres1@gsnPanelRight              =           0.97
pres1@gsnPanelLabelBar           =           True ;打开图形面板的标签条
pres1@lbTitleOn                  =           True
pres1@lbTitleString              =           "IVMFC "+"(g m~S~~F18~-~F21~2~N~"+" "+"s~S~~F18~-~F21~1~N~"+")"
pres1@lbTitleFontHeightF         =           0.012
pres1@pmLabelBarWidthF           =           0.29  ;设置标签条的宽度
pres1@pmLabelBarHeightF          =           0.04
pres1@lbLabelFontHeightF         =           0.01 ;设置标签条标签的字体高度
pres1@lbOrientation              =          "horizontal" 
pres1@lbTitlePosition            =           "Bottom"
pres1@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres1@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
;pres1@gsnPanelFigureStringsPerimOn = False
pres1@gsnPanelFigureStrings      =           fig_strs1(:) ;指定图形面板中子图的标识符
pres1@gsnPanelFigureStringsFontHeightF   =       0.012 ;设置图形面板中子图标识符的字体高度为0.013
pres1@gsnPanelYWhiteSpacePercent = 3.5 ;设置每行图的间距
pres1@gsnPanelXWhiteSpacePercent = 9 ;设置每行图的间距
pres1@pmLabelBarOrthogonalPosF    = 0.03 ;色标水平方向偏离的位置，正右，负左
pres1@pmLabelBarParallelPosF      = -0.03;色标垂直方向偏离的位置，正上，负下

txres1               = True
txres1@txFontHeightF = 0.022
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs2(0) ,0.2,0.76,txres1)
gsn_text_ndc(wks,fig_strs2(1),0.42,0.76,txres1)
gsn_text_ndc(wks,fig_strs2(2),0.642,0.76,txres1)
gsn_text_ndc(wks,fig_strs2(3),0.865,0.76,txres1)

fig_strs3 = (/"Type-D","Type-C","Type-O"/)
txres1@txFontHeightF = 0.02
txres1@txAngleF = 90
gsn_text_ndc(wks,fig_strs3(0) ,0.03,0.66,txres1)
gsn_text_ndc(wks,fig_strs3(1),0.03,0.5,txres1)
gsn_text_ndc(wks,fig_strs3(2),0.03,0.34,txres1)

gsn_panel(wks, plot1, (/3,2/), pres)
gsn_panel(wks, plot, (/3,2/), pres1)
frame(wks)

end 