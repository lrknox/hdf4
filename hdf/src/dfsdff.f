c***************************************************************************
c
c
c                         NCSA HDF version 3.2r3
c                            December 1, 1992
c
c NCSA HDF Version 3.2 source code and documentation are in the public
c domain.  Specifically, we give to the public domain all rights for future
c licensing of the source code, all resale rights, and all publishing rights.
c
c We ask, but do not require, that the following message be included in all
c derived works:
c
c Portions developed at the National Center for Supercomputing Applications at
c the University of Illinois at Urbana-Champaign, in collaboration with the
c Information Technology Institute of Singapore.
c
c THE UNIVERSITY OF ILLINOIS GIVES NO WARRANTY, EXPRESSED OR IMPLIED, FOR THE
c SOFTWARE AND/OR DOCUMENTATION PROVIDED, INCLUDING, WITHOUT LIMITATION,
c WARRANTY OF MERCHANTABILITY AND WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE
c
c***************************************************************************
C
C $Header$
C
C $Log$
C Revision 1.2  1993/01/04 18:09:33  sxu
C add dsp32sd (for dfsdpre32sdg)
C
c Revision 1.1  1992/08/25  21:40:44  koziol
c Initial revision
c
C
C------------------------------------------------------------------------------
C File:     dfsdFf.f
C Purpose:  Fortran stubs for Fortran SDS routines
C Invokes:  dfsdF.c dfsd.c
C Contents: 
C   dsgdims:        get dimensions of next SDG
C   dsgdata:        get data for next SDG
C   dssdast:        set strings for data for subsequent SDGs
C   dssdist:        set strings for a dimension for subsequent SDGs
C   dspdata:        write SDG to new file
C   dsadata:        append SDG to existing file
C   dsgslc:         get slice from file
C   dssslc:         set up to write slices to file
C   dsrref:	    set up next ref to read
C   dsnum:          return number of SDGs in file
C   dsp32sd:        is the SDG/ref written by HDF prior to version 3.2?		
C   dfsdgetdims:    get dimensions of next SDG
C   dfsdgetdata:    get data for next SDG
C   dfsdsetdatastrs:set strings for data for subsequent SDGs
C   dfsdsetdimstrs: set strings for a dimension for subsequent SDGs
C   dfsdputdata:    write SDG to new file
C   dfsdadddata:    append SDG to existing file
C   dfsdgetslice:   get slice from file
C   dfsdstartslice:set up to write slices to file
C   dfsdreadref:    set up next ref to read
C   dfsdnumber:     return number of SDGs in the file
C Remarks: none
C------------------------------------------------------------------------------



C------------------------------------------------------------------------------
C Name: dsgdims
C Purpose:  get dimensions of next SDG
C Inputs:   filename: name of HDF file
C           rank: integer to return rank in
C           dimsizes: array to return dimensions in
C           maxrank: size of array dimsizes
C Returns: 0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes: dsigdim
C------------------------------------------------------------------------------

      integer function dsgdims(filename, rank, dimsizes, maxrank)
      character*(*) filename
      integer rank, dimsizes, maxrank, dsigdim

      dsgdims = dsigdim(filename, rank, dimsizes, maxrank,
     +                                              len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsgdata
C Purpose:  get data from next SDG
C Inputs:   filename: name of HDF file
C           rank: integer containing no of dimensions in array data
C           maxsizes: array containing dimensions of array data
C           data: array to return data values in
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsigdat
C------------------------------------------------------------------------------

      integer function dsgdata(filename, rank, maxsizes, data)
      character*(*) filename
      integer rank, maxsizes, dsigdat
      real data

      dsgdata = dsigdat(filename, rank, maxsizes, data,
     +                                                len(filename))
      return
      end


C------------------------------------------------------------------------------
C Name:     dssdast
C Purpose:  set data strings to be written out with next SDG
C Inputs:   label, unit, format, coordsys: strings to be set
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisdas_
C------------------------------------------------------------------------------

      integer function  dssdast(label, unit, format, coordsys)
      character*(*) label, unit, format,  coordsys
      integer dsisdas, len

      dssdast = dsisdas(label, unit, format, coordsys,
     +1, len(label), len(unit), len(format), len(coordsys))

      return
      end


C------------------------------------------------------------------------------
C Name:     dssdist
C Purpose:  set dim strings to be written out with next SDG
C Inputs:   label, unit, format, coordsys: strings to be set
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisdis_
C------------------------------------------------------------------------------

      integer function  dssdist(dim, label, unit, format)
      character*(*) label, unit, format
      integer dim, len
      integer dsisdis

      dssdist = dsisdis(dim, label, unit, format,
     +len(label), len(unit), len(format))

      return
      end


C------------------------------------------------------------------------------
C Name:     dspdata
C Purpose:  call dsipdat to write SDG to new file
C Inputs:   filename: name of HDF file
C           rank: no of dimensions of array data
C           dimsizes: array containing the dimensions of array data
C           data: array containing the data values
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsipdat
C------------------------------------------------------------------------------

      integer function dspdata(filename, rank, dimsizes, data)
      character*(*) filename
      integer rank, dimsizes, data, len, dsipdat

      dspdata = dsipdat(filename, rank, dimsizes, data, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsadata
C Purpose:  call dsiadat to append SDG to existing file
C Inputs:   filename: name of HDF file
C           rank: no of dimensions of array data
C           dimsizes: array containing the dimensions of array data
C           data: array containing the data values
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsiadat
C------------------------------------------------------------------------------

      integer function dsadata(filename, rank, dimsizes, data)
      character*(*) filename
      integer rank, dimsizes, data, len, dsiadat

      dsadata = dsiadat(filename, rank, dimsizes, data, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsgslc
C Purpose:  call dsigslc to get slice from file
C Inputs:   filename: name of HDF file
C           winst: array of size = rank of data, containing start of slice
C           winend: array of size rank, containing end of slice
C           data: array for returning slice
C           ndims: no of dims of array data
C           dims: dimensions of array data
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsigslc
C------------------------------------------------------------------------------

      integer function dsgslc(filename,winst,windims,data,dims)
      character*(*) filename
      integer winst, windims, data, dims, dsigslc

      dsgslc = dsigslc(filename, winst, windims, data, dims,
     +     len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dssslc
C Purpose:  call dsisslc to set up to write slices
C Inputs:   filename: name of HDF file
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisslc
C------------------------------------------------------------------------------

      integer function dssslc(filename)
      character*(*) filename
      integer dsisslc

      dssslc = dsisslc(filename, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsrref
C Purpose:  call dsirref to set up next ref to read
C Inputs:   filename: name of HDF file
C           ref: next ref to read
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsirref
C------------------------------------------------------------------------------

      integer function dsrref(filename, ref)
      character*(*) filename
      integer ref
      integer dsirref

      dsrref = dsirref(filename, ref, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsnum
C Purpose:  return the number of SDGs in the file
C Inputs:   filename: name of HDF file
C Returns:  number of SDGs on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsinum
C------------------------------------------------------------------------------

      integer function dsnum(filename)
      character*(*) filename
      integer len, dsinum

      dsnum = dsinum(filename, len(filename))

      return
      end

C------------------------------------------------------------------------------
C Name:     dsp32sd
C Purpose:  tests if the SDG with the specified ref was written by HDF prior to
C            version 3.2
C Input:    filename: name of HDF file
C           ref: the ref number of the SDG
C           ispre32: set to TRUE if the SDG/ref was written by old library;
C                        to FALSE otherwise.
C Retruns:  0 on success, -1 on failure
C Users:    HDF Fortran programmers
C------------------------------------------------------------------------------

      integer function dsp32sd(filename, ref, ispre32)
      character*(*) filename
      integer ref, ispre32, len, dsip32s

      dsp32sd = dsip32s(filename, ref, ispre32, len(filename))

      return
      end



CEND7MAX


C------------------------------------------------------------------------------
C Name: dfsdgetdims
C Purpose:  get dimensions of next SDG
C Inputs:   filename: name of HDF file
C           rank: integer to return rank in
C           dimsizes: array to return dimensions in
C           maxrank: size of array dimsizes
C Returns: 0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes: dsigdim
C------------------------------------------------------------------------------

      integer function dfsdgetdims(filename, rank, dimsizes, maxrank)
      character*(*) filename
      integer rank, dimsizes, maxrank, dsigdim

      dfsdgetdims = dsigdim(filename, rank, dimsizes, maxrank,
     +                                              len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdgetdata
C Purpose:  get data from next SDG
C Inputs:   filename: name of HDF file
C           rank: integer containing no of dimensions in array data
C           maxsizes: array containing dimensions of array data
C           data: array to return data values in
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsigdat
C------------------------------------------------------------------------------

      integer function dfsdgetdata(filename, rank, maxsizes, data)
      character*(*) filename
      integer rank, maxsizes, dsigdat
      real data

      dfsdgetdata = dsigdat(filename, rank, maxsizes, data,
     +                                                len(filename))
      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdsetdatastrs
C Purpose:  set data strings to be written out with next SDG
C Inputs:   label, unit, format, coordsys: strings to be set
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisdas_
C------------------------------------------------------------------------------

      integer function  dfsdsetdatastrs(label, unit, format, coordsys)
      character*(*) label, unit, format,  coordsys
      integer dsisdas, len

      dfsdsetdatastrs = dsisdas(label, unit, format, coordsys,
     +1, len(label), len(unit), len(format), len(coordsys))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdsetdimstrs
C Purpose:  set dim strings to be written out with next SDG
C Inputs:   label, unit, format, coordsys: strings to be set
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisdis_
C------------------------------------------------------------------------------

      integer function  dfsdsetdimstrs(dim, label, unit, format)
      character*(*) label, unit, format
      integer dim, len
      integer dsisdis

      dfsdsetdimstrs = dsisdis(dim, label, unit, format,
     +len(label), len(unit), len(format))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdputdata
C Purpose:  call dsipdat to write SDG to new file
C Inputs:   filename: name of HDF file
C           rank: no of dimensions of array data
C           dimsizes: array containing the dimensions of array data
C           data: array containing the data values
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsipdat
C------------------------------------------------------------------------------

      integer function dfsdputdata(filename, rank, dimsizes, data)
      character*(*) filename
      integer rank, dimsizes, data, len, dsipdat

      dfsdputdata = dsipdat(filename,rank,dimsizes,data,len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdadddata
C Purpose:  call dsiadat to append SDG to existing file
C Inputs:   filename: name of HDF file
C           rank: no of dimensions of array data
C           dimsizes: array containing the dimensions of array data
C           data: array containing the data values
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsiadat
C------------------------------------------------------------------------------

      integer function dfsdadddata(filename, rank, dimsizes, data)
      character*(*) filename
      integer rank, dimsizes, data, len, dsiadat

      dfsdadddata = dsiadat(filename,rank,dimsizes,data,len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdgetslice
C Purpose:  call dsigslc to get slice from file
C Inputs:   filename: name of HDF file
C           winst: array of size = rank of data, containing start of slice
C           winend: array of size rank, containing end of slice
C           data: array for returning slice
C           ndims: no of dims of array data
C           dims: dimensions of array data
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsigslc
C------------------------------------------------------------------------------

      integer function dfsdgetslice(filename, winst, winend, data,
     +                                                     dims)
      character*(*) filename
      integer winst, winend, data,  dims, dsigslc

      dfsdgetslice = dsigslc(filename, winst, winend, data,
     +                                             dims, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdstartslice
C Purpose:  call dsisslc to set up to write slices
C Inputs:   filename: name of HDF file
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsisslc
C------------------------------------------------------------------------------

      integer function dfsdstartslice(filename)
      character*(*) filename
      integer dsisslc

      dfsdstartslice = dsisslc(filename, len(filename))

      return
      end

C------------------------------------------------------------------------------
C Name:     dfsdreadref
C Purpose:  call dsirref to set up next ref to read
C Inputs:   filename: name of HDF file
C           ref: next ref to read
C Returns:  0 on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsirref
C------------------------------------------------------------------------------

      integer function dfsdreadref(filename, ref)
      character*(*) filename
      integer ref
      integer dsirref

      dfsdreadref = dsirref(filename, ref, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdnumber
C Purpose:  return the number of SDGs in the file
C Inputs:   filename: name of HDF file
C Returns:  number of SDGs on success, -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsinum
C------------------------------------------------------------------------------

      integer function dfsdnumber(filename)
      character*(*) filename
      integer len, dsinum

      dfsdnumber = dsinum(filename, len(filename))

      return
      end


C------------------------------------------------------------------------------
C Name:     dfsdgetdimstrs
C Purpose:  return the label unit and format for the current SDGs 
C Inputs:   
C Returns:  -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsinum
C------------------------------------------------------------------------------

      integer function dfsdgetdimstrs(dim, label, unit, format)
      character*(*) label, unit, format
      integer len, dsigdis, dim

      dfsdgetdimstrs = dsigdis(dim, label, unit, format, len(label),
     +   len(unit), len(format))

      return
      end


C------------------------------------------------------------------------------
C Name:     dsgdist
C Purpose:  return the label unit and format for the current SDGs 
C Inputs:   
C Returns:  -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsinum
C------------------------------------------------------------------------------

      integer function dsgdist(dim, label, unit, format)
      character*(*) label, unit, format
      integer len, dsigdis, dim

      dsgdist = dsigdis(dim, label, unit, format, len(label),
     +   len(unit), len(format))

      return
      end

C------------------------------------------------------------------------------
C Name:     dsgdast
C Purpose:  return the label unit and format for the current SDGs 
C Inputs:   
C Returns:  -1 on failure with DFerror set
C Users:    HDF Fortran programmers
C Invokes:  dsinum
C------------------------------------------------------------------------------

      integer function dsgdast(label, unit, format, coordsys)
      character*(*) label, unit, format, coordsys
      integer len, dsigdas

      dsgdast = dsigdas(label, unit, format, coordsys, len(label),
     +   len(unit), len(format), len(coordsys))

      return
      end

