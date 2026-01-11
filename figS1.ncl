load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f2 = addfile(filedir+"Calculate_beibu_type.nc","r")
type = f2->type

f3 = addfile(filedir+"identify_Beibu_DLLJ_event.nc","r")
type1 = f3->mark_type1_event
type2 = f3->mark_type2_event
type3 = f3->mark_type3_event

f33 = addfile(filedir+"identify_NSCS_DLLJ_event.nc","r")
type11 = f33->mark_type1_event
type22 = f33->mark_type2_event
type33 = f33->mark_type3_event

f1 = addfile("/sky6/lbz-share/ERA5/2022/ERA5_u_20220101.nc","r")
lat = f1->latitude({35:10})
yyyymmddhh = new((/4392/),"integer")
i=0
do im = 4,9
    tt = days_in_month(2001,im)
    do id = 1,tt
        do ih = 0,23
            yyyymmddhh(i) = (2001*1000000 + im*10000 + id*100 + ih)
            i=i+1
        end do
    end do
end do
ntim  = dimsizes(yyyymmddhh)
yyyy  = yyyymmddhh/1000000 
;print(max(yyyy))
mmddhh = yyyymmddhh%1000000             
;print(max(mmddhh))
mm    = mmddhh/10000
;print(max(mm))
ddhh    = mmddhh%10000                 
;print(max(ddhh))
dd    = ddhh/100                          
;print(max(dd))
hh    = ddhh%100
mn    = dd
sc    = dd
mn    = 0
sc    = 0
units  = "hours since 2001-04-01 00:00:00" 
time   = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, 0)
time!0 = "time"
colors = (/(/255/255.,255/255.,255/255./),(/253/255.,235/255.,164/255./),(/252/255.,197/255.,88/255./),(/252/255.,161/255.,47/255./),(/247/255.,126/255.,43/255./)/)
;colors1 = (/(/255/255.,255/255.,255/255./),(/227/255.,244/255.,251/255./),(/183/255.,228/255.,246/255./),(/119/255.,189/255.,230/255./),(/74/255.,144/255.,203/255./)/)
;colors1 = (/(/255/255.,255/255.,255/255./),(/209/255.,229/255.,240/255./),(/146/255.,197/255.,222/255./),(/67/255.,147/255.,195/255./),(/33/255.,102/255.,172/255./)/)
colors1 = (/(/255/255.,255/255.,255/255./),(/146/255.,197/255.,222/255./),(/67/255.,147/255.,195/255./),(/33/255.,102/255.,172/255./)/)
colors2 = (/(/254/255.,225/255.,221/255./),(/251/255.,197/255.,195/255./),(/251/255.,158/255.,181/255./),(/249/255.,104/255.,161/255./),(/221/255.,52/255.,152/255./)/)
cmap = read_colormap_file("WhiteBlueGreenYellowRed")
index = (/0,50,98,152,168,183,200,216,232,249/)

resn                       = True     ; plot mods desired
resn@gsnDraw              = False                ; do not draw the plot
resn@gsnFrame             = False 
resn@gsnAddCyclic          = False 
resn@gsnMaximize           = True     ; Make plot fit the frame
resn@cnFillOn              = True
resn@tmXBMajorLengthF      =           0.04    ; change the tickmark length
resn@tmYLMajorLengthF      =           0.04
resn@tmXBMinorLengthF      =           0.025    ; change the tickmark length
resn@tmYLMinorLengthF      =           0.025

resn@cnFillPalette         = cmap(index,:);"WhiteBlueGreenYellowRed";"wind_17lev";"perc2_9lev";"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"sunshine_9lev";"precip4_11lev";"BlueDarkRed18";"matlab_jet"
resn@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
resn@cnLevels              = (/8,9,10,11,12,13,14,15,16/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
resn@cnFillMode            = "CellFill"
resn@cnLinesOn             = False
resn@vpHeightF             = 1.6
resn@vpWidthF              = 4.5
resn@vpXF             = 0.6;0.15-1
resn@vpYF             = 1
resn@lbLabelBarOn = False
resn@cnInfoLabelOn = False
resn@cnLineLabelsOn = False

resn@pmLabelBarWidthF = 2.8
resn@pmLabelBarHeightF = 0.25
resn@lbLabelFontHeightF = 0.1
resn@lbOrientation  =  "Horizontal"
resn@lbTitlePosition = "Bottom"
resn@lbTitleString = "Wind Speed (m s~S~~F18~-~F21~1~N~)"
resn@lbTitleFontHeightF = 0.12
;resn@pmLabelBarParallelPosF = 
resn@pmLabelBarOrthogonalPosF = 0.05
resn@tmXTOn = False
resn@tmYROn = False
;resn@gsnLeftStringFontHeightF = 0.055
resn@tmYLTickSpacingF = 4
resn@tmXBLabelFontHeightF = 0.12
resn@tmYLLabelFontHeightF = 0.14
;resn@cnFillOpacityF = 0.5
resn0 = resn

resn1                       = True     ; plot mods desired
resn1@gsnDraw              = False                ; do not draw the plot
resn1@gsnFrame             = False 
resn1@gsnAddCyclic          = False 
resn1@tmXBMajorLengthF      =           0.04    ; change the tickmark length
resn1@tmYLMajorLengthF      =           0.04
resn1@tmXBMinorLengthF      =           0.025    ; change the tickmark length
resn1@tmYLMinorLengthF      =           0.025
resn1@gsnMaximize           = True     ; Make plot fit the frame
resn1@cnFillOn              = False
resn1@cnLinesOn             = True
resn1@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
resn1@cnLevels              = (/10,14/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
resn1@cnMonoLineColor       =  False
resn1@cnLineColors       = colors1(1:3:2,:);colors2(:,:)
resn1@cnLineThicknessF = 5
resn1@cnMonoFillColor = False                 ; default color is fground [black]
;resn1@cnMonoFillPattern = False              ; want multiple patterns 
;resn1@cnMonoFillScale   = False              ; want patterns w/ diff densities 
;resn1@cnFillColors      = (/(/255/255,255/255,255/255/),(/33/255,102/255,172/255/),(/33/255,102/255,172/255/),(/33/255,102/255,172/255/)/)
;resn1@cnFillPatterns    = (/ -1,  3,  3,3/)    ; 3=slant lines; -1=transparent
;resn1@cnFillScales      = (/1, 0.6, 0.6 ,0.6/)   ; line density; default [no op]
;resn1@cnFillMode            = "RasterFill"
resn1@vpHeightF             = 1.6
resn1@vpWidthF              = 4.5
resn1@vpXF             = 0.6;0.15-1
resn1@vpYF             = 1
resn1@lbLabelBarOn = False
resn1@cnInfoLabelOn = False
resn1@cnLineLabelsOn = False
resn1@lbLabelFontHeightF = 0.1
resn1@lbTitleString = "950 hPa Wind Speed (m s~S~~F18~-~F21~1~N~)"
resn1@lbTitleFontHeightF = 0.12
resn1@pmLabelBarOrthogonalPosF = 0.05
resn1@tmXTOn = False
resn1@tmYROn = False
;resn1@gsnLeftStringFontHeightF = 0.055
resn1@tmYLTickSpacingF = 4
resn1@tmXBLabelFontHeightF = 0.12
resn1@tmYLLabelFontHeightF = 0.14
resn01 = resn1

res                       = True     ; plot mods desired
res@gsnDraw              = False                ; do not draw the plot
res@gsnFrame             = False 
res@gsnAddCyclic          = False 
res@tmXBMajorLengthF      =           0.04    ; change the tickmark length
res@tmYLMajorLengthF      =           0.04
res@tmXBMinorLengthF      =           0.025    ; change the tickmark length
res@tmYLMinorLengthF      =           0.025
res@gsnMaximize           = True     ; Make plot fit the frame
res@cnFillOn              = True
;res@cnFillPalette         = "WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"sunshine_9lev";"precip4_11lev";"BlueDarkRed18";"matlab_jet","precip3_16lev";
res@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
res@cnLevels              = (/15,35,50/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
res@cnFillColors          = colors1(:,:)
res@cnFillMode            = "CellFill";"RasterFill"
res@cnLinesOn             = False
res@vpHeightF             = 1.6
res@vpWidthF              = 4.5
res@vpXF             = 0.6;0.15-1
res@vpYF             = 1
res@lbLabelBarOn = False
res@cnInfoLabelOn = False
res@cnLineLabelsOn = False

res@pmLabelBarWidthF = 2.8
res@pmLabelBarHeightF = 0.25
res@lbLabelFontHeightF = 0.1
res@lbOrientation  =  "Horizontal"
res@lbTitlePosition = "Bottom"
res@lbTitleString = "Percentage of grids for BLJs (%)"
res@lbTitleFontHeightF = 0.12
res@pmLabelBarOrthogonalPosF = 0.05
res@tmXTOn = False
res@tmYROn = False
;res@gsnLeftStringFontHeightF = 0.055
res@tmYLTickSpacingF = 4
res@tmXBLabelFontHeightF = 0.12
res@tmYLLabelFontHeightF = 0.14
;resn@cnFillOpacityF = 0.5
res0 = res

res1                       = True     ; plot mods desired
res1@gsnDraw              = False                ; do not draw the plot
res1@gsnFrame             = False 
res1@gsnAddCyclic          = False 
res1@tmXBMajorLengthF      =           0.04    ; change the tickmark length
res1@tmYLMajorLengthF      =           0.04
res1@tmXBMinorLengthF      =           0.025    ; change the tickmark length
res1@tmYLMinorLengthF      =           0.025
res1@gsnMaximize           = True     ; Make plot fit the frame
res1@cnFillOn              = False
res1@cnLinesOn             = True
res1@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
res1@cnLevels              = (/15,50/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
res1@cnMonoLineColor       =  False
res1@cnLineColors       = colors2(2:4:2,:)
res1@cnLineThicknessF = 5
;res1@cnMonoFillColor = False                 ; default color is fground [black]
;res1@cnMonoFillPattern = False              ; want multiple patterns 
;res1@cnMonoFillScale   = False              ; want patterns w/ diff densities 
;res1@cnFillColors      = (/(/255/255,255/255,255/255/),(/33/255,102/255,172/255/),(/33/255,102/255,172/255/),(/33/255,102/255,172/255/)/)
;res1@cnFillPatterns    = (/ -1,  3,  3 ,3/)    ; 3=slant lines; -1=transparent
;res1@cnFillScales      = (/1, 0.6, 0.6 ,0.6/)   ; line density; default [no op]
;res1@cnFillMode            = "RasterFill"
res1@vpHeightF             = 1.6
res1@vpWidthF              = 4.5
res1@vpXF             = 0.6;0.15-1
res1@vpYF             = 1
res1@lbLabelBarOn = False
res1@cnInfoLabelOn = False
res1@cnLineLabelsOn = False
res1@lbLabelFontHeightF = 0.1
res1@lbTitleString = "Percentage of grids for BLJs (%)"
res1@lbTitleFontHeightF = 0.12
res1@pmLabelBarOrthogonalPosF = 0.05
res1@tmXTOn = False
res1@tmYROn = False
;res1@gsnLeftStringFontHeightF = 0.055
res1@tmYLTickSpacingF = 4
res1@tmXBLabelFontHeightF = 0.12
res1@tmYLLabelFontHeightF = 0.14
res01 = res1

; 设置时间坐标
resTick                = True
resTick@ttmFormat      = "%d %c"
resTick@ttmAxis        = "XB"
resTick@ttmMajorStride = 96
resTick@ttmMinorStride = 24

; 区域分割线
lnres = True
lnres@gsLineColor = "black"
lnres@gsLineThicknessF = 3 
lnres@gsLineDashPattern = 2
lnres1 = lnres
lnres1@gsLineColor = "gray"

pmres = True
pmres@gsMarkerIndex = 7 ;-- use marker 1
pmres@gsMarkerSizeF = 0.008 ;-- set size of markers
pmres@gsMarkerThicknessF = 1.2

resGon					= True
resGon@gsFillIndex 		= 0
resGon@gsFillColor 		= "blue"

resGon					= True
resGon@gsFillIndex 		= 0
resGon@gsFillColor 		= "blue"

resLine			= True
resLine@gsLineThicknessF	= 2.
resLine@gsLineDashPattern	= 0
resLine@gsLineColor 		= "black"

days = (/119,123,119,123,123,119/)
days1 = (/29,30,29,30,30,29/)

yr = 2001
iyear = yr-2001
filename1 = "DLLJs_Beibu_950hPa_"+yr+".txt"
data1 = readAsciiTable(filedir+filename1, 4392, "float", 0)
;printVarSummary(data1)
data1!0 = "latitude"
data1&latitude = lat 
data1!1 = "time"
data1&time = time 
filename2 = "DLLJs_Beibu_750hPa_"+yr+".txt"
data2 = readAsciiTable(filedir+filename2, 4392, "float", 0)
;printVarSummary(data2)
data2!0 = "latitude"
data2&latitude = lat 
data2!1 = "time"
data2&time = time 
;printVarSummary(data2)

filename3 = "ws_Beibu_950hPa_"+yr+".txt"
ws1 = readAsciiTable(filedir+filename3, 4392, "float", 0)
;printVarSummary(ws1)
ws1!0 = "latitude"
ws1&latitude = lat 
ws1!1 = "time"
ws1&time = time 
filename4 = "ws_Beibu_750hPa_"+yr+".txt"
ws2 = readAsciiTable(filedir+filename4, 4392, "float", 0)
;printVarSummary(ws2)
ws2!0 = "latitude"
ws2&latitude = lat 
ws2!1 = "time"
ws2&time = time 

data1 = smth9_Wrap(data1, 0.50, 0.25, False)
data2 = smth9_Wrap(data2, 0.50, 0.25, False)
ws1   = smth9_Wrap(ws1, 0.50, -0.25, False)
ws2   = smth9_Wrap(ws2, 0.50, -0.25, False)

ind_1 = ind(type1(iyear,:).ne.0)
ind_2 = ind(type2(iyear,:).ne.0)
ind_3 = ind(type3(iyear,:).ne.0)

ind_11 = ind(ind_1.le.719)
ind_21 = ind(ind_2.le.719)
ind_31 = ind(ind_3.le.719)

plots = new(4 , "graphic")
dums  = new(4 , "graphic")
dums1  = new(4 , "graphic")
dum1 = new(days(0), "graphic")
dum4 = new(days(3), "graphic")
dum01 = new(days(0), "graphic")
dum04 = new(days(3), "graphic")
dumm1 = new(days1(0), "graphic")
dumm4 = new(days1(3), "graphic")
dumm01 = new(days1(0), "graphic")
dumm04 = new(days1(3), "graphic")

markers1_1 = new(720,"graphic")
markers2_1 = new(720,"graphic")
markers3_1 = new(720,"graphic")
markers1_4 = new(720,"graphic")
markers2_4 = new(720,"graphic")
markers3_4 = new(720,"graphic")

markers_1_1 = new(720,"graphic")
markers_2_1 = new(720,"graphic")
markers_3_1 = new(720,"graphic")
markers_1_4 = new(720,"graphic")
markers_2_4 = new(720,"graphic")
markers_3_4 = new(720,"graphic")

markers1_10 = new(720,"graphic")
markers2_10 = new(720,"graphic")
markers3_10 = new(720,"graphic")
markers1_40 = new(720,"graphic")
markers2_40 = new(720,"graphic")
markers3_40 = new(720,"graphic")

markers_1_10 = new(720,"graphic")
markers_2_10 = new(720,"graphic")
markers_3_10 = new(720,"graphic")
markers_1_40 = new(720,"graphic")
markers_2_40 = new(720,"graphic")
markers_3_40 = new(720,"graphic")

plotname1 = "fig_event_case"
wks   = gsn_open_wks ("pdf", plotname1 )
wks@wkHeight = 2048
wks@wkWidth  = 2048

time_axis_labels(time(0:719), resn, resTick)
time_axis_labels(time(0:719), res, resTick)
resn@gsnLeftString = "(a) Wind Speed"
res@gsnLeftString = "(b) Percentage of LLJ grids"

resn@gsnLeftStringFontHeightF = 0.16
res@gsnLeftStringFontHeightF  = 0.16
resn@lbLabelBarOn = True
res@lbLabelBarOn = True

plots(0) = gsn_csm_contour(wks, ws1({15:30},0:719), resn)
plot1 = gsn_csm_contour(wks, ws2({15:30},0:719), resn1)
plots(1) = gsn_csm_contour(wks, data1({15:30},0:719), res)
plot2 = gsn_csm_contour(wks, data2({15:30},0:719), res1)
dums1(0) = gsn_add_polyline(wks, plots(0), (/time(0),time(719)/), (/24,24/), lnres)
dums1(1) = gsn_add_polyline(wks, plots(1), (/time(0),time(719)/), (/24,24/), lnres)

do i=0,days1(0)-1
    dumm1(i) = gsn_add_polyline(wks, plots(0), (/time(24+24*i),time(24+24*i)/), (/15,30/), lnres1)
    dumm01(i) = gsn_add_polyline(wks, plots(1), (/time(24+24*i),time(24+24*i)/), (/15,30/), lnres1)
end do
overlay(plots(1),plot2)
overlay(plots(0),plot1)

    resGon@gsFillColor 		= "#8c510a";"#4F845C";"#F6944B";"#996E2E";"#4F845C"
    if (.not.all(ismissing(ind_11))) then
        nmax  = max(type1(iyear,ind_1(ind_11)))
        nmin  = min(type1(iyear,ind_1(ind_11)))
        i = 0
        do n = nmin,nmax 
            marker1 = ind(type1(iyear,:).eq.n)
            if (.not.all(ismissing(marker1))) then
                xx = (/min(time(marker1)),max(time(marker1)),max(time(marker1)),min(time(marker1)),min(time(marker1))/)
                yy = (/15.,15.,16.,16.,15./)
                markers_1_1(i) = gsn_add_polygon(wks, plots(0), xx, yy, resGon)
                markers_1_10(i) = gsn_add_polygon(wks, plots(1), xx, yy, resGon)
                i = i + 1
            end if
            delete([/marker1/])
        end do
        delete([/nmax,nmin,i/])
    end if

    resGon@gsFillColor 		= "blue";"#CFE7C4";"#377483";"#0787C3";"#315A89";"#377483"
    if (.not.all(ismissing(ind_21))) then
        nmax  = max(type2(iyear,ind_2(ind_21)))
        nmin  = min(type2(iyear,ind_2(ind_21)))
        i = 0
        do n = nmin,nmax 
            marker2 = ind(type2(iyear,:).eq.n)
            if (.not.all(ismissing(marker2))) then
                xx = (/min(time(marker2)),max(time(marker2)),max(time(marker2)),min(time(marker2)),min(time(marker2))/)
                yy = (/15.,15.,16.,16.,15./)
                markers_2_1(i) = gsn_add_polygon(wks, plots(0), xx, yy, resGon)
                markers_2_10(i) = gsn_add_polygon(wks, plots(1), xx, yy, resGon)
                i = i+1
            end if
            delete([/marker2/])
        end do
        delete([/nmax,nmin,i/])
    end if

    resGon@gsFillColor 		= "red";"#FBDFE2";"#B83945";"#EC3232";"#B42B22";"#B83945"
    if (.not.all(ismissing(ind_31))) then
        nmax  = max(type3(iyear,ind_3(ind_31)))
        nmin  = min(type3(iyear,ind_3(ind_31)))
        i = 0
        do n = nmin,nmax 
            marker3 = ind(type3(iyear,:).eq.n)
            if (.not.all(ismissing(marker3))) then
                xx = (/min(time(marker3)),max(time(marker3)),max(time(marker3)),min(time(marker3)),min(time(marker3))/)
                yy = (/15.,15.,16.,16.,15./);yy = (/29.,29.,30.,30.,29./)
                markers_3_1(i) = gsn_add_polygon(wks, plots(0), xx, yy, resGon)
                markers_3_10(i) = gsn_add_polygon(wks, plots(1), xx, yy, resGon)
                i = i+1
            end if
            delete([/marker3/])
        end do
        delete([/nmax,nmin,i/])
    end if
delete([/ind_1,ind_2,ind_3/])

yr = 2002
iyear = yr-2001
filename1 = "DLLJs_NSCS_950hPa_"+yr+".txt"
data10 = readAsciiTable(filedir+filename1, 4392, "float", 0)
;printVarSummary(data1)
data10!0 = "latitude"
data10&latitude = lat 
data10!1 = "time"
data10&time = time 
filename2 = "DLLJs_NSCS_750hPa_"+yr+".txt"
data20 = readAsciiTable(filedir+filename2, 4392, "float", 0)
;printVarSummary(data2)
data20!0 = "latitude"
data20&latitude = lat 
data20!1 = "time"
data20&time = time 
;printVarSummary(data2)

filename3 = "ws_NSCS_950hPa_"+yr+".txt"
ws10 = readAsciiTable(filedir+filename3, 4392, "float", 0)
;printVarSummary(ws1)
ws10!0 = "latitude"
ws10&latitude = lat 
ws10!1 = "time"
ws10&time = time 
filename4 = "ws_NSCS_750hPa_"+yr+".txt"
ws20 = readAsciiTable(filedir+filename4, 4392, "float", 0)
;printVarSummary(ws2)
ws20!0 = "latitude"
ws20&latitude = lat 
ws20!1 = "time"
ws20&time = time 

data10 = smth9_Wrap(data10, 0.50, 0.25, False)
data20 = smth9_Wrap(data20, 0.50, 0.25, False)
ws10   = smth9_Wrap(ws10, 0.50, -0.25, False)
ws20   = smth9_Wrap(ws20, 0.50, -0.25, False)

ind_1 = ind(type11(iyear,:).ne.0)
ind_2 = ind(type22(iyear,:).ne.0)
ind_3 = ind(type33(iyear,:).ne.0)

ind_14 = ind(ind_1.le.719)
ind_24 = ind(ind_2.le.719)
ind_34 = ind(ind_3.le.719)

time_axis_labels(time(0:719), resn0, resTick)
time_axis_labels(time(0:719), res0, resTick)
resn0@gsnLeftString = "(c) Wind Speed"
res0@gsnLeftString = "(d) Percentage of LLJ grids"

resn0@gsnLeftStringFontHeightF = 0.16
res0@gsnLeftStringFontHeightF  = 0.16
resn0@lbLabelBarOn = True
res0@lbLabelBarOn = True

plots(2) = gsn_csm_contour(wks, ws10({15:30},0:719), resn0)
plot3 = gsn_csm_contour(wks, ws20({15:30},0:719), resn01)
plots(3) = gsn_csm_contour(wks, data10({15:30},0:719), res0)
plot4 = gsn_csm_contour(wks, data20({15:30},0:719), res01)
dums1(2) = gsn_add_polyline(wks, plots(2), (/time(0),time(719)/), (/24,24/), lnres)
dums1(3) = gsn_add_polyline(wks, plots(3), (/time(0),time(719)/), (/24,24/), lnres)

do i=0,days1(0)-1
    dumm4(i) = gsn_add_polyline(wks, plots(2), (/time(24+24*i),time(24+24*i)/), (/15,30/), lnres1)
    dumm04(i) = gsn_add_polyline(wks, plots(3), (/time(24+24*i),time(24+24*i)/), (/15,30/), lnres1)
end do
overlay(plots(2),plot3)
overlay(plots(3),plot4)

resGon@gsFillColor 		= "#8c510a";;"Orange";"#4F845C";"#F6944B";"#996E2E";"#4F845C"
    if (.not.all(ismissing(ind_14))) then
        nmax  = max(type11(iyear,ind_1(ind_14)))
        nmin  = min(type11(iyear,ind_1(ind_14)))
        i = 0
        do n = nmin,nmax 
            marker1 = ind(type11(iyear,:).eq.n)
            if (.not.all(ismissing(marker1))) then
                xx = (/min(time(marker1)),max(time(marker1)),max(time(marker1)),min(time(marker1)),min(time(marker1))/)
                yy = (/15.,15.,16.,16.,15./)
                markers_1_4(i) = gsn_add_polygon(wks, plots(2), xx, yy, resGon)
                markers_1_40(i) = gsn_add_polygon(wks, plots(3), xx, yy, resGon)
                i = i + 1
            end if
            delete([/marker1/])
        end do
        delete([/nmax,nmin,i/])
    end if

    resGon@gsFillColor 		= "blue";"#CFE7C4";"#377483";"#0787C3";"#315A89";"#377483"
    if (.not.all(ismissing(ind_24))) then
        nmax  = max(type22(iyear,ind_2(ind_24)))
        nmin  = min(type22(iyear,ind_2(ind_24)))
        i = 0
        do n = nmin,nmax 
            marker2 = ind(type22(iyear,:).eq.n)
            if (.not.all(ismissing(marker2))) then
                xx = (/min(time(marker2)),max(time(marker2)),max(time(marker2)),min(time(marker2)),min(time(marker2))/)
                yy = (/15.,15.,16.,16.,15./)
                markers_2_4(i) = gsn_add_polygon(wks, plots(2), xx, yy, resGon)
                markers_2_40(i) = gsn_add_polygon(wks, plots(3), xx, yy, resGon)
                i = i+1
            end if
            delete([/marker2/])
        end do
        delete([/nmax,nmin,i/])
    end if

    resGon@gsFillColor 		= "red";"#FBDFE2";"#B83945";"#EC3232";"#B42B22";"#B83945"
    if (.not.all(ismissing(ind_34))) then
        nmax  = max(type33(iyear,ind_3(ind_34)))
        nmin  = min(type33(iyear,ind_3(ind_34)))
        i = 0
        do n = nmin,nmax 
            marker3 = ind(type33(iyear,:).eq.n)
            if (.not.all(ismissing(marker3))) then
                xx = (/min(time(marker3)),max(time(marker3)),max(time(marker3)),min(time(marker3)),min(time(marker3))/)
                yy = (/15.,15.,16.,16.,15./);yy = (/29.,29.,30.,30.,29./)
                markers_3_4(i) = gsn_add_polygon(wks, plots(2), xx, yy, resGon)
                markers_3_40(i) = gsn_add_polygon(wks, plots(3), xx, yy, resGon)
                i = i+1
            end if
            delete([/marker3/])
        end do
        delete([/nmax,nmin,i/])
    end if

    resP = True
    resP@gsnMaximize    = True
    resP@gsnFrame       = False
    ;resP@txString   = "Beibu Gulf & 2002 & April"
    ;resP@txFontHeightF = 0.026
    resP@gsnPanelYWhiteSpacePercent = 0
    resP@gsnPanelXWhiteSpacePercent = 0
    resP@gsnPanelTop       = 0.93
    resP@gsnPanelBottom    = 0.03
    resP@gsnPanelLeft      = 0.04
    resP@gsnPanelRight     = 0.49

    resP1 =resP
    ;resP1@txString   = "Northern SCS & 2011 & April"
    ;resP1@gsnPanelTop                =           0.93
    resP1@gsnPanelBottom             =           0.03
    resP1@gsnPanelLeft               =           0.51
    resP1@gsnPanelRight              =           0.96
    resP1@gsnPanelYWhiteSpacePercent = 0
    resP1@gsnPanelXWhiteSpacePercent = 0

    txres1               = True
    txres1@txFontHeightF = 0.018
    gsn_text_ndc(wks,"BBG & 2001 & April",0.285,0.76,txres1) 
    gsn_text_ndc(wks,"NSCS & 2002 & April",0.75,0.76,txres1) 

    gsn_panel(wks,plots(0:1),(/2,1/),resP)
    gsn_panel(wks,plots(2:3),(/2,1/),resP1)
    frame(wks)
end 