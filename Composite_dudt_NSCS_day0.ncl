begin 
f2 = addfile("/sky7/zhouchling/data/DLLJ_SouthChina1/cal_LLJ_day0_NSCS.nc","r")
LLJ_day = f2->LLJ_day

f1 = addfile("/sky6/lbz-share/ERA5/2022/ERA5_u_20220101.nc","r")
lat1 = f1->latitude({40:10:-1})
lon1 = f1->longitude({85:135})
lev1 = f1->level({1000:600})
nlat = dimsizes(lat1) 
nlon = dimsizes(lon1)
nlev = dimsizes(lev1)
num_type_day = new((/3/),"integer")
num_type_day = 0

u_TD   =  new((/3,24,nlev,nlat,nlon/),"float")
u_HAD  =  new((/3,24,nlev,nlat,nlon/),"float")
u_VAD  =  new((/3,24,nlev,nlat,nlon/),"float")
PGFx   =  new((/3,24,nlev,nlat,nlon/),"float")
CFx    =  new((/3,24,nlev,nlat,nlon/),"float")

v_TD   =  new((/3,24,nlev,nlat,nlon/),"float")
v_HAD  =  new((/3,24,nlev,nlat,nlon/),"float")
v_VAD  =  new((/3,24,nlev,nlat,nlon/),"float")
PGFy   =  new((/3,24,nlev,nlat,nlon/),"float")
CFy    =  new((/3,24,nlev,nlat,nlon/),"float")
u_TD   = 0.0
u_HAD  = 0.0
u_VAD  = 0.0
PGFx   = 0.0
CFx    = 0.0
v_TD   = 0.0
v_HAD  = 0.0
v_VAD  = 0.0
PGFy   = 0.0
CFy    = 0.0
tim1 = (/0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23/)
u_TD!1 = "time"
u_TD&time = tim1
u_TD!2 = "level"
u_TD&level = lev1
u_TD!3 = "latitude"
u_TD&latitude = lat1 
u_TD!4 = "longitude" 
u_TD&longitude = lon1 
copy_VarCoords(u_TD, u_HAD)
copy_VarCoords(u_TD, u_VAD)
copy_VarCoords(u_TD, PGFx)
copy_VarCoords(u_TD, CFx)
copy_VarCoords(u_TD, v_TD)
copy_VarCoords(u_TD, v_HAD)
copy_VarCoords(u_TD, v_VAD)
copy_VarCoords(u_TD, PGFy)
copy_VarCoords(u_TD, CFy)

dp = lev1*100
angu = 0.0000729
dlon = (lon1(2)-lon1(1))*0.0174533
dlat = (lat1(2)-lat1(1))*0.0174533


do itype = 0,2
    do year = 2001,2023
        iyr = year-2001
        if (year.ge.2007) then
            path_uv = "/sky6/lbz-share/ERA5/"
        end if
        if (year.lt.2007) then
            path_uv = "/sky7/lbz_share/ERA5/"
        end if

        do month = 4,9
            imon = month - 4
            nt = days_in_month(year, month)
            do day = 1,nt
                iday = day-1
                if (LLJ_day(itype,iyr,imon,iday).eq.1) then
                    file_u = addfile(path_uv+year+"/ERA5_u_"+year+sprinti("%2.2i",month)+sprinti("%2.2i",day)+".nc","r")
                    file_v = addfile(path_uv+year+"/ERA5_v_"+year+sprinti("%2.2i",month)+sprinti("%2.2i",day)+".nc","r")
                    file_z = addfile(path_uv+year+"/ERA5_z_"+year+sprinti("%2.2i",month)+sprinti("%2.2i",day)+".nc","r")
                    file_w = addfile(path_uv+year+"/ERA5_w_"+year+sprinti("%2.2i",month)+sprinti("%2.2i",day)+".nc","r")
                    u   = file_u->U(:,{1000:600},{40:10:-1},{85:135})
                    v   = file_v->V(:,{1000:600},{40:10:-1},{85:135})
                    z   = file_z->Z(:,{1000:600},{40:10:-1},{85:135})   ;[kg/kg], (level,lat,lon)
                    w   = file_w->W(:,{1000:600},{40:10:-1},{85:135})
                    delete([/file_u,file_v,file_z,file_w/])

                    num_type_day(itype) = num_type_day(itype)+1
                    ;;;;;dudt;;;;;
                    dudt = u
                    dudt = center_finite_diff_n(u, 3600, False, 0, 0)
                    u_TD(itype,:,:,:,:) = u_TD(itype,:,:,:,:) + dudt
                    ;printVarSummary(dudt)
                    ;printMinMax(dudt,0)
                    ;;;;;dvdt;;;;;
                    dvdt = u
                    dvdt = center_finite_diff_n(v, 3600, False, 0, 0)
                    v_TD(itype,:,:,:,:) = v_TD(itype,:,:,:,:) + dvdt
                    ;printVarSummary(dvdt)
                    ;printMinMax(dvdt,0)

                    ;;;;u_HAD;;;;;;
                    u_HAD0 = advect_variable_cfd(u,v,u,lat1,lon1,False,"U advection","m/s/s",0)
                    u_HAD(itype,:,:,:,:) = u_HAD(itype,:,:,:,:) + (-1)*tofloat(u_HAD0)

                    ;;;;u_HAD;;;;;;
                    v_HAD0 = advect_variable_cfd(u,v,v,lat1,lon1,False,"V advection","m/s/s",0)
                    v_HAD(itype,:,:,:,:) = v_HAD(itype,:,:,:,:) + (-1)*tofloat(v_HAD0)

                    ;;;u_VAD;;;;
                    dudp = center_finite_diff_n(u,dp,False,0,1)
                    u_VAD(itype,:,:,:,:) = u_VAD(itype,:,:,:,:) + (-1)*w*tofloat(dudp)

                    ;;;v_VAD;;;;
                    dvdp = center_finite_diff_n(v,dp,False,0,1)
                    v_VAD(itype,:,:,:,:) = v_VAD(itype,:,:,:,:) + (-1)*w*tofloat(dvdp)

                    ;;;;;PGFx;;;;;;;CF;;;;;
                    dZdX = new ( (/24,nlev,nlat,nlon/), "float")
                    CFx0 = new((/24,nlev,nlat,nlon/),"float")
                    CFy0 = new((/24,nlev,nlat,nlon/),"float")
                    do nl=0,nlat-1                      ; loop over each latitude
                        dX = 6378388.*cos(0.0174533*lat1(nl))*dlon  ; constant at this latitude
                        dZdX(:,:,nl,:) = tofloat(center_finite_diff_n (z(:,:,nl,:), dX , False,0,2))

                        f = 2*angu*sin(0.0174533*lat1(nl))
                        CFx0(:,:,nl,:) = tofloat(f*v(:,:,nl,:))
                        CFy0(:,:,nl,:) = tofloat(f*u(:,:,nl,:))
                    end do
                    PGFx(itype,:,:,:,:) = PGFx(itype,:,:,:,:) + (-1)*dZdX
                    CFx(itype,:,:,:,:)  = CFx(itype,:,:,:,:) + CFx0
                    CFy(itype,:,:,:,:)  = CFy(itype,:,:,:,:) + (-1)*CFy0

                    ;;;;;PGFy;;;
                    dY = 6378388.*dlat
                    dZdY = center_finite_diff_n (z, dY, False,0,2)
                    PGFy(itype,:,:,:,:) = PGFy(itype,:,:,:,:) + (-1)*tofloat(dZdY)

                    delete([/u,v,z,w,dudt,dvdt,u_HAD0,v_HAD0,dudp,dvdp,dZdX,dZdY,CFx0,CFy0/])
                end if 
            end do
        end do 
    end do
end do
print(num_type_day)
do i =0,2
    if (num_type_day(i).ne.0) then
        u_TD(i,:,:,:,:)  = u_TD(i,:,:,:,:)/tofloat(num_type_day(i))
        v_TD(i,:,:,:,:)  = v_TD(i,:,:,:,:)/tofloat(num_type_day(i))
        u_HAD(i,:,:,:,:) = u_HAD(i,:,:,:,:)/tofloat(num_type_day(i))
        v_HAD(i,:,:,:,:) = v_HAD(i,:,:,:,:)/tofloat(num_type_day(i))
        u_VAD(i,:,:,:,:) = u_VAD(i,:,:,:,:)/tofloat(num_type_day(i))
        v_VAD(i,:,:,:,:) = v_VAD(i,:,:,:,:)/tofloat(num_type_day(i))
        PGFx(i,:,:,:,:)  = PGFx(i,:,:,:,:)/tofloat(num_type_day(i))
        PGFy(i,:,:,:,:)  = PGFy(i,:,:,:,:)/tofloat(num_type_day(i))
        CFx(i,:,:,:,:)   = CFx(i,:,:,:,:)/tofloat(num_type_day(i))
        CFy(i,:,:,:,:)   = CFy(i,:,:,:,:)/tofloat(num_type_day(i))
    end if
end do 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
fnameout = "Composite_dudt_NSCS_day0.nc"
system("rm -f " + fnameout)
setfileoption("nc","Format","NetCDF4");
fout=addfile(filedir + fnameout, "c")
fout->u_TD    = u_TD
fout->v_TD    = v_TD
fout->u_HAD   = u_HAD
fout->v_HAD   = v_HAD
fout->u_VAD   = u_VAD
fout->v_VAD   = v_VAD
fout->PGFx    = PGFx
fout->PGFy    = PGFy
fout->CFx     = CFx
fout->CFy     = CFy
fout->num_typeB = num_type_day
end 