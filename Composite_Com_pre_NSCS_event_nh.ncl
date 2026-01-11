begin
pathpre = "/sky3/lq_shared/IMERG_V7B/"
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
wsB = new((/3,nlev,nlat,nlon/),"float")
uB = 0.0
vB = 0.0
wsB = 0.0

pathatt = "/sky3/lq_shared/IMERG_V7B/2015/"
fileatt = addfile(pathatt+"IMERG_201504111730.nc", "r")
lat1 = fileatt->lat({10:40})
lon1 = fileatt->lon({85:135})
nlat1 = dimsizes(lat1)
nlon1 = dimsizes(lon1)
preB = new((/3,nlat1,nlon1/),"float")
preB1 = new((/3,nlat1,nlon1/),"float")
preB = 0.0 
preB1 = 0.0

num_type = new((/3/),"integer")
num_type = 0
num_type1 = new((/3/),"integer")
num_type1 = 0
hr1 = new((/9/),"integer")
hr1 = (/0,1,2,3,4,5,6,7,8/)

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
                if ((ind_num1(0)+hr1(i)).ge.0 .and. (ind_num1(0)+hr1(i)).le.4391) then
                    filepre11 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"00.nc","r")
                    filepre22 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"30.nc","r")
                    pre11 = transpose(filepre11->precipitation(0,{85:135},{10:40}))
                    pre22 = transpose(filepre22->precipitation(0,{85:135},{10:40}))
                    preB1(0,:,:) = preB1(0,:,:)+(pre11+pre22)/2.

                    num_type1(0) = num_type1(0) + 1
                    delete([/filepre11,filepre22,pre11,pre22/])
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
                    filepre11 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"00.nc","r")
                    filepre22 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"30.nc","r")
                    pre11 = transpose(filepre11->precipitation(0,{85:135},{10:40}))
                    pre22 = transpose(filepre22->precipitation(0,{85:135},{10:40}))
                    preB1(1,:,:) = preB1(1,:,:)+(pre11+pre22)/2.
        
                    num_type1(1) = num_type1(1) + 1
                    delete([/filepre11,filepre22,pre11,pre22/])
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
                    filepre11 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"00.nc","r")
                    filepre22 = addfile(pathpre+year+"/IMERG_"+year+sprinti("%2.2i",month(ind_num1(0)+hr1(i)))+sprinti("%2.2i",day(ind_num1(0)+hr1(i)))+sprinti("%2.2i",hour(ind_num1(0)+hr1(i)))+"30.nc","r")
                    pre11 = transpose(filepre11->precipitation(0,{85:135},{10:40}))
                    pre22 = transpose(filepre22->precipitation(0,{85:135},{10:40}))
                    preB1(2,:,:) = preB1(2,:,:)+(pre11+pre22)/2.
        
                    num_type1(2) = num_type1(2) + 1
                    delete([/filepre11,filepre22,pre11,pre22/])
                end if
            end if
            delete(ind_num1)
        end do
    end if
    delete(ind1)
end do

end do

print(num_type1)
do i =0,2
    if (num_type1(i).ne.0) then
        preB1(i,:,:) = preB1(i,:,:)/(tofloat(num_type1(i))/9.0)
    end if
end do 

preB1!1 = "latitude"
preB1&latitude = lat1 
preB1!2 = "longitude" 
preB1&longitude = lon1

fnameout3 = "composite_Com_pre_NSCS_type_event_after9h.nc"
system("rm -f " + fnameout3)
setfileoption("nc","Format","NetCDF4");
fout2=addfile(filedir + fnameout3, "c")
fout2->preB = preB1
fout2->num_type = num_type1

end