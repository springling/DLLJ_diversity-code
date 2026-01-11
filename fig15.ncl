begin 
num_BN = new((/3,3/),"float")
num_NB = new((/3,3/),"float")
num_BN =(/(/0.,0.,0./),(/1.58,10.39,0.07/),(/0.15,16.53,11.04/)/) 
;num_NB =(/(/0.,39.24,1.84/),(/0.,23.08,18.31/),(/0.,0.42,30.97/)/) 
num_NB =(/(/1.84,18.31,30.97/),(/39.26,22.8,0.42/),(/0.,0.,0./)/) 

plot = new(1, "graphic")
pngname = "Type_NSCS_Beibu_1"
type = "pdf"
wks = gsn_open_wks(type,pngname)
cmap = read_colormap_file("MPL_BuPu")
color = (/(/255./255.,255./255.,255./255./),(/253./255.,221./255.,177./255./),(/253./255.,181./255.,126./255./),(/242./255.,110./255.,76./255./),(/202./255.,30./255.,20./255./)/)
res = True 
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnMaximize     =           False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""

;------tickmark settings
res@tmXBLabelFontHeightF        =           0.02        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.02
res@tmXBMajorLengthF            =           0    ; change the tickmark length
res@tmYLMajorLengthF            =           0
res@tmXTMajorLengthF            =           0    ; change the tickmark length
res@tmYRMajorLengthF            =           0
res@vpHeightF                   = 0.45
res@vpWidthF                    = 0.53

res@cnFillOn                    =           True
res@cnFillMode                  =           "RasterFill"  ; Turn on raster fill
res@cnLinesOn                   =           False         ; Turn off contour lines
res@cnLineLabelsOn              =           False         ; turns off contour line labels
res@cnFillPalette               =        cmap(2:100,:);"MPL_BuPu";color(:,:);"WhiteBlueGreenYellowRed"
;res@cnFillOpacityF              =        0.95

res@cnInfoLabelOn               =           False
res@lbLabelBarOn                =           False

res@cnLevelSelectionMode        =           "ExplicitLevels";"ManualLevels"
res@cnLevels              = (/0.1,1.,5,10,12,15,20,25/)
;res@cnMinLevelValF              =           startf
;res@cnMaxLevelValF              =           endf
;res@cnLevelSpacingF             =           spacingf


res@tmXBMode             = "Explicit"                ; explicit labels
;res@tmXBValues           = (/0.2,0.6,1,1.4,1.8,2.2/) 
res@tmXBValues           = fspan(0.2,1.0,3)
res@tmXBLabels           = (/"Type-D","Type-C","Type-O"/)        
res@sfXArray             = fspan(0,1.2,4)
res@tmYLMode             = "Explicit"                ; explicit labels
;res@tmYLValues           = (/0.1,0.3,0.5,0.7,0.9,1.1,1.3,1.5,1.7,1.9,2.1,2.3,2.5,2.7,2.9,3.1,3.3,3.7,3.9,4.1,4.3,4.5,4.7,4.9/) 
res@tmYLValues           = fspan(0.3,1.1,3)
res@tmYLLabels           = (/"Type-O","Type-C","Type-D"/)    
res@sfYArray             = fspan(0.,1.2,4) 
res@tmYLLabelAngleF      = 90
res@tmXBLabelFontHeightF = 0.02 
res@tmYLLabelFontHeightF = 0.02  
res@tiYAxisString        =  "BBG(Condition event-B)"
res@tiXAxisString        =  "NSCS (Event-A)"
res@tiYAxisFontHeightF    = 0.022
res@tiXAxisFontHeightF    = 0.022
res@gsnCenterStringFontHeightF    = 0.025

; 区域分割线
lnres = True
lnres@gsLineColor = "black"
lnres@gsLineThicknessF = 2 
lnres@gsLineDashPattern = 1
lnres1 = lnres
;lnres1@gsLineColor = "gray55"
fig_strs = (/"(b) P(NSCS|BBG)","(a) P(BBG|NSCS)"/)
;res@gsnLeftString = fig_strs(0)
;res@gsnLeftStringFontHeightF = 0.026
;plot(1) = gsn_csm_contour(wks, num_BN, res)

res@tiXAxisString        =  "NSCS (Condition event-B)"
res@tiYAxisString        =  "BBG (Event-A)"
 
res@gsnCenterString = "P(BBG|NSCS)"
plot(0) = gsn_csm_contour(wks, num_NB, res)

;dumm1 = gsn_add_polyline(wks, plot(1), (/0.4,0.4/), (/0,1.2/), lnres1)
;dumm2 = gsn_add_polyline(wks, plot(1), (/0.8,0.8/), (/0,1.2/), lnres1)
dumm3 = gsn_add_polyline(wks, plot(0), (/0.4,0.4/), (/0,1.2/), lnres1)
dumm4 = gsn_add_polyline(wks, plot(0), (/0.8,0.8/), (/0,1.2/), lnres1)

;dumm11 = gsn_add_polyline(wks, plot(1), (/0,1.2/), (/0.4,0.4/), lnres1)
;dumm22 = gsn_add_polyline(wks, plot(1), (/0,1.2/), (/0.8,0.8/), lnres1)
dumm33 = gsn_add_polyline(wks, plot(0), (/0,1.2/), (/0.4,0.4/), lnres1)
dumm44 = gsn_add_polyline(wks, plot(0), (/0,1.2/), (/0.8,0.8/), lnres1)

resText = True 
resText@txFontHeightF = 0.024
resText@txFont                = "helvetica"
resText@txFontColor   = "black"
text = (/"0","0","0","1.58","10.39","0.07","0.15","16.53","11.04"/)

xx = (/0.2,0.6,1.0,0.2,0.6,1.0,0.2,0.6,1.0/)
yy = (/0.2,0.2,0.2,0.6,0.6,0.6,1.0,1.0,1.0/)
;plottext = gsn_add_text(wks, plot(1), text, xx, yy, resText)


text = (/"1.84","18.31","30.97","39.26","22.8","0.42","0","0","0"/)
plottext = gsn_add_text(wks, plot(0), text, xx, yy, resText)



pres                 = True
;pres@gsnPanelYWhiteSpacePercent = 1 ;设置每行图的间距
;pres@gsnPanelXWhiteSpacePercent = 5 ;设置每行图的间距
gsn_panel(wks,plot(0),(/1,1/),pres)

end