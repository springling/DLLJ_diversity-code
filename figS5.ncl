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
latmin              =           15
latmax              =           30 
lonmin              =           102
lonmax              =           122

f1 = addfile(filedir + "composite_UVws_Beibu_type_event_day0.nc","r")
uB1 = f1->uB(:,:,:,{latmin:latmax},{lonmin:lonmax})
vB1 = f1->vB(:,:,:,{latmin:latmax},{lonmin:lonmax})
wsB1 = f1->wsB(:,:,:,{latmin:latmax},{lonmin:lonmax})
num_type1 = f1->num_type
print(num_type1) 
printVarSummary(uB1)

f2 = addfile(filedir + "composite_UVws_NSCS_type_event_day0.nc","r")
uN1 = f2->uB(:,:,:,{latmin:latmax},{lonmin:lonmax})
vN1 = f2->vB(:,:,:,{latmin:latmax},{lonmin:lonmax})
wsN1 = f2->wsB(:,:,:,{latmin:latmax},{lonmin:lonmax})
num_type2 = f2->num_type
print(num_type2)

f1 = addfile(filedir + "composite_UVwsg_Beibu_type_event_day0.nc","r")
uB2 = f1->ug(:,:,:,{latmin:latmax},{lonmin:lonmax})
vB2 = f1->vg(:,:,:,{latmin:latmax},{lonmin:lonmax})
wsB2 = f1->wsg(:,:,:,{latmin:latmax},{lonmin:lonmax})
num_type1 = f1->num_type
print(num_type1) 
printVarSummary(uB2)

f2 = addfile(filedir + "composite_UVwsg_NSCS_type_event_day0.nc","r")
uN2 = f2->ug(:,:,:,{latmin:latmax},{lonmin:lonmax})
vN2 = f2->vg(:,:,:,{latmin:latmax},{lonmin:lonmax})
wsN2 = f2->wsg(:,:,:,{latmin:latmax},{lonmin:lonmax})
num_type2 = f2->num_type
print(num_type2)

ndim = dimsizes(uB2)
uBB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
vBB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
wsBB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
uNN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
vNN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
wsNN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))

uB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
vB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
wsB = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
uN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
vN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))
wsN = new((/ndim(0),ndim(1),ndim(2),ndim(3),ndim(4)/),typeof(uB2))

levhPa = uB2&level
do i = 0,dimsizes(levhPa)-1
    uBB(:,:,i,:,:) = uB1(:,:,{levhPa(i)},:,:) - uB2(:,:,{levhPa(i)},:,:)
    vBB(:,:,i,:,:) = vB1(:,:,{levhPa(i)},:,:) - vB2(:,:,{levhPa(i)},:,:)
    uNN(:,:,i,:,:) = uN1(:,:,{levhPa(i)},:,:) - uN2(:,:,{levhPa(i)},:,:)
    vNN(:,:,i,:,:) = vN1(:,:,{levhPa(i)},:,:) - vN2(:,:,{levhPa(i)},:,:)
end do

do i = 0,23
    uB(:,i,:,:,:) = uBB(:,i,:,:,:) - dim_avg_n_Wrap(uBB,1)
    vB(:,i,:,:,:) = vBB(:,i,:,:,:) - dim_avg_n_Wrap(vBB,1)
    uN(:,i,:,:,:) = uNN(:,i,:,:,:) - dim_avg_n_Wrap(uNN,1)
    vN(:,i,:,:,:) = vNN(:,i,:,:,:) - dim_avg_n_Wrap(vNN,1)
end do
wsB = wind_speed(uB, vB)
wsN = wind_speed(uN, vN)
copy_VarCoords(uB2,uB)
copy_VarCoords(uB2,vB)
copy_VarCoords(uB2,wsB)
copy_VarCoords(uB2,uN)
copy_VarCoords(uB2,vN)
copy_VarCoords(uB2,wsN)

newlat = fspan(latmin, latmax, latmax-latmin+1)
newlon = fspan(lonmin, lonmax, lonmax-lonmin+1)

newlat!0 = "latitude"
newlat&latitude = newlat 
newlat@units = "degrees_north"

newlon!0 = "longitude"
newlon&longitude = newlon
newlon@units = "degrees_east"

uBnew = new((/ndim(0),ndim(1),ndim(2),latmax-latmin+1,lonmax-lonmin+1/),typeof(uB2))
vBnew = new((/ndim(0),ndim(1),ndim(2),latmax-latmin+1,lonmax-lonmin+1/),typeof(uB2))
uNnew = new((/ndim(0),ndim(1),ndim(2),latmax-latmin+1,lonmax-lonmin+1/),typeof(uB2))
vNnew = new((/ndim(0),ndim(1),ndim(2),latmax-latmin+1,lonmax-lonmin+1/),typeof(uB2))
do i = 0 , latmax-latmin 
	do j = 0 , lonmax-lonmin
		uBnew(:,:,:,i,j) = uB(:,:,:,i*4,j*4)
		vBnew(:,:,:,i,j) = vB(:,:,:,i*4,j*4)

        uNnew(:,:,:,i,j) = uN(:,:,:,i*4,j*4)
		vNnew(:,:,:,i,j) = vN(:,:,:,i*4,j*4)
	end do 
end do 
uBnew!3 = "latitude"
uBnew&latitude = newlat 
uBnew!4 = "longitude"
uBnew&longitude = newlon  
copy_VarCoords(uBnew, vBnew)
copy_VarCoords(uBnew, uNnew)
copy_VarCoords(uBnew, vNnew)
printVarSummary(uBnew)

colors = (/"slateblue3","slateblue2","slateblue1","seagreen3","seagreen2","seagreen1",\
          "skyblue3","skyblue2","skyblue1","red3","red2","red1"/)
type                =           "pdf"
filename            =           "draw_uvag_daily_3_950"
wks                 =           gsn_open_wks(type , filename)
vector  		    = 			new((/6,24/),graphic)
map  				= 			new(6,graphic)

res                 =           True
res@gsnDraw         =           False
res@gsnFrame        =           False
res@gsnMaximize           = False
res@gsnLeftString   =           ""
res@gsnRightString  =           ""
res@vpWidthF              = 0.65
res@vpHeightF             = 0.5

res@gsnAddCyclic    =           False

vres                =           res

vres@vcGlyphStyle               =           "LineArrow"
vres@vcRefMagnitudeF            =           3
vres@vcRefLengthF               =           0.05;0.06;
vres@vcMinDistanceF             =           0.05
vres@vcLineArrowThicknessF      =           1.2
vres@vcPositionMode             =           "ArrowTail"
vres@vcLineArrowHeadMaxSizeF    =           0.
vres@vcLineArrowHeadMinSizeF 	= 			0.

vres@vcRefAnnoOn                =           False
vres@vcRefAnnoString2           =           "3 m s~S~~F18~-~F21~1~N~"
vres@vcRefAnnoBackgroundColor   =           "white"
vres@vcRefAnnoPerimOn           =           True  ;不加边框
;vres@vcRefAnnoString2On         =           False   ; 下的字符
vres@vcRefAnnoString1On         =           False ;设定参考箭头上
vres@vcRefAnnoFontHeightF       =           0.025 ;矢量标签字体大小

res@pmTickMarkDisplayMode       =           "Always"

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
res@mpNationalLineThicknessF    =           1.0
res@mpUSStateLineThicknessF     =           1.0
res@mpGridAndLimbOn             =           False
res@mpDataBaseVersion           =           "Ncarg4_1" 
res@mpDataSetName               =           "/sky1/home/zhouchling/data/map/Earth..4"
res@mpOutlineOn                 =           True
res@mpOutlineDrawOrder          =           "PreDraw"
res@mpLandFillColor             =           -1
res@mpFillOn                    =           False
res@mpMinLatF                   =           latmin
res@mpMaxLatF                   =           latmax
res@mpMinLonF                   =           lonmin
res@mpMaxLonF                   =           lonmax

res@mpOutlineSpecifiers         =           (/"Taiwan","China:states"/)
res@mpProvincialLineColor       =           (/"gray40","gray40"/)
res@mpProvincialLineThicknessF  =           (/0.8,0.8/)

res@cnLineLabelsOn              =           False
res@cnFillOn                    =           True
res@cnLinesOn                   =           False
res@cnLevelSelectionMode        =           "ExplicitLevels"
res@cnLevels                    =           1500
res@cnFillColors                =           (/"Transparent","gray60"/)
res@cnFillDrawOrder             =           "PreDraw"
res@cnFillOpacityF              =           0.5
res@lbLabelBarOn                =           False

res@tmXBLabelFontHeightF        =           0.032        ; change maj lat tm spacing
res@tmYLLabelFontHeightF        =           0.032
res@tmXBMajorLengthF            =           0.01    ; change the tickmark length
res@tmYLMajorLengthF            =           0.01
res@gsnMajorLonSpacing  = 4
res@gsnMajorLatSpacing  = 4

LEV = 950.
itype = 0
do t = 0,5,2
    if (t.eq.0 .or. t.eq.1 .or. t.eq.2 .or. t.eq.3) then
        res@tmXBLabelsOn = False
    end if

    if (t.eq.4 .or. t.eq.5) then
        res@tmXBLabelsOn = True
    end if

    if (t.eq.1 .or. t.eq.3 .or. t.eq.5) then
        res@tmYLLabelsOn = False
    else 
        res@tmYLLabelsOn = True
    end if
    
    map(t) = gsn_csm_contour_map_ce(wks, elevt, res)
	do hour = 0 , 23 
		tt = hour/2
		vres@vcLineArrowColor = colors(tt)
		vector(t,hour) 			=  			gsn_csm_vector(wks, uBnew(itype,hour,{LEV},:,:),vBnew(itype,hour,{LEV},:,:), vres)
		overlay(map(t), vector(t,hour))
	end do 
    itype = itype + 1 
end do 

itype = 0
do t = 1,5,2
    if (t.eq.0 .or. t.eq.1 .or. t.eq.2 .or. t.eq.3) then
        res@tmXBLabelsOn = False
    end if

    if (t.eq.4 .or. t.eq.5) then
        res@tmXBLabelsOn = True
    end if

    if (t.eq.1 .or. t.eq.3 .or. t.eq.5) then
        res@tmYLLabelsOn = False
    else 
        res@tmYLLabelsOn = True
    end if
	map(t) = gsn_csm_contour_map_ce(wks, elevt, res)
	do hour = 0 , 23 
		tt = hour/2
		vres@vcLineArrowColor = colors(tt)
		vector(t,hour) 			=  			gsn_csm_vector(wks, uNnew(itype,hour,{LEV},:,:),vNnew(itype,hour,{LEV},:,:), vres)
		overlay(map(t), vector(t,hour))
	end do 
    itype = itype + 1 
end do 

;***********************************************
; legend resources
;***********************************************
labels = (/"08 LST"," "," ","14 LST"," "," ","20 LST"," "," ","02 LST"," "," "/)

lgres                    = True
lgres@lgLineColors       = colors
lgres@lgDashIndexes       = (/0,0,0,0,0,0,0,0,0,0,0,0/)
lgres@lgLineThicknessF   = 2.5   ; legend line thickness = contour line thickness
lgres@lgItemType         = "Lines"        ; show lines only (default)
lgres@lgLabelFontHeightF = 0.2            ; set the legend label font thickness
lgres@vpWidthF           = 0.13           ; width of legend (NDC)
lgres@vpHeightF          = 0.13            ; height of legend (NDC)
lgres@lgPerimOn           = True
lgres@lgPerimColor        = "black"  
lgres@lgPerimThicknessF   = 1.5   
lgres@lgPerimFill         = "SolidFill"
lgres@lgPerimFillColor    = "white"
lbid = gsn_create_legend(wks,12,labels,lgres)         ; create legend

amres = True
amres@amParallelPosF   = 0.3995		    ; move legend to the right
amres@amOrthogonalPosF = -0.368             ; move the legend down
annoid1 = gsn_add_annotation(map(1),lbid,amres)   ; add legend to plot

fig_strs = (/"(a) Type-D","(d) Type-D","(b) Type-C","(e) Type-C","(c) Type-O","(f) Type-O"/)
;fig_strs = (/"(a) Type-1 (+3h)","(d) Type-1 (+3h)","(b) Type-2 (+3h)","(e) Type-2 (+3h)","(c) Type-3 (+3h)","(f) Type-3 (+3h)"/)
fig_strs1 = (/"BBG","NSCS"/)
pres                            =           True
pres@gsnMaximize                =           False
pres@gsnFrame                  =           False 
pres@gsnPanelTop               = 0.93
pres@gsnPanelBottom            = 0.05
;pres@gsnPanelLabelBar           =           True ;打开图形面板的标签条
;pres@lbTitleOn                  =           True
;pres@lbTitleString              =           "(10~S~~F18~-~F21~4~N~"+" "+"s~S~~F18~-~F21~1~N~"+")";"(gpm)";"("+ sclab5+" "+div@units +")"
;pres@lbTitleFontHeightF         =           0.016
;pres@pmLabelBarWidthF           =           0.002  ;设置标签条的宽度
;pres@pmLabelBarHeightF          =           0.6
;pres@lbLabelFontHeightF         =           0.016 ;设置标签条标签的字体高度
;pres@lbOrientation              =          "Vertical"
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   0 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStringsPerimOn = True
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsFontHeightF   =       0.016 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 0 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0 ;设置每行图的间距
;pres@pmLabelBarOrthogonalPosF    = -0.035 ;色标水平方向偏离的位置，正右，负左
;pres@pmLabelBarParallelPosF      = 0.02;色标垂直方向偏离的位置，正上，负下
;pres@gsnPanelDebug          = True
txres1               = True
txres1@txFontHeightF = 0.026
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs1(0) ,0.32,0.95,txres1)
gsn_text_ndc(wks,fig_strs1(1),0.77,0.95,txres1)

gsn_panel(wks, map, (/3,2/), pres)
;simple_legend_ndc(wks, genres, lineres, textres)
frame(wks)
end