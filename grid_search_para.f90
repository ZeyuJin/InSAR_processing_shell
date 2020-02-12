program grid_search_para
   implicit none
   ! ioc:   switch for oceanic (0) or continental (1) earthquakes
   ! nr:    number of horizontal observation distances
   ! nzs:   number of equidistant source depth
   ! nt:    number of time samples
   ! l:     number of data lines of layered model
   ! nH:    number of sampling for elastic thickness
   ! neta:  number of sampling for viscosity of lower layer
   integer :: ioc,nr,nzs,nt,ii,jj,kk
   integer,parameter :: l = 3,nH = 5,neta = 5
   integer :: No(l)
   real (kind=8) :: zrec,r1,r2,sampratio,zs1,zs2
   real (kind=8) :: twindow,accuracy,grfac
   real (kind=8) :: depth(l),Vp(l),Vs(l),rho(l),eta1(l),eta2(l),alpha(l)
   integer :: H(nH)
   real (kind=8) :: visc(neta)
   character (len=100) :: outputfile,fname(14),outdir,mkdir,remo_file
   character (len=30) :: index1,index2
   !integer :: time

   ! parameter for source-observation configurations
   zrec = 0.0
   ioc = 1
   nr = 201
   r1 = 0.0
   r2 = 200.0
   sampratio = 5.0
   nzs = 43
   zs1 = 0.0
   zs2 = 21.0

   ! parameters for time sampling
   nt = 32
   twindow = 950 ! 2.5yrs

   ! parameters for wavenumber integration
   accuracy = 0.025
   grfac = 0.00

   ! parameters for output files
   ! outputfile = "test.dat"
   ! outdir = "'./Green/'"
   fname(1) = "'uz'"
   fname(2) = "'ur'"
   fname(3) = "'ut'"
   fname(4) = "'szz'"
   fname(5) = "'srr'"
   fname(6) = "'stt'"
   fname(7) = "'szr'"
   fname(8) = "'srt'"
   fname(9) = "'stz'"
   fname(10) = "'tr'"
   fname(11) = "'tt'"
   fname(12) = "'rot'"
   fname(13) = "'gd'"
   fname(14) = "'gr'"

   ! global model parameters
   No = (/ 1,2,3 /)
   depth = (/ 0.0, 0.0, 0.0 /)
   Vp = (/ 5.7735, 5.7735, 5.7735 /)
   Vs = (/ 3.3333, 3.3333, 3.3333 /)
   rho = (/ 2700.0, 2700.0, 2700.0 /)
   eta1 = 0.0000
   eta2 = (/ 0.0000, 0.0000, 0.0000 /)
   alpha = 1.000

   ! some changing parameters (elastic thinkness, viscosity and output name)
   ! scaling elastic thickness and viscosity first, and then time the coef.
   do ii = 1,nH,1
      H(ii) = 10 + ii * 5
   enddo
   visc = (/ 1.0E17, 5.0E17, 1.0E18, 5.0E18, 1.0E19 /)

   ! test for print 
   ! print *, (H(ii), ii=1,nH)
   ! print *, (visc(ii), ii=1,nH)

   ! using grid search to generate configure file with seires of
   ! elastic thinkness and viscosity
   do ii = 1,nH,1
      do jj = 1,neta,1
         
         depth(2) = H(ii)
         depth(3) = H(ii)
         eta2(3) = visc(jj)
        
         write(index1,*) H(ii)
         index1 = adjustl(index1)
         write(index2,*) jj
         index2 = adjustl(index2)
         outputfile = 'SKFS_'//trim(index1)//'_'//trim(index2)//'.dat'
         outdir = "'./Green_"//trim(index1)//'_'//trim(index2)//"_func/'"
         ! outdir = "'./'"
         mkdir = 'mkdir -p Green_'//trim(index1)//'_'//trim(index2)//'_func'
         remo_file = 'mv '//trim(outputfile)//' Green_'//trim(index1)//'_'//trim(index2)//'_func/'
         write(*,'(a)') mkdir
         call system(mkdir)

         ! write out configure file
         open(10,file=outputfile,status='new')
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'#         PARAMETERS FOR SOURCE-OBSERVATION CONFIGURATIONS        '
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(f12.1,i4)') zrec,ioc
         write(10,'(i5,3f7.1)') nr,r1,r2,sampratio
         write(10,'(i5,2f7.1)') nzs,zs1,zs2
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'#           PARAMETERS FOR TIME SAMPLING                          '
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(i3,f9.1)') nt,twindow
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'#           PARAMETERS FOR WAVENUMBER INTEGRATION                 ' 
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(f6.3)') accuracy
         write(10,'(f6.3)') grfac
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'#           PARAMETERS FOR OUTPUT FILES                           '
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(2x,a20)') outdir
         write(10,'(3(2x,a10))') fname(1),fname(2),fname(3)
         write(10,'(6(2x,a10))')  &
                             fname(4),fname(5),fname(6),fname(7),fname(8),fname(9)
         write(10,'(5(2x,a10))') fname(10),fname(11),fname(12),fname(13),fname(14)
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'#           GLOBAL MODEL PARAMETERS                               '
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(i3,10x,a30)') l,'     |int: no_model_lines;'
         write(10,'(a)')'#-----------------------------------------------------------------'
         write(10,'(a)')'# no  depth[km]  vp[km/s]  vs[km/s]  rho[kg/m^3] &
                        &eta1[Pa*s] eta2[Pa*s] alpha'
         write(10,'(a)')'#-----------------------------------------------------------------'
         do kk = 1,l,1 
             write(10,'(i3,f8.1,1x,2f11.4,f10.1,1x,2E13.4,f9.3)') &
             &No(kk),depth(kk),Vp(kk),Vs(kk),rho(kk),&
             &eta1(kk),eta2(kk),alpha(kk)
         enddo
         write(10,'(a)')'#==========================end of input==========================='
         close(10)

         write(*,'(a)') remo_file
         call system(remo_file)
      enddo
   enddo
end program grid_search_para
