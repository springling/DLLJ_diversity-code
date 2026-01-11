load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

begin 
f3 = addfile("/sky7/zhouchling/data/DLLJ_SouthChina1/identify_Beibu_DLLJ_event.nc","r")
type1 = f3->mark_type1_event
type2 = f3->mark_type2_event
type3 = f3->mark_type3_event

type = where(type1.ne.0, 1, 0)
type = where(type2.ne.0, 2, type)
type = where(type3.ne.0, 3, type)
printVarSummary(type)

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

type!1 = "time"
type&time = time 

colors = (/(/255/255.,255/255.,255/255./),(/246/255.,196/255.,60/255./),(/67/255.,147/255.,195/255./),(/214/255.,96/255.,77/255./)/)

yvalue              =           ispan(1,23,1);fspan(0.5,21.5,22)
nlabel              =           dimsizes(yvalue)
ylabel              =           (/"2001","","2003","","2005","","2007","","2009","","2011","","2013","","2015","","2017","","2019","","2021","","2023"/);

resn                       = True     ; plot mods desired
resn@gsnDraw              = False                ; do not draw the plot
resn@gsnFrame             = False 
resn@gsnAddCyclic          = False 
resn@gsnMaximize           = False     ; Make plot fit the frame

resn1 = resn 

resn@tmXBMajorLengthF      =           0.04    ; change the tickmark length
resn@tmYLMajorLengthF      =           0.04
resn@tmXBMinorLengthF      =           0.025    ; change the tickmark length
resn@tmYLMinorLengthF      =           0.025


resn@cnFillOn              = True
resn@cnFillPalette         = colors;"WhiteBlueGreenYellowRed";"wind_17lev";"perc2_9lev";"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"sunshine_9lev";"precip4_11lev";"BlueDarkRed18";"matlab_jet"
resn@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
resn@cnLevels              = (/0.5,1.5,2.5/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
resn@cnFillMode            = "RasterFill"
resn@cnLinesOn             = False
resn@cnLineLabelsOn        = False 
resn@vpHeightF             = 1.4
resn@vpWidthF              = 3.2
resn@vpXF             = 0.6;0.15-1
resn@vpYF             = 1
resn@lbLabelBarOn = False
resn@cnInfoLabelOn = False

resn@tmYLMode          = "Explicit"  
resn@tmYLValues        = yvalue
resn@tmYLLabels        = ylabel
resn@sfYArray          = fspan(0.5,23.5,24)

resn@tmXTOn = False
resn@tmYROn = False
resn@tmYLTickSpacingF = 4
resn@tmXBLabelFontHeightF = 0.07
resn@tmYLLabelFontHeightF = 0.07
resn0 = resn

resn1@cnFillOn              = True
resn1@cnFillPalette         = colors;"WhiteBlueGreenYellowRed";"wind_17lev";"perc2_9lev";"WhiteBlueGreenYellowRed";"precip_11lev";"precip3_16lev";"sunshine_9lev";"precip4_11lev";"BlueDarkRed18";"matlab_jet"
resn1@cnLevelSelectionMode  = "ExplicitLevels"   ; set explicit contour levels
resn1@cnLevels              = (/0.5,1.5,2.5/);fspan(0.4, 1.8, 8);fspan(0.6, 2, 8);fspan(0.5, 4, 8)
resn1@cnFillMode            = "RasterFill"
resn1@cnLinesOn             = False
resn1@cnLineLabelsOn        = False 
resn1@vpHeightF             = 1.2
resn1@vpWidthF              = 4.
resn1@vpXF             = 0.6;0.15-1
resn1@vpYF             = 1
resn1@lbLabelBarOn = False
resn1@cnInfoLabelOn = False
resn2 = resn1
resn01 = resn1 
resn02 = resn1

resn2 = resn1
; 设置时间坐标
resTick                = True
resTick@ttmFormat      = "%d %c"
resTick@ttmAxis        = "XB"
resTick@ttmMajorStride = 96
resTick@ttmMinorStride = 24


    plots = new(6 , "graphic")
    plots1 = new(6 , "graphic")
    plots2 = new(6 , "graphic")

    plotname1 = "Type_Beibu_time1"
    plotname2 = "Type_Beibu_time2"
    plotname3 = "Type_Beibu_time3"
    wks   = gsn_open_wks ("pdf", plotname1 )  ; send graphics to PNG file 
    wks0   = gsn_open_wks("pdf", plotname2 )  ; send graphics to PNG file
    wks01   = gsn_open_wks("pdf", plotname3 )

    wks@wkHeight = 2048
    wks@wkWidth  = 2048
    wks0@wkHeight = 2048
    wks0@wkWidth  = 2048
    wks01@wkHeight = 2048
    wks01@wkWidth  = 2048

    time_axis_labels(time(0:719), resn, resTick)
    resn@gsnLeftString = "(a) BBG & April"
    resn@gsnLeftStringFontHeightF = 0.08
    resn0@gsnLeftStringFontHeightF = 0.08
    resn@lbLabelBarOn = False
    resn0@lbLabelBarOn = False
    plots(0) = gsn_csm_contour(wks, type(:,0:719), resn)

    resn0@gsnLeftString = "(b) BBG & May"
    time_axis_labels(time(720:1463), resn0, resTick)
    plots(1) = gsn_csm_contour(wks, type(:,720:1463), resn0)


    resn@gsnLeftString = "(c) BBG & June"
    time_axis_labels(time(1464:2183), resn, resTick)
    plots(2) = gsn_csm_contour(wks0, type(:,1464:2183), resn)

    resn0@gsnLeftString = "(d) BBG & July"
    time_axis_labels(time(2184:2927), resn0, resTick)
    plots(3) = gsn_csm_contour(wks0, type(:,2184:2927), resn0)


    resn0@gsnLeftString = "(e) BBG & August"
    time_axis_labels(time(2928:3671), resn0, resTick)
    plots(4) = gsn_csm_contour(wks01, type(:,2928:3671), resn0)


    resn@gsnLeftString = "(f) BBG & September"
    time_axis_labels(time(3672:4391), resn, resTick)
    plots(5) = gsn_csm_contour(wks01, type(:,3672:4391), resn)


    resP = True
    resP@gsnMaximize    = True
    resP@gsnFrame       = False
    ;resP@txString   = "Beibu Gulf"
    ;resP@txFontHeightF = 0.022
    resP@gsnPanelYWhiteSpacePercent = 0
    resP@gsnPanelXWhiteSpacePercent = 0
    gsn_panel(wks,plots(0:1),(/2,1/),resP)
    frame(wks)
    gsn_panel(wks0,plots(2:3),(/2,1/),resP)
    frame(wks0)
    gsn_panel(wks0,plots(4:5),(/2,1/),resP)
    frame(wks01)


end 