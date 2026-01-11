begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/" 
f1 = addfile(filedir + "Composite_dudt_Beibu_day0.nc","r")
f2 = addfile(filedir + "Composite_dudt_NSCS_day0.nc","r")
u_TD1  = f1->u_TD 
v_TD1  = f1->v_TD  
u_HAD1 = f1->u_HAD  
v_HAD1 = f1->v_HAD  
u_VAD1 = f1->u_VAD   
v_VAD1 = f1->v_VAD  
PGFx1  = f1->PGFx   
PGFy1  = f1->PGFy  
CFx1   = f1->CFx   
CFy1   = f1->CFy 
num_typeB1 = f1->num_typeB 
Frx1 = u_TD1 - u_HAD1  - PGFx1 - CFx1
Fry1 = v_TD1 - v_HAD1  - PGFy1 - CFy1
copy_VarCoords(u_TD1,Frx1)
copy_VarCoords(u_TD1,Fry1)

u_TD2  = f2->u_TD 
v_TD2  = f2->v_TD  
u_HAD2 = f2->u_HAD  
v_HAD2 = f2->v_HAD  
u_VAD2 = f2->u_VAD   
v_VAD2 = f2->v_VAD  
PGFx2  = f2->PGFx   
PGFy2  = f2->PGFy  
CFx2   = f2->CFx   
CFy2   = f2->CFy 
num_typeB2 = f2->num_typeB 
Frx2 = u_TD2 - u_HAD2  - PGFx2 - CFx2
Fry2 = v_TD2 - v_HAD2  - PGFy2 - CFy2
copy_VarCoords(u_TD2,Frx2)
copy_VarCoords(u_TD2,Fry2)

printVarSummary(u_TD1)

fn1 = addfile(filedir + "composite_UVws_Beibu_type_event_day0.nc","r")
uB = fn1->uB
vB = fn1->vB
wsB = fn1->wsB
num_type1 = fn1->num_type
print(num_type1) 
printVarSummary(uB)

fn2 = addfile(filedir + "composite_UVws_NSCS_type_event_day0.nc","r")
uN = fn2->uB
vN = fn2->vB
wsN = fn2->wsB
num_type2 = fn2->num_type
print(num_type2)

ndim = dimsizes(uB)
;dim(0)-BLJ/SLLJ; dim(1)-Type
data_uB = new((/2,ndim(0)/),"float")
data_vB = new((/2,ndim(0)/),"float")
data_uN = new((/2,ndim(0)/),"float")
data_vN = new((/2,ndim(0)/),"float")

;Type1_BLJ
lonmin = 106.
lonmax = 110.5
latmin = 18.
latmax = 22.

data_uB(0,0) = dim_avg(dim_avg_n_Wrap(uB(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(0,0) = dim_avg(dim_avg_n_Wrap(vB(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type2_BLJ
latmin = 18.
latmax = 22.
data_uB(0,1) = dim_avg(dim_avg_n_Wrap(uB(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(0,1) = dim_avg(dim_avg_n_Wrap(vB(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type3_BLJ
latmin = 18.
latmax = 22.
data_uB(0,2) = dim_avg(dim_avg_n_Wrap(uB(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(0,2) = dim_avg(dim_avg_n_Wrap(vB(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type1_SLLJ
latmin = 23.5
latmax = 28.5
data_uB(1,0) = dim_avg(dim_avg_n_Wrap(uB(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(1,0) = dim_avg(dim_avg_n_Wrap(vB(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type2_SLLJ
latmin = 22.
latmax = 27.
data_uB(1,1) = dim_avg(dim_avg_n_Wrap(uB(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(1,1) = dim_avg(dim_avg_n_Wrap(vB(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type3_SLLJ
latmin = 18.
latmax = 23.
data_uB(1,2) = dim_avg(dim_avg_n_Wrap(uB(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vB(1,2) = dim_avg(dim_avg_n_Wrap(vB(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type1_BLJ
lonmin = 110.5
lonmax = 117.
latmin = 18.
latmax = 22.
data_uN(0,0) = dim_avg(dim_avg_n_Wrap(uN(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(0,0) = dim_avg(dim_avg_n_Wrap(vN(0,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type2_BLJ
latmin = 18.
latmax = 22.
data_uN(0,1) = dim_avg(dim_avg_n_Wrap(uN(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(0,1) = dim_avg(dim_avg_n_Wrap(vN(1,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type3_BLJ
latmin = 18.
latmax = 22.
data_uN(0,2) = dim_avg(dim_avg_n_Wrap(uN(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(0,2) = dim_avg(dim_avg_n_Wrap(vN(2,:,{950},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type1_SLLJ
latmin = 23.5
latmax = 28.5
data_uN(1,0) = dim_avg(dim_avg_n_Wrap(uN(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(1,0) = dim_avg(dim_avg_n_Wrap(vN(0,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type2_SLLJ
latmin = 22.
latmax = 27.
data_uN(1,1) = dim_avg(dim_avg_n_Wrap(uN(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(1,1) = dim_avg(dim_avg_n_Wrap(vN(1,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

;Type3_SLLJ
latmin = 18.
latmax = 23.
data_uN(1,2) = dim_avg(dim_avg_n_Wrap(uN(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))
data_vN(1,2) = dim_avg(dim_avg_n_Wrap(vN(2,:,{750},{latmax:latmin},{lonmin:lonmax}), (/1,2/)))

dims = dimsizes(u_TD1)
fi1 = new((/dims(0),dims(1),dims(2),dims(3),dims(4)/),"float")
fi2 = new((/dims(0),dims(1),dims(2),dims(3),dims(4)/),"float")

;950hPa-atan2(data_uB(0,i), data_vB(0,i))
;750hPa-atan2(data_uB(1,i), data_vB(1,i))
do i = 0,2
    fi1(i,:,:,:,:) = atan2(data_uB(1,i), data_vB(1,i))
    fi2(i,:,:,:,:) = atan2(data_uN(1,i), data_vN(1,i))
end do
print(fi1(:,0,0,0,0)*(180./3.1415926))
print(fi2(:,0,0,0,0)*(180./3.1415926))

TD1 = u_TD1*sin(fi1)+v_TD1*cos(fi1)
TD2 = u_TD2*sin(fi2)+v_TD2*cos(fi2)
HAD1 = u_HAD1*sin(fi1)+v_HAD1*cos(fi1)
HAD2 = u_HAD2*sin(fi2)+v_HAD2*cos(fi2)
VAD1 = u_VAD1*sin(fi1)+v_VAD1*cos(fi1)
VAD2 = u_VAD2*sin(fi2)+v_VAD2*cos(fi2)
PGF1 = PGFx1*sin(fi1)+PGFy1*cos(fi1)
PGF2 = PGFx2*sin(fi2)+PGFy2*cos(fi2)
CF1 = CFx1*sin(fi1)+CFy1*cos(fi1)
CF2 = CFx2*sin(fi2)+CFy2*cos(fi2)
Fr1 = Frx1*sin(fi1)+Fry1*cos(fi1)
Fr2 = Frx2*sin(fi2)+Fry2*cos(fi2)
copy_VarCoords(u_TD1,TD1)
copy_VarCoords(u_TD1,TD2)
copy_VarCoords(u_TD1,HAD1)
copy_VarCoords(u_TD1,HAD2)
copy_VarCoords(u_TD1,VAD1)
copy_VarCoords(u_TD1,VAD2)
copy_VarCoords(u_TD1,PGF1)
copy_VarCoords(u_TD1,PGF2)
copy_VarCoords(u_TD1,CF1)
copy_VarCoords(u_TD1,CF2)
copy_VarCoords(u_TD1,Fr1)
copy_VarCoords(u_TD1,Fr2)

;dim(0)-Type; dim(1)-6项，dim(2)-Time
uequa1 = new((/3,5,dims(1)/),"float")
uequa2 = new((/3,5,dims(1)/),"float")
uequa11 = new((/3,5,dims(1)/),"float")
uequa22 = new((/3,5,dims(1)/),"float")

LEV = 750
;Type1_SLLJ
lonmin = 106.
lonmax = 110.5
latmin = 23.5
latmax = 28.5
uequa1(0,4,:) = dim_avg_n_Wrap(TD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(0,3,:) = dim_avg_n_Wrap(HAD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(0,2,:) = dim_avg_n_Wrap(PGF1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(0,1,:) = dim_avg_n_Wrap(CF1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(0,0,:) = dim_avg_n_Wrap(Fr1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(0,2,:) = dim_avg_n_Wrap(VAD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type2_SLLJ
latmin = 22.
latmax = 27.
uequa1(1,4,:) = dim_avg_n_Wrap(TD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(1,3,:) = dim_avg_n_Wrap(HAD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(1,2,:) = dim_avg_n_Wrap(PGF1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(1,1,:) = dim_avg_n_Wrap(CF1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(1,0,:) = dim_avg_n_Wrap(Fr1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(1,2,:) = dim_avg_n_Wrap(VAD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type3_SLLJ
latmin = 18.
latmax = 23.
uequa1(2,4,:) = dim_avg_n_Wrap(TD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(2,3,:) = dim_avg_n_Wrap(HAD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(2,2,:) = dim_avg_n_Wrap(PGF1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(2,1,:) = dim_avg_n_Wrap(CF1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa1(2,0,:) = dim_avg_n_Wrap(Fr1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(2,2,:) = dim_avg_n_Wrap(VAD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type1_SLLJ
lonmin = 110.5
lonmax = 117.
latmin = 23.5
latmax = 28.5
uequa2(0,4,:) = dim_avg_n_Wrap(TD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(0,3,:) = dim_avg_n_Wrap(HAD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(0,2,:) = dim_avg_n_Wrap(PGF2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(0,1,:) = dim_avg_n_Wrap(CF2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(0,0,:) = dim_avg_n_Wrap(Fr2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(0,2,:) = dim_avg_n_Wrap(VAD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type2_SLLJ
latmin = 22.
latmax = 27.
uequa2(1,4,:) = dim_avg_n_Wrap(TD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(1,3,:) = dim_avg_n_Wrap(HAD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(1,2,:) = dim_avg_n_Wrap(PGF2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(1,1,:) = dim_avg_n_Wrap(CF2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(1,0,:) = dim_avg_n_Wrap(Fr2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(1,2,:) = dim_avg_n_Wrap(VAD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type3_SLLJ
latmin = 18.
latmax = 23.
uequa2(2,4,:) = dim_avg_n_Wrap(TD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(2,3,:) = dim_avg_n_Wrap(HAD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(2,2,:) = dim_avg_n_Wrap(PGF2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(2,1,:) = dim_avg_n_Wrap(CF2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa2(2,0,:) = dim_avg_n_Wrap(Fr2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(2,2,:) = dim_avg_n_Wrap(VAD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

do i = 0,2
    fi1(i,:,:,:,:) = atan2(data_uB(0,i), data_vB(0,i))
    fi2(i,:,:,:,:) = atan2(data_uN(0,i), data_vN(0,i))
end do
print(fi1(:,0,0,0,0)*(180./3.1415926))
print(fi2(:,0,0,0,0)*(180./3.1415926))

TD1 = u_TD1*sin(fi1)+v_TD1*cos(fi1)
TD2 = u_TD2*sin(fi2)+v_TD2*cos(fi2)
HAD1 = u_HAD1*sin(fi1)+v_HAD1*cos(fi1)
HAD2 = u_HAD2*sin(fi2)+v_HAD2*cos(fi2)
VAD1 = u_VAD1*sin(fi1)+v_VAD1*cos(fi1)
VAD2 = u_VAD2*sin(fi2)+v_VAD2*cos(fi2)
PGF1 = PGFx1*sin(fi1)+PGFy1*cos(fi1)
PGF2 = PGFx2*sin(fi2)+PGFy2*cos(fi2)
CF1 = CFx1*sin(fi1)+CFy1*cos(fi1)
CF2 = CFx2*sin(fi2)+CFy2*cos(fi2)
Fr1 = Frx1*sin(fi1)+Fry1*cos(fi1)
Fr2 = Frx2*sin(fi2)+Fry2*cos(fi2)
copy_VarCoords(u_TD1,TD1)
copy_VarCoords(u_TD1,TD2)
copy_VarCoords(u_TD1,HAD1)
copy_VarCoords(u_TD1,HAD2)
copy_VarCoords(u_TD1,VAD1)
copy_VarCoords(u_TD1,VAD2)
copy_VarCoords(u_TD1,PGF1)
copy_VarCoords(u_TD1,PGF2)
copy_VarCoords(u_TD1,CF1)
copy_VarCoords(u_TD1,CF2)
copy_VarCoords(u_TD1,Fr1)
copy_VarCoords(u_TD1,Fr2)

LEV = 950
;Type1_BLJ
lonmin = 106.
lonmax = 110.5
latmin = 18.
latmax = 22.
uequa11(0,4,:) = dim_avg_n_Wrap(TD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(0,3,:) = dim_avg_n_Wrap(HAD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(0,2,:) = dim_avg_n_Wrap(PGF1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(0,1,:) = dim_avg_n_Wrap(CF1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(0,0,:) = dim_avg_n_Wrap(Fr1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(0,2,:) = dim_avg_n_Wrap(VAD1(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type2_BLJ
latmin = 18.
latmax = 22.
uequa11(1,4,:) = dim_avg_n_Wrap(TD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(1,3,:) = dim_avg_n_Wrap(HAD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(1,2,:) = dim_avg_n_Wrap(PGF1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(1,1,:) = dim_avg_n_Wrap(CF1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(1,0,:) = dim_avg_n_Wrap(Fr1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(1,2,:) = dim_avg_n_Wrap(VAD1(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type3_BLJ
latmin = 18.
latmax = 22.
uequa11(2,4,:) = dim_avg_n_Wrap(TD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(2,3,:) = dim_avg_n_Wrap(HAD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(2,2,:) = dim_avg_n_Wrap(PGF1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(2,1,:) = dim_avg_n_Wrap(CF1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa11(2,0,:) = dim_avg_n_Wrap(Fr1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa1(2,2,:) = dim_avg_n_Wrap(VAD1(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type1_BLJ
lonmin = 110.5
lonmax = 117.
latmin = 18.
latmax = 22.
uequa22(0,4,:) = dim_avg_n_Wrap(TD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(0,3,:) = dim_avg_n_Wrap(HAD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(0,2,:) = dim_avg_n_Wrap(PGF2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(0,1,:) = dim_avg_n_Wrap(CF2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(0,0,:) = dim_avg_n_Wrap(Fr2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(0,2,:) = dim_avg_n_Wrap(VAD2(0,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type2_BLJ
latmin = 18.
latmax = 22.
uequa22(1,4,:) = dim_avg_n_Wrap(TD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(1,3,:) = dim_avg_n_Wrap(HAD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(1,2,:) = dim_avg_n_Wrap(PGF2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(1,1,:) = dim_avg_n_Wrap(CF2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(1,0,:) = dim_avg_n_Wrap(Fr2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(1,2,:) = dim_avg_n_Wrap(VAD2(1,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

;Type3_BLJ
latmin = 18.
latmax = 22.
uequa22(2,4,:) = dim_avg_n_Wrap(TD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(2,3,:) = dim_avg_n_Wrap(HAD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(2,2,:) = dim_avg_n_Wrap(PGF2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(2,1,:) = dim_avg_n_Wrap(CF2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
uequa22(2,0,:) = dim_avg_n_Wrap(Fr2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000
;uequa2(2,2,:) = dim_avg_n_Wrap(VAD2(2,:,{LEV},{latmin:latmax},{lonmin:lonmax}), (/1,2/))*10000

smoothed_uequa1 = runave(uequa1, 5, 0)
smoothed_uequa1(:,:,0)    = uequa1(:,:,0)
smoothed_uequa1(:,:,1)    = (uequa1(:,:,0)+uequa1(:,:,2))/2.
smoothed_uequa1(:,:,23)   = uequa1(:,:,23)
smoothed_uequa1(:,:,22)    = (uequa1(:,:,21)+uequa1(:,:,23))/2.
smoothed_uequa2 = runave(uequa2, 5, 0)
smoothed_uequa2(:,:,0)    = uequa2(:,:,0)
smoothed_uequa2(:,:,1)    = (uequa2(:,:,0)+uequa2(:,:,2))/2.
smoothed_uequa2(:,:,23)   = uequa2(:,:,23)
smoothed_uequa2(:,:,22)    = (uequa2(:,:,21)+uequa2(:,:,23))/2.

smoothed_uequa11 = runave(uequa11, 5, 0)
smoothed_uequa11(:,:,0)    = uequa11(:,:,0)
smoothed_uequa11(:,:,1)    = (uequa11(:,:,0)+uequa11(:,:,2))/2.
smoothed_uequa11(:,:,23)   = uequa11(:,:,23)
smoothed_uequa11(:,:,22)    = (uequa11(:,:,21)+uequa11(:,:,23))/2.
smoothed_uequa22 = runave(uequa22, 5, 0)
smoothed_uequa22(:,:,0)    = uequa22(:,:,0)
smoothed_uequa22(:,:,1)    = (uequa22(:,:,0)+uequa22(:,:,2))/2.
smoothed_uequa22(:,:,23)   = uequa22(:,:,23)
smoothed_uequa22(:,:,22)    = (uequa22(:,:,21)+uequa22(:,:,23))/2.

colors = (/"Gray","purple","royalblue","orange","black"/)
pdfname = "fig_dudt_Beibu_NSCS"
type = "pdf"
wks = gsn_open_wks(type,pdfname) 
plot1 = new(12, "graphic")
base = new(6, "graphic")
line = new(12,graphic)


sres1 = True
sres1@gsnDraw               = False
sres1@gsnFrame              = False
sres1@gsnMaximize           = False
sres1@vpWidthF              = 0.8
sres1@vpHeightF             = 0.55
sres1@trXMinF               = 0
sres1@trXMaxF               = 23

;sres1@gsnXYBarChart         = True
;sres1@gsnXYBarChartBarWidth = 0.25           ; change bar widths

sres1@tmXBMode              = "Explicit"         ; explicit labels
sres1@tmXBValues            = ispan(0,23,1)
sres1@tmXBLabels            = (/"08"," "," ","11"," "," ","14"," "," ", \
                                "17"," "," ","20"," "," ","23"," "," ","02"," "," ","05"," "," "/)
;sres@tmXBValues            = ispan(1,12,1)
;sres@tmXBLabels            = (/"8","10","12","14","16","18","20","22","0","2","4","6"/)

sres1@tmXTOn                = False
sres1@tmYROn                = False 
;sres1@tmBorderLineColor     = "Gray55"
sres1@tmXBLabelFontHeightF  = 0.042
sres1@tmYLLabelFontHeightF  = 0.042
sres1@gsnRightString        = ""
sres1@tiYAxisString         = "Momentum tendency (10~S~~F18~-~F21~4~N~ m s~S~~F18~-~F21~1~N~ h~S~~F18~-~F21~1~N~)"
sres1@tiYAxisFontHeightF    = 0.058
sres1@tiXAxisString         = "Time (LST)"
sres1@tiXAxisFontHeightF    = 0.052  

sres1@tmYRLabelsOn          = False
sres1@tmXTLabelsOn          = False
sres1@tmYLLabelsOn  =True
sres1@tmXBMajorLengthF         = -0.01 
sres1@tmXBMajorOutwardLengthF  = -0.01 
sres1@tmYLMajorLengthF         = 0
sres1@tmYLMajorOutwardLengthF  = 0
sres1@tmYLMinorLengthF         = 0
sres1@tmYLMinorOutwardLengthF  = 0
sres1@xyDashPattern            = 0
sres1@xyLineThicknesses        = (/  3,   3, 3, 3,3/)          ; make second line thicker
sres1@xyLineColors             = colors
sres1@gsnYRefLine              = 0
sres1@gsnYRefLineColor         = "Gray"
sres1@gsnYRefLineDashPattern   = 1

sres1@pmLegendDisplayMode    = "Always"            ; turn on legend,"NoCreate"
sres1@pmLegendSide           = "Top"               ; Change location of 
sres1@pmLegendParallelPosF   = 0.9                  ; move units right
sres1@pmLegendOrthogonalPosF = -0.4               ; move units down
sres1@pmLegendWidthF         = 0.14                ; Change width and
sres1@pmLegendHeightF        = 0.18                ; height of legend.
sres1@lgLabelFontHeightF     = 0.025                ; change font height
;sres1@lgTitleOn              = True                ; turn on legend title
;sres1@lgTitleString          = "BLJ"           ; create legend title
;sres1@lgTitleFontHeightF     = 0.024                ; font of legend title
;sres1@xyExplicitLegendLabels = (/"TD", "HAD","PGF","CF","Res"/)         ; explicit labels
sres1@xyExplicitLegendLabels = (/"Res", "CF","PGF","HAD","TD"/) 
sres1@pmLegendDisplayMode    = "NoCreate"
sres1@tiXAxisString         = " "
sres1@tiYAxisString         = " "
sres1@trYMinF               = -2.
sres1@trYMaxF               = 2.
plot1(0)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa1(0,:,:),sres1) ; create plot
;sres1@trYMinF               = -1.8
;sres1@trYMaxF               = 2.
sres1@tiYAxisString         = "Momentum tendency (10~S~~F18~-~F21~4~N~ m s~S~~F18~-~F21~1~N~ h~S~~F18~-~F21~1~N~)"

plot1(4)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa1(1,:,:),sres1) ; create plot
sres1@tiXAxisString         = "Time (LST)"
sres1@trYMinF               = -1.2
sres1@trYMaxF               = 1.2
sres1@tiYAxisString         = " "
plot1(8)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa1(2,:,:),sres1) ; create plot

sres1@tiXAxisString         = " "
sres1@trYMinF               = -2.5
sres1@trYMaxF               = 2.5
plot1(2)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa11(0,:,:),sres1) ; create plot
sres1@trYMinF               = -4.
sres1@trYMaxF               = 4.
plot1(6)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa11(1,:,:),sres1) ; create plot
sres1@tiXAxisString         = "Time (LST)"
sres1@trYMinF               = -4.
sres1@trYMaxF               = 4.
plot1(10)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa11(2,:,:),sres1) ; create plot

sres1@tiXAxisString         = " "
sres1@trYMinF               = -1.2
sres1@trYMaxF               = 1.2
plot1(1)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa2(0,:,:),sres1) ; create plot
;sres1@trYMinF               = -4.
;sres1@trYMaxF               = 4.
;sres1@tiYAxisString         = "Momentum tendency (10~S~~F18~-~F21~4~N~ m s~S~~F18~-~F21~1~N~ s~S~~F18~-~F21~1~N~)"
plot1(5)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa2(1,:,:),sres1) ; create plot
;sres1@trYMinF               = -4.
;sres1@trYMaxF               = 4.
sres1@tiXAxisString         = "Time (LST)"
plot1(9)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa2(2,:,:),sres1) ; create plot

sres1@tiXAxisString         = " "
sres1@trYMinF               = -2.5
sres1@trYMaxF               = 2.5
plot1(3)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa22(0,:,:),sres1) ; create plot
sres1@trYMinF               = -2.5
sres1@trYMaxF               = 2.5
plot1(7)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa22(1,:,:),sres1) ; create plot
sres1@tiXAxisString         = "Time (LST)"
sres1@trYMinF               = -2.5
sres1@trYMaxF               = 2.5
plot1(11)  = gsn_csm_xy (wks,ispan(0,23,1),smoothed_uequa22(2,:,:),sres1) ; create plot


;fig_strs = (/"(a1) Type-D","(b1) Type-D","(a2) Type-D","(b2) Type-D","(c1) Type-C","(d1) Type-C","(c2) Type-C","(d2) Type-C","(e1) Type-O","(f1) Type-O","(e2) Type-O","(f2) Type-O"/)
fig_strs = (/"(a) Type-D","(d) Type-D","(g) Type-D","(j) Type-D","(b) Type-C","(e) Type-C","(h) Type-C","(k) Type-C","(c) Type-O","(f) Type-O","(i) Type-O","(l) Type-O"/)

pres = True
pres@gsnMaximize                =           False
pres@gsnFrame                   =           False
pres@gsnPanelTop       = 0.9
pres@gsnPanelBottom    = 0.1
pres@gsnPanelLeft       = 0.05 
pres@gsnPanelRight    = 0.95
pres@amJust                     =           "TopLeft" ;设置图形的对齐方式为左上角
pres@gsnPanelFigureStringsBackgroundFillColor   =   -1 ;调整背景颜色，0为白色，-1为透明
pres@gsnPanelFigureStrings      =           fig_strs(:) ;指定图形面板中子图的标识符
pres@gsnPanelFigureStringsPerimOn = False
pres@gsnPanelFigureStringsFontHeightF   =       0.012 ;设置图形面板中子图标识符的字体高度为0.013
pres@gsnPanelYWhiteSpacePercent = 0 ;设置每行图的间距
pres@gsnPanelXWhiteSpacePercent = 0.5

fig_strs11 = (/"BBG","NSCS","BBG","NSCS"/)
 
txres1               = True
txres1@txFontHeightF = 0.016
;txres1@txFont           = "helvetica-bold"
gsn_text_ndc(wks,fig_strs11(0) ,0.182,0.75,txres1)
gsn_text_ndc(wks,fig_strs11(1),0.415,0.75,txres1)
gsn_text_ndc(wks,fig_strs11(2),0.635,0.75,txres1)
gsn_text_ndc(wks,fig_strs11(3),0.86,0.75,txres1)

txres1@txFontHeightF = 0.022
fig_strs111 = (/"SLLJ (750 hPa)","BLJ (950 hPa)"/)
gsn_text_ndc(wks,fig_strs111(0) ,0.3,0.788,txres1)
gsn_text_ndc(wks,fig_strs111(1),0.735,0.788,txres1)

colorle = (/"black","royalblue","purple","orange","grey"/)
legend = (/"TD","PGF","CF", "HAD","Fr"/)
;legend2 = (/"u/v"/)
thinks = (/2.5,2,2.5,2.5,2.5,2.5/) 
;thinks2 = (/2.5,2.5/) 

lgres                     = True
lgres@lgMonoDashIndex     = True
lgres@lgLineColors        = colorle(0)
;lgres@lgMarkerIndexes     = (/1,1/)
;lgres@lgMarkerSizeF       = 0.02
;lgres@lgMarkerColors      = colorle(0:1:-1)
lgres@lgDashIndexes       = 0
lgres@lgLineThicknessF    = 3.5   ; legend line thickness = contour line thickness
;lgres@lgLineDashSegLenF   = 0.8
;lgres@lgItemType          = "MarkLines"        ; show lines only (default)
lgres@lgLabelFontHeightF  = 0.2            ; set the legend label font thickness
lgres@vpWidthF            = 0.24          ; width of legend (NDC)
lgres@vpHeightF           = 0.18            ; height of legend (NDC)
lgres@lgPerimOn           = False
lgres@lgPerimColor        = "Gray40"       ; draw the box perimeter in orange
lgres@lgPerimThicknessF   = 1.5           ; thicken the box perimeter
lgres@lgPerimFill         = "SolidFill"
lgres@lgPerimFillColor    = "white"

amres = True
amres@amParallelPosF   = 0.5         ; move legend to the right
amres@amOrthogonalPosF =   1.05             ; move the legend down
lbid = gsn_create_legend(wks,1,legend(0),lgres)         ; create legend
annoid1 = gsn_add_annotation(plot1(8),lbid,amres)

lgres@lgLabelFontHeightF  = 0.24            ; set the legend label font thickness
lgres@vpWidthF            = 0.28          ; width of legend (NDC)
lgres@vpHeightF           = 0.2            ; height of legend (NDC)
amres@amParallelPosF   = 1.2
lgres@lgLineColors        = colorle(1)
lbid2 = gsn_create_legend(wks,1,legend(1),lgres)
annoid2 = gsn_add_annotation(plot1(8),lbid2,amres)

lgres@lgLabelFontHeightF  = 0.2            ; set the legend label font thickness
lgres@vpWidthF            = 0.24          ; width of legend (NDC)
lgres@vpHeightF           = 0.18            ; height of legend (NDC)
amres@amParallelPosF   = 1.9
lgres@lgLineColors        = colorle(2)
lbid3 = gsn_create_legend(wks,1,legend(2),lgres)
annoid3 = gsn_add_annotation(plot1(8),lbid3,amres)

lgres@lgLabelFontHeightF  = 0.24            ; set the legend label font thickness
lgres@vpWidthF            = 0.28          ; width of legend (NDC)
lgres@vpHeightF           = 0.2            ; height of legend (NDC)
amres@amParallelPosF   = 2.6         ; move legend to the right
lgres@lgLineColors        = colorle(3)
lbid4 = gsn_create_legend(wks,1,legend(3),lgres)       ; create legend
annoid4 = gsn_add_annotation(plot1(8),lbid4,amres)

lgres@lgLabelFontHeightF  = 0.2            ; set the legend label font thickness
lgres@vpWidthF            = 0.24          ; width of legend (NDC)
lgres@vpHeightF           = 0.18            ; height of legend (NDC)
amres@amParallelPosF   = 3.3
lgres@lgLineColors        = colorle(4)
lbid5 = gsn_create_legend(wks,1,legend(4),lgres)       ; create legend
annoid5 = gsn_add_annotation(plot1(8),lbid5,amres)

gsn_panel(wks,plot1,(/3,4/),pres)
frame(wks)
end 