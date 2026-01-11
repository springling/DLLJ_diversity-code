begin
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f2 = addfile(filedir + "identify_NSCS_DLLJ_event.nc","r")
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
utc_date = cd_calendar(time, 0)
month  = tointeger(utc_date(:,1))    ; use sprinti 
day    = tointeger(utc_date(:,2))
hour   = tointeger(utc_date(:,3))

f1 = addfile("/sky6/lbz-share/ERA5/2022/ERA5_u_20220101.nc","r")
u0   = f1->U(:,{100:1000},{40:10},{85:135})
lev = u0&level
lat = u0&latitude 
lon = u0&longitude
nlev = dimsizes(lev)
nlat = dimsizes(lat)
nlon = dimsizes(lon)
uB = new((/3,nlev,nlat,nlon/),"float")
vB = new((/3,nlev,nlat,nlon/),"float")
uB = 0.0
vB = 0.0

pathatt = "/sky3/lq_shared/IMERG_V7B/2015/"
fileatt = addfile(pathatt+"IMERG_201504111730.nc", "r")
lat1 = fileatt->lat({10:40})
lon1 = fileatt->lon({85:135})
nlat1 = dimsizes(lat1)
nlon1 = dimsizes(lon1)
preB = new((/3,nlat1,nlon1/),"float")
preB = 0.0 

num_type = new((/3/),"integer")
num_type = 0

hr = (/-24,-23,-22,-21,-20,-19,-18,-17,-16/)

do i = 0,8
do year = 2001,2023
    iyr = year-2001
    if (year.ge.2007) then
        path_uv = "/sky6/lbz-share/ERA5/"
    end if
    if (year.lt.2007) then
        path_uv = "/sky7/lbz_share/ERA5/"
    end if

    ind1 = ind(type1(iyr,:).ne.0)
    if (.not.all(ismissing(ind1))) then
        nmax  = max(type1(iyr,ind1))
        nmin  = min(type1(iyr,ind1))
        do n = nmin,nmax
            ind_num1 = ind(type1(iyr,:).eq.n)
            if (.not.all(ismissing(ind_num1))) then
                if ((ind_num1(0)+hr(i)).ge.0 .and. (ind_num1(0)+hr(i)).le.4391) then
                    file_u = addfile(path_uv+year+"/ERA5_z_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    file_v = addfile(path_uv+year+"/ERA5_w_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    u   = file_u->Z(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    v   = file_v->W(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    uB(0,:,:,:) = uB(0,:,:,:) + u
                    vB(0,:,:,:) = vB(0,:,:,:) + v
        
                    num_type(0) = num_type(0) + 1
                    delete([/file_u,file_v,u,v/])
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
                if ((ind_num1(0)+hr(i)).ge.0 .and. (ind_num1(0)+hr(i)).le.4391) then
                    file_u = addfile(path_uv+year+"/ERA5_z_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    file_v = addfile(path_uv+year+"/ERA5_w_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    u   = file_u->Z(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    v   = file_v->W(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    uB(1,:,:,:) = uB(1,:,:,:) + u
                    vB(1,:,:,:) = vB(1,:,:,:) + v
        
                    num_type(1) = num_type(1) + 1
                    delete([/file_u,file_v,u,v/])
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
                if ((ind_num1(0)+hr(i)).ge.0 .and. (ind_num1(0)+hr(i)).le.4391) then
                    file_u = addfile(path_uv+year+"/ERA5_z_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    file_v = addfile(path_uv+year+"/ERA5_w_"+year+sprinti("%2.2i",month(ind_num1(0)+hr(i)))+sprinti("%2.2i",day(ind_num1(0)+hr(i)))+".nc","r")
                    u   = file_u->Z(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    v   = file_v->W(hour(ind_num1(0)+hr(i)),{100:1000},{40:10},{85:135})
                    uB(2,:,:,:) = uB(2,:,:,:) + u
                    vB(2,:,:,:) = vB(2,:,:,:) + v
        
                    num_type(2) = num_type(2) + 1
                    delete([/file_u,file_v,u,v/])
                end if
            end if
            delete(ind_num1)
        end do
    end if
    delete(ind1)
end do
end do

print(num_type)
do i =0,2
    if (num_type(i).ne.0) then
        uB(i,:,:,:) = uB(i,:,:,:)/(tofloat(num_type(i))/9.0)
        vB(i,:,:,:) = vB(i,:,:,:)/(tofloat(num_type(i))/9.0)
    end if
end do 

uB!1 = "level"
uB&level = lev
uB!2 = "latitude" 
uB&latitude = lat 
uB!3 = "longitude" 
uB&longitude = lon 
copy_VarCoords(uB, vB)
fnameout1 = "composite_Com_ZW_NSCS_type_event_befor9h.nc"
system("rm -f " + fnameout1)
setfileoption("nc","Format","NetCDF4");
fout=addfile(filedir + fnameout1, "c")
fout->zB = uB
fout->wB = vB
fout->num_type = num_type


end