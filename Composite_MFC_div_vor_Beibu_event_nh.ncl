begin 
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f2 = addfile(filedir + "identify_Beibu_DLLJ_event.nc","r")
type1 = f2->mark_type1_event
type2 = f2->mark_type2_event
type3 = f2->mark_type3_event

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
print(max(yyyy))
mmddhh = yyyymmddhh%1000000             
print(max(mmddhh))
mm    = mmddhh/10000
print(max(mm))
ddhh    = mmddhh%10000                 
print(max(ddhh))
dd    = ddhh/100                          
print(max(dd))
hh    = ddhh%100
mn    = dd
sc    = dd
mn    = 0
sc    = 0
units  = "hours since 2001-04-01 00:00:00" 
time   = cd_inv_calendar(yyyy,mm,dd,hh,mn,sc,units, 0)
time!0 = "time"
utc_date = cd_calendar(time, 0)
month  = tointeger(utc_date(:,1))    ; use sprinti 
day    = tointeger(utc_date(:,2))
hour   = tointeger(utc_date(:,3))

f1 = addfile("/sky6/lbz-share/ERA5/2022/ERA5_u_20220101.nc","r")
lat1 = f1->latitude({40:10})
lon1 = f1->longitude({85:135})
lev1 = f1->level({1000:700})
nlat = dimsizes(lat1) 
nlon = dimsizes(lon1)
nlev = dimsizes(lev1)
num_typeB = new((/3/),"integer")
num_typeB = 0
uq    = new((/3,nlev,nlat,nlon/),"float") ;Zonal Moisture Flux [uq] ;[m/s][g/kg]
vq    = new((/3,nlev,nlat,nlon/),"float") ;Meridional Moisture Flux [vq] ;[m/s][g/kg]
iuq   = new((/3,nlat,nlon/),"float");Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg] ;[g/(m*s)]
ivq   = new((/3,nlat,nlon/),"float");Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg] ;[g/(m*s)]
duvq  = new((/3,nlev,nlat,nlon/),"float");Divergence of Moisture Flux ;g/(kg*s)
iduvq = new((/3,nlat,nlon/),"float");Integrated Mass Weighted Moisture Flux Convergence ;g/(m2*s)
div   = new((/3,nlev,nlat,nlon/),"float");Divergence of Wind ;1/s
ud    = new((/3,nlev,nlat,nlon/),"float");Zonal Divergent Wind ;m/s
vd    = new((/3,nlev,nlat,nlon/),"float");Meridional Divergent Wind ;m/s
VIMFC = new((/3,nlat,nlon/),"float");Integrated Mass Weighted Moisture Flux Convergence ;g/(m2*s)
vor   = new((/3,nlev,nlat,nlon/),"float");Divergence of Wind ;1/s

uq   = 0.0
vq   = 0.0
iuq  = 0.0
ivq  = 0.0
duvq = 0.0
iduvq = 0.0
div = 0.0
ud = 0.0
vd = 0.0
vor = 0.0

uq!1 = "level"
uq&level = lev1
uq!2 = "latitude"
uq&latitude = lat1 
uq!3 = "longitude" 
uq&longitude = lon1 
copy_VarCoords(uq, vq)
uq@long_name = "Zonal Moisture Flux [uq]"   
vq@long_name = "Meridional Moisture Flux [vq]"
uq@units     = "[m/s][g/kg]"     
vq@units     = "[m/s][g/kg]"

iuq!1 = "latitude"
iuq&latitude = lat1 
iuq!2 = "longitude" 
iuq&longitude = lon1 
copy_VarCoords(iuq, ivq)
iuq@long_name = "Integrated Zonal UQ [uq*dpg]" 
iuq@LONG_NAME = "Sum: Mass Weighted Integrated Zonal Moisture Flux [uq*dpg]" 
iuq@units     = "[g/(m*s)]"
ivq@long_name = "Integrated Meridional VQ [vq*dpg]" 
ivq@LONG_NAME = "Sum: Mass Weighted Integrated Meridional Moisture Flux [vq*dpg]" 
ivq@units     = "[g/(m*s)]"

copy_VarCoords(uq, duvq)
duvq@long_name = "Divergence of Moisture Flux"
duvq@units     = "g/(kg*s)"    ; (1/m)*[(m/s)(g/kg)] => [g/(kg-s)]
copy_VarCoords(iuq, iduvq)
iduvq@long_name = "Integrated Mass Wgt MFC" 
iduvq@LONG_NAME = "Integrated Mass Weighted Moisture Flux Convergence" 
iduvq@units     = "g/(m2*s)"
copy_VarCoords(uq, div)
div@long_name = "Divergence of Wind"
div@units     = "1/s"  
copy_VarCoords(uq, vor)
vor@long_name = "vorticity"
vor@units     = "1/s"
copy_VarCoords(uq, ud)
copy_VarCoords(uq, vd)  
ud@long_name  = "Zonal Divergent Wind"
ud@units      = "m/s"
vd@long_name  = "Meridional Divergent Wind"
vd@units      = "m/s"

copy_VarCoords(iuq, VIMFC)
VIMFC@long_name = "VIMFC" 
VIMFC@LONG_NAME = "Integrated Mass Weighted Moisture Flux Convergence" 
VIMFC@units     = "g/(m2*s)"

ptop = 70000            ; 'shum' upper level                  
ptop@units = "Pa"
g    = 9.80665          ; m/s2

hr1 = new((/9/),"integer")
hr1 = (/0,1,2,3,4,5,6,7,8/)

do i = 0,8
do year = 2001,2023;2023
    iyr = year-2001
    if (year.ge.2007) then
        path_uvq = "/sky6/lbz-share/ERA5/"
    else 
        path_uvq = "/sky7/lbz_share/ERA5/"
    end if
    ind1 = ind(type1(iyr,:).ne.0)
    if (.not.all(ismissing(ind1))) then
        nmax  = max(type1(iyr,ind1))
        nmin  = min(type1(iyr,ind1))
        do n = nmin,nmax
            ind_num1 = ind(type1(iyr,:).eq.n)
            if (.not.all(ismissing(ind_num1))) then
                if ((ind_num1(0)+hr1(i)).ge.0 .and. (ind_num1(0)+hr1(i)).le.4391) then
                    num_typeB(0) = num_typeB(0) + 1
                    file_u = addfile(path_uvq+year+"/ERA5_u_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_v = addfile(path_uvq+year+"/ERA5_v_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_q = addfile(path_uvq+year+"/ERA5_q_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_ps = addfile("/sky6/lbz-share/ERA5/surface/ERA5_sp_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+".nc","r")
                    nt  = hour(ind_num1(0)+hr1(i))
                    u   = file_u->U(nt,{1000:700},{40:10},{85:135})   ; m/s, (level,lat,lon)
                    v   = file_v->V(nt,{1000:700},{40:10},{85:135})
                    q   = file_q->Q(nt,{1000:700},{40:10},{85:135})   ;[kg/kg], (level,lat,lon)
                    ntt = 24*(day(ind_num1(0)+hr1(i))-1)+hour(ind_num1(0)+hr1(i)) 
                    ps   = file_ps->SP(ntt,{40:10},{85:135})          ; Pa=>[kg/(m.s2)], (lat,lon)
                    delete([/file_u,file_v,file_q,file_ps/])

                    ;---Vertical levels
                    plev = q&level                      ; hPa  
                    plev = plev*100                     ; [100000,...,10000] Pa=>[kg/(m-s2)]
                    plev@units = "Pa"

                    ;---Change [kg/kg] to [g/kg]; not necessary: but common units for q
                    q    = q*1000            
                    q@units = "g/kg"

                    ;---Layer thickness: ; Pa=>[kg/(m.s2)], (level,lat,lon) dpres_plevel_Wrap
                    ;---Mass weighting:  (dp/g) => [Pa/(m/s2)] => (Pa.s2)/m => [kg/(m.s2)][s2/m] =>  (kg/m2)
                    dp   = dpres_plevel_Wrap(plev, ps, ptop, 0) ; Pa; layar thickness
                    dpg  = dp/g    
                    dpg@long_name = "Layer Mass Weighting"
                    dpg@units     = "kg/m2"                     ; dp/g, Pa/(m s-2), reduce to kg m-2

                    ;---Moisture flux components at each pressure level
                    uq0 = u*q
                    vq0 = v*q
                    copy_VarCoords(u,uq0)
                    copy_VarCoords(v,vq0)   ; (level,lat,lon)
                    uq(0,:,:,:)   = uq(0,:,:,:) + uq0                         
                    vq(0,:,:,:)   = vq(0,:,:,:) + vq0  

                    ;---Integrated mass weighted moisture flux components
                    uq_dpg = u*q*dpg                ; mass weighted 'uq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    iuq(0,:,:)    = iuq(0,:,:) + dim_sum_n(uq_dpg, 0)

                    vq_dpg = v*q*dpg                ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    ivq(0,:,:)    = ivq(0,:,:) + dim_sum_n(vq_dpg, 0)
                    
                    
                    ;---Divergence of moisture flux: uv2dvF => global 'fixed' rectilinear grid
                    duvq0  = uv2dv_cfd(uq0, vq0,lat1,lon1, 2)  ;(level,lat,lon)
                    duvq(0,:,:,:)  = duvq(0,:,:,:) + duvq0

                    ;---Mass weighted integration [sum] of the divergence of moisture flux
                    duvq_dpg = duvq0*dpg            ;  [g/(kg-s)][kg/m2] => [g/(m2.s)]
                    iduvq(0,:,:)  = iduvq(0,:,:) + dim_sum_n(duvq_dpg, 0)
                    
                    ;*************************************************
                    ; Calculate divergence: Use Wrap to include meta data
                    ; Calculate divergent wind components
                    ;*************************************************
                    ;div0 = uv2dv_cfd(u,v,lat1,lon1, 2)                ; u,v ==> divergence; (:,:,:)
                    ;div(0,:,:,:) = div(0,:,:,:) + div0
                    ;ud0  = new ( dimsizes(u), typeof(u), "No_FillValue")
                    ;vd0  = new ( dimsizes(v), typeof(v), "No_FillValue")
                    ;dv2uvf(div0,ud0,vd0)                     ; divergence ==> divergent components  

                    ;ud(0,:,:,:) = ud(0,:,:,:) + ud0
                    ;vd(0,:,:,:) = vd(0,:,:,:) + vd0

                    ;计算涡度
                    ;vr0 = uv2vr_cfd (u,v,lat1,lon1, 2)
                    ;vor(0,:,:,:) = vor(0,:,:,:) + vr0
                    ;delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,ud0,vd0,div0,vr0/])
                    delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,u,v,q,ps/])
                end if
            end if
            delete(ind_num1)
        end do
    end if
    delete(ind1)

    ind1 = ind(type2(iyr,:).ne.0)
    if (.not.all(ismissing(ind1))) then
        nmax  = max(type2(iyr,ind1))
        nmin  = min(type2(iyr,ind1))
        do n = nmin,nmax
            ind_num1 = ind(type2(iyr,:).eq.n)
            if (.not.all(ismissing(ind_num1))) then
                if ((ind_num1(0)+hr1(i)).ge.0 .and. (ind_num1(0)+hr1(i)).le.4391) then
                    num_typeB(1) = num_typeB(1) + 1
                    file_u = addfile(path_uvq+year+"/ERA5_u_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_v = addfile(path_uvq+year+"/ERA5_v_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_q = addfile(path_uvq+year+"/ERA5_q_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_ps = addfile("/sky6/lbz-share/ERA5/surface/ERA5_sp_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+".nc","r")
                    nt  = hour(ind_num1(0)+hr1(i))
                    u   = file_u->U(nt,{1000:700},{40:10},{85:135})   ; m/s, (level,lat,lon)
                    v   = file_v->V(nt,{1000:700},{40:10},{85:135})
                    q   = file_q->Q(nt,{1000:700},{40:10},{85:135})   ;[kg/kg], (level,lat,lon)
                    ntt = 24*(day(ind_num1(0)+hr1(i))-1)+hour(ind_num1(0)+hr1(i)) 
                    ps   = file_ps->SP(ntt,{40:10},{85:135})          ; Pa=>[kg/(m.s2)], (lat,lon)
                    delete([/file_u,file_v,file_q,file_ps/])

                    ;---Vertical levels
                    plev = q&level                      ; hPa  
                    plev = plev*100                     ; [100000,...,10000] Pa=>[kg/(m-s2)]
                    plev@units = "Pa"

                    ;---Change [kg/kg] to [g/kg]; not necessary: but common units for q
                    q    = q*1000            
                    q@units = "g/kg"

                    ;---Layer thickness: ; Pa=>[kg/(m.s2)], (level,lat,lon) dpres_plevel_Wrap
                    ;---Mass weighting:  (dp/g) => [Pa/(m/s2)] => (Pa.s2)/m => [kg/(m.s2)][s2/m] =>  (kg/m2)
                    dp   = dpres_plevel_Wrap(plev, ps, ptop, 0) ; Pa; layar thickness
                    dpg  = dp/g    
                    dpg@long_name = "Layer Mass Weighting"
                    dpg@units     = "kg/m2"                     ; dp/g, Pa/(m s-2), reduce to kg m-2

                    ;---Moisture flux components at each pressure level
                    uq0 = u*q
                    vq0 = v*q
                    copy_VarCoords(u,uq0)
                    copy_VarCoords(v,vq0)   ; (level,lat,lon)
                    uq(1,:,:,:)   = uq(1,:,:,:) + uq0                         
                    vq(1,:,:,:)   = vq(1,:,:,:) + vq0  

                    ;---Integrated mass weighted moisture flux components
                    uq_dpg = u*q*dpg                ; mass weighted 'uq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    iuq(1,:,:)    = iuq(1,:,:) + dim_sum_n(uq_dpg, 0)

                    vq_dpg = v*q*dpg                ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    ivq(1,:,:)    = ivq(1,:,:) + dim_sum_n(vq_dpg, 0)
                    
                    
                    ;---Divergence of moisture flux: uv2dvF => global 'fixed' rectilinear grid
                    duvq0  = uv2dv_cfd(uq0, vq0,lat1,lon1, 2)  ;(level,lat,lon)
                    duvq(1,:,:,:)  = duvq(1,:,:,:) + duvq0

                    ;---Mass weighted integration [sum] of the divergence of moisture flux
                    duvq_dpg = duvq0*dpg            ;  [g/(kg-s)][kg/m2] => [g/(m2.s)]
                    iduvq(1,:,:)  = iduvq(1,:,:) + dim_sum_n(duvq_dpg, 0)
                    
                    ;*************************************************
                    ; Calculate divergence: Use Wrap to include meta data
                    ; Calculate divergent wind components
                    ;*************************************************
                    ;div0 = uv2dv_cfd(u,v,lat1,lon1, 2)                ; u,v ==> divergence; (:,:,:)
                    ;div(1,:,:,:) = div(1,:,:,:) + div0
                    ;ud0  = new ( dimsizes(u), typeof(u), "No_FillValue")
                    ;vd0  = new ( dimsizes(v), typeof(v), "No_FillValue")
                    ;dv2uvf(div0,ud0,vd0)                     ; divergence ==> divergent components  

                    ;ud(1,:,:,:) = ud(1,:,:,:) + ud0
                    ;vd(1,:,:,:) = vd(1,:,:,:) + vd0

                    ;计算涡度
                    ;vr0 = uv2vr_cfd (u,v,lat1,lon1, 2)
                    ;vor(1,:,:,:) = vor(1,:,:,:) + vr0
                    ;delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,ud0,vd0,div0,vr0/])
                    delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,u,v,q,ps/])
                end if
            end if
            delete(ind_num1)
        end do
    end if
    delete(ind1)

    ind1 = ind(type3(iyr,:).ne.0)
    if (.not.all(ismissing(ind1))) then
        nmax  = max(type3(iyr,ind1))
        nmin  = min(type3(iyr,ind1))
        do n = nmin,nmax
            ind_num1 = ind(type3(iyr,:).eq.n)
            if (.not.all(ismissing(ind_num1))) then
                if ((ind_num1(0)+hr1(i)).ge.0 .and. (ind_num1(0)+hr1(i)).le.4391) then
                    num_typeB(2) = num_typeB(2) + 1
                    file_u = addfile(path_uvq+year+"/ERA5_u_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_v = addfile(path_uvq+year+"/ERA5_v_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_q = addfile(path_uvq+year+"/ERA5_q_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+".nc","r")
                    file_ps = addfile("/sky6/lbz-share/ERA5/surface/ERA5_sp_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+".nc","r")
                    nt  = hour(ind_num1(0)+hr1(i))
                    u   = file_u->U(nt,{1000:700},{40:10},{85:135})   ; m/s, (level,lat,lon)
                    v   = file_v->V(nt,{1000:700},{40:10},{85:135})
                    q   = file_q->Q(nt,{1000:700},{40:10},{85:135})   ;[kg/kg], (level,lat,lon)
                    ntt = 24*(day(ind_num1(0)+hr1(i))-1)+hour(ind_num1(0)+hr1(i)) 
                    ps   = file_ps->SP(ntt,{40:10},{85:135})          ; Pa=>[kg/(m.s2)], (lat,lon)
                    delete([/file_u,file_v,file_q,file_ps/])

                    ;---Vertical levels
                    plev = q&level                      ; hPa  
                    plev = plev*100                     ; [100000,...,10000] Pa=>[kg/(m-s2)]
                    plev@units = "Pa"

                    ;---Change [kg/kg] to [g/kg]; not necessary: but common units for q
                    q    = q*1000            
                    q@units = "g/kg"

                    ;---Layer thickness: ; Pa=>[kg/(m.s2)], (level,lat,lon) dpres_plevel_Wrap
                    ;---Mass weighting:  (dp/g) => [Pa/(m/s2)] => (Pa.s2)/m => [kg/(m.s2)][s2/m] =>  (kg/m2)
                    dp   = dpres_plevel_Wrap(plev, ps, ptop, 0) ; Pa; layar thickness
                    dpg  = dp/g    
                    dpg@long_name = "Layer Mass Weighting"
                    dpg@units     = "kg/m2"                     ; dp/g, Pa/(m s-2), reduce to kg m-2

                    ;---Moisture flux components at each pressure level
                    uq0 = u*q
                    vq0 = v*q
                    copy_VarCoords(u,uq0)
                    copy_VarCoords(v,vq0)   ; (level,lat,lon)
                    uq(2,:,:,:)   = uq(2,:,:,:) + uq0                         
                    vq(2,:,:,:)   = vq(2,:,:,:) + vq0  

                    ;---Integrated mass weighted moisture flux components
                    uq_dpg = u*q*dpg                ; mass weighted 'uq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    iuq(2,:,:)    = iuq(2,:,:) + dim_sum_n(uq_dpg, 0)

                    vq_dpg = v*q*dpg                ; mass weighted 'vq'; [m/s][g/kg][kg/m2]=>[g/(m.s)]
                    ivq(2,:,:)    = ivq(2,:,:) + dim_sum_n(vq_dpg, 0)
                    
                    
                    ;---Divergence of moisture flux: uv2dvF => global 'fixed' rectilinear grid
                    duvq0  = uv2dv_cfd(uq0, vq0,lat1,lon1, 2)  ;(level,lat,lon)
                    duvq(2,:,:,:)  = duvq(2,:,:,:) + duvq0

                    ;---Mass weighted integration [sum] of the divergence of moisture flux
                    duvq_dpg = duvq0*dpg            ;  [g/(kg-s)][kg/m2] => [g/(m2.s)]
                    iduvq(2,:,:)  = iduvq(2,:,:) + dim_sum_n(duvq_dpg, 0)
                    
                    ;*************************************************
                    ; Calculate divergence: Use Wrap to include meta data
                    ; Calculate divergent wind components
                    ;*************************************************
                    ;div0 = uv2dv_cfd(u,v,lat1,lon1, 2)                ; u,v ==> divergence; (:,:,:)
                    ;div(2,:,:,:) = div(2,:,:,:) + div0
                    ;ud0  = new ( dimsizes(u), typeof(u), "No_FillValue")
                    ;vd0  = new ( dimsizes(v), typeof(v), "No_FillValue")
                    ;dv2uvf(div0,ud0,vd0)                     ; divergence ==> divergent components  

                    ;ud(2,:,:,:) = ud(2,:,:,:) + ud0
                    ;vd(2,:,:,:) = vd(2,:,:,:) + vd0

                    ;计算涡度
                    ;vr0 = uv2vr_cfd (u,v,lat1,lon1, 2)
                    ;vor(2,:,:,:) = vor(2,:,:,:) + vr0
                    ;delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,ud0,vd0,div0,vr0/])
                    delete([/uq_dpg,vq_dpg,duvq_dpg,duvq0,u,v,q,ps/])
                end if
            end if 
            delete(ind_num1)
        end do
    end if
    delete(ind1)
end do
end do

do i =0,2
  if (num_typeB(i).ne.0) then
    uq(i,:,:,:)   = uq(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    vq(i,:,:,:)   = vq(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    iuq(i,:,:)    = iuq(i,:,:)/(tofloat(num_typeB(i))/9.0)
    ivq(i,:,:)    = ivq(i,:,:)/(tofloat(num_typeB(i))/9.0)
    duvq(i,:,:,:) = duvq(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    iduvq(i,:,:)  = iduvq(i,:,:)/(tofloat(num_typeB(i))/9.0)

    ;div(i,:,:,:)  = div(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    ;ud(i,:,:,:)  = ud(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    ;vd(i,:,:,:)  = vd(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
    ;vor(i,:,:,:)  = vor(i,:,:,:)/(tofloat(num_typeB(i))/9.0)
  end if
end do 
VIMFC =  -iduvq           ; Note the preceding -1 [negative precedes integration]  


;print("-----------------")
;printVarSummary(uq)              
;printMinMax(uq,0)
;print("-----------------")
;printVarSummary(vq)                
;printMinMax(vq,0)
;print("-----------------")
;printVarSummary(iuq)              
;printMinMax(iuq,0)
;print("-----------------")
;printVarSummary(ivq)                
;printMinMax(ivq,0)
;print("-----------------")
;printVarSummary(duvq)              
;printMinMax(duvq,0)
;print("-----------------")
;printVarSummary(iduvq)                
;printMinMax(iduvq,0)
;print("-----------------")
;printVarSummary(VIMFC)                
;printMinMax(VIMFC,0)
;print("-----------------")
;printVarSummary(ud)              
;printMinMax(ud,0)
;print("-----------------")
;printVarSummary(vd)                
;printMinMax(vd,0)
;print("-----------------")

fnameout = "composite_Com_MFC_div_Beibu_type_event_after9h_3.nc"
system("rm -f " + fnameout)
setfileoption("nc","Format","NetCDF4");
fout=addfile(filedir +fnameout, "c")
fout->uq  = uq
fout->vq  = vq
fout->iuq = iuq
fout->ivq = ivq
fout->duvq  = duvq
fout->iduvq = iduvq
fout->VIMFC = VIMFC
fout->num_typeB = num_typeB

;fnameout1 = "composite_Com_div_vor_Beibu_type_event_after9h_1.nc"
;system("rm -f " + fnameout1)
;setfileoption("nc","Format","NetCDF4");
;fout1=addfile(filedir +fnameout1, "c")
;fout1->div   = div
;fout1->ud    = ud
;fout1->vd    = vd
;fout1->vor   = vor
;fout1->num_typeB = num_typeB

end