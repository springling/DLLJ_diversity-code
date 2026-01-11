begin
filedir = "/sky7/zhouchling/data/DLLJ_SouthChina1/"
f1 = addfile(filedir+"Calculate_Beibu_type.nc","r")
;f1 = addfile(filedir+"Calculate_NSCS_type.nc","r")

type = f1->type
ndim = dimsizes(type)
mark_type1_event = new((/ndim(0),ndim(1)/),"integer")
mark_type2_event = new((/ndim(0),ndim(1)/),"integer")
mark_type3_event = new((/ndim(0),ndim(1)/),"integer")
mark_type1_event = 0
mark_type2_event = 0
mark_type3_event = 0

a = 0
b = 0
c = 0
do i = 0,22
    do j = 0,ndim(1)-1
        if (type(i,j).eq.1) then
            a = a + 1
        end if

        if (type(i,j).eq.2) then
            b = b + 1
        end if

        if (type(i,j).eq.3) then
            c = c + 1
        end if
    end do
end do 
print(a)
print(b)
print(c)

do year = 2001,2023;2023
    iyr = year-2001
    ind_num1 = ind(type(iyr,:).eq.1)
    n = dimsizes(ind_num1)
    num_event = 1
    if (n.ge.2) then
        mark_type1_event(iyr,ind_num1(0)) = num_event
        do i = 0,n-2
            if (ind_num1(i+1).le.ind_num1(i)+2) then;ind_num1(i)+2是保证里面可以间隔1小时
                mark_type1_event(iyr,ind_num1(i+1)) = num_event
            else
                num_event = num_event +1
                mark_type1_event(iyr,ind_num1(i+1)) = num_event
            end if
        end do
    end if
    delete([/ind_num1,num_event/])

    ind_num1 = ind(type(iyr,:).eq.2)
    n = dimsizes(ind_num1)
    num_event = 1
    if (n.ge.2) then
        mark_type2_event(iyr,ind_num1(0)) = num_event
        do i = 0,n-2
            if (ind_num1(i+1).le.ind_num1(i)+2) then
                mark_type2_event(iyr,ind_num1(i+1)) = num_event
            else
                num_event = num_event +1
                mark_type2_event(iyr,ind_num1(i+1)) = num_event
            end if
        end do
    end if
    delete([/ind_num1,num_event/])

    ind_num1 = ind(type(iyr,:).eq.3)
    n = dimsizes(ind_num1)
    num_event = 1
    if (n.ge.2) then
        mark_type3_event(iyr,ind_num1(0)) = num_event
        do i = 0,n-2
            if (ind_num1(i+1).le.ind_num1(i)+2) then
                mark_type3_event(iyr,ind_num1(i+1)) = num_event
            else
                num_event = num_event +1
                mark_type3_event(iyr,ind_num1(i+1)) = num_event
            end if
        end do
    end if
    delete([/ind_num1,num_event/])
end do

num_type_event = new((/3/),"integer")
num_type_event = 0
do iyr = 0,22
    nmax = max(mark_type1_event(iyr,:))
    do nn = 1,nmax
        ind_num1 = ind(mark_type1_event(iyr,:).eq.nn)
        if(dimsizes(ind_num1).ge.3) then
            num_type_event(0) = num_type_event(0) + 1
        end if
        if(dimsizes(ind_num1).lt.3) then
            do i = 0,dimsizes(ind_num1)-1
                mark_type1_event(iyr,ind_num1(i)) = 0
            end do
        end if
        delete(ind_num1)
    end do

    nmax = max(mark_type2_event(iyr,:))
    do nn = 1,nmax
        ind_num1 = ind(mark_type2_event(iyr,:).eq.nn)
        if(dimsizes(ind_num1).ge.3) then
            num_type_event(1) = num_type_event(1) + 1
        end if
        if(dimsizes(ind_num1).lt.3) then
            do i = 0,dimsizes(ind_num1)-1
                mark_type2_event(iyr,ind_num1(i)) = 0
            end do
        end if
        delete(ind_num1)
    end do

    nmax = max(mark_type3_event(iyr,:))
    do nn = 1,nmax
        ind_num1 = ind(mark_type3_event(iyr,:).eq.nn)
        if(dimsizes(ind_num1).ge.3) then
            num_type_event(2) = num_type_event(2) + 1
        end if
        if(dimsizes(ind_num1).lt.3) then
            do i = 0,dimsizes(ind_num1)-1
                mark_type3_event(iyr,ind_num1(i)) = 0
            end do
        end if
        delete(ind_num1)
    end do
end do
print(num_type_event) 

;fnameout1 = "identify_Beibu_DLLJ_event.nc"
;fnameout1 = "identify_NSCS_DLLJ_event.nc"
;system("rm -f " + fnameout1)
;setfileoption("nc","Format","NetCDF4");
;fout=addfile(filedir+fnameout1, "c")
;fout->mark_type1_event = mark_type1_event
;fout->mark_type2_event = mark_type2_event
;fout->mark_type3_event = mark_type3_event
;fout->num_type_event   = num_type_event
end