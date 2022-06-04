T-Blade3 VERSION 1.2 BUILDING GUIDE
The tool can create a variety of 3D blade geometries based on few basic parameters and limited interaction with a CAD system. The geometric and aerodynamic parameters are used to create 2D airfoils and these airfoils are stacked on the desired stacking axis. The tool generates a specified number of 2D blade sections in a 3D Cartesian coordinate system. The geometry modeler can also be used for generating 3D blades with special features like bent tip, split tip and other concepts, which can be explored with minimum changes to the blade geometry. The use of control points for the definition of splines makes it easy to modify the blade shapes quickly and smoothly to obtain the desired blade model. The second derivative of the mean-line (related to the curvature) is controlled using B-splines to create the airfoils. This is analytically integrated twice to obtain the mean-line. A smooth thickness distribution is then added to the airfoil with two options either the Wennerstrom distribution or a quartic B-spline thickness distribution. B-splines have also been implemented to achieve customized airfoil leading and trailing edges.

1. PREREQUISITES

Obtaining and running T-Blade3 depends on the following

git
Fortran
    Tested with: GFortran 6.0+
GNU Make

Additionally for building the test suite on non-Windows systems,
the following is needed

pFUnit (pfunit.sourceforge.net)

2. OBTAINING T-BLADE3

The best way to obtain T-Blade3 is to clone the git repository from
GitHub as follows:

git clone https://github.com/GTSL-UC/T-Blade3.git

This will create the directory T-Blade3 in the current working 
directory.

3. DIRECTORY CONTENTS

In the top level of the T-Blade3 directory are the following files

README - This file.

Copyright.txt - Contains information pertaining to the use and
                distribution of T-Blade3

License.txt - T-Blade3 license information

GitHub.address - Contains the address of the GitHub page with
                 the T-Blade3 git repository

Makefile - Master makefile for compiling T-Blade3/test suite/ESP UDPs

documentation - Subdirectory which contains additional documentation
                for T-Blade3

source - Source code for T-Blade3 and ESP UDPs (also contains
         sub makefiles for T-Blade3 and ESP)

tests - Subdirectory which contains unit tests for T-Blade3 (also
        contains sub makefile for the test suite)

scripts - Subdirectory which contains scripts for plotting various
          T-Blade3 output

inputs - Contains example cases for T-Blade3

4. BUILDING T-BLADE3

a. Change to the directory into which T-Blade3 has been placed
b. To build T-Blade3, execute make
    $ make
c. The source directory now contains object files and Fortran
   module files
d. The executables are generated in a bin directory one level
   above the source directory

4.1. TESTING

Additionally, to build and run the T-Blade3 test suite, run
    $ make tests

This requires a serial installation of pFUnit with $PFUNIT
being defined as
    $ export PFUNIT=/path/to/pfunit/serial/install

4.2. CLEANING

Run the following command to remove object files, module files
and the T-Blade3 binaries (from the top level directory):
    $ make clean
