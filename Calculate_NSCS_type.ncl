load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
begin
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"

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

ny = 23
nhour = 4392
type = new((/ny,nhour/), "integer")
type = -999
year = new((/ny/),"integer")
year = ispan(2001,2023,1)

track_cma = readAsciiTable(filedir+"CHBST_SouthChina.txt", 6, "float", 0)
YYYY1 = tointeger(track_cma(:,0))
MM1 = tointeger(track_cma(:,1)) 
DD1 = tointeger(track_cma(:,2))
HH1 = tointeger(track_cma(:,3))

do yr = 2001,2023
    iyear = yr-2001 
    filename1 = "DLLJs_NSCS_950hPa_"+yr+".txt"
    data1 = readAsciiTable(filedir+filename1, 4392, "float", 0)
    ;printVarSummary(data1)
    data1!0 = "latitude"
    data1&latitude = lat 
    data1!1 = "time"
    data1&time = time 
    filename2 = "DLLJs_NSCS_750hPa_"+yr+".txt"
    data2 = readAsciiTable(filedir+filename2, 4392, "float", 0)
    ;printVarSummary(data2)
    data2!0 = "latitude"
    data2&latitude = lat 
    data2!1 = "time"
    data2&time = time 
    ;printVarSummary(data2)

    filename3 = "ws_NSCS_950hPa_"+yr+".txt"
    ws1 = readAsciiTable(filedir+filename3, 4392, "float", 0)
    ;printVarSummary(ws1)
    ws1!0 = "latitude"
    ws1&latitude = lat 
    ws1!1 = "time"
    ws1&time = time 
    filename4 = "ws_NSCS_750hPa_"+yr+".txt"
    ws2 = readAsciiTable(filedir+filename4, 4392, "float", 0)
    ;printVarSummary(ws2)
    ws2!0 = "latitude"
    ws2&latitude = lat 
    ws2!1 = "time"
    ws2&time = time 
    ;printVarSummary(ws2)
    data01 = data1({18:30},:)
    data02 = data2({18:30},:)
    data00 = data1({18:24},:)
    ws01   = ws1({18:30},:)
    ws02   = ws2({18:30},:)
    ws00   = ws1({18:24},:)
    lat0   = data01&latitude
    lat00  = data00&latitude

    do mon = 4,9
        tt = days_in_month(yr,mon)
        print("---year---")
        print(yr)
        print("---mon---")
        print(mon)
        do day = 1,tt;tt
            ind_TC = ind((YYYY1.eq.yr).and.(MM1.eq.mon).and.(DD1.eq.day))
            if (.not.all(ismissing(ind_TC))) then
                delete(ind_TC)
                continue
            end if
            delete(ind_TC)

            do ih = 0,23
                if (mon.eq.4) then
                    i = (day-1)*24 + ih
                end if
                if (mon.eq.5) then
                    i = 30*24 + (day-1)*24 + ih
                end if
                if (mon.eq.6) then
                    i = (30+31)*24 + (day-1)*24 + ih
                end if
                if (mon.eq.7) then
                    i = (30+31+30)*24 + (day-1)*24 + ih
                end if
                if (mon.eq.8) then
                    i = (30+31+30+31)*24 + (day-1)*24 + ih
                end if
                if (mon.eq.9) then
                    i = (30+31+30+31+31)*24 + (day-1)*24 + ih
                end if

                BLJ_gt_50   = ind(data00(:,i).ge.50)
                BLJ_gt_15   = ind(data00(:,i).ge.15)
                SLLJ_gt_15  = ind(data02(:,i).ge.15)
                ;SLLJ_eq_Max = ind(data02(:,i).eq.max(data02(:,i)))
                SLLJ_eq_Max = ind(data02(:,i).ge.50)
                index_YY = .not.all(ismissing(BLJ_gt_50))
                index_Y1 = .not.all(ismissing(BLJ_gt_15))
                index_Y2 = .not.all(ismissing(SLLJ_gt_15))
                index_Y3 = .not.all(ismissing(SLLJ_eq_Max))

                wsB_gt_10_0 = ind(ws00(:,i).ge.10)
                wsB_gt_10   = ind(ws00(:,i).ge.10)
                wsS_gt_10   = ind(ws02(:,i).ge.10)
                ;wsS_eq_Max = ind(ws02(:,i).eq.max(ws02(:,i)))
                wsS_eq_Max = ind(ws02(:,i).ge.12)
                index_HH = .not.all(ismissing(wsB_gt_10_0))
                index_H1 = .not.all(ismissing(wsB_gt_10))
                index_H2 = .not.all(ismissing(wsS_gt_10))
                index_H3 = .not.all(ismissing(wsS_eq_Max))

                if (index_YY.and.index_Y1.and.index_Y2.and.index_Y3.and.index_HH.and.index_H1.and.index_H2.and.index_H3) then
                    BLJ_North_Boudary = lat00(max(BLJ_gt_15))
                    SLLJ_South_Boudary = lat0(min(SLLJ_gt_15))
                    SLLJ_Max = lat0(tointeger(dim_avg(SLLJ_eq_Max)))
                    ;SLLJ_Max = lat0(max(SLLJ_eq_Max))
                    deta_Y0 = SLLJ_South_Boudary - BLJ_North_Boudary
                    deta_Y1 = SLLJ_Max - BLJ_North_Boudary

                    wsB_North_Boudary = lat00(max(wsB_gt_10))
                    wsS_South_Boudary = lat0(min(wsS_gt_10))
                    wsS_Max = lat0(tointeger(dim_avg(wsS_eq_Max)))
                    ;wsS_Max = lat0(max(wsS_eq_Max))
                    deta_H0 = wsS_South_Boudary - wsB_North_Boudary
                    deta_H1 = wsS_Max - wsB_North_Boudary
                    ;print("-------------")
                    ;print(deta_Y0)
                    ;print(deta_Y1)
                    ;print(deta_H0)
                    ;print(deta_H1)
                    ;print("---------------")

                    if (deta_Y0.gt.0 .and. deta_H0.gt.0) then
                        type(iyear,i) = 1
                    end if

                    if (deta_Y0.le.0 .and. deta_H0.le.0 .and. deta_Y1.ge.0 .and. deta_H1.ge.0) then
                        type(iyear,i) = 2
                    end if

                    if (deta_Y0.le.0 .and. deta_H0.le.0 .and. deta_Y1.lt.0 .and. deta_H1.lt.0) then
                        type(iyear,i) = 3
                    end if
                    delete([/BLJ_North_Boudary,SLLJ_South_Boudary,SLLJ_Max,deta_Y0,deta_Y1/])
                    delete([/wsB_North_Boudary,wsS_South_Boudary,wsS_Max,deta_H0,deta_H1/])
                    ;print(type(iyear,i))
                    ;print("----------------")
                end if
                delete([/BLJ_gt_50,BLJ_gt_15,SLLJ_gt_15,SLLJ_eq_Max,index_YY,index_Y1,index_Y2,index_Y3/])
                delete([/wsB_gt_10_0,wsB_gt_10,wsS_gt_10,wsS_eq_Max,index_HH,index_H1,index_H2,index_H3/])
            end do
        end do
    end do
    delete([/data1,data2,ws1,ws2/])
end do

type!0 = "year"
type&year = year 
type!1 = "time"
type&time = time 
fnameout1 = "Calculate_NSCS_type.nc"
system("rm -f " + fnameout1)
setfileoption("nc","Format","NetCDF4");
fout=addfile(filedir+fnameout1, "c")
fout->type = type





end 