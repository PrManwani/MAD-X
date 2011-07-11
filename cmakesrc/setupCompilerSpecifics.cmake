
#fortran compiler stuff... extensive example
# FFLAGS depend on the compiler

# SET(CMAKE_FORTRAN_COMPILER mpif77)
if (CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    message( "--- ifort is recommended fortran compiler ---")
    # ON APPLE machines and on 32bit Linux systems, -O2 seems to be the highest optimization level possible
    # for file l_complex_taylor.f90
    if(APPLE OR ${CMAKE_SIZEOF_VOID_P} EQUAL 4)
        set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -fno-range-check -fno-f2c -O2 ")
    else(APPLE OR ${CMAKE_SIZEOF_VOID_P} EQUAL 4)
      set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -fno-range-check -fno-f2c -O4 ")
    endif(APPLE OR ${CMAKE_SIZEOF_VOID_P} EQUAL 4)
  set (CMAKE_Fortran_FLAGS "") # remove -g -O2 from main list of flags.. issue for older cmake/gfortran
    if (MADX_GOTOBLAS2)
        set (CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fexternal-blas")
        set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -lgoto2 ")
    endif (MADX_GOTOBLAS2)
  set (CMAKE_Fortran_FLAGS_DEBUG   " -fno-f2c -O0 -g ")
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )
    

elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
  set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -assume noold_unit_star -D_INTEL_IFORT_SET_RECL -O4")
  set (CMAKE_Fortran_FLAGS_DEBUG   " -f77rtl -O0 -g -assume noold_unit_star -D_INTEL_IFORT_SET_RECL")
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )
  if(MADX_FEDORA_FIX)
   message( WARNING "Only use the Fedora fix if you are using Fedora!" )
   set(CMAKE_Fortran_FLAGS " -no-ipo ")
  endif(MADX_FEDORA_FIX)

elseif (CMAKE_Fortran_COMPILER MATCHES "lf95")
  message( WARNING " This compiler is not yet confirmed working properly with CMake")
    if ( MADX_FORCE_32 )
      message( WARNING " On a 64 bit system you need to use the toolchain-file (see README) to get anywhere with the 32bit compiler.")
    endif ( MADX_FORCE_32 )
  set (CMAKE_Fortran_FLAGS_RELEASE " --o2 --tp  ")
  set (CMAKE_SKIP_RPATH ON)
  set (CMAKE_Fortran_FLAGS_DEBUG   " --info --f95 --lst -V -g  --ap --trace --trap --verbose  --chk aesux ")
  set(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "") #suppress rdynamic which doesn't work for lf95...
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )

elseif (CMAKE_Fortran_COMPILER MATCHES "nagfor")
  message( WARNING " Make sure you use the same gcc as nagfor is compiled with, or linking WILL fail.")
  set (CMAKE_SKIP_RPATH ON)
  set (CMAKE_Fortran_FLAGS_RELEASE " -gline -maxcontin=100 -ieee=full -D_NAG ")
  set (CMAKE_Fortran_FLAGS_DEBUG   " -gline -maxcontin=100 -ieee=full -D_NAG -C=all -nan ")
  set(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS "") #suppress rdynamic which isn't recognized by nagfor...
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -Bstatic ")
    endif ( MADX_STATIC )

elseif (CMAKE_Fortran_COMPILER MATCHES "g77")
  message( WARNING " This compiler is not yet confirmed working for mad-x")
    message( "--- ifort is recommended fortran compiler ---")
  set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -fno-f2c -O3 ")
  set (CMAKE_Fortran_FLAGS_DEBUG   " -fno-f2c -O0 -g ")
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )

elseif (CMAKE_Fortran_COMPILER MATCHES "g95")
    message( "--- ifort is recommended fortran compiler ---")
  set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -fno-second-underscore -fshort-circuit -O2 ")
  set (CMAKE_Fortran_FLAGS_DEBUG   " -fno-second-underscore -O0 -g -Wall -pedantic -ggdb3")  
    if ( MADX_STATIC )
    set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )

elseif (CMAKE_Fortran_COMPILER_ID MATCHES "PathScale")
    message( "--- ifort is recommended fortran compiler ---")
    set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -O3 ")
    set (CMAKE_Fortran_FLAGS_DEBUG   " -O0 -g ")  
    if ( MADX_STATIC )
        set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif()
else()
    message( "--- ifort is recommended fortran compiler ---")
    message ("Fortran compiler full path: " ${CMAKE_Fortran_COMPILER})
    message ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    message (WARNING " No optimized Fortran compiler flags are known for this compiler...")
    set (CMAKE_Fortran_FLAGS_RELEASE " -funroll-loops -fno-range-check -O2")
    set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
    if ( MADX_STATIC )
        set (CMAKE_Fortran_LINK_FLAGS   "${CMAKE_Fortran_LINK_FLAGS} -static ")
    endif ( MADX_STATIC )
endif()
#end fortran compiler stuff...
