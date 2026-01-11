program Dfre_DLLJs_traits
implicit none
!lon=249 73-135E
!lat=213 53N-0
character(len=299)::fileout1,fileout2,fileout3,fileout4,fileout5,fileout6,fileout7,fileout8
integer DLLJ1(19,101,24),DLLJ2(27,101,24),SLLJ1(19,101,24),SLLJ2(27,101,24),BLJ1(19,101,24),BLJ2(27,101,24)
real(kind=8)::lata(101),lona1(19),lona2(27),leva(23)
real u1(19,101,2,24),u2(27,101,2,24),v1(19,101,2,24),v2(27,101,2,24),ws1(19,101,2,24),ws2(27,101,2,24)
real DLLJs_B(2,101,4392),ws_B(2,101,4392),DLLJs_N(2,101,4392),ws_N(2,101,4392)  
character(len=4)::yc
character(len=2)::monc,dayc
integer y,mon,day,imon
integer t,lon,lat,num_s,m,it,i
integer::time(4392),region(2)

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'

call ra(leva,lata,lona1,lona2)
print *, "lat", lata(1)
print *, "lon1", lona1(1)
print *, "lon2", lona2(1)
print *, "lev", leva(23)
do m = 1, 4392
    time(m) = m
end do
region(1) = 1
region(2) = 2

do y=2022,2023
  write(yc,"(i4)")y
  DLLJs_B = 0.0
  DLLJs_N = 0.0
  ws_B    = 0.0
  ws_N    = 0.0
  fileout1='/sky7/zhouchling/data/DLLJ_SouthChina1/DLLJs_Beibu_950hPa_'//yc//'.txt'
  fileout2='/sky7/zhouchling/data/DLLJ_SouthChina1/DLLJs_Beibu_750hPa_'//yc//'.txt'
  fileout3='/sky7/zhouchling/data/DLLJ_SouthChina1/DLLJs_NSCS_950hPa_'//yc//'.txt'
  fileout4='/sky7/zhouchling/data/DLLJ_SouthChina1/DLLJs_NSCS_750hPa_'//yc//'.txt'
  fileout5='/sky7/zhouchling/data/DLLJ_SouthChina1/ws_Beibu_950hPa_'//yc//'.txt'
  fileout6='/sky7/zhouchling/data/DLLJ_SouthChina1/ws_Beibu_750hPa_'//yc//'.txt'
  fileout7='/sky7/zhouchling/data/DLLJ_SouthChina1/ws_NSCS_950hPa_'//yc//'.txt'
  fileout8='/sky7/zhouchling/data/DLLJ_SouthChina1/ws_NSCS_750hPa_'//yc//'.txt'
  open(10, file=fileout1, status='new', action='write') ! 打开文件进行写操作 
  open(20, file=fileout2, status='new', action='write')
  open(30, file=fileout3, status='new', action='write') ! 打开文件进行写操作 
  open(40, file=fileout4, status='new', action='write')
  open(50, file=fileout5, status='new', action='write') ! 打开文件进行写操作 
  open(60, file=fileout6, status='new', action='write')
  open(70, file=fileout7, status='new', action='write') ! 打开文件进行写操作 
  open(80, file=fileout8, status='new', action='write')
	do mon=4,9!12月
    imon = mon-3
	  write(monc,"(i2.2)")mon !将y,mon转换成字符型，以便于构建文件名
	  call daysinmonth(y,mon,t)
    !write(*,*) t
 	  do day=1,t!t天
		  write(*,*)day
 		  write(dayc,"(i2.2)")day
      call readLLJ(yc,monc,dayc,DLLJ1,SLLJ1,BLJ1,DLLJ2,SLLJ2,BLJ2)
      call us(y,yc,monc,dayc,u1,u2)
      call vs(y,yc,monc,dayc,v1,v2)
      ws1(:,:,:,:) = sqrt(u1(:,:,:,:)**2+v1(:,:,:,:)**2)
      ws2(:,:,:,:) = sqrt(u2(:,:,:,:)**2+v2(:,:,:,:)**2)

      if (mon.eq.4) then
        it = (day-1)*24 + 1
      end if
      if (mon.eq.5) then
        it = 30*24 + (day-1)*24 + 1
      end if
      if (mon.eq.6) then
        it = (30+31)*24 + (day-1)*24 + 1
      end if
      if (mon.eq.7) then
        it = (30+31+30)*24 + (day-1)*24 + 1
      end if
      if (mon.eq.8) then
        it = (30+31+30+31)*24 + (day-1)*24 + 1
      end if
      if (mon.eq.9) then
        it = (30+31+30+31+31)*24 + (day-1)*24 + 1
      end if

      call Calculate_latWind_LLJGrid1(19,101,u1,v1,ws1,DLLJ1,BLJ1,SLLJ1,DLLJs_B(:,:,it:it+23),ws_B(:,:,it:it+23))
      call Calculate_latWind_LLJGrid2(27,101,u2,v2,ws2,DLLJ2,BLJ2,SLLJ2,DLLJs_N(:,:,it:it+23),ws_N(:,:,it:it+23))
    end do
  end do
  do i = 1, 101
    write(10,*) DLLJs_B(1,i,:) 
    write(20,*) DLLJs_B(2,i,:) 
    write(30,*) DLLJs_N(1,i,:) 
    write(40,*) DLLJs_N(2,i,:) 
    write(50,*) ws_B(1,i,:) 
    write(60,*) ws_B(2,i,:) 
    write(70,*) ws_N(1,i,:) 
    write(80,*) ws_N(2,i,:) 
  enddo
  close(10) 
  close(20)
  close(30) 
  close(40)
  close(50) 
  close(60)
  close(70) 
  close(80)
end do
end program

!读lev,lat,lon)
subroutine ra(lev,lat,lon1,lon2)
implicit none
character(len=299)::fu
integer::ncid,status,levid,latid,lonid,lenlev,lenlat,lenlon,county(1),starty(1)
integer::levvid,latvid,lonvid
real(kind=8)::lev(23),lat(101),lon1(19),lon2(27),lata(721),lona(1440),leva(37)

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fu='/sky6/lbz-share/ERA5/2022/ERA5_u_20220701.nc'

!open the nc
status=nf_open(fu,nf_nowrite,ncid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"open att nc"

starty(1)=1
status=nf_inq_dimid(ncid,'level',levvid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimid levvid"
status=nf_inq_dimlen(ncid,levvid,lenlev)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimlen lenlev"
county(1)=37
status=nf_inq_varid(ncid,'level',levid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq varid levid"
status=nf_get_vara_double(ncid,levid,starty,county,leva)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"get vara lev"
lev(:) = leva(37:15:-1)

starty(1)=1
!read latitude
status=nf_inq_dimid(ncid,'latitude',latvid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimid latvid"
status=nf_inq_dimlen(ncid,latvid,lenlat)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimlen lenlat"
county(1)=lenlat
status=nf_inq_varid(ncid,'latitude',latid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq varid latid"
status=nf_get_vara_double(ncid,latid,starty,county,lata)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"get vara lat"
lat(:)=lata(221:321)
!status=nf_inq_att(ncidr,latid,"units",xtype,len)
!write(*,*)xtype,len
!if(status/=nf_noerr) write(*,*)nf_strerror(status)

!read longitude
status=nf_inq_dimid(ncid,'longitude',lonvid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimid lonvid"
status=nf_inq_dimlen(ncid,lonvid,lenlon)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq dimlen lenlon"
county(1)=lenlon
status=nf_inq_varid(ncid,'longitude',lonid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"inq varid lonid"
status=nf_get_vara_double(ncid,lonid,starty,county,lona)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"get vara lon"
lon1(:)=lona(425:443)
lon2(:)=lona(443:469)
status=nf_close(ncid)
end subroutine

!计算每个月的天数
subroutine daysinmonth(y,mon,t)
implicit none
integer(kind=2)::y,mon
integer::t
if(mon.eq.1.or.mon.eq.3.or.mon.eq.5.or.mon.eq.7.or.mon.eq.8.or.mon.eq.10.or.mon.eq.12)then
	t=31
else if(mon.eq.4.or.mon.eq.6.or.mon.eq.9.or.mon.eq.11)then
	t=30
end if
if (mon.eq.2) then
	if (mod(y,4).eq.0.and.mod(y,100).ne.0) then
	    t=29
	elseif(mod(y,400).eq.0)then
	    t=29
	else
	    t=28
	endif
endif
return
end subroutine

!读取LLJs
subroutine readLLJ(yc,monc,dayc,DLLJ1,SLLJ1,BLJ1,DLLJ2,SLLJ2,BLJ2)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fu
integer::SLLJa(249,213,24),BLJa(249,213,24),DLLJa(249,213,24)
integer::SLLJ1(19,101,24),BLJ1(19,101,24),DLLJ1(19,101,24)
integer::SLLJ2(27,101,24),BLJ2(27,101,24),DLLJ2(27,101,24)
integer::startx(3),countx(3)
integer::ncid,status,Did,Bid,Sid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fu='/sky7/zhouchling/data/llj/china/'//yc//'/china_llj_'//yc//monc//dayc//'.nc'

!write(*,*)fu
status=nf_open(fu,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)

data startx /1,1,1/
data countx /249,213,24/
status=nf_inq_varid(ncid,'Dllj',Did)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_get_vara_int(ncid,Did,startx,countx,DLLJa)

status=nf_inq_varid(ncid,'Sllj',Sid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_get_vara_int(ncid,Sid,startx,countx,SLLJa)

status=nf_inq_varid(ncid,'Blj',Bid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_get_vara_int(ncid,Bid,startx,countx,BLJa)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)

DLLJ1(:,:,:) = DLLJa(133:151,73:173,:) 
SLLJ1(:,:,:) = SLLJa(133:151,73:173,:) 
BLJ1(:,:,:)  = BLJa(133:151,73:173,:) 
DLLJ2(:,:,:) = DLLJa(151:177,73:173,:) 
SLLJ2(:,:,:) = SLLJa(151:177,73:173,:) 
BLJ2(:,:,:)  = BLJa(151:177,73:173,:) 
status=nf_close(ncid)
end subroutine

!读取u
subroutine us(y,yc,monc,dayc,u1,u2)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fu
integer::y
real::u1(19,101,2,24),u2(27,101,2,24),ua(1440,721,37,24)
integer::startx(4),countx(4)
integer::ncid,status,uid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
if (y.ge.2007) then
	fu='/sky6/lbz-share/ERA5/'//yc//'/ERA5_u_'//yc//monc//dayc//'.nc'
else
	fu='/sky7/lbz_share/ERA5/'//yc//'/ERA5_u_'//yc//monc//dayc//'.nc'
endif
!write(*,*)fu
status=nf_open(fu,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'U',uid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1,1/
data countx /1440,721,37,24/
status=nf_get_vara_real(ncid,uid,startx,countx,ua)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)

u1(:,:,1,:) = ua(425:443,221:321,34,:) !925hPa
u1(:,:,2,:) = ua(425:443,221:321,27,:) !750hPa
u2(:,:,1,:) = ua(443:469,221:321,34,:) !925hPa
u2(:,:,2,:) = ua(443:469,221:321,27,:) !750hPa
write(*,*)"U1",u1(1,1,1:2,3)
status=nf_close(ncid)
end subroutine

!读取v
subroutine vs(y,yc,monc,dayc,v1,v2)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fv
real::v1(19,101,2,24),v2(27,101,2,24),va(1440,721,37,24)
integer::startx(4),countx(4)
integer::ncid,status,vid
integer::y

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
if (y.ge.2007) then
	fv='/sky6/lbz-share/ERA5/'//yc//'/ERA5_v_'//yc//monc//dayc//'.nc'
endif
if (y.le.2006) then
	fv='/sky7/lbz_share/ERA5/'//yc//'/ERA5_v_'//yc//monc//dayc//'.nc'
endif
!write(*,*)fu
status=nf_open(fv,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'V',vid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1,1/
data countx /1440,721,37,24/
status=nf_get_vara_real(ncid,vid,startx,countx,va)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)
v1(:,:,1,:) = va(425:443,221:321,34,:) !925hPa
v1(:,:,2,:) = va(425:443,221:321,27,:) !750hPa
v2(:,:,1,:) = va(443:469,221:321,34,:) !925hPa
v2(:,:,2,:) = va(443:469,221:321,27,:) !750hPa
write(*,*)"V1",v1(1,1,1:2,3)
status=nf_close(ncid)
end subroutine

subroutine Calculate_latWind_LLJGrid1(nlon,nlat,u,v,ws,DLLJ1,BLJ1,SLLJ1,DLLJs_B,ws_B)
implicit none
integer nlon,nlat
real u(19,101,2,24),v(19,101,2,24),ws(19,101,2,24),DLLJs_B(2,101,24),ws_B(2,101,24)
real ws0(2)
integer DLLJ1(19,101,24),SLLJ1(19,101,24),BLJ1(19,101,24)
integer i,j,n,nB,nS

do n =1,24
  do j = 1,nlat
    nB = 0
    nS = 0
    ws0 = 0.0
    do i =1,nlon
      if((DLLJ1(i,j,n).eq.1 .or. BLJ1(i,j,n).eq.1).and.(v(i,j,1,n).gt.0)) then
        nB = nB + 1
      end if
      if((DLLJ1(i,j,n).eq.1 .or. SLLJ1(i,j,n).eq.1).and.(v(i,j,2,n).gt.0).and.(u(i,j,2,n).gt.0)) then
        nS = nS + 1
      end if
      ws0 = ws0 + ws(i,j,:,n)
    end do 
    DLLJs_B(1,j,n) = real(nB)/real(nlon)*100
    DLLJs_B(2,j,n) = real(nS)/real(nlon)*100
    ws_B(:,j,n)    = ws0/real(nlon)
    print *,"nB",nB,"nS",nS,"ws0",ws0
    print *,"DLLJs_B",DLLJs_B(:,j,n),"ws_B",ws_B(:,j,n)
  end do
end do
end subroutine

subroutine Calculate_latWind_LLJGrid2(nlon,nlat,u,v,ws,DLLJ2,BLJ2,SLLJ2,DLLJs_N,ws_N)
implicit none
integer nlon,nlat
real u(27,101,2,24),v(27,101,2,24),ws(27,101,2,24),DLLJs_N(2,101,24),ws_N(2,101,24)
real ws0(2)
integer DLLJ2(27,101,24),SLLJ2(27,101,24),BLJ2(27,101,24)
integer i,j,n,nB,nS

do n =1,24
  do j = 1,nlat
    nB = 0
    nS = 0
    ws0 = 0.0
    do i =1,nlon
      if((DLLJ2(i,j,n).eq.1 .or. BLJ2(i,j,n).eq.1).and.(v(i,j,1,n).gt.0)) then
        nB = nB + 1
      end if
      if((DLLJ2(i,j,n).eq.1 .or. SLLJ2(i,j,n).eq.1).and.(v(i,j,2,n).gt.0).and.(u(i,j,2,n).gt.0)) then
        nS = nS + 1
      end if
      ws0 = ws0 + ws(i,j,:,n)
    end do 
    DLLJs_N(1,j,n) = real(nB)/real(nlon)*100
    DLLJs_N(2,j,n) = real(nS)/real(nlon)*100
    ws_N(:,j,n)    = ws0/real(nlon)
    print *,"nB",nB,"nS",nS,"ws0",ws0
    print *,"DLLJs_N",DLLJs_N(:,j,n),"ws_N",ws_N(:,j,n)
  end do
end do
end subroutine
