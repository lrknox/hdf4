C
C $Header$
C
C $Log$
C Revision 1.4  1992/06/16 15:39:42  chouck
C HP is really picky about things not extending into column 72
C
c Revision 1.3  1992/05/28  16:43:32  chouck
c Fixed line continuation characters to make RS/6000 happy
c
c Revision 1.2  1992/05/18  22:11:07  sxu
c modified constants for number types
c
c Revision 1.1  1992/03/01  22:29:07  dilg
c Initial revision
c
c Revision 1.1  1992/02/29  21:24:40  likkai
c Initial revision
c
C
c	==========================================================   
c
c  HDF VSET Sample Program
c  Jason NG NCSA FEB-28-92
c
c  EGFHI.F
c  Uses High-Level routines
c  Creates a vset of 1 vgroup and 3 vdatas in the file 'egfhi.hdf'.
c
c
c	===========================================================

	program HIGHLEVEL

	print *, 'This program tests the Fortran Vset High-level'
	print *, 'calls. It creates 3 vdatas, and then create a vgroup'
	print *, 'that will be linked to the 3 vdatas.'
	print *,' '

	call DOIT

	end



	subroutine DOIT

c  Remove this fortran directive if your compiler doesn't support it.
c  It forces an error message whenever a variable is not decalred.

	IMPLICIT	NONE

	integer	idata(200)		
	real	rdata(200)	
	integer	conval(3,200)		
	integer	tagarray(10), refarray(10) 

c	--- declare the HDF and VSET routines used. This is compulsory!

	external HOPEN, HCLOSE ,VHFSD, VHFSDM, VHFMKGP
	integer	HOPEN ,VHFSD, VHFSDM, VHFMKGP

	integer 	f, i, j 
	integer  vs1, vs2, vs3, vg

c	--- some defined constants. see "vg.h"
        
	integer 	LONGTYPE    
        parameter 	(LONGTYPE=24)
	integer 	REALTYPE	
        
	parameter 	(REALTYPE=5)
	integer		VDATATAG
	parameter 	(VDATATAG=1962)
	integer 	FULLACC	
	parameter 	(FULLACC=7)

c	------ generate some data -------

	do 111 i=1,200
		rdata(i) = i *1.001 + 500
		idata(i) = i
111	continue

	do 112 i=1,100
		do 114 j=1,3
		  conval(j,i) = i*j
114	continue
112	continue

c	------- open hdf file ------
        
	f = HOPEN ('egfhi.hdf'//char(0), FULLACC, 0)

c	------- store 100 floats as one field in one vdata  ------
	vs1 = VHFSD (f, 'MP', rdata, 100, REALTYPE,  
     +					'melting-points', 'test')

c	------- store 120 integers as one field in one vdata  ------
	vs2 = VHFSD (f, 'AGE', idata, 120, LONGTYPE,
     +				'age-of-specimens', 'test')


c    ------- store 100*3 values as one field (of order 3) -----
c    ------- in one vdata  ------
	vs3 = VHFSDM (f, 'PLIST', conval, 100, LONGTYPE, 
     +				'connectivity triplets','test',3)

c	--------- messages  ----------------------

	if (vs1 .eq. -1) then 
	  print *,'error creating melting-point vdata' 
	else 
	  print *, 'created vdata "melting-points" with 100 elements'
	endif

	if (vs2 .eq. -1) then 
	  print *,'error creating  "age-of-specimens" vdata' 
	else 
	  print *, 'created vdata "age-of-specimens" with 120 elements'
	endif
	if (vs3 .eq. -1) then 
	  print *,'error creating  "connectivity triplets" vdata' 
	else 
	  print *, 'created vdata "connectivity triplets" with '
          print *, '   100 elements'
	endif

c ------ make a vgroup that has links to all the above vdatas ----  

	tagarray(1) = VDATATAG
	refarray(1) = vs1
	tagarray(2) = VDATATAG
	refarray(2) = vs2
	tagarray(3) = VDATATAG
	refarray(3) = vs3

	vg = VHFMKGP(f,tagarray,refarray,3,
     +			'vgroup with 3 vdatas (fortran)', 'test')
	if (vg .eq. -1) then 
		print *,'error creating  vgroup'
	else 
		print *, 'created vgroup that links all the 3 vdatas'
	endif
c	--- all done. close the file ---
	call HCLOSE (f)

	print *,' '
	print *, 'SUCCESS: created file egfhi.hdf'
	print *, 'Use the utility vshow to look at the results:'
	print *, '       vshow egfhi.hdf +'
	print *, 'Results should be as in the file egfhi.result'
	print *,' '

	end

