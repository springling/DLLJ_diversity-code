!筛选出中国范围的DLLJ,BLJ,SLLJ分别存放于Dllj,Blj,Sllj(249,213,23,24),(lon,lat,level,hour)
!计算全年每月DLLJ,BLJ,SLLJ的发生次数，存放于Dfre,Bfre,Sfre(249,213,23,12),(lon,lat,level,mon)
program china_jets 
implicit none
!lon=249
!lat=213
integer::Dllj(249,213,23,24),Blj(249,213,23,24),Sllj(249,213,23,24),Dfre(249,213,23,12),Bfre(249,213,23,12),Sfre(249,213,23,12)
real::spd(249,213,23,24),u(249,213,23,24),v(249,213,23,24),z(249,213,23,24)
real::sp(249,213,744),zsf(249,213),hsf(249,213)
real::wind(23),hei(23)
character(len=4)::yc
character(len=2)::dayc,monc
integer(kind=2)::day,y,mon
integer::i,j,k,kk,n,t,nk,mk,ih,hh,nhour,m,bk,sk
real(kind=8)::lev(23),lat(213),lon(249)
integer::time1(24),time2(12)

do m = 1, 24
    time1(m) = m
end do
do m = 1, 12
    time2(m) = m
end do
!write(*,*)"time",time(1:24)
!read data of level, latitude,longitude
call ra(lev,lat,lon)	
call topo(zsf)
hsf = zsf/9.8
!write(*,*)"hsf",hsf(461,273)
Dfre(1:249,1:213,1:23,1:12)=0
Sfre(1:249,1:213,1:23,1:12)=0
Bfre(1:249,1:213,1:23,1:12)=0
!write(*,*)"Bfre",Bfre(425:461,240:273)
do y=2023,2023 !更改年份 
	do mon=1,12!12月
		write(yc,"(i4)")y
		write(monc,"(i2.2)")mon !将y,mon转换成字符型，以便于构建文件名
		call daysinmonth(y,mon,t)

 		do day=1,t!t天
			write(*,*)day
 			write(dayc,"(i2.2)")day

 			call us(yc,monc,dayc,u)  !read data
 			call vs(yc,monc,dayc,v)
            call zs(yc,monc,dayc,z)
            call sps(yc,monc,sp)

 			spd(1:249,1:213,1:23,1:24)=sqrt(u**2+v**2)   !calculate spd!
			!!standards!
            Sllj(1:249,1:213,1:23,1:24)=0	
            Dllj(1:249,1:213,1:23,1:24)=0
            Blj(1:249,1:213,1:23,1:24)=0
            
 			loop_n: do n=1,24 !for a day
				write(*,*)n
                nhour = 24*(day-1)+n
  				loop_j: do j=1,213  !for all grids
   					loop_i: do i=1,249
                        if (hsf(i,j).gt.3000.0) then
                            !write(*,*)"hsf",hsf(i,j)
                            cycle loop_i
                        end if
                        nk = 1 !计算地形以上的第一层索引nk
                        loop_ih: do ih=1,23
                            if (z(i,j,ih,n).lt.zsf(i,j)) then
                                nk = nk+1
                            else
                                mk = nk !计算地表以上400hPa的索引mk
                                loop_hh: do hh = nk+1,23
                                    if (lev(hh).gt.(lev(nk)-400)) then
                                        mk = mk+1
                                    end if
                                end do loop_hh
                            end if
                        end do loop_ih
                        wind(:)=spd(i,j,:,n)
                        !write(*,*)"nk","mk",nk,mk
                        !write(*,*)"hsf",hsf(i,j)
                        !筛选满足条件的llj
                        bk = 23!用于记录Blj所在高度
                        sk = 23!用于记录Sllj所在高度
                        loop_k: do k = nk,mk-1
                            if ((wind(k).ge.10.).and.(wind(k).ge.wind(k+1))) then
                            if (((k.eq.nk)).or.((k.ne.nk).and.(wind(k).ge.wind(k-1)))) then
                                loop_kk: do kk = k+1,mk 
                                    if ((kk.eq.mk).or.((kk.ne.mk).and.(wind(kk+1).ge.wind(kk)))) then
                                        if ((wind(k)-wind(kk)).ge.2.5) then
                                            if (((sp(i,j,nhour)-lev(k)).lt.100.).and.(wind(k).ge.10.)) then
                                                Blj(i,j,k,n) = 1
                                                bk = k
                                                exit loop_kk
                                            end if
                                            if (((sp(i,j,nhour)-lev(k)).gt.100.).and.(wind(k).ge.10.))then
                                                Sllj(i,j,k,n) = 1
                                                sk = k
                                                exit loop_kk
                                            end if
                                        end if
                                        if ((wind(k)-wind(kk)).lt.2.5) then
                                            exit loop_kk
                                        end if
                                    end if
                                end do loop_kk
                            end if
                            end if
                        end do loop_k
                        !计算Sllj,Blj,Dllj的发生次数
                        
                        if ((Sllj(i,j,sk,n).eq.1).and.(Blj(i,j,bk,n).eq.1)) then
                            Dllj(i,j,sk,n)=1
                            Dllj(i,j,bk,n)=1
                            Blj(i,j,bk,n) =0
                            Sllj(i,j,sk,n)=0
                            Dfre(i,j,sk,mon) = Dfre(i,j,sk,mon)+1
                            Dfre(i,j,bk,mon) = Dfre(i,j,bk,mon)+1
                        end if
                        if ((Sllj(i,j,sk,n).eq.1).and.(Blj(i,j,bk,n).eq.0)) then
                            Sfre(i,j,sk,mon) = Sfre(i,j,sk,mon)+1
                        end if
                        if ((Blj(i,j,bk,n).eq.1).and.(Sllj(i,j,sk,n).eq.0)) then
                            Bfre(i,j,bk,mon) = Bfre(i,j,bk,mon)+1
                        end if
   					end do loop_i!!i
  				end do loop_j!!j
 			end do loop_n!!n
            !print ft->nc.not transpose!
            !write(*,*)"Sllj",Sllj(450:455,250:255,1)
		    call ncllj(yc,monc,dayc,lat,lon,lev,time1,Blj,Sllj,Dllj)
		end do !!day
	end do !!mon
end do !!year
!write(*,*)"Sfre",Sfre(450:455,250:255)
call ncfre(lat,lon,lev,time2,Bfre,Sfre,Dfre)
end program

!读lev,lat,lon)
subroutine ra(lev,lat,lon)
implicit none
character(len=299)::fu
integer::ncid,status,levid,latid,lonid,lenlev,lenlat,lenlon,county(1),starty(1)
integer::levvid,latvid,lonvid
real(kind=8)::lev(23),lat(213),lon(249),lata(721),lona(1440),leva(37)

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
write(*,*)"lev",lev(1)

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
lat(:)=lata(149:361)
!status=nf_inq_att(ncidr,latid,"units",xtype,len)
!write(*,*)xtype,len
!if(status/=nf_noerr) write(*,*)nf_strerror(status)
write(*,*)"lat",lat(1)

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
lon(:)=lona(293:541)
write(*,*)"lon",lon(1)

status=nf_close(ncid)
end subroutine

!读取地表位势
subroutine topo(zsf)
implicit none
character(len=299)::fe
integer::ncid,status,topolevid
integer::nlat,nlon
real::zsfa(1440,721,1),zsf(249,213)
integer::startx(3),countx(3)
include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'

fe='/sky1/home/zhouchling/data/ERA5_topo.nc'
!open the nc
status=nf_open(fe,nf_nowrite,ncid)
if(status/=nf_noerr) write(*,*)nf_strerror(status),"open topolev"

status=nf_inq_varid(ncid,'Z',topolevid)
if(status/=nf_noerr)write(*,*)nf_strerror(status),"inq varid"
data startx /1,1,1/
data countx /1440,721,1/
status=nf_get_vara_real(ncid,topolevid,startx,countx,zsfa)
if(status/=nf_noerr)write(*,*)nf_strerror(status),"get vara elev"
zsf(:,:)=zsfa(293:541,149:361,1)
write(*,*)"zsf",zsf(1,1)
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
else if(mon.eq.2)then
	if(mod(y,4).eq.0)then
		if(mod(y,100).ne.0)then
			t=29
		else
			if(mod(y,400).eq.0)then
				t=29
			else
				t=28
			end if
		end if
	else if(mod(y,4).ne.0)then
		t=28
	end if
end if 
end subroutine

!读取u
subroutine us(yc,monc,dayc,u)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fu
real::u(249,213,23,24),ua(1440,721,37,24)
integer::startx(4),countx(4)
integer::ncid,status,uid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fu='/sky6/lbz-share/ERA5/'//yc//'/ERA5_u_'//yc//monc//dayc//'.nc'
!write(*,*)fu
status=nf_open(fu,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'U',uid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1,1/
data countx /1440,721,37,24/
status=nf_get_vara_real(ncid,uid,startx,countx,ua)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)
u(:,:,:,:) = ua(293:541,149:361,37:15:-1,:)
write(*,*)"U",u(1,1,5,3)
status=nf_close(ncid)
end subroutine

!读取v
subroutine vs(yc,monc,dayc,v)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fv
real::v(249,213,23,24),va(1440,721,37,24)
integer::startx(4),countx(4)
integer::ncid,status,vid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fv='/sky6/lbz-share/ERA5/'//yc//'/ERA5_v_'//yc//monc//dayc//'.nc'
!write(*,*)fu
status=nf_open(fv,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'V',vid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1,1/
data countx /1440,721,37,24/
status=nf_get_vara_real(ncid,vid,startx,countx,va)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)
v(:,:,:,:) = va(293:541,149:361,37:15:-1,:)
write(*,*)"V",v(1,1,5,3)
status=nf_close(ncid)
end subroutine

!读取z
subroutine zs(yc,monc,dayc,z)
implicit none
character(len=4)::yc
character(len=2)::dayc,monc
character(len=299)::fz
real::z(249,213,23,24),za(1440,721,37,24)
integer::startx(4),countx(4)
integer::ncid,status,zid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fz='/sky6/lbz-share/ERA5/'//yc//'/ERA5_z_'//yc//monc//dayc//'.nc'
!write(*,*)fu
status=nf_open(fz,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'Z',zid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1,1/
data countx /1440,721,37,24/
status=nf_get_vara_real(ncid,zid,startx,countx,za)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)
z(:,:,:,:) = za(293:541,149:361,37:15:-1,:)
write(*,*)"Z",z(1,1,5,3)
status=nf_close(ncid)
end subroutine

!读取sp
subroutine sps(yc,monc,sp)
implicit none
character(len=4)::yc
character(len=2)::monc
character(len=299)::fsp
real::sp(249,213,744),spa(1440,721,744)
integer::startx(3),countx(3)
integer::ncid,status,spid

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'
fsp='/sky6/lbz-share/ERA5/surface/ERA5_sp_'//yc//monc//'.nc'
!write(*,*)fu
status=nf_open(fsp,nf_nowrite,ncid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
status=nf_inq_varid(ncid,'SP',spid)
if(status/=nf_noerr)write(*,*)nf_strerror(status)
data startx /1,1,1/
data countx /1440,721,744/
status=nf_get_vara_real(ncid,spid,startx,countx,spa)
!if(status/=nf_noerr)write(*,*)nf_strerror(status)
sp(:,:,:) = spa(293:541,149:361,:)
sp = sp/100 !转为hPa
write(*,*)"sp",sp(1,1,3)
status=nf_close(ncid)
end subroutine


subroutine ncllj(yc,monc,dayc,lat,lon,lev,time,Blj,Sllj,Dllj)
character(len=299)::fileout
character(len=4)::yc
character(len=2)::monc,dayc
integer::status,ncid,lonid,latid,levid,timid,latvid,lonvid,levvid,timvid,Slljid,Bljid,Dlljid
integer::nlat=213,nlon=249,ntime=24,nlev=23
character(len=13)::unitlat
character(len=20)::unitlev
character(len=12)::unitlon
character(len=8)::unittim
integer::dimids(4)
real(kind=8)::lat(213),lon(249),lev(23)
integer::time(24)
integer::Blj(249,213,23,24),Sllj(249,213,23,24),Dllj(249,213,23,24)
include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'

fileout='/sky7/zhouchling/data/lljs/china/'//yc//'/china_lljs_'//yc//monc//dayc//'.nc'

status=nf_create(fileout,nf_clobber,ncid)
if(status/=nf_noerr) write(*,*)"create_nc",nf_strerror(status)

status=nf_def_dim(ncid, 'time',ntime,timid)
if(status/=nf_noerr) write(*,*)"def_dimtim",nf_strerror(status)

status=nf_def_dim(ncid, 'level',nlev,levid)
if(status/=nf_noerr) write(*,*)"def_dimlev",nf_strerror(status)

status=nf_def_dim(ncid, 'latitude',nlat,latid)
if(status/=nf_noerr) write(*,*)"def_dimlat",nf_strerror(status)

status=nf_def_dim(ncid, 'longitude',nlon,lonid)
if(status/=nf_noerr) write(*,*)"def_dimlon",nf_strerror(status)

write(*,*)"def_var"

!levid,latid,lonid::dimension id
!levvid,latvid,lonvid::var id

status=nf_def_var(ncid,'time',nf_int,1,timid,timvid)
if(status/=nf_noerr) write(*,*)"def_tim",nf_strerror(status)
unittim="24 hours"
status=nf_put_att(ncid,timvid,'units',nf_char,8,unittim)
if(status/=nf_noerr) write(*,*)"timatt",nf_strerror(status)

status=nf_def_var(ncid,'level',nf_double,1,levid,levvid)
if(status/=nf_noerr) write(*,*)"def_lev",nf_strerror(status)
unitlev="from_200_to_1000_hPa"
status=nf_put_att(ncid,levvid,'units',nf_char,20,unitlev)
if(status/=nf_noerr) write(*,*)"levatt",nf_strerror(status)

status=nf_def_var(ncid, "latitude",nf_double,1,latid,latvid)
if(status/=nf_noerr) write(*,*)"def_lat",nf_strerror(status)
unitlat="degrees_north"
status=nf_put_att(ncid,latvid,'units',nf_char,13,unitlat)
if(status/=nf_noerr) write(*,*)"latatt",nf_strerror(status)

status=nf_def_var(ncid, "longitude",nf_double,1,lonid,lonvid)
if(status/=nf_noerr) write(*,*)"def_lon",nf_strerror(status)
unitlon="degrees_east"
status=nf_put_att(ncid,lonvid,'units',nf_char,12,unitlon)
if(status/=nf_noerr) write(*,*)"lonatt",nf_strerror(status)

dimids=(/lonid,latid,levid,timid/)
write(*,*)dimids

status=nf_def_var(ncid, "Blj",nf_int,4,dimids,Bljid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_def_var(ncid, "Sllj",nf_int,4,dimids,Slljid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_def_var(ncid, "Dllj",nf_int,4,dimids,Dlljid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)
status=nf_enddef(ncid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_put_var(ncid,timvid,time)
status=nf_put_var(ncid,levvid,lev)
status=nf_put_var(ncid,latvid,lat)
status=nf_put_var(ncid,lonvid,lon)

status=nf_put_var(ncid,Bljid,Blj)
status=nf_put_var(ncid,Slljid,Sllj)
status=nf_put_var(ncid,Dlljid,Dllj)

status=nf_close(ncid)
write(*,*)"end_put_var"
end subroutine

subroutine ncfre(lat,lon,lev,time,Bfre,Sfre,Dfre)
character(len=299)::fileout
integer::status,ncid,lonid,latid,levid,timid,latvid,lonvid,levvid,timvid,Dfreid,Sfreid,Bfreid
integer::nlat=213,nlon=249,ntime=12,nlev=23
character(len=20)::unitlev
character(len=13)::unitlat
character(len=12)::unitlon
character(len=8)::unittim
integer::dimids(4)
integer::time(12)
real(kind=8)::lat(213),lon(249),lev(23)
integer::Bfre(249,213,23,12),Sfre(249,213,23,12),Dfre(249,213,23,12)

include '/sky7/chenzj/software/geos-chem-libraries/include/netcdf.inc'

fileout='/sky7/zhouchling/data/lljs/china_lljs_fre2023.nc'

status=nf_create(fileout,nf_clobber,ncid)
if(status/=nf_noerr) write(*,*)"create_nc",nf_strerror(status)

status=nf_def_dim(ncid, 'time',ntime,timid)
if(status/=nf_noerr) write(*,*)"def_dimtim",nf_strerror(status)

status=nf_def_dim(ncid, 'level',nlev,levid)
if(status/=nf_noerr) write(*,*)"def_dimlev",nf_strerror(status)

status=nf_def_dim(ncid, 'latitude',nlat,latid)
if(status/=nf_noerr) write(*,*)"def_dimlat",nf_strerror(status)

status=nf_def_dim(ncid, 'longitude',nlon,lonid)
if(status/=nf_noerr) write(*,*)"def_dimlon",nf_strerror(status)

write(*,*)"def_var"

!levid,latid,lonid::dimension id
!levvid,latvid,lonvid::var id
status=nf_def_var(ncid,'time',nf_int,1,timid,timvid)
if(status/=nf_noerr) write(*,*)"def_tim",nf_strerror(status)
unittim="12 month"
status=nf_put_att(ncid,timvid,'units',nf_char,8,unittim)
if(status/=nf_noerr) write(*,*)"timatt",nf_strerror(status)

status=nf_def_var(ncid,'level',nf_double,1,levid,levvid)
if(status/=nf_noerr) write(*,*)"def_lev",nf_strerror(status)
unitlev="from_200_to_1000_hPa"
status=nf_put_att(ncid,levvid,'units',nf_char,20,unitlev)
if(status/=nf_noerr) write(*,*)"levatt",nf_strerror(status)

status=nf_def_var(ncid, "latitude",nf_double,1,latid,latvid)
if(status/=nf_noerr) write(*,*)"def_lat",nf_strerror(status)
unitlat="degrees_north"
status=nf_put_att(ncid,latvid,'units',nf_char,13,unitlat)
if(status/=nf_noerr) write(*,*)"latatt",nf_strerror(status)

status=nf_def_var(ncid, "longitude",nf_double,1,lonid,lonvid)
if(status/=nf_noerr) write(*,*)"def_lon",nf_strerror(status)
unitlon="degrees_east"
status=nf_put_att(ncid,lonvid,'units',nf_char,12,unitlon)
if(status/=nf_noerr) write(*,*)"lonatt",nf_strerror(status)

dimids=(/lonid,latid,levid,timid/)
write(*,*)dimids

status=nf_def_var(ncid, "Bfre",nf_int,4,dimids,Bfreid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_def_var(ncid, "Sfre",nf_int,4,dimids,Sfreid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_def_var(ncid, "Dfre",nf_int,4,dimids,Dfreid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)
status=nf_enddef(ncid)
if(status/=nf_noerr) write(*,*)nf_strerror(status)

status=nf_put_var(ncid,timvid,time)
status=nf_put_var(ncid,levvid,lev)
status=nf_put_var(ncid,latvid,lat)
status=nf_put_var(ncid,lonvid,lon)

status=nf_put_var(ncid,Bfreid,Bfre)
status=nf_put_var(ncid,Sfreid,Sfre)
status=nf_put_var(ncid,Dfreid,Dfre)

status=nf_close(ncid)
write(*,*)"end_put_var"
end subroutine